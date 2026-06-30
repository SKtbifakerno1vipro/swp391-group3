package controller.realtime;

import dal.PaymentDAO;
import dal.CustomerDAO;
import dal.ContractDAO;
import model.Payment;
import model.ContractHistory;
import model.User;
import dto.CustomerDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "RealtimeNotificationServlet", urlPatterns = {"/realtime/notifications"})
public class RealtimeNotificationServlet extends HttpServlet {
    
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Connection", "keep-alive");

        PrintWriter writer = response.getWriter();
        // Lùi mốc thời gian ban đầu lại 5 giây để quét bắt kịp các giao dịch trong lúc chuyển trang
        Timestamp lastChecked = new Timestamp(System.currentTimeMillis() - 5000);
        System.out.println("[Realtime Servlet] Client connected: " + user.getUserName() + " (Role: " + user.getRoleId() + ")");

        while (!writer.checkError()) {
            int roleId = user.getRoleId();

            // 1. Payments Notifications
            if (roleId == 3) {
                // Customer: only their own payments
                List<Payment> myPayments = paymentDAO.getPaymentsSince(lastChecked, user.getUserId());
                for (Payment p : myPayments) {
                    if (p.getCreatedAt() != null) {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatCustomerPaymentJson(p, request.getContextPath()) + "\n\n");
                        
                        Timestamp pTime = Timestamp.valueOf(p.getCreatedAt());
                        Timestamp nextTime = new Timestamp(pTime.getTime() + 100);
                        if (nextTime.after(lastChecked)) {
                            lastChecked = nextTime;
                        }
                    }
                }
            } else {
                // Admin / Staff: all payments
                List<Payment> allPayments = paymentDAO.getPaymentsSince(lastChecked, null);
                for (Payment p : allPayments) {
                    if (p.getCreatedAt() != null) {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatAdminPaymentJson(p, request.getContextPath()) + "\n\n");
                        
                        Timestamp pTime = Timestamp.valueOf(p.getCreatedAt());
                        Timestamp nextTime = new Timestamp(pTime.getTime() + 100);
                        if (nextTime.after(lastChecked)) {
                            lastChecked = nextTime;
                        }
                    }
                }
            }

            // 2. Customer Notifications (Admin: 1, Staff: 2)
            if (roleId == 1 || roleId == 2) {
                List<CustomerDTO> newCustomers = customerDAO.getCustomersSince(lastChecked);
                for (CustomerDTO c : newCustomers) {
                    if (c.getUser() != null && c.getUser().getCreateAt() != null) {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatNewCustomerJson(c, request.getContextPath()) + "\n\n");
                        
                        Timestamp cTime = Timestamp.valueOf(c.getUser().getCreateAt());
                        Timestamp nextTime = new Timestamp(cTime.getTime() + 100);
                        if (nextTime.after(lastChecked)) {
                            lastChecked = nextTime;
                        }
                    }
                }
            }

            // 3. Contract Workflow Notifications
            List<ContractHistory> newHistories = contractDAO.getContractHistoriesSince(lastChecked);
            for (ContractHistory h : newHistories) {
                if (h.getCreatedAt() != null) {
                    boolean shouldNotify = false;
                    String title = "";
                    String msg = "";
                    String link = request.getContextPath() + "/contract-detail?id=" + h.getContractId();

                    int changerRole = 0;
                    try {
                        if (h.getEditStatus() != null) changerRole = Integer.parseInt(h.getEditStatus());
                    } catch(Exception ignored){}

                    // A. Officer submits to Manager (DRAFT/PENDING_REVIEW -> PENDING_REVIEW by Officer)
                    if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 5) {
                        if (roleId == 2) { // Manager gets it
                            shouldNotify = true;
                            title = "Hợp đồng cần duyệt";
                            msg = "Officer vừa gửi hợp đồng " + h.getContractNumber() + " để duyệt.";
                        }
                    }
                    // B. Manager requests edit (-> PENDING_REVIEW by Manager)
                    else if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 2) {
                        if (roleId == 5) { // Officer gets it
                            shouldNotify = true;
                            title = "Yêu cầu sửa hợp đồng";
                            msg = "Manager yêu cầu sửa hợp đồng " + h.getContractNumber() + ".";
                        }
                    }
                    // C. Customer requests edit (-> PENDING_REVIEW by Customer)
                    else if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 3) {
                        if (roleId == 2 || roleId == 5) { // Manager & Officer get it
                            shouldNotify = true;
                            title = "Khách hàng yêu cầu sửa";
                            msg = "Khách hàng yêu cầu sửa hợp đồng " + h.getContractNumber() + ".";
                        }
                    }
                    // D. Manager approves (-> CUSTOMER_CHECK)
                    else if ("CUSTOMER_CHECK".equals(h.getToStatus())) {
                        if (roleId == 2) { // Manager
                            shouldNotify = true;
                            title = "Duyệt thành công";
                            msg = "Đã gửi hợp đồng " + h.getContractNumber() + " cho khách hàng.";
                        } else if (roleId == 3 && user.getUserId() == h.getCustomerUserId()) { // Customer
                            shouldNotify = true;
                            title = "Hợp đồng chờ ký";
                            msg = "Hợp đồng " + h.getContractNumber() + " đã sẵn sàng. Vui lòng kiểm tra và ký.";
                        }
                    }
                    // E. Customer approves/signs (-> APPROVED / SIGNED)
                    else if (("APPROVED".equals(h.getToStatus()) || "SIGNED".equals(h.getToStatus())) && changerRole == 3) {
                        if (roleId == 2 || roleId == 5) { // Manager & Officer
                            shouldNotify = true;
                            title = "Khách hàng đã chốt hợp đồng";
                            msg = "Khách hàng đã chốt/ký hợp đồng " + h.getContractNumber() + ".";
                        }
                    }

                    if (shouldNotify) {
                        writer.write("event: notification\n");
                        writer.write("data: {\"type\":\"info\",\"title\":\"" + escapeJson(title) + "\",\"message\":\"" + escapeJson(msg) + "\",\"link\":\"" + escapeJson(link) + "\"}\n\n");
                    }

                    Timestamp hTime = Timestamp.valueOf(h.getCreatedAt());
                    Timestamp nextTime = new Timestamp(hTime.getTime() + 100);
                    if (nextTime.after(lastChecked)) {
                        lastChecked = nextTime;
                    }
                }
            }

            writer.flush();
            response.flushBuffer();

            try {
                Thread.sleep(4000);
            } catch (InterruptedException e) {
                break;
            }
        }
        System.out.println("[Realtime Servlet] Connection closed for user: " + user.getUserName());
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }

    private String formatCustomerPaymentJson(Payment p, String contextPath) {
        double amt = p.getAmount() != null ? p.getAmount().doubleValue() : 0.0;
        String contractNo = p.getContractNumber() != null ? p.getContractNumber() : "";
        return String.format(
            "{\"type\":\"success\",\"title\":\"Ký hợp đồng thành công\",\"message\":\"Hợp đồng số %s trị giá %,.0f VNĐ vừa được ký.<br>Hãy nhấn vào \'Thanh toán\' để hoàn tất thủ tục.\",\"link\":\"%s/payment/detail?id=%d\",\"btnText\":\"Thanh toán\"}",
            escapeJson(contractNo),
            amt,
            contextPath,
            p.getPaymentId()
        );
    }



    private String formatAdminPaymentJson(Payment p, String contextPath) {
        String name = p.getCustomerName() != null ? p.getCustomerName() : "System / Anonymous";
        double amt = p.getAmount() != null ? p.getAmount().doubleValue() : 0.0;
        return String.format(
            "{\"type\":\"success\",\"title\":\"Giao dịch mới\",\"message\":\"Khách hàng %s vừa thanh toán %,.0f VNĐ\",\"link\":\"%s/payment/list\"}",
            escapeJson(name),
            amt,
            contextPath
        );
    }

    private String formatNewCustomerJson(CustomerDTO c, String contextPath) {
        String name = (c.getUser() != null && c.getUser().getFullName() != null) ? c.getUser().getFullName() : "Khách hàng mới";
        return String.format(
            "{\"type\":\"info\",\"title\":\"Thành viên mới\",\"message\":\"Khách hàng %s vừa đăng ký tài khoản thành công.\",\"link\":\"%s/customer/list\"}",
            escapeJson(name),
            contextPath
        );
    }
}

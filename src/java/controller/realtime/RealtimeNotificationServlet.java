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
        long startTime = System.currentTimeMillis() - 5000;
        Timestamp lastCheckedPayment = new Timestamp(startTime);
        Timestamp lastCheckedCustomer = new Timestamp(startTime);

        // Quét theo ID thay vì mốc thời gian (Riêng cho Contract theo yêu cầu)
        int lastContractHistoryId = contractDAO.getMaxContractHistoryId();

        System.out.println("[Realtime Servlet] Client connected: " + user.getUserName() + " (Role: " + user.getRoleId() + ")");

        while (!writer.checkError()) {
            int roleId = user.getRoleId();

            // 1. Payments Notifications
            List<Payment> myPayments = paymentDAO.getPaymentsSince(lastCheckedPayment, (roleId == 3 ? user.getUserId() : null));
            java.time.LocalDateTime lastLdt = lastCheckedPayment.toLocalDateTime();
            Timestamp maxPaymentTime = lastCheckedPayment;

            for (Payment p : myPayments) {
                // a. Contract Signed (new pending payments)
                if (p.getCreatedAt() != null && p.getCreatedAt().isAfter(lastLdt) && "PENDING".equals(p.getPaymentStatus())) {
                    if (roleId == 3) {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatCustomerPaymentJson(p, request.getContextPath()) + "\n\n");
                    } else {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatAdminContractSignedJson(p, request.getContextPath()) + "\n\n");
                    }

                    Timestamp pTime = Timestamp.valueOf(p.getCreatedAt());
                    if (pTime.after(maxPaymentTime)) {
                        maxPaymentTime = pTime;
                    }
                }

                // b. Payment Completed
                if (p.getPaidAt() != null && p.getPaidAt().isAfter(lastLdt) && "COMPLETED".equals(p.getPaymentStatus())) {
                    if (roleId == 3) {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatCustomerPaymentCompletedJson(p, request.getContextPath()) + "\n\n");
                    } else {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatAdminPaymentCompletedJson(p, request.getContextPath()) + "\n\n");
                    }

                    Timestamp pTime = Timestamp.valueOf(p.getPaidAt());
                    if (pTime.after(maxPaymentTime)) {
                        maxPaymentTime = pTime;
                    }
                }
            }
            if (maxPaymentTime.after(lastCheckedPayment)) {
                lastCheckedPayment = maxPaymentTime;
            }

            // 2. Customer Notifications (Admin: 1, Staff: 2)
            if (roleId == 1 || roleId == 2) {
                List<CustomerDTO> newCustomers = customerDAO.getCustomersSince(lastCheckedCustomer);
                for (CustomerDTO c : newCustomers) {
                    if (c.getUser() != null && c.getUser().getCreateAt() != null) {
                        writer.write("event: notification\n");
                        writer.write("data: " + formatNewCustomerJson(c, request.getContextPath()) + "\n\n");

                        Timestamp cTime = Timestamp.valueOf(c.getUser().getCreateAt());
                        if (cTime.after(lastCheckedCustomer)) {
                            lastCheckedCustomer = cTime;
                        }
                    }
                }
            }

            // 3. Contract Workflow Notifications
            List<ContractHistory> newHistories = contractDAO.getContractHistoriesSinceId(lastContractHistoryId);
            for (ContractHistory h : newHistories) {
                if (h.getCreatedAt() != null) {
                    boolean shouldNotify = false;
                    String title = "";
                    String msg = "";
                    String link = request.getContextPath() + "/contract-detail?id=" + h.getContractId();

                    // user had just clicked button
                    int changerRole = h.getChangerRoleId();

                    // A. Officer submits to Manager (DRAFT/PENDING_REVIEW -> PENDING_REVIEW by Officer)
                    if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 5) {
                        if (roleId == 2) {
                            shouldNotify = true;
                            title = "Hợp đồng cần duyệt";
                            msg = "Officer vừa gửi hợp đồng " + h.getContractNumber() + " để duyệt.";
                        }
                    } // B. Manager requests edit (-> PENDING_REVIEW by Manager)
                    else if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 2) {
                        if (roleId == 5) {
                            shouldNotify = true;
                            title = "Yêu cầu sửa hợp đồng";
                            msg = "Manager yêu cầu sửa hợp đồng " + h.getContractNumber() + ".";
                        }
                    } // C. Customer requests edit (-> PENDING_REVIEW by Customer)
                    else if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 3) {
                        if (roleId == 2 || roleId == 5) {
                            shouldNotify = true;
                            title = "Khách hàng yêu cầu sửa";
                            msg = "Khách hàng yêu cầu sửa hợp đồng " + h.getContractNumber() + ".";
                        }
                    } // D. Manager approves (-> CUSTOMER_CHECK)
                    else if ("CUSTOMER_CHECK".equals(h.getToStatus())) {
                        if (roleId == 2) {
                            shouldNotify = true;
                            title = "Duyệt thành công";
                            msg = "Đã gửi hợp đồng " + h.getContractNumber() + " cho khách hàng.";
                        } else if (roleId == 3 && user.getUserId() == h.getCustomerUserId()) { // Customer
                            shouldNotify = true;
                            title = "Hợp đồng chờ ký";
                            msg = "Hợp đồng " + h.getContractNumber() + " đã sẵn sàng. Vui lòng kiểm tra và ký.";
                        }
                    } // E. Customer approves (-> APPROVED )
                    else if ("APPROVED".equals(h.getToStatus()) && changerRole == 3) {
                        if (roleId == 2 || roleId == 5) {
                            shouldNotify = true;
                            title = "Khách hàng đã chốt hợp đồng";
                            msg = "Khách hàng đã chốt " + h.getContractNumber() + ".";
                        }
                    } // F. Customer and Manager signs (-> SIGNED)
                    else if ("SIGNED".equals(h.getToStatus())) {
                        if (roleId == 2 || roleId == 5 || roleId == 6) {
                            shouldNotify = true;
                            title = "Cả hai bên đã ký hợp đồng";
                            msg = "Cả khách hàng và quản lý đã ký hợp đồng " + h.getContractNumber() + " thành công! "
                                    + "Vui lòng chuẩn bị hàng cho khách hàng! ";
                        }
                    }

                    if (shouldNotify) {
                        writer.write("event: notification\n");
                        writer.write("data: {\"type\":\"info\",\"title\":\"" + escapeJson(title)
                                + "\",\"message\":\"" + escapeJson(msg)
                                + "\",\"link\":\"" + escapeJson(link) + "\"}\n\n");
                    }

                    if (h.getHistoryId() > lastContractHistoryId) {
                        lastContractHistoryId = h.getHistoryId();
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
        if (input == null) {
            return "";
        }
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

    private String formatAdminContractSignedJson(Payment p, String contextPath) {
        String name = p.getCustomerName() != null ? p.getCustomerName() : "Khách hàng";
        String contractNo = p.getContractNumber() != null ? p.getContractNumber() : "";
        return String.format(
                "{\"type\":\"info\",\"title\":\"Ký hợp đồng\",\"message\":\"Khách hàng %s đã ký hợp đồng số %s.\",\"link\":\"%s/contract-detail?id=%d\",\"btnText\":\"Xem hợp đồng\",\"icon\":\"contract\",\"color\":\"#3b82f6\"}",
                escapeJson(name),
                escapeJson(contractNo),
                contextPath,
                p.getCustomerContractId()
        );
    }

    private String formatCustomerPaymentCompletedJson(Payment p, String contextPath) {
        double amt = p.getAmount() != null ? p.getAmount().doubleValue() : 0.0;
        String contractNo = p.getContractNumber() != null ? p.getContractNumber() : "";
        return String.format(
                "{\"type\":\"success\",\"title\":\"Thanh toán thành công\",\"message\":\"Bạn đã thanh toán thành công %,.0f VNĐ cho hợp đồng số %s.\",\"link\":\"%s/payment/detail?id=%d\",\"btnText\":\"Chi tiết\",\"icon\":\"payments\",\"color\":\"#10b981\"}",
                amt,
                escapeJson(contractNo),
                contextPath,
                p.getPaymentId()
        );
    }

    private String formatAdminPaymentCompletedJson(Payment p, String contextPath) {
        String name = p.getCustomerName() != null ? p.getCustomerName() : "Khách hàng";
        double amt = p.getAmount() != null ? p.getAmount().doubleValue() : 0.0;
        String contractNo = p.getContractNumber() != null ? p.getContractNumber() : "";
        return String.format(
                "{\"type\":\"success\",\"title\":\"Thanh toán thành công\",\"message\":\"Khách hàng %s đã thanh toán %,.0f VNĐ cho hợp đồng số %s.\",\"link\":\"%s/payment/detail?id=%d\",\"btnText\":\"Chi tiết\",\"icon\":\"payments\",\"color\":\"#10b981\"}",
                escapeJson(name),
                amt,
                escapeJson(contractNo),
                contextPath,
                p.getPaymentId()
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

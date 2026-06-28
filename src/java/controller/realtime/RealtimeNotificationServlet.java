package controller.realtime;

import dal.PaymentDAO;
import dal.CustomerDAO;
import model.Payment;
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
            "{\"type\":\"success\",\"title\":\"Ký hợp đồng thành công\",\"message\":\"Hợp đồng số %s trị giá %,.0f VNĐ vừa được ký.<br>Hãy nhấn vào \'Thanh toán\' để hoàn tất thủ tục.\",\"link\":\"%s/payment/list\",\"btnText\":\"Thanh toán\"}",
            escapeJson(contractNo),
            amt,
            contextPath
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

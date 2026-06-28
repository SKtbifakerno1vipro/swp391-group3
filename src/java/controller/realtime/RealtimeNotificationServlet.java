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
        Timestamp lastChecked = new Timestamp(System.currentTimeMillis());

        while (!writer.checkError()) {
            int roleId = user.getRoleId();

            // 1. Payments Notifications
            if (roleId == 3) {
                // Customer: only their own payments
                List<Payment> myPayments = paymentDAO.getPaymentsSince(lastChecked, user.getUserId());
                for (Payment p : myPayments) {
                    writer.write("event: notification\n");
                    writer.write("data: " + formatCustomerPaymentJson(p, request.getContextPath()) + "\n\n");
                    
                    if (p.getCreatedAt() != null) {
                        Timestamp pTime = Timestamp.valueOf(p.getCreatedAt());
                        if (pTime.after(lastChecked)) {
                            lastChecked = pTime;
                        }
                    }
                }
            } else {
                // Admin / Staff: all payments
                List<Payment> allPayments = paymentDAO.getPaymentsSince(lastChecked, null);
                for (Payment p : allPayments) {
                    writer.write("event: notification\n");
                    writer.write("data: " + formatAdminPaymentJson(p, request.getContextPath()) + "\n\n");
                    
                    if (p.getCreatedAt() != null) {
                        Timestamp pTime = Timestamp.valueOf(p.getCreatedAt());
                        if (pTime.after(lastChecked)) {
                            lastChecked = pTime;
                        }
                    }
                }
            }

            // 2. Customer Notifications (Admin: 1, Staff: 2)
            if (roleId == 1 || roleId == 2) {
                List<CustomerDTO> newCustomers = customerDAO.getCustomersSince(lastChecked);
                for (CustomerDTO c : newCustomers) {
                    writer.write("event: notification\n");
                    writer.write("data: " + formatNewCustomerJson(c, request.getContextPath()) + "\n\n");
                    
                    if (c.getUser() != null && c.getUser().getCreateAt() != null) {
                        Timestamp cTime = Timestamp.valueOf(c.getUser().getCreateAt());
                        if (cTime.after(lastChecked)) {
                            lastChecked = cTime;
                        }
                    }
                }
            }

            writer.flush();

            try {
                Thread.sleep(4000);
            } catch (InterruptedException e) {
                break;
            }
        }
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
        return String.format(
            "{\"type\":\"success\",\"title\":\"Thành công\",\"message\":\"Giao dịch thanh toán trị giá %,.0f VNĐ đã được xử lý.\",\"link\":\"%s/payment/list\"}",
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

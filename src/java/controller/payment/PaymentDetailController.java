package controller.payment;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Payment;
import model.User;
import service.PaymentService;

@WebServlet(name = "PaymentDetailController", urlPatterns = {"/payment/detail"})
public class PaymentDetailController extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/payment/list");
            return;
        }

        try {
            int paymentId = Integer.parseInt(idStr);
            Payment payment = paymentService.getPaymentById(paymentId);

            if (payment == null) {
                response.sendRedirect(request.getContextPath() + "/payment/list");
                return;
            }

            // Security check: Customers should only see their own payments
            if (user.getRoleId() == 3 && payment.getCreatedBy() != null && payment.getCreatedBy() != user.getUserId()) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=denied");
                return;
            }

            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/views/payment/payment_detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/payment/list");
        }
    }
}

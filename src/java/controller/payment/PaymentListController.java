package controller.payment;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Payment;
import model.User;
import service.PaymentService;

@WebServlet(name = "PaymentListController", urlPatterns = {"/payment/list"})
public class PaymentListController extends HttpServlet {

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

        List<Payment> list;
        if (user.getRoleId() == 3) {
            // Customer - only view their own payments
            list = paymentService.getPaymentsByCustomerId(user.getUserId());
        } else {
            // Admin, Manager, etc. - view all payments
            list = paymentService.getAllPayments();
        }

        request.setAttribute("list", list);
        request.getRequestDispatcher("/views/payment/payment_list.jsp").forward(request, response);
    }
}

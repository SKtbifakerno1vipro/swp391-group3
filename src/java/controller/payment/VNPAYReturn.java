package controller.payment;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VNPAYReturn", urlPatterns = {"/payment/return"})
public class VNPAYReturn extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String vnp_TxnRef = req.getParameter("vnp_TxnRef");

        int paymentId = -1;
        try {
            if (vnp_TxnRef != null) {
                if (vnp_TxnRef.contains("_")) {
                    paymentId = Integer.parseInt(vnp_TxnRef.split("_")[0]);
                } else {
                    paymentId = Integer.parseInt(vnp_TxnRef);
                }
            }
        } catch (NumberFormatException ignored) {}

        if (paymentId > 0) {
            resp.sendRedirect(req.getContextPath() + "/payment/detail?id=" + paymentId);
        } else {
            resp.sendRedirect(req.getContextPath() + "/payment/list");
        }
    }
}

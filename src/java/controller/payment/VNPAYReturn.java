package controller.payment;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Enumeration;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Payment;
import model.User;
import model.Contract;
import service.PaymentService;
import dal.ContractDAO;

@WebServlet(name = "VNPAYReturn", urlPatterns = {"/payment/return"})
public class VNPAYReturn extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();
    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = req.getParameter(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");

        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder hashData = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = fields.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    hashData.append('&');
                }
            }
        }

        String signValue = PaymentConfig.hmacSHA512(PaymentConfig.vnp_HashSecret, hashData.toString());
        boolean isSignValid = signValue.equalsIgnoreCase(vnp_SecureHash);

        String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = req.getParameter("vnp_TxnRef");
        String vnp_Amount = req.getParameter("vnp_Amount");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        long amountCents = Long.parseLong(vnp_Amount != null ? vnp_Amount : "0");
        BigDecimal amountPaid = BigDecimal.valueOf(amountCents / 100.0);

        int paymentId = -1;
        try {
            paymentId = Integer.parseInt(vnp_TxnRef);
        } catch (NumberFormatException ignored) {}

        String newStatus = (isSignValid && "00".equals(vnp_ResponseCode)) ? "COMPLETED" : "FAILED";

        if (paymentId > 0) {
            // Update existing payment status
            paymentService.updatePaymentStatus(paymentId, newStatus);
        } else {
            // Fallback: insert new payment record
            int contractId = paymentService.getAnyContractId();
            Payment payment = new Payment();
            payment.setCustomerContractId(contractId);
            payment.setAmount(amountPaid);
            payment.setPaymentType("VNPAY");
            payment.setPaidAt("COMPLETED".equals(newStatus) ? LocalDateTime.now() : null);
            payment.setPaymentStatus(newStatus);
            payment.setCreatedBy(user != null ? user.getUserId() : null);
            paymentId = paymentService.insertPayment(payment);
        }

        resp.sendRedirect(req.getContextPath() + "/payment/detail?id=" + paymentId);
    }
}

package controller.payment;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.PaymentConfig;
import service.PaymentService;
import model.Payment;

@WebServlet(name = "VNPAYPayment", urlPatterns = {"/payment"})
public class VNPAYPayment extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!PaymentConfig.isValidConfig) {
            String errorMsg = URLEncoder.encode("Payment service is temporarily misconfigured. Please contact support", StandardCharsets.UTF_8.toString());
            String pidStr = req.getParameter("paymentId");
            if (pidStr != null && !pidStr.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/payment/detail?id=" + pidStr + "&error=" + errorMsg);
            } else {
                resp.sendRedirect(req.getContextPath() + "/payment/list?error=" + errorMsg);
            }
            return;
        }

        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_TmnCode = PaymentConfig.vnp_TmnCode; 
        String vnp_IpAddr = PaymentConfig.getIpAddress(req);
        String vnp_CurrCode = "VND";
        
        String paymentIdStr = req.getParameter("paymentId"); 
        if (paymentIdStr == null || paymentIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/payment/list?error=" + 
            URLEncoder.encode("Mã thanh toán không hợp lệ!", StandardCharsets.UTF_8.toString()));
            return;
        }

        int paymentId = -1;
        try {
            paymentId = Integer.parseInt(paymentIdStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/payment/list?error=" + 
            URLEncoder.encode("Mã thanh toán không hợp lệ!", StandardCharsets.UTF_8.toString()));
            return;
        }

        PaymentService paymentService = new PaymentService();
        Payment p = paymentService.getPaymentById(paymentId);
        if (p == null) {
            resp.sendRedirect(req.getContextPath() + "/payment/list?error=" + 
            URLEncoder.encode("Không tìm thấy thông tin thanh toán!", StandardCharsets.UTF_8.toString()));
            return;
        }
        if ("COMPLETED".equals(p.getPaymentStatus())) {
            resp.sendRedirect(req.getContextPath() + "/payment/detail?id=" + paymentId + "&error=" + 
            URLEncoder.encode("Khoản thanh toán này đã hoàn tất từ trước!", StandardCharsets.UTF_8.toString()));
            return;
        }
        if ("FAILED".equals(p.getPaymentStatus()) || "CANCELLED".equals(p.getPaymentStatus())) {
            paymentService.updatePaymentStatus(paymentId, "PENDING");
        }
        String vnp_TxnRef = paymentId + "_" + System.currentTimeMillis();

        long amountValue = (p.getAmount() != null) ? p.getAmount().longValue() : 0L;
        long amount = amountValue * 100; 
        String vnp_OrderInfo = "Thanh toan don hang " + vnp_TxnRef; 
        String orderType = "other"; 

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", vnp_Version);
        vnp_Params.put("vnp_Command", vnp_Command);
        vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", vnp_CurrCode);
        vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
        vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
        vnp_Params.put("vnp_OrderType", orderType);
        vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
        vnp_Params.put("vnp_Locale", "en"); 

        
        String contextPath = req.getContextPath();
        // http://localhost:8080/swp391-group3/payment/return
        String returnUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + contextPath + "/payment/return";
        vnp_Params.put("vnp_ReturnUrl", returnUrl);

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);
        
        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString())).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                    hashData.append('&');
                }
            }
        }
        
        String queryUrl = query.toString();
        String vnp_SecureHash = PaymentConfig.hmacSHA512(PaymentConfig.vnp_HashSecret, hashData.toString());
        queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
        String paymentUrl = PaymentConfig.vnp_PayUrl + "?" + queryUrl;

        resp.sendRedirect(paymentUrl);
    }
}

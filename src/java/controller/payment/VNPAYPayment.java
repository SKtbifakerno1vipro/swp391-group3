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

@WebServlet(name = "VNPAYPayment", urlPatterns = {"/payment"})
public class VNPAYPayment extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String vnp_Version = "2.1.0";
        String vnp_Command = "pay";
        String vnp_TmnCode = PaymentConfig.vnp_TmnCode; 
        String vnp_IpAddr = PaymentConfig.getIpAddress(req);
        String vnp_CurrCode = "VND";
        
        String vnp_TxnRef = req.getParameter("orderId"); 
        if (vnp_TxnRef == null || vnp_TxnRef.isEmpty()) {
            vnp_TxnRef = req.getParameter("vnp_TxnRef");
        }
        if (vnp_TxnRef == null || vnp_TxnRef.isEmpty()) {
            vnp_TxnRef = String.valueOf(System.currentTimeMillis());
        }

        long amountValue = Long.parseLong(req.getParameter("amount"));
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
        vnp_Params.put("vnp_Locale", "vn"); 

        
        String contextPath = req.getContextPath();
        String returnUrl = req.getScheme() + "://" + req.getServerName() + ":" + req.getServerPort() + contextPath + "/payment-return";
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

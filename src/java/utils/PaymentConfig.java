package utils;

import jakarta.servlet.http.HttpServletRequest;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class PaymentConfig {
    public static String vnp_PayUrl;
    public static String vnp_TmnCode; 
    public static String vnp_HashSecret; 
    public static boolean isValidConfig = true;

    static {
        Properties props = new Properties();
        try {
            java.io.File classesDir = new java.io.File(PaymentConfig.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            java.io.File webInfDir = classesDir.getParentFile();
            java.io.File file = new java.io.File(webInfDir, "resources/PaymentConfig.properties");
            try (InputStream input = new java.io.FileInputStream(file)) {
                props.load(input);
                vnp_PayUrl = props.getProperty("vnp_PayUrl");
                vnp_TmnCode = props.getProperty("vnp_TmnCode");
                vnp_HashSecret = props.getProperty("vnp_HashSecret");
            }
        } catch (Exception e) {
            System.out.println("[ERROR] Failed to load PaymentConfig.properties: " + e.getMessage());
        }
        // Kiểm tra tính hợp lệ của tham số cấu hình
        if (vnp_PayUrl == null || vnp_PayUrl.trim().isEmpty() ||
            vnp_TmnCode == null || vnp_TmnCode.trim().isEmpty() ||
            vnp_HashSecret == null || vnp_HashSecret.trim().isEmpty()) {
            
            isValidConfig = false;
            System.err.println("[ERROR] PaymentConfig is invalid! Payment service is temporarily misconfigured.");
            if (vnp_PayUrl == null || vnp_PayUrl.trim().isEmpty()) {
                System.err.println("[ERROR] Missing parameter: vnp_PayUrl");
            }
            if (vnp_TmnCode == null || vnp_TmnCode.trim().isEmpty()) {
                System.err.println("[ERROR] Missing parameter: vnp_TmnCode");
            }
            if (vnp_HashSecret == null || vnp_HashSecret.trim().isEmpty()) {
                System.err.println("[ERROR] Missing parameter: vnp_HashSecret");
            }
        }
    }
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                return null;
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes(StandardCharsets.UTF_8);
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] result = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    public static String getIpAddress(HttpServletRequest request) {
        String ipAddress;
        try {
            ipAddress = request.getHeader("X-FORWARDED-FOR");
            if (ipAddress == null) {
                ipAddress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAddress = "127.0.0.1";
        }
        return ipAddress;
    }
}

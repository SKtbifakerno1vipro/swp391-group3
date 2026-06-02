package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtils {

    private static final String HOSTNAME = "smtp.gmail.com";
    private static final String PORT = "587"; // Cổng TLS của Gmail
    private static final String FROM_EMAIL = "email_cua_ban@gmail.com";
    private static final String APP_PASSWORD = "chuoi_16_ky_tu_mat_khau_ung_dung";

    public static boolean sendEmail(String toEmail, String subject, String content) {
        // 1. Cấu hình các thuộc tính kết nối SMTP
        Properties props = new Properties();
        props.put("mail.smtp.host", HOSTNAME);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Bắt buộc dùng TLS

        // 2. Xác thực tài khoản
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        };

        // 3. Tạo Session làm việc
        Session session = Session.getInstance(props, auth);

        try {
            // 4. Cấu hình nội dung thư
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            msg.setFrom(new InternetAddress(FROM_EMAIL, "Hệ Thống SWP391"));
            msg.setReplyTo(InternetAddress.parse(FROM_EMAIL, false));
            msg.setSubject(subject, "UTF-8");
            
            // Hỗ trợ viết code HTML trong nội dung mail (gửi mail định dạng đẹp)
            msg.setContent(content, "text/html; charset=UTF-8"); 
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));

            // 5. Gửi hành trình đi
            Transport.send(msg);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
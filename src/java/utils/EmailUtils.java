package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.InputStream;
import java.util.Properties;

public class EmailUtils {
    //thư viện Jakarta Mail API để kết nối với Server SMTP của Google (Gmail) và gửi email đi dưới dạng mã HTML

    private static final String HOSTNAME = "smtp.gmail.com";
    private static final String PORT = "587"; // Cổng TLS của Gmail
    
    // Helper method to load email configuration from properties file
    private static Properties loadEmailProperties() {
        Properties props = new Properties();
        try (InputStream input = EmailUtils.class.getClassLoader().getResourceAsStream("../../WEB-INF/EmailConfig.properties")) {
            if (input != null) {
                props.load(input);
            } else {
                System.out.println("[ERROR] EmailConfig.properties file not found!");
            }
        } catch (Exception e) {
            System.out.println("[ERROR] Failed to load EmailConfig.properties: " + e.getMessage());
            e.printStackTrace();
        }
        return props;
    }
    
    public static boolean sendEmail(String toEmail, String subject, String content) {
        // Read credentials from local properties file
        Properties config = loadEmailProperties();
        final String loginUser = config.getProperty("mail.smtp.user");
        final String smtpKey = config.getProperty("mail.smtp.key"); // Đối với Gmail, đây chính là App Password
        final String senderEmail = config.getProperty("mail.sender.email");
        final String senderName = config.getProperty("mail.sender.name");

        if (loginUser == null || smtpKey == null) {
            System.out.println("[WARNING] Email credentials are empty. Cannot send email!");
            return false;
        }

        // Configure SMTP connection properties for Gmail // setting SMTP cho gate gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", HOSTNAME);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Bắt buộc dùng TLS đối với Gmail cổng 587
        
        // tránh lỗi bắt tay SSL/TLS với server Google
        props.put("mail.smtp.ssl.protocols", "TLSv1.2"); 
        props.put("mail.smtp.starttls.required", "true");

        // kiem tra danh tinh khi connect voi gmail
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(loginUser, smtpKey);
            }
        });
        session.setDebug(true);
        try {
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            
            // Đối với Gmail, senderEmail bắt buộc phải trùng khớp với loginUser (Email cá nhân của bạn)
            msg.setFrom(new InternetAddress(senderEmail, senderName));
            
            msg.setSubject(subject, "UTF-8");
            msg.setContent(content, "text/html; charset=UTF-8"); // Supports HTML tags for rich layout
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));

            System.out.println("[INFO] Attempting to send email to: " + toEmail);
            Transport.send(msg);
            System.out.println("[SUCCESS] Email sent successfully to: " + toEmail);
            return true;
        } catch (Exception e) {
            System.out.println("[SEVERE] Failed to send email to: " + toEmail + ". Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
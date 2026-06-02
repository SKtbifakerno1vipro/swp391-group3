package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.InputStream;
import java.util.Properties;

public class EmailUtils {

    private static final String HOSTNAME = "smtp-relay.brevo.com";
    private static final String PORT = "587"; 
    
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
        final String smtpKey = config.getProperty("mail.smtp.key");

        if (loginUser == null || smtpKey == null) {
            System.out.println("[WARNING] Email credentials are empty. Cannot send email!");
            return false;
        }

        // Configure SMTP connection properties for Brevo
        Properties props = new Properties();
        props.put("mail.smtp.host", HOSTNAME);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Force TLS encryption

        // Authenticate session with Brevo Server
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(loginUser, smtpKey);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            
            // Sender email must match your registered Brevo account email
            msg.setFrom(new InternetAddress(loginUser, "SWP391 System Notification"));
            
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
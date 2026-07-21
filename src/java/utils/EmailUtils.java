package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.InputStream;
import java.util.Properties;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import dal.EmailLogDAO;

public class EmailUtils {

    //thu vien Jakarta Mail API đe ket noi voi Server SMTP cua Google (Gmail) va gui email đi duoi dang ma HTML
    private static final EmailLogDAO emailLogDAO = new EmailLogDAO();
    private static final String HOSTNAME = "smtp.gmail.com";
    private static final String PORT = "587"; // Cổng TLS của Gmail

    private static Properties loadEmailProperties() {
        Properties props = new Properties();
        try {
            // Lấy URL nơi chứa class file này khi chạy trên Web Server (đã build) (/WEB-INF/classes/)
            java.io.File classesDir = new java.io.File(EmailUtils.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            java.io.File webInfDir = classesDir.getParentFile();
            java.io.File file = new java.io.File(webInfDir, "resources/EmailConfig.properties");
            try (InputStream input = new java.io.FileInputStream(file)) {
                props.load(input);
            }
        } catch (Exception e) {
            System.out.println("[ERROR] Failed to load EmailConfig.properties: " + e.getMessage());
            e.printStackTrace();
        }
        return props;
    }

    private static final ExecutorService executor = Executors.newCachedThreadPool();

    private static boolean sendEmailRaw(String toEmail, String subject, String content) throws Exception {
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

        // tranh loi bat tay SSL/TLS voi server Google
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

        MimeMessage msg = new MimeMessage(session);
        msg.addHeader("Content-Type", "text/html; charset=UTF-8");

        // Đoi voi Gmail, senderEmail bat buoc phai trung khop voi loginUser (Email ca nhan cua ban)
        msg.setFrom(new InternetAddress(senderEmail, senderName, "UTF-8"));

        msg.setSubject(subject, "UTF-8");

        msg.setHeader("Content-Type", "text/html; charset=UTF-8");
        msg.setHeader("Content-Transfer-Encoding", "quoted-printable");

        msg.setContent(content, "text/html; charset=UTF-8");
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));

        System.out.println("[INFO] Attempting to send email to: " + toEmail);
        System.out.println("file.encoding = " + System.getProperty("file.encoding"));
        System.out.println("native.encoding = " + System.getProperty("native.encoding"));
        Transport.send(msg);
        return true;
    }

    public static void sendEmailAsync(final String toEmail, final String subject, final String content, final Integer userId) {
        executor.submit(() -> {
            int maxRetries = 3;
            int attempt = 0;
            boolean sent = false;
            while (attempt < maxRetries && !sent) {
                attempt++;
                try {
                    System.out.println("[INFO] Async email send attempt " + attempt + " to: " + toEmail);
                    sent = sendEmailRaw(toEmail, subject, content);
                    if (sent) {
                        System.out.println("[SUCCESS] Async email sent successfully to: " + toEmail);
                        try {
                            emailLogDAO.insertLog(toEmail, subject, content, "SUCCESS", userId);
                        } catch (Exception ex) {
                            System.out.println("[WARNING] Failed to write email log: " + ex.getMessage());
                        }
                    }
                } catch (Exception e) {
                    System.out.println("[WARNING] Async email send attempt " + attempt + " failed for: " + toEmail + ". Error: " + e.getMessage());
                    if (attempt >= maxRetries) {
                        System.out.println("[SEVERE] Async email failed permanently after " + maxRetries + " attempts to: " + toEmail);
                        try {
                            emailLogDAO.insertLog(toEmail, subject, content, "FAILED", userId);
                        } catch (Exception ex) {
                            System.out.println("[WARNING] Failed to write email log: " + ex.getMessage());
                        }
                    } else {
                        try {
                            Thread.sleep(5000); // Wait 5 seconds before retrying
                        } catch (InterruptedException ie) {
                            Thread.currentThread().interrupt();
                            break;
                        }
                    }
                }
            }
        });
    }
}

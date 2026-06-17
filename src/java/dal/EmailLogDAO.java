package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.EmailLog;

public class EmailLogDAO extends DBContext {

    public EmailLogDAO() {
        super();
        createTableIfNotExists();
    }

    private void createTableIfNotExists() {
        String sql = "IF OBJECT_ID('email_log', 'U') IS NULL "
                   + "BEGIN "
                   + "    CREATE TABLE email_log ( "
                   + "        log_id INT IDENTITY(1,1) PRIMARY KEY, "
                   + "        recipient NVARCHAR(255) NOT NULL, "
                   + "        subject NVARCHAR(255) NOT NULL, "
                   + "        content NVARCHAR(MAX) NOT NULL, "
                   + "        sent_at DATETIME DEFAULT GETDATE(), "
                   + "        status VARCHAR(20) NOT NULL "
                   + "    ); "
                   + "END";
        try {
            if (connection != null) {
                try (PreparedStatement st = connection.prepareStatement(sql)) {
                    st.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insertLog(String recipient, String subject, String content, String status) {
        String sql = "INSERT INTO email_log (recipient, subject, content, status) VALUES (?, ?, ?, ?)";
        try {
            if (connection != null) {
                try (PreparedStatement st = connection.prepareStatement(sql)) {
                    st.setString(1, recipient);
                    st.setString(2, subject);
                    st.setString(3, content);
                    st.setString(4, status);
                    st.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<EmailLog> getAllLogs() {
        List<EmailLog> list = new ArrayList<>();
        String sql = "SELECT * FROM email_log ORDER BY sent_at DESC";
        try {
            if (connection != null) {
                try (PreparedStatement st = connection.prepareStatement(sql);
                     ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        EmailLog log = new EmailLog(
                            rs.getInt("log_id"),
                            rs.getString("recipient"),
                            rs.getString("subject"),
                            rs.getString("content"),
                            rs.getTimestamp("sent_at"),
                            rs.getString("status")
                        );
                        list.add(log);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

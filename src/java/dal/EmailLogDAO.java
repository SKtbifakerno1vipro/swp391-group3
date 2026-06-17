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
        String sql = "SELECT el.*, u.user_name FROM email_log el LEFT JOIN [user] u ON el.recipient = u.email ORDER BY el.sent_at DESC";
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
                            rs.getString("status"),
                            rs.getString("user_name")
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

    public List<EmailLog> searchAndPaginateLogs(String searchEmail, String searchUsername, Timestamp startTimestamp, Timestamp endTimestamp, int page, int pageSize) {
        List<EmailLog> list = new ArrayList<>();
        String sql = "SELECT el.*, u.user_name FROM email_log el LEFT JOIN [user] u ON el.recipient = u.email WHERE 1=1";
        
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            sql += " AND el.recipient LIKE ?";
        }
        if (searchUsername != null && !searchUsername.trim().isEmpty()) {
            sql += " AND u.user_name LIKE ?";
        }
        if (startTimestamp != null) {
            sql += " AND el.sent_at >= ?";
        }
        if (endTimestamp != null) {
            sql += " AND el.sent_at <= ?";
        }
        
        sql += " ORDER BY el.sent_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            if (connection != null) {
                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    int index = 1;
                    if (searchEmail != null && !searchEmail.trim().isEmpty()) {
                        ps.setString(index++, "%" + searchEmail.trim() + "%");
                    }
                    if (searchUsername != null && !searchUsername.trim().isEmpty()) {
                        ps.setString(index++, "%" + searchUsername.trim() + "%");
                    }
                    if (startTimestamp != null) {
                        ps.setTimestamp(index++, startTimestamp);
                    }
                    if (endTimestamp != null) {
                        ps.setTimestamp(index++, endTimestamp);
                    }
                    ps.setInt(index++, (page - 1) * pageSize);
                    ps.setInt(index++, pageSize);
                    
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            EmailLog log = new EmailLog(
                                rs.getInt("log_id"),
                                rs.getString("recipient"),
                                rs.getString("subject"),
                                rs.getString("content"),
                                rs.getTimestamp("sent_at"),
                                rs.getString("status"),
                                rs.getString("user_name")
                            );
                            list.add(log);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalLogsCount(String searchEmail, String searchUsername, Timestamp startTimestamp, Timestamp endTimestamp) {
        String sql = "SELECT COUNT(*) FROM email_log el LEFT JOIN [user] u ON el.recipient = u.email WHERE 1=1";
        
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            sql += " AND el.recipient LIKE ?";
        }
        if (searchUsername != null && !searchUsername.trim().isEmpty()) {
            sql += " AND u.user_name LIKE ?";
        }
        if (startTimestamp != null) {
            sql += " AND el.sent_at >= ?";
        }
        if (endTimestamp != null) {
            sql += " AND el.sent_at <= ?";
        }
        
        try {
            if (connection != null) {
                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    int index = 1;
                    if (searchEmail != null && !searchEmail.trim().isEmpty()) {
                        ps.setString(index++, "%" + searchEmail.trim() + "%");
                    }
                    if (searchUsername != null && !searchUsername.trim().isEmpty()) {
                        ps.setString(index++, "%" + searchUsername.trim() + "%");
                    }
                    if (startTimestamp != null) {
                        ps.setTimestamp(index++, startTimestamp);
                    }
                    if (endTimestamp != null) {
                        ps.setTimestamp(index++, endTimestamp);
                    }
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return rs.getInt(1);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}

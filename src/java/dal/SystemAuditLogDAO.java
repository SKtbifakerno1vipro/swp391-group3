package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.SystemAuditLog;

public class SystemAuditLogDAO extends DBContext {

    public boolean insertLog(SystemAuditLog log) {
        String sql = "INSERT INTO system_audit_log (user_id, action_type, affected_object, description, created_at) "
                   + "VALUES (?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (log.getUserId() != null) {
                ps.setInt(1, log.getUserId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, log.getActionType());
            ps.setString(3, log.getAffectedObject());
            ps.setString(4, log.getDescription());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error inserting audit log: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public List<SystemAuditLog> getLogsWithFilters(String actionType, String affectedObject, String searchUser, 
                                                   String startDate, String endDate, int pageIndex, int pageSize) {
        List<SystemAuditLog> list = new ArrayList<>();
        String sql = "SELECT l.*, u.user_name, u.full_name "
                   + "FROM system_audit_log l "
                   + "LEFT JOIN [user] u ON l.user_id = u.user_id "
                   + "WHERE 1=1";

        if (actionType != null && !actionType.trim().isEmpty()) {
            sql += " AND l.action_type = ?";
        }
        if (affectedObject != null && !affectedObject.trim().isEmpty()) {
            sql += " AND l.affected_object = ?";
        }
        if (searchUser != null && !searchUser.trim().isEmpty()) {
            sql += " AND (u.user_name LIKE ? OR u.full_name LIKE ?)";
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql += " AND l.created_at >= ?";
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql += " AND l.created_at <= ?";
        }

        sql += " ORDER BY l.log_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (actionType != null && !actionType.trim().isEmpty()) {
                ps.setString(index++, actionType.trim());
            }
            if (affectedObject != null && !affectedObject.trim().isEmpty()) {
                ps.setString(index++, affectedObject.trim());
            }
            if (searchUser != null && !searchUser.trim().isEmpty()) {
                String searchPattern = "%" + searchUser.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }
            if (startDate != null && !startDate.trim().isEmpty()) {
                ps.setString(index++, startDate.trim() + " 00:00:00");
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                ps.setString(index++, endDate.trim() + " 23:59:59");
            }
            ps.setInt(index++, (pageIndex - 1) * pageSize);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SystemAuditLog log = new SystemAuditLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                log.setActionType(rs.getString("action_type"));
                log.setAffectedObject(rs.getString("affected_object"));
                log.setDescription(rs.getString("description"));
                if (rs.getTimestamp("created_at") != null) {
                    log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                log.setUserName(rs.getString("user_name"));
                log.setUserFullName(rs.getString("full_name"));
                list.add(log);
            }
        } catch (Exception e) {
            System.err.println("Error search audit logs: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalLogs(String actionType, String affectedObject, String searchUser, String startDate, String endDate) {
        String sql = "SELECT COUNT(*) "
                   + "FROM system_audit_log l "
                   + "LEFT JOIN [user] u ON l.user_id = u.user_id "
                   + "WHERE 1=1";

        if (actionType != null && !actionType.trim().isEmpty()) {
            sql += " AND l.action_type = ?";
        }
        if (affectedObject != null && !affectedObject.trim().isEmpty()) {
            sql += " AND l.affected_object = ?";
        }
        if (searchUser != null && !searchUser.trim().isEmpty()) {
            sql += " AND (u.user_name LIKE ? OR u.full_name LIKE ?)";
        }
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql += " AND l.created_at >= ?";
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql += " AND l.created_at <= ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (actionType != null && !actionType.trim().isEmpty()) {
                ps.setString(index++, actionType.trim());
            }
            if (affectedObject != null && !affectedObject.trim().isEmpty()) {
                ps.setString(index++, affectedObject.trim());
            }
            if (searchUser != null && !searchUser.trim().isEmpty()) {
                String searchPattern = "%" + searchUser.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }
            if (startDate != null && !startDate.trim().isEmpty()) {
                ps.setString(index++, startDate.trim() + " 00:00:00");
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                ps.setString(index++, endDate.trim() + " 23:59:59");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Error counting audit logs: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public List<String> getUniqueAffectedObjects() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT affected_object FROM system_audit_log ORDER BY affected_object";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("affected_object"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

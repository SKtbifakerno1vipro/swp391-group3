package service;

import dal.SystemAuditLogDAO;
import model.SystemAuditLog;
import java.util.List;

public class AuditLogService {
    private final SystemAuditLogDAO auditLogDAO;

    public AuditLogService() {
        this.auditLogDAO = new SystemAuditLogDAO();
    }

    public static void log(Integer userId, String actionType, String affectedObject, String description) {
        try {
            SystemAuditLog log = new SystemAuditLog();
            log.setUserId(userId);
            log.setActionType(actionType);
            log.setAffectedObject(affectedObject);
            log.setDescription(description);
            
            SystemAuditLogDAO dao = new SystemAuditLogDAO();
            dao.insertLog(log);
            System.out.println("[AUDIT LOG] Action: " + actionType + " | Object: " + affectedObject + " | User ID: " + userId + " | Desc: " + description);
        } catch (Exception e) {
            System.err.println("Failed to write audit log: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<SystemAuditLog> getLogsWithFilters(String actionType, String affectedObject, String searchUser, 
                                                   String startDate, String endDate, int pageIndex, int pageSize) {
        return auditLogDAO.getLogsWithFilters(actionType, affectedObject, searchUser, startDate, endDate, pageIndex, pageSize);
    }

    public int getTotalLogs(String actionType, String affectedObject, String searchUser, String startDate, String endDate) {
        return auditLogDAO.getTotalLogs(actionType, affectedObject, searchUser, startDate, endDate);
    }

    public List<String> getUniqueAffectedObjects() {
        return auditLogDAO.getUniqueAffectedObjects();
    }
}

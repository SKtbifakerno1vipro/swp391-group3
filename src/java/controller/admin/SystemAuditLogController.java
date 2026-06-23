package controller.admin;

import service.AuditLogService;
import model.SystemAuditLog;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SystemAuditLogController", urlPatterns = {"/admin/audit-logs"})
public class SystemAuditLogController extends HttpServlet {

    private final AuditLogService auditLogService = new AuditLogService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) { // 1 is System Admin
            response.sendRedirect(request.getContextPath() + "/dashboard?error=denied");
            return;
        }

        String actionType = request.getParameter("actionType");
        String affectedObject = request.getParameter("affectedObject");
        String searchUser = request.getParameter("searchUser");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageRaw = request.getParameter("page");

        int page = 1;
        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (actionType != null) actionType = actionType.trim();
        if (affectedObject != null) affectedObject = affectedObject.trim();
        if (searchUser != null) searchUser = searchUser.trim();
        if (startDate != null) startDate = startDate.trim();
        if (endDate != null) endDate = endDate.trim();

        List<SystemAuditLog> logs = auditLogService.getLogsWithFilters(actionType, affectedObject, searchUser, startDate, endDate, page, PAGE_SIZE);
        int totalRecords = auditLogService.getTotalLogs(actionType, affectedObject, searchUser, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) {
            totalPages = 1;
        }

        List<String> affectedObjects = auditLogService.getUniqueAffectedObjects();

        request.setAttribute("auditLogs", logs);
        request.setAttribute("affectedObjects", affectedObjects);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("actionType", actionType);
        request.setAttribute("affectedObject", affectedObject);
        request.setAttribute("searchUser", searchUser);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/views/admin/audit_logs.jsp").forward(request, response);
    }
}

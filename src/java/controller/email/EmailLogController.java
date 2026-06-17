package controller.email;

import dal.EmailLogDAO;
import model.EmailLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "EmailLogController", urlPatterns = {"/email/logs"})
public class EmailLogController extends HttpServlet {

    private final EmailLogDAO emailLogDAO = new EmailLogDAO();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchEmail = request.getParameter("searchEmail");
        String searchUsername = request.getParameter("searchUsername");
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

        if (searchEmail != null) {
            searchEmail = searchEmail.trim();
        }
        if (searchUsername != null) {
            searchUsername = searchUsername.trim();
        }

        Timestamp startTimestamp = null;
        Timestamp endTimestamp = null;

        if (startDate != null && !startDate.isBlank()) {
            try {
                LocalDateTime localDateTime = LocalDateTime.parse(startDate, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                startTimestamp = Timestamp.valueOf(localDateTime);
            } catch (Exception ignored) {
            }
        }

        if (endDate != null && !endDate.isBlank()) {
            try {
                LocalDateTime localDateTime = LocalDateTime.parse(endDate, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                endTimestamp = Timestamp.valueOf(localDateTime);
            } catch (Exception ignored) {
            }
        }

        List<EmailLog> list = emailLogDAO.searchAndPaginateLogs(searchEmail, searchUsername, startTimestamp, endTimestamp, page, PAGE_SIZE);
        int totalRecords = emailLogDAO.getTotalLogsCount(searchEmail, searchUsername, startTimestamp, endTimestamp);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) {
            totalPages = 1;
        }

        request.setAttribute("emailLogs", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("searchUsername", searchUsername);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("/views/email/email_logs.jsp").forward(request, response);
    }
}

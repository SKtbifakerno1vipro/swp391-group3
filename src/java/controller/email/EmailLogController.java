package controller.email;

import dal.EmailLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "EmailLogController", urlPatterns = {"/email/logs"})
public class EmailLogController extends HttpServlet {

    private final EmailLogDAO emailLogDAO = new EmailLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("emailLogs", emailLogDAO.getAllLogs());
        request.getRequestDispatcher("/views/email/email_logs.jsp").forward(request, response);
    }
}

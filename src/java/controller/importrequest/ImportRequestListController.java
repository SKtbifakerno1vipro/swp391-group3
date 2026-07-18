package controller.importrequest;

import dal.ImportRequestDAO;
import model.ImportRequest;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ImportRequestListController", urlPatterns = {"/import-request-list"})
public class ImportRequestListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ImportRequestDAO importRequestDAO = new ImportRequestDAO();
        List<ImportRequest> list = importRequestDAO.getAllImportRequests();

        request.setAttribute("list", list);
        request.setAttribute("message", request.getParameter("message"));
        request.getRequestDispatcher("/views/importrequest/list.jsp").forward(request, response);
    }
}

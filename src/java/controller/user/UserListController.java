package controller.user;

import service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UserListController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roleId = request.getParameter("roleId");
        String status = request.getParameter("status");
        request.setAttribute("roleId", roleId);
        request.setAttribute("status", status);
        request.setAttribute("users", userService.searchUsers(roleId, status));
        request.getRequestDispatcher("/views/user/list.jsp").forward(request, response);
    }
}

package controller.user;

import service.UserService;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CreateUserController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User u = new User();
        u.setUserName(request.getParameter("userName"));
        u.setPassword(request.getParameter("password"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus(request.getParameter("status"));
        u.setRoleId(Integer.parseInt(request.getParameter("roleId")));

        userService.createUser(u);
        response.sendRedirect(request.getContextPath() + "/user-list");
    }
}

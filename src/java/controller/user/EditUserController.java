package controller.user;

import service.UserService;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class EditUserController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int idEdit = Integer.parseInt(idStr);
            request.setAttribute("u", userService.getUserById(idEdit));
            request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("userId");
        if (idStr != null && !idStr.isEmpty()) {
            User u = new User();
            u.setUserId(Integer.parseInt(idStr));
            u.setUserName(request.getParameter("userName"));
            u.setPassword(request.getParameter("password"));
            u.setEmail(request.getParameter("email"));
            u.setFullName(request.getParameter("fullName"));
            u.setPhone(request.getParameter("phone"));
            u.setStatus(request.getParameter("status"));
            u.setRoleId(Integer.parseInt(request.getParameter("roleId")));

            userService.updateUser(u);
        }
        response.sendRedirect(request.getContextPath() + "/user-list");
    }
}

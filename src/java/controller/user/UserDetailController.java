package controller.user;

import service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UserDetailController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int idView = Integer.parseInt(idStr);
            request.setAttribute("u", userService.getUserById(idView));
            request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/user-list");
        }
    }
}

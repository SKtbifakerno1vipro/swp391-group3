package controller.user;

import service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import model.User;

@WebServlet(name = "UserDetailController", urlPatterns = {"/user-detail"})
public class UserDetailController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        try {
            User u = userService.getUserById(Integer.parseInt(id));
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/user-list");
                return;
            }
            request.setAttribute("u", u);
            request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}

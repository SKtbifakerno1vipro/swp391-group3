package controller.user;
import service.UserService;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
@WebServlet(name = "UserDetailController", urlPatterns = {"/user-detail"})
public class UserDetailController extends HttpServlet {
    private final UserService userService = new UserService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        request.setAttribute("user", userService.getUserById(Integer.parseInt(id)));
        request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
    }
}
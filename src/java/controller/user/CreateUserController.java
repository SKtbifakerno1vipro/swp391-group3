package controller.user;

import service.UserService;
import dal.RoleDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;
import service.RoleService;

@WebServlet(name = "CreateUserController", urlPatterns = {"/create-user"})
public class CreateUserController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("roleList", roleService.getAllRoles());
        request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
    }

    boolean isDuplicate(List<User> list, User u) {
        for (User t : list) {
            if (t.getEmail().equals(u.getEmail()) || (t.getPhone() != null && t.getPhone().equals(u.getPhone()))) {
                return true;
            }
        }
        return false;
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
        u.setRoleId(Integer.valueOf(request.getParameter("roleId")));
        List<User> list = userService.getAllUsers();
        if (isDuplicate(list, u)) {
            request.setAttribute("error", "Duplicate email or phone");
            request.setAttribute("u", u);
            request.setAttribute("roleList", roleService.getAllRoles());
            request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
        }
        userService.createUser(u);
        response.sendRedirect(request.getContextPath() + "/user-list");
    }
}

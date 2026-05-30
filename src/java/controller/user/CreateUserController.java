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
        request.setAttribute("roles", roleService.getAllRoles());
        request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User u = new User();
        u.setUserName(request.getParameter("userName"));
        u.setPassword(request.getParameter("password"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus("ACTIVE");
        u.setGender(request.getParameter("gender"));
        u.setRoleId(Integer.parseInt(request.getParameter("roleId")));

        // 1. Kiem tra trung lap bang 1 ham duy nhat
        String duplicateError = userService.checkDuplicate(u.getUserName(), u.getEmail(), u.getPhone());
        if (duplicateError != null) {
            request.setAttribute("error", duplicateError);
            request.setAttribute("roles", roleService.getAllRoles());
            request.setAttribute("u", u);
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
            return;
        }

        // 2. Neu khong trung lap thi thuc thi insert
        boolean success = userService.createUser(u);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-list");
        } else {
            request.setAttribute("error", "Loi he thong khi tao User!");
            request.setAttribute("roles", roleService.getAllRoles());
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
        }
    }
}

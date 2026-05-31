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
import utils.Validation;

@WebServlet(name = "CreateUserController", urlPatterns = {"/create-user"})
public class CreateUserController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    private final Validation validate = new Validation();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("roles", roleService.getAllRoles());
        request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String error = null;
        User u = new User();

        u.setUserName(request.getParameter("userName"));
        u.setPassword(request.getParameter("password"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus("ACTIVE");
        u.setGender(request.getParameter("gender"));
        u.setRoleId(Integer.parseInt(request.getParameter("roleId")));

        //1. check validate data
        if (error == null) {
            error = validate.validateEmpty(u.getUserName(), "User name");
        }
        if (error == null) {
            error = validate.validateEmpty(u.getPassword(), "Password");
        }
        if (error == null) {
            error = validate.validateEmail(u.getEmail());
        }
        if (error == null) {
            error = validate.validatePhone(u.getPhone());
        }

        if (error == null) {
            error = userService.checkDuplicate(u.getUserName(), u.getEmail(), u.getPhone(), u.getUserId());
        }
        
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("roles", roleService.getAllRoles());
            request.setAttribute("u", u);
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
            return;
        }

        // 2. Neu khong error thi insert
        boolean success = userService.createUser(u);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-list");
        } else {
            request.setAttribute("error", "Error insert  user!");
            request.setAttribute("roles", roleService.getAllRoles());
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
        }
    }
}

package controller.user;

import service.UserService;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import service.RoleService;
import utils.Validation;

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
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //1. check validate data
        if (error == null) {
            error = Validation.validateEmpty(u.getUserName(), "User name");
        }
        if (error == null) {
            error = Validation.validatePassword(u.getPassword());
        }
        if (error == null) {
            error = Validation.validateEmail(u.getEmail());
        }
        if (error == null) {
            error = Validation.validatePhone(u.getPhone());
        }

        if (error == null) {
            if (userService.isEmailDuplicate(u.getEmail(), u.getUserId())) {
                error = "Email duplicated, please enter again!";
            }
            if (userService.isPhoneDuplicate(u.getPhone(), u.getUserId())) {
                error = "Phone duplicated, please enter again!";
            }
            if (userService.isUsernameDuplicate(u.getUserName(), u.getUserId())) {
                error = "User Name duplicated, please enter again!";
            }
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("roles", roleService.getAllRoles());
            request.setAttribute("u", u);
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
            return;
        }
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

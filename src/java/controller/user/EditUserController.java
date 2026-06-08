package controller.user;

import service.*;
import utils.Validation;
import dal.RoleDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "EditUserController", urlPatterns = {"/edit-user"})
public class EditUserController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                User u = userService.getUserById(Integer.parseInt(idStr));
                if (u == null) {
                    response.sendRedirect(request.getContextPath() + "/user-list");
                    return;
                }
                request.setAttribute("u", u);

                request.setAttribute("roles", roleService.getAllRoles());

                request.setAttribute("mode", "edit");
                request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User u = new User();
        String error = null;

        String userIdStr = request.getParameter("id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            try {
                u.setUserId(Integer.parseInt(userIdStr));
            } catch (NumberFormatException e) {
                u.setUserId(0);
            }
        }

        u.setUserName(request.getParameter("userName"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus(request.getParameter("status"));
        u.setGender(request.getParameter("gender"));

        try {
            u.setRoleId(Integer.parseInt(request.getParameter("roleId")));
        } catch (NumberFormatException e) {
            u.setRoleId(0);
        }

        if (error == null) {
            error = Validation.validateEmpty(u.getFullName(), "Full Name");
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
            request.setAttribute("mode", "edit");
            request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
            return;
        }

        boolean success = userService.updateUser(u);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-list");
        } else {
            request.setAttribute("error", "Lỗi hệ thống khi cập nhật User!");
            request.setAttribute("roles", roleService.getAllRoles());
            request.setAttribute("u", u);
            request.setAttribute("mode", "edit");
            request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
        }
    }
}

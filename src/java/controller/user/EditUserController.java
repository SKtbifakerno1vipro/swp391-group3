package controller.user;

import service.*;
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
                RoleDAO roleDAO = new RoleDAO();
                request.setAttribute("roles", roleDAO.getAllRoles());

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

        String userIdStr = request.getParameter("id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            u.setUserId(Integer.parseInt(userIdStr));
        }
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus(request.getParameter("status"));
        u.setGender(request.getParameter("gender"));
        u.setRoleId(Integer.parseInt(request.getParameter("roleId")));
        String duplicateError = userService.checkDuplicate(u.getUserName(), u.getEmail(), u.getPhone());
        if (duplicateError != null) {
            request.setAttribute("u", u);
            request.setAttribute("roles", roleService.getAllRoles());
            request.setAttribute("mode", "edit");
            request.setAttribute("error", duplicateError);
            request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
            return;
        }

        userService.updateUser(u);
        response.sendRedirect(request.getContextPath() + "/user-list");
    }
}

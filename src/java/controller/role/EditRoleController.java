package controller.role;

import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Role;

public class EditRoleController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int roleId = Integer.parseInt(request.getParameter("id"));
        Role role = roleService.getRoleById(roleId);
        request.setAttribute("role", role);
        request.getRequestDispatcher("/views/role/edit-role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String roleName = request.getParameter("roleName");

        Role role = new Role();
        role.setRoleId(roleId);
        role.setRoleName(roleName);

        roleService.updateRole(role);
        response.sendRedirect(request.getContextPath() + "/role-list");
    }
}

package controller.role;

import model.Permission;
import model.Role;
import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import java.util.ArrayList;

@WebServlet(name = "RoleDetailController", urlPatterns = {"/role-detail"})
public class RoleDetailController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String roleIdParam = request.getParameter("roleId");
            if (roleIdParam == null || roleIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/role-list");
                return;
            }

            int roleId = Integer.parseInt(roleIdParam);
            Role role = roleService.getRoleDetail(roleId);

            if (role != null) {
                request.setAttribute("role", role);
                request.getRequestDispatcher("/views/role/role-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/role-list");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Role ID!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String roleName = request.getParameter("roleName");
            
            // Validate
            if (roleName == null || roleName.trim().isEmpty()) {
                Role role = roleService.getRoleDetail(roleId);
                request.setAttribute("role", role);
                request.setAttribute("error", "Tên role không được để trống!");
                request.getRequestDispatcher("/views/role/role-detail.jsp").forward(request, response);
                return;
            }
            
            // Update
            Role role = new Role();
            role.setRoleId(roleId);
            role.setRoleName(roleName.trim());
            roleService.updateRole(role);
            
            // Redirect về view mode
            response.sendRedirect(request.getContextPath() + "/role-detail?roleId=" + roleId + "&status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating role!");
        }
    }
}
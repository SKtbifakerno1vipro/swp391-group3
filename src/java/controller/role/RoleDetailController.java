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
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoleDetailController", urlPatterns = {"/role-detail"})
public class RoleDetailController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roleIdParam = request.getParameter("roleId");
            if (roleIdParam == null || roleIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/role-list");
                return;
            }

            int roleId = Integer.parseInt(roleIdParam);
            Role role = roleService.getRoleDetail(roleId);
            List<Permission> allPermissions = roleService.getAllPermissions();

            if (role != null) {
                request.setAttribute("role", role);
                request.setAttribute("allPermissions", allPermissions);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/role-list");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            List<Permission> allPermissions = roleService.getAllPermissions();
            List<Integer> selectedPermissionIds = new ArrayList<>();

            for (Permission p : allPermissions) {
                String paramName = "permission_" + p.getPermissionId();
                String paramValue = request.getParameter(paramName);
                if (paramValue != null) {
                    selectedPermissionIds.add(p.getPermissionId());
                }
            }

            roleService.updateRolePermissions(roleId, selectedPermissionIds);
            response.sendRedirect(request.getContextPath() + "/role-detail?roleId=" + roleId + "&status=success");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "error!");
        }
    }
}





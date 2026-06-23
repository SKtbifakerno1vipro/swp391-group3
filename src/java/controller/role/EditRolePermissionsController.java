package controller.role;

import service.RoleService;
import model.RolePermission;
import model.Role;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "EditRolePermissionsController", urlPatterns = {"/edit-role-permissions"})
public class EditRolePermissionsController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String roleIdParam = request.getParameter("roleId");
        if (roleIdParam == null || roleIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/role-list");
            return;
        }

        int roleId = Integer.parseInt(roleIdParam); // chuyẻn đổi từ string sang dạng int 
        Role role = roleService.getRoleDetail(roleId);
        //nếu role bị xóa (role == null) thì jsp lỗi 
        if(role == null){
            response.sendRedirect(request.getContextPath() + "/role-list");
            return;
        }
        
        List<RolePermission> permissionList = roleService.getAllPermissions();// lấy toàn bộ danh sách permissions từ service và lưu vào list tên là permission list

        Set<Integer> selectedPermissionIds = new HashSet<>();
        if (role != null && role.getPermissions() != null) {
            for (RolePermission p : role.getPermissions()) { 
                selectedPermissionIds.add(p.getPermissionId());// xem ban đầu cái nào đã được tích  bằng cách lấy ID
            }
        }

        request.setAttribute("role", role);
        request.setAttribute("permissionList", permissionList);
        request.setAttribute("selectedPermissionIds", selectedPermissionIds);
        request.getRequestDispatcher("/views/role/edit-role-permissions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String[] permissionIdValues = request.getParameterValues("permissionIds");

        List<Integer> permissionIds = new ArrayList<>();
        if (permissionIdValues != null) {
            for (String val : permissionIdValues) {
                permissionIds.add(Integer.parseInt(val));
            }
        }

        model.User currentUser = (model.User) request.getSession().getAttribute("user");
        Integer currentUserId = currentUser != null ? currentUser.getUserId() : null;
        Role role = roleService.getRoleDetail(roleId);
        String roleName = role != null ? role.getRoleName() : String.valueOf(roleId);

        roleService.updateRolePermissions(roleId, permissionIds);
        service.AuditLogService.log(currentUserId, "UPDATE", "Role", "Chỉnh sửa danh sách quyền cho vai trò: " + roleName + " (ID: " + roleId + ")");
        response.sendRedirect(request.getContextPath() + "/role-detail?roleId=" + roleId + "&status=success");
    }
}

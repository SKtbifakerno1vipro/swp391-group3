package controller.role;

import model.RolePermission;
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

@WebServlet(name = "RoleDetailController", urlPatterns = { "/role-detail" })
public class RoleDetailController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        try {
            // lấy role id từ tham số roleId từ thẻ a role-detail?roleId=
            String roleIdParam = request.getParameter("roleId");
            if (roleIdParam == null || roleIdParam.trim().isEmpty()) { // kiểm tra xem có tồn tại role id không
                response.sendRedirect(request.getContextPath() + "/role-list"); // nếu không có thì chuyển về trang danh
                                                                                // sách role
                return;
            }

            int roleId = Integer.parseInt(roleIdParam);
            Role role = roleService.getRoleDetail(roleId); // lấy chi tiết role từ service

            if (role != null) { // kiểm tra role có tồn tại không
                request.setAttribute("permissionList", roleService.getAllPermissions()); // lấy danh sách quyền
                Set<Integer> selectedPermissionIds = new HashSet<>(); // tạo danh sách quyền đã chọn
                if (role.getPermissions() != null) {
                    for (RolePermission p : role.getPermissions()) { // duyệt danh sách quyền
                        selectedPermissionIds.add(p.getPermissionId()); // thêm quyền vào danh sách
                    }
                }
                request.setAttribute("role", role);
                request.setAttribute("selectedPermissionIds", selectedPermissionIds);

                request.getRequestDispatcher("/views/role/role-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/role-list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/role-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            String roleName = request.getParameter("roleName");

            String[] permissionIdValues = request.getParameterValues("permissionIds");
            List<Integer> permissionIds = new ArrayList<>();

            if (permissionIdValues != null) {
                for (String val : permissionIdValues) {
                    int id = Integer.parseInt(val);
                    permissionIds.add(id);
                }
            }

            // Validate
            if (roleName == null || roleName.trim().isEmpty()) {
                Role role = roleService.getRoleDetail(roleId);
                request.setAttribute("role", role);
                request.setAttribute("permissionList", roleService.getAllPermissions());

                Set<Integer> selectedPermissionIds = new HashSet<>();
                if (role.getPermissions() != null) {
                    for (RolePermission p : role.getPermissions()) {
                        selectedPermissionIds.add(p.getPermissionId());
                    }
                }
                request.setAttribute("selectedPermissionIds", selectedPermissionIds);
                request.setAttribute("error", "Tên role không được để trống!");
                request.getRequestDispatcher("/views/role/role-detail.jsp").forward(request, response);
                return;
            }

            // Update
            Role role = new Role();
            role.setRoleId(roleId);
            role.setRoleName(roleName.trim());

            roleService.updateRole(role);
            roleService.updateRolePermissions(roleId, permissionIds);

            // Redirect ve view mode
            response.sendRedirect(request.getContextPath() + "/role-detail?roleId=" + roleId + "&status=success");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/role-list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi cập nhật vai trò!");
        }
    }
}

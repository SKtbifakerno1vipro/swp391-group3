package controller;

import models.Permission;
import models.Role;
import service.RoleDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoleController", urlPatterns = {"/role-detail"})
public class RoleController extends HttpServlet {

    private RoleDAO roleDAO;

    @Override
    public void init() {
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roleIdParam = request.getParameter("roleId");
            if (roleIdParam == null || roleIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/role-list");
                return;
            }
            
            int roleId = Integer.parseInt(roleIdParam);
            
            // Lấy chi tiết vai trò (Role) kèm quyền hiện tại
            Role role = roleDAO.getRoleDetail(roleId);
            // Lấy tổng tất cả các quyền có trong hệ thống
            List<Permission> allPermissions = roleDAO.getAllPermissions();


            if (role != null) {
                request.setAttribute("role", role);
                request.setAttribute("allPermissions", allPermissions);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/role-list");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID của vai trò không hợp lệ!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            
            // Lấy tất cả các ID của quyền có trong hệ thống
            List<Permission> allPermissions = roleDAO.getAllPermissions();
            List<Integer> selectedPermissionIds = new ArrayList<>();

            // Duyệt qua danh sách quyền, kiểm tra xem checkbox tương ứng có được tích chọn không
            for (Permission p : allPermissions) {
                String paramName = "permission_" + p.getPermissionId();
                String paramValue = request.getParameter(paramName);
                
                if (paramValue != null) { // Nếu parameter khác null nghĩa là checkbox đã được tick chọn
                    selectedPermissionIds.add(p.getPermissionId());
                }
            }

            // Gọi hàm thực thi xóa cũ - thêm mới trong DB
            roleDAO.updateRolePermissions(roleId, selectedPermissionIds);

            // Quay trở về trang chi tiết kèm trạng thái cập nhật thành công
            response.sendRedirect(request.getContextPath() + "/role-detail?roleId=" + roleId + "&status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi trong quá trình lưu quyền!");
        }
    }
}
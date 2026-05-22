package service;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Role;
import models.Permission; // Bạn nhớ tạo hoặc check xem class này có các thuộc tính permissionId, permissionName chưa nhé

public class RoleDAO extends DBContext {

    // 1. Lấy thông tin chi tiết của một Role kèm danh sách các quyền hiện tại của nó
    public Role getRoleDetail(int roleId) {
        Role role = null;
        String sql = "SELECT r.role_id, r.role_name, p.permission_id, p.permission_name " +
                     "FROM role r " +
                     "LEFT JOIN role_permission rp ON r.role_id = rp.role_id " +
                     "LEFT JOIN permission p ON rp.permission_id = p.permission_id " +
                     "WHERE r.role_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roleId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                if (role == null) {
                    role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setPermissions(new ArrayList<>());
                }
                int permId = rs.getInt("permission_id");
                if (permId > 0) {
                    Permission p = new Permission();
                    p.setPermissionId(permId);
                    p.setPermissionName(rs.getString("permission_name"));
                    role.getPermissions().add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return role;
    }

    // 2. Lấy toàn bộ danh sách tất cả các quyền có trong hệ thống để hiển thị lên màn hình cấu hình
    public List<Permission> getAllPermissions() {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT permission_id, permission_name FROM permission";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Permission p = new Permission();
                p.setPermissionId(rs.getInt("permission_id"));
                p.setPermissionName(rs.getString("permission_name"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Cập nhật phân quyền: Xóa các quyền cũ của Role đó đi và chèn lại các quyền mới được tích chọn
    public void updateRolePermissions(int roleId, List<Integer> permissionIds) {
        try {
            // Sử dụng Transaction để đảm bảo an toàn dữ liệu
            connection.setAutoCommit(false);

            // Bước A: Xóa toàn bộ liên kết quyền cũ của Role này trong bảng trung gian role_permission
            String deleteSql = "DELETE FROM role_permission WHERE role_id = ?";
            try (PreparedStatement stDelete = connection.prepareStatement(deleteSql)) {
                stDelete.setInt(1, roleId);
                stDelete.executeUpdate();
            }

            // Bước B: Thêm lại các quyền mới được tick chọn (sử dụng Batch để tối ưu hiệu năng)
            if (permissionIds != null && !permissionIds.isEmpty()) {
                String insertSql = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
                try (PreparedStatement stInsert = connection.prepareStatement(insertSql)) {
                    for (int permId : permissionIds) {
                        stInsert.setInt(1, roleId);
                        stInsert.setInt(2, permId);
                        stInsert.addBatch();
                    }
                    stInsert.executeBatch();
                }
            }

            // Commit nếu mọi thứ chạy mượt mà
            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // 4. tạo các role mới
    public boolean insertRole(String roleName) {
    String sql = "INSERT INTO role (role_name, create_at, update_at) VALUES (?, GETDATE(), GETDATE())";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, roleName);
        int rows = st.executeUpdate();
        return rows > 0; // Trả về true nếu thêm thành công
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
}
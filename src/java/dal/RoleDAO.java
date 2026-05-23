package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Role;

public class RoleDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        try {
            String sql = "select role_id, role_name from role";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                roles.add(role);
            }
        } catch (Exception e) {
            System.out.println("getAllRoles: " + e.getMessage());
        }
        return roles;
    }

    public boolean insertRole(String roleName) {
        String sql = "INSERT INTO role (role_name) VALUES (?)";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, roleName);
            return st.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO insertRole error: " + e.getMessage());
        }
        return false;
    }

    public model.Role getRoleById(int id) {
        String sql = "SELECT * FROM role WHERE role_id = ?";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            java.sql.ResultSet rs = st.executeQuery();
            if (rs.next()) {
                model.Role role = new model.Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                return role;
            }
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO getRoleById error: " + e.getMessage());
        }
        return null;
    }

    public boolean updateRole(model.Role role) {
        String sql = "UPDATE role SET role_name = ? WHERE role_id = ?";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, role.getRoleName());
            st.setInt(2, role.getRoleId());
            return st.executeUpdate() > 0;
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO updateRole error: " + e.getMessage());
        }
        return false;
    }

    public model.Role getRoleDetail(int id) {
        return getRoleById(id);
    }

    public java.util.List<model.Permission> getAllPermissions() {
        java.util.List<model.Permission> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM permission";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            java.sql.ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.Permission p = new model.Permission();
                p.setPermissionId(rs.getInt("permission_id"));
                p.setPermissionName(rs.getString("permission_name"));
                list.add(p);
            }
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO getAllPermissions error: " + e.getMessage());
        }
        return list;
    }

    public void updateRolePermissions(int roleId, java.util.List<Integer> permissionIds) {
        try {
            connection.setAutoCommit(false);
            // Xóa permissions cũ
            String sqlDelete = "DELETE FROM role_permission WHERE role_id = ?";
            java.sql.PreparedStatement stDel = connection.prepareStatement(sqlDelete);
            stDel.setInt(1, roleId);
            stDel.executeUpdate();
            
            // Thêm permissions mới
            if (permissionIds != null && !permissionIds.isEmpty()) {
                String sqlInsert = "INSERT INTO role_permission (role_id, permission_id) VALUES (?, ?)";
                java.sql.PreparedStatement stIns = connection.prepareStatement(sqlInsert);
                for (Integer pId : permissionIds) {
                    stIns.setInt(1, roleId);
                    stIns.setInt(2, pId);
                    stIns.addBatch();
                }
                stIns.executeBatch();
            }
            connection.commit();
            connection.setAutoCommit(true);
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO updateRolePermissions error: " + e.getMessage());
        }
    }
}

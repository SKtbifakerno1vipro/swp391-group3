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
            String sql = "SELECT role_id, role_name, created_at, updated_at, status FROM role ORDER BY role_id";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setCreateAt(rs.getTimestamp("created_at"));
                role.setUpdateAt(rs.getTimestamp("updated_at"));
                role.setStatus(rs.getString("status"));
                roles.add(role);
            }
        } catch (Exception e) {
            System.out.println("getAllRoles eror: ");
            e.printStackTrace();
        }
        return roles;
    }

    public int createRole(String roleName) {
        String sql = "INSERT INTO role (role_name) VALUES (?)";

        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);

            st.setString(1, roleName);
            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                java.sql.ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO createRole error:");
            e.printStackTrace();
        }

        return -1;
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
        String sql = "UPDATE role SET role_name = ?, updated_at = GETDATE() WHERE role_id = ?";
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
        model.Role role = null;
        String sql = """
                     SELECT r.role_id, r.role_name, r.created_at, r.updated_at,p.permission_id, p.permission_name
                     FROM role r
                     LEFT JOIN role_permission rp ON r.role_id = rp.role_id
                     LEFT JOIN permission p ON rp.permission_id = p.permission_id
                     WHERE r.role_id = ?
                     """;
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            java.sql.ResultSet rs = st.executeQuery();

            while (rs.next()) {
                if (role == null) {
                    role = new model.Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setCreateAt(rs.getTimestamp("created_at"));
                    role.setUpdateAt(rs.getTimestamp("updated_at"));

                }
                int permissionId = rs.getInt("permission_id");
                if (permissionId > 0) {
                    model.Permission p = new model.Permission();
                    p.setPermissionId(permissionId);
                    p.setPermissionName(rs.getString("permission_name"));
                    role.getPermissions().add(p);
                }
            }
        } catch (Exception e) {
            System.out.println("RoleDAO getRoleDetail error:");
            e.printStackTrace();
        }
        return role;
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

            String sqlDelete = "DELETE FROM role_permission WHERE role_id = ?";
            java.sql.PreparedStatement stDel = connection.prepareStatement(sqlDelete);
            stDel.setInt(1, roleId);
            stDel.executeUpdate();

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

    // begin - Xhieu - contact me wwhen remove
    public Integer getRoleIdByName(String roleName) {
        String sql = "SELECT role_id FROM role WHERE role_name = ?";

        try (PreparedStatement stm1 = connection.prepareStatement(sql)) {
            stm1.setString(1, roleName);
            try (ResultSet rs1 = stm1.executeQuery()) {
                if (rs1.next()) {
                    return rs1.getInt("role_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // TrÃ¡ÂºÂ£ vÃ¡Â»Â null nÃ¡ÂºÂ¿u khÃƒÂ´ng tÃƒÂ¬m thÃ¡ÂºÂ¥y role tÃ†Â°Ã†Â¡ng Ã¡Â»Â©ng
    }
    // end - Xhieu

    public boolean isRoleNameExists(String roleName) {
        String sql = "SELECT COUNT(*) FROM role WHERE role_name = ?";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, roleName);
            java.sql.ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;

            }
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDao isRoleNameExists error: " + e.getMessage());
        }
        return false;
    }

    public int countUsersByRoleId(int roleId) {
        String sql = "SELECT COUNT(*) FROM [user] WHERE role_id = ?";

        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roleId);
            java.sql.ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO countUsersByRoleId error:");
            e.printStackTrace();
        }

        return 0;
    }

    public boolean softDeleteRole(int roleId) {
        String sql = "UPDATE role SET status='Inactive' WHERE role_id = ?";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roleId);
            return st.executeUpdate() > 0; 

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean restoreRole(int roleId) {
        String sql = "UPDATE role SET status='Active' WHERE role_id = ?";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roleId);
            return st.executeUpdate() > 0; 

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}


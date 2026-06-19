package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Quotation;
import model.Role;

public class RoleDAO extends DBContext {
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        try {
            String sql = "SELECT role_id, role_name, created_at, updated_at FROM role ORDER BY role_id";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setCreateAt(rs.getTimestamp("created_at"));
                role.setUpdateAt(rs.getTimestamp("updated_at"));

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
        //join 1: dung đe lay danh sach cac permission đuoc gan cho role.
        //join 2: dung đe lay ten permission tu bang permission.
        //dung left join đe ngay ca chua co quyen van lay ra đuoc
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
                    model.RolePermission p = new model.RolePermission();
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

    public java.util.List<model.RolePermission> getAllPermissions() {
        java.util.List<model.RolePermission> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM permission";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            java.sql.ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.RolePermission p = new model.RolePermission();
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
            //chua luu ngay vao dtb
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
    public int getRoleIdByName(String roleName) {
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
        return 0;
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

    public List<Role> searchRole(String searchText) {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT role_id, role_name, created_at, updated_at FROM role "
                + "WHERE 1=1 "; // Có dấu cách ở cuối

        if (searchText != null && !searchText.trim().isEmpty()) {
            sql += "AND role_name LIKE ?";
        }
        sql += " ORDER BY role.created_at DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (searchText != null && !searchText.trim().isEmpty()) {
                ps.setString(1, "%" + searchText.trim() + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Role role = new Role();
                // lay toan bo cac cot de hien thi len bang
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setCreateAt(rs.getTimestamp("created_at"));
                role.setUpdateAt(rs.getTimestamp("updated_at"));

                list.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Role> getrolesByPage(int page, int pageSize) {
        List<Role> list = new ArrayList<>();

        String sql = """
             SELECT role_id, role_name, created_at, updated_at 
             FROM role 
             ORDER BY role_id 
             OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
             """;

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int offset = (page - 1) * pageSize;

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setCreateAt(rs.getTimestamp("created_at"));
                role.setUpdateAt(rs.getTimestamp("updated_at"));

                list.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public int countRoles(){
        String sql ="SELECT COUNT(*) FROM role";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()){
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}

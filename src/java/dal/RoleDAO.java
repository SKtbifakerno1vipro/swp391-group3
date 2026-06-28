package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Quotation;
import model.Role;

public class RoleDAO extends DBContext {
//lay toan bo roles 
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        try {
            String sql = "SELECT role_id, role_name, created_at, updated_at, status FROM role ORDER BY role_id";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
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
//tao roles
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
//lay role theo ID
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
                role.setCreateAt(rs.getTimestamp("created_at"));
                role.setUpdateAt(rs.getTimestamp("updated_at"));
                role.setStatus(rs.getString("status"));
                return role;
            }
        } catch (java.sql.SQLException e) {
            System.out.println("RoleDAO getRoleById error: " + e.getMessage());
        }
        return null;
    }
//cap nhat role
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

//lay role chi tiet
    public model.Role getRoleDetail(int id) {
        model.Role role = null;
        //join 1: dung đe lay danh sach cac permission đuoc gan cho role.
        //join 2: dung đe lay ten permission tu bang permission.
        //dung left join đe ngay ca chua co quyen van lay ra đuoc
        String sql = """
                     SELECT r.role_id, r.role_name, r.created_at, r.updated_at, r.status, p.permission_id, p.permission_name
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
                    role.setStatus(rs.getString("status"));

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
//lay toan bo phan quyen
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
//cap nhat quyen
    public void updateRolePermissions(
            int roleId,
            List<Integer> permissionIds) {

        try {

            connection.setAutoCommit(false);

            String sqlDelete
                    = "DELETE FROM role_permission WHERE role_id = ?";

            PreparedStatement stDel
                    = connection.prepareStatement(sqlDelete);

            stDel.setInt(1, roleId);

            stDel.executeUpdate();

            if (permissionIds != null
                    && !permissionIds.isEmpty()) {

                String sqlInsert
                        = "INSERT INTO role_permission "
                        + "(role_id, permission_id) "
                        + "VALUES (?, ?)";

                PreparedStatement stIns
                        = connection.prepareStatement(sqlInsert);

                for (Integer pId : permissionIds) {

                    stIns.setInt(1, roleId);
                    stIns.setInt(2, pId);

                    stIns.addBatch();
                }

                stIns.executeBatch();
            }

            String sqlUpdateRole = "UPDATE role SET updated_at = GETDATE() WHERE role_id = ?";
            PreparedStatement stUpd = connection.prepareStatement(sqlUpdateRole);
            stUpd.setInt(1, roleId);
            stUpd.executeUpdate();

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
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }
//lay id theo name
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
//check xem ten role da ton tai truoc do chua
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
//search role
    public List<Role> searchRole(String searchText) {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT role_id, role_name, created_at, updated_at, status FROM role "
                + "WHERE 1=1 "; // Có dấu cách ở cuối

        if (searchText != null && !searchText.trim().isEmpty()) {
            sql += "AND role_name LIKE ?";
        }
        //DESC: tang dan, ASC: giam dan
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
                role.setStatus(rs.getString("status"));

                list.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
//lay role theo trang (phan trang)
    public List<Role> getrolesByPage(int page, int pageSize) {
        List<Role> list = new ArrayList<>();

        String sql = """
             SELECT role_id, role_name, created_at, updated_at, status 
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
                role.setStatus(rs.getString("status"));

                list.add(role);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
//dem so roles hien co  
    public int countRoles() {
        String sql = "SELECT COUNT(*) FROM role";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

}

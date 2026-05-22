package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;
import models.Role;

public class RoleDAO extends service.DBContext {
    PreparedStatement stm;
    ResultSet rs;
    
    public List<Role> getAllRoles(){
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
    public Role getRoleById(int roleId) {

        String sql = """
                     SELECT role_id, role_name, create_at, update_at
                     FROM role
                     WHERE role_id = ?
                     """;

        try {

            Connection conn = getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, roleId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Role role = new Role();

                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setCreateAt(rs.getTimestamp("create_at"));
                role.setUpdateAt(rs.getTimestamp("update_at"));

                return role;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    public void updateRole(Role role) {

        String sql = """
                     UPDATE role
                     SET role_name = ?,
                         update_at = GETDATE()
                     WHERE role_id = ?
                     """;

        try {

            Connection conn = getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, role.getRoleName());

            ps.setInt(2, role.getRoleId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import models.Role;

public class RoleDAO extends DBContext {

    public List<Role> getAllRoles() {

        List<Role> roles = new ArrayList<>();

        String sql = """
                     SELECT role_id, role_name, create_at, update_at
                     FROM role
                     ORDER BY role_id
                     """;

        try {
            Connection conn = getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Role role = new Role();

                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setCreateAt(rs.getTimestamp("create_at"));
                role.setUpdateAt(rs.getTimestamp("update_at"));

                roles.add(role);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return roles;
    }
}
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
}
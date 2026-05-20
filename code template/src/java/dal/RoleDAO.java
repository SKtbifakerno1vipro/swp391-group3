package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.ArrayList;
import models.Role;

public class RoleDAO extends DBContext {
    PreparedStatement stm;
    ResultSet rs;
    
    public List<Role> GetRoles() {
        List<Role> roles = new ArrayList<Role>();
        try {
            String strSQL = "select * from Roles";
            stm = connection.prepareCall(strSQL);
            rs = stm.executeQuery();
            while (rs.next()) {
                int roleId = rs.getInt("roleId");
                String roleName = rs.getString("roleName");
                Role role = new Role(roleId, roleName);
                roles.add(role);
            }
        } catch (Exception ex) {
            System.out.println("GetRoles: " + ex.getMessage());
        }
        return roles;
    }
}
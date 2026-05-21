package dao;

import java.util.List;
import models.Role;

public class TestRoleDAO {

    public static void main(String[] args) {

        RoleDAO dao = new RoleDAO();

        List<Role> roles = dao.getAllRoles();

        for (Role role : roles) {
            System.out.println(role.getRoleId() + " - " + role.getRoleName());
        }
    }
}
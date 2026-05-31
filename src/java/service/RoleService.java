package service;

import dal.RoleDAO;
import java.util.List;
import model.Permission;
import model.Role;

public class RoleService {
    private final RoleDAO roleDAO = new RoleDAO();

    public List<Role> getAllRoles() {
        return roleDAO.getAllRoles();
    }

    public Role getRoleById(int roleId) {
        return roleDAO.getRoleById(roleId);
    }

    public Role getRoleDetail(int roleId) {
        return roleDAO.getRoleDetail(roleId);
    }

    public List<Permission> getAllPermissions() {
        return roleDAO.getAllPermissions();
    }

    public boolean insertRole(String roleName) {
        return roleDAO.insertRole(roleName);
    }

    public void updateRole(Role role) {
        roleDAO.updateRole(role);
    }

    public void updateRolePermissions(int roleId, List<Integer> permissionIds) {
        roleDAO.updateRolePermissions(roleId, permissionIds);
    }
    // begin - Xhieu - contact me wwhen remove
    public Integer getRoleIdByName(String roleName) {
        
        if (roleName == null || roleName.isBlank()) {
            return null;
        }
        return roleDAO.getRoleIdByName(roleName.trim());
    }
    // end - Xhieu
}


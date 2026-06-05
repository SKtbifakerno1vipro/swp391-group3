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

    public int createRole(String roleName) {
        return roleDAO.createRole(roleName);
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
    public boolean isRoleNameExists(String roleName) {
        return roleDAO.isRoleNameExists(roleName);
    }

    public boolean deleteRole(int roleId) {
        return roleDAO.softDeleteRole(roleId);
    }

    public boolean restoreRole(int roleId) {
        return roleDAO.restoreRole(roleId);
    }

}

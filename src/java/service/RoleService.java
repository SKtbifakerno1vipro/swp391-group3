package service;

import dal.RoleDAO;
import java.util.List;
import model.RolePermission;
import model.Role;

public class RoleService {

    private final RoleDAO roleDAO = new RoleDAO();

    public List<Role> getAllRoles() {
        return roleDAO.getAllRoles();
    }

    public List<Role> getAllRolesForCreateUser() {
        List<Role> roles = roleDAO.getAllRoles();
        roles.remove(2);
        return roles;
    }

    public Role getRoleById(int roleId) {
        return roleDAO.getRoleById(roleId);
    }

    public Role getRoleDetail(int roleId) {
        return roleDAO.getRoleDetail(roleId);
    }

    public List<RolePermission> getAllPermissions() {
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
    public int getRoleIdByName(String roleName) {
        if (roleName == null || roleName.isBlank()) {
            return -1;
        }
        return roleDAO.getRoleIdByName(roleName.trim());
    }

    // end - Xhieu
    public boolean isRoleNameExists(String roleName) {
        return roleDAO.isRoleNameExists(roleName);
    }

    public List<Role> searchRoles(String search) {
        return roleDAO.searchRole(search);
    }

    public List<Role> getRolesByPage(int page, int pageSize) {
        return roleDAO.getrolesByPage(page, pageSize);
    }

    public int countRoles() {
        return roleDAO.countRoles();
    }
}

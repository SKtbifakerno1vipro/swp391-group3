package models;

import java.time.LocalDateTime;
import java.util.*;
public class Role {
    private int roleId;
    private String roleName;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;
    private List<Permission> permissions; // Danh sách các quyền thuộc Role này

    public Role() {}

    public Role(String roleName) {
        this.roleName = roleName;
        this.createAt = LocalDateTime.now();
        this.updateAt = LocalDateTime.now();
    }

    public Role(int roleId, String roleName, LocalDateTime createAt, LocalDateTime updateAt) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }
    
    public Role(int roleId, String roleName,LocalDateTime createAt, LocalDateTime updateAt, List<Permission> permissions) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.permissions = permissions;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }

    public List<Permission> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<Permission> permissions) {
        this.permissions = permissions;
    }
    
    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public LocalDateTime getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }

    public LocalDateTime getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(LocalDateTime updateAt) {
        this.updateAt = updateAt;
    }

    @Override
    public String toString() {
        return "Role{" +
                "roleId=" + roleId +
                ", roleName='" + roleName + '\'' +
                ", createAt=" + createAt +
                ", updateAt=" + updateAt +
                '}';
    }
}

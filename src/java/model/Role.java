package model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Role {

    private int roleId;
    private String roleName;
    private Timestamp createAt;
    private Timestamp updateAt;
    private List<Permission> permissions = new ArrayList<>();

    public Role() {
    }

    public Role(int roleId, String roleName, Timestamp createAt, Timestamp updateAt) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.createAt = createAt;
        this.updateAt = updateAt;
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

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

    public Timestamp getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(Timestamp updateAt) {
        this.updateAt = updateAt;
    }

    public List<Permission> getPermissions() {
        return permissions;
    }

    public void setPermissions(List<Permission> permissions) {
        this.permissions = permissions;
    }
}


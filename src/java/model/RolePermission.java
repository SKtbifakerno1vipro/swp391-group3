package model;

import java.sql.Timestamp;

public class RolePermission {

    private int permissionId;
    private String permissionName;
    private Timestamp createAt;
    private Timestamp updateAt;
    private String urlPattern;

    public RolePermission() {
    }

    public RolePermission(int permissionId, String permissionName, Timestamp createAt, Timestamp updateAt, String urlPattern) {
        this.permissionId = permissionId;
        this.permissionName = permissionName;
        this.createAt = createAt;
        this.updateAt = updateAt;
        this.urlPattern = urlPattern;
    }

    public int getPermissionId() {
        return permissionId;
    }

    public void setPermissionId(int permissionId) {
        this.permissionId = permissionId;
    }

    public String getPermissionName() {
        return permissionName;
    }

    public void setPermissionName(String permissionName) {
        this.permissionName = permissionName;
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

    public String getUrlPattern() {
        return urlPattern;
    }

    public void setUrlPattern(String urlPattern) {
        this.urlPattern = urlPattern;
    }

}

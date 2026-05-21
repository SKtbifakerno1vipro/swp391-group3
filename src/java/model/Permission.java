package model;

import java.time.LocalDateTime;

public class Permission {
    private int permissionId;
    private String permissionName;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;

    public Permission() {}

    public Permission(int permissionId, String permissionName, LocalDateTime createAt, LocalDateTime updateAt) {
        this.permissionId = permissionId;
        this.permissionName = permissionName;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }

    public int getPermissionId() { return permissionId; }
    public void setPermissionId(int permissionId) { this.permissionId = permissionId; }
    public String getPermissionName() { return permissionName; }
    public void setPermissionName(String permissionName) { this.permissionName = permissionName; }
    public LocalDateTime getCreateAt() { return createAt; }
    public void setCreateAt(LocalDateTime createAt) { this.createAt = createAt; }
    public LocalDateTime getUpdateAt() { return updateAt; }
    public void setUpdateAt(LocalDateTime updateAt) { this.updateAt = updateAt; }
}

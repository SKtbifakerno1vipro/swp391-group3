package models;

public class User {

    private int userId;
    private String userName;
    private String password;
    private String email;
    private String fullName;
    private String phone;
    private String status;
    private int roleId;

    public User() {
    }

    public User(int userId, String userName, String password, String email, String fullName, String phone, String status, Integer roleId, LocalDateTime createAt, LocalDateTime updateAt) {
        this.userId = userId;
        this.userName = userName;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.status = status;
        this.roleId = roleId;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
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
}

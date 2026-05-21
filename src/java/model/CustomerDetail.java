package model;

import java.time.LocalDateTime;

public class CustomerDetail extends Customer {
    private User user;
    private String userRoleName;

    public CustomerDetail() {
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getUserRoleName() {
        return userRoleName;
    }

    public void setUserRoleName(String userRoleName) {
        this.userRoleName = userRoleName;
    }
}

package models;

import java.time.LocalDateTime;

/**
 * ProviderDetail extends Provider to include associated User and role name
 */
public class ProviderDetail extends Provider {
    private User user;
    private String userRoleName;

    public ProviderDetail() {}

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

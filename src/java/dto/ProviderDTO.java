package dto;
import model.Provider;
import model.User;
public class ProviderDTO {
    private Provider provider;
    private User user;
    private String userRoleName;
    public ProviderDTO() {}
    public ProviderDTO(Provider provider, User user, String userRoleName) {
        this.provider = provider;
        this.user = user;
        this.userRoleName = userRoleName;
    }
    public Provider getProvider() { return provider; }
    public void setProvider(Provider provider) { this.provider = provider; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getUserRoleName() { return userRoleName; }
    public void setUserRoleName(String userRoleName) { this.userRoleName = userRoleName; }
}
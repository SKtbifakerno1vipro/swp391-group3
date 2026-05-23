package dto;

import model.Customer;
import model.User;

public class CustomerDTO {

    private Customer customer;
    private User user;
    private String userRoleName;

    public CustomerDTO() {
    }

    public CustomerDTO(Customer customer, User user, String userRoleName) {
        this.customer = customer;
        this.user = user;
        this.userRoleName = userRoleName;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
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

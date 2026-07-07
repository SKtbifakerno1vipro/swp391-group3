package dto;

import java.time.LocalDateTime;
import java.util.Date;
import model.Customer;
import model.User;

public class CustomerDTO {

    private Customer customer;
    private User user;

    public CustomerDTO() {
        this.customer = new Customer();
        this.user = new User();
    }

    public CustomerDTO(Customer customer, User user) {
        this.customer = customer;
        this.user = user;
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
}
package dto;

import model.CustomerOrder;
import model.Customer;
import model.User;

public class CustomerOrderDTO {
    private CustomerOrder customerOrder;
    private Customer customer;
    private User customerUser;

    public CustomerOrderDTO() {}

    public CustomerOrder getCustomerOrder() {
        return customerOrder;
    }

    public void setCustomerOrder(CustomerOrder customerOrder) {
        this.customerOrder = customerOrder;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public User getCustomerUser() {
        return customerUser;
    }

    public void setCustomerUser(User customerUser) {
        this.customerUser = customerUser;
    }
}

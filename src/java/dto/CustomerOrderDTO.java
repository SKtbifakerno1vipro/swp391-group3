package dto;

import model.CustomerOrder;
import model.Customer;
import model.CustomerOrderDetail;
import model.Product;
import model.User;

public class CustomerOrderDTO {
    private CustomerOrder customerOrder;
    private Customer customer;

    public CustomerOrderDTO() {}
    private CustomerOrderDetail detail;
    private Product product;

    private User customerUser; // The user linked to the customer

 
    

    public CustomerOrderDTO(CustomerOrder customerOrder, Customer customer, CustomerOrderDetail detail, Product product, User customerUser) {
        this.customerOrder = customerOrder;
        this.customer = customer;
        this.detail = detail;
        this.product = product;
        this.customerUser = customerUser;
    }

    public CustomerOrderDetail getDetail() {
        return detail;
    }

    public void setDetail(CustomerOrderDetail detail) {
        this.detail = detail;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }


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

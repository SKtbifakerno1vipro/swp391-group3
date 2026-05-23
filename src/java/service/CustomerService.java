package service;

import dal.CustomerDAO;
import java.util.List;
import model.Customer;
import model.CustomerDetail;
import model.User;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();

    public List<CustomerDetail> getAllCustomerDetails() {
        return customerDAO.getAllCustomerDetails();
    }

    public CustomerDetail getCustomerDetailByCustomerId(int id) {
        return customerDAO.getCustomerDetailByCustomerId(id);
    }

    public List<User> getAllUsers() {
        return customerDAO.getAllUsers();
    }

    public Customer getCustomerByCustomerId(int id) {
        return customerDAO.getCustomerByCustomerId(id);
    }

    public User getUserByEmail(String email) {
        return customerDAO.getUserByEmail(email);
    }

    public User getUserById(int userId) {
        return customerDAO.getUserById(userId);
    }

    public Integer getRoleIdByName(String roleName) {
        return customerDAO.getRoleIdByName(roleName);
    }

    public Customer createUserAndCustomer(User user, Customer customer) {
        return customerDAO.createUserAndCustomer(user, customer);
    }

    public boolean updateUser(User user) {
        return customerDAO.updateUser(user);
    }

    public boolean updateCustomer(Customer customer) {
        return customerDAO.updateCustomer(customer);
    }

    public String getLastError() {
        return customerDAO.getLastError();
    }
}

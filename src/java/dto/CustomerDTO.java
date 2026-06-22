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

    // Customer properties
    public int getCustomerId() {
        return customer.getCustomerId();
    }

    public void setCustomerId(int customerId) {
        customer.setCustomerId(customerId);
    }

    public String getTaxCode() {
        return customer.getTaxCode();
    }

    public void setTaxCode(String taxCode) {
        customer.setTaxCode(taxCode);
    }

    public String getCustomerType() {
        return customer.getCustomerType();
    }

    public void setCustomerType(String customerType) {
        customer.setCustomerType(customerType);
    }

    public String getCompanyName() {
        return customer.getCompanyName();
    }

    public void setCompanyName(String companyName) {
        customer.setCompanyName(companyName);
    }

    public Integer getAssignedToUserId() {
        return customer.getAssignedToUserId();
    }

    public void setAssignedToUserId(Integer assignedToUserId) {
        customer.setAssignedToUserId(assignedToUserId);
    }

    // User properties
    public int getUserId() {
        return user.getUserId();
    }

    public void setUserId(int userId) {
        user.setUserId(userId);
    }

    public String getUserName() {
        return user.getUserName();
    }

    public void setUserName(String userName) {
        user.setUserName(userName);
    }

    public String getPassword() {
        return user.getPassword();
    }

    public void setPassword(String password) {
        user.setPassword(password);
    }

    public String getEmail() {
        return user.getEmail();
    }
    

    public void setEmail(String email) {
        user.setEmail(email);
    }

    public String getGender() {
        return user.getGender();
    }

    public void setGender(String gender) {
        user.setGender(gender);
    }

    public String getFullName() {
        return user.getFullName();
    }

    public void setFullName(String fullName) {
        user.setFullName(fullName);
    }

    public String getPhone() {
        return user.getPhone();
    }

    public void setPhone(String phone) {
        user.setPhone(phone);
    }

    public String getStatus() {
        return user.getStatus();
    }

    public void setStatus(String status) {
        user.setStatus(status);
    }

    public int getRoleId() {
        return user.getRoleId();
    }

    public void setRoleId(int roleId) {
        user.setRoleId(roleId);
    }

    public LocalDateTime getCreateAt() {
        return user.getCreateAt();
    }

    public void setCreateAt(LocalDateTime createAt) {
        user.setCreateAt(createAt);
    }

    public LocalDateTime getUpdateAt() {
        return user.getUpdateAt();
    }

    public void setUpdateAt(LocalDateTime updateAt) {
        user.setUpdateAt(updateAt);
    }

    public Date getDateBirth() {
        return user.getDateBirth();
    }

    public void setDateBirth(Date dateBirth) {
        user.setDateBirth(dateBirth);
    }

    public String getAddress() {
        return user.getAddress();
    }

    public void setAddress(String address) {
        user.setAddress(address);
    }

    public int getCreatedBy() {
        return user.getCreatedBy();
    }

    public void setCreatedBy(int createdBy) {
        user.setCreatedBy(createdBy);
    }

    public int getUpdatedBy() {
        return user.getUpdatedBy();
    }

    public void setUpdatedBy(int updatedBy) {
        user.setUpdatedBy(updatedBy);
    }

    public String getCreateTimeString() {
        return user.getCreateTimeString();
    }

    public String getUpdateTimeString() {
        return user.getUpdateTimeString();
    }
}
package service;

import dal.CustomerDAO;
import dal.UserDAO;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import java.util.ArrayList;
import model.User;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserDAO userDAO = new UserDAO();
    private String error = "";
    
    public List<CustomerDTO> getAllCustomerDTOs() {
        return customerDAO.getAllCustomerDTOs();
    }
public List<CustomerDTO> FilterCustomerDTOs(String keyword, String cusType) {
    List<CustomerDTO> list = new ArrayList<>();
    
    String searchKeyword = (keyword != null) ? keyword.trim().toLowerCase() : "";
    String filterType = (cusType != null) ? cusType.trim() : "";

    for (CustomerDTO allCustomerDTO : customerDAO.getAllCustomerDTOs()) {
        boolean isTypeMatched = false;
        boolean isKeywordMatched = false;

        // 2. CHECK CUSTOMER TYPE
        
        if (filterType.isBlank()) {
            isTypeMatched = true;
        } else if (allCustomerDTO.getCustomer().getCustomerType() != null 
                && allCustomerDTO.getCustomer().getCustomerType().equalsIgnoreCase(filterType)) {
            isTypeMatched = true;
        }

        // 3. CHECK KEYWORD 
        if (searchKeyword.isBlank()) {
            isKeywordMatched = true;
        } else {
            String fullName = (allCustomerDTO.getUser().getFullName() != null) ? allCustomerDTO.getUser().getFullName().toLowerCase() : "";
            String email = (allCustomerDTO.getUser().getEmail() != null) ? allCustomerDTO.getUser().getEmail().toLowerCase() : "";
            String phone = (allCustomerDTO.getUser().getPhone() != null) ? allCustomerDTO.getUser().getPhone() : "";

            if (fullName.contains(searchKeyword) || email.contains(searchKeyword) || phone.contains(searchKeyword)) {
                isKeywordMatched = true;
            }
        }

        if (isTypeMatched && isKeywordMatched) {
            list.add(allCustomerDTO);
        }
    }
    return list;
}
    public CustomerDTO getCustomerDTOByCustomerId(int id) {
        return customerDAO.getCustomerDTOByCustomerId(id);
    }
    
    public boolean updateCustomerDTOByOJB(User u, Customer c) {
        boolean userUpdated = updateUser(u);
        boolean customerUpdated = updateCustomer(c);
        return userUpdated && customerUpdated;
    }

    public Customer getCustomerByUserId(int userId) {
        return customerDAO.getCustomerByUserId(userId);
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
        boolean isDuplicate = false;
        
        for (User allUser : getAllUsers()) {
            if (user.getUserName().equals(allUser.getUserName())) {
                isDuplicate = true;
                error = "Username already exists!";
                break;
            }
            
            if (user.getEmail() != null && user.getEmail().equals(allUser.getEmail())) {
                isDuplicate = true;
                error = "Email is already registered!";
                break;
            }
            
            if (user.getPhone() != null && user.getPhone().equals(allUser.getPhone())) {
                isDuplicate = true;
                error = "Phone number is already registered!";
                break;
            }
        }
        if (!isDuplicate) {
            return customerDAO.createCustomer(user, customer);
        }
        return null;
    }

    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    public boolean updateCustomer(Customer customer) {
        return customerDAO.updateCustomer(customer);
    }

    public String getLastError() {
        return customerDAO.getLastError() + error;
    }
}
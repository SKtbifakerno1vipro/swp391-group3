package service;

import dal.*;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import model.User;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    
    private List<String> cusTypeList = Arrays.asList("NEW CUSTOMER", "LOYAL CUSTOMER"); 
    
    public List<String> getCusTypeList() {
        return cusTypeList;
    }
    // new
    
    public List<CustomerDTO> getSearchAndPaginatedCusDTOs(String searchName, String type, int page, int pageSize) {
        List<CustomerDTO> dtoList = new ArrayList<>();

        List<Customer> customerList = customerDAO.searchAndPaginateCustomers(searchName, type, page, pageSize);
        if (customerList == null || customerList.isEmpty()) {
            return dtoList; 
        }

        List<User> userList = userService.getAllUsersReturnUser();
        Map<Integer, User> userMap = new HashMap<>();
        if (userList != null) {
            for (User u : userList) {
                userMap.put(u.getUserId(), u);
            }
        }

        for (Customer c : customerList) {
            User u = userMap.get(c.getUserId());
            if (u != null) {
                dtoList.add(new CustomerDTO(c, u, null));
            }
        }
        return dtoList;
    }
    // new 
    public int getTotalPages(String searchName, String type, int pageSize) {
        // Gọi hàm đếm tổng số dòng thỏa mãn điều kiện lọc dưới DAO
        int totalRecords = customerDAO.getTotalCustomersCount(searchName, type);
        
        if (totalRecords == 0) return 1;
        
        // Công thức tính tổng số trang chuẩn (Làm tròn lên)
        return (int) Math.ceil((double) totalRecords / pageSize);
    }
    // new
    public List<CustomerDTO> getAllCustomerDTOs() {
        List<CustomerDTO> dtoList = new ArrayList<>();
        List<Customer> customerList = customerDAO.getAllCustomers();

        if (customerList == null || customerList.isEmpty()) {
            return dtoList; 
        }

        List<User> userList = userService.getAllUsersReturnUser(); 

        Map<Integer, User> userMap = new HashMap<>();
        if (userList != null) {
            for (User u : userList) {
                userMap.put(u.getUserId(), u);
            }
        }

        for (Customer c : customerList) {
            User u = userMap.get(c.getUserId());

            if (u != null) {
                CustomerDTO dto = new CustomerDTO(c, u, "Customer");
                dtoList.add(dto);
            }
        }
        return dtoList;
    }
    // new 
    public CustomerDTO getCustomerDTOByCusId(int customerId) {
    // 
    Customer c = customerDAO.getCustomerByCusId(customerId);
    if (c == null) {
        return null;
    }
    
    int userId = c.getUserId();
    User u = userService.getUserByIdFullParameter(userId);

    if (u == null) {
        return null;
    }
    CustomerDTO dto = new CustomerDTO(c, u, "Customer");
    return dto;
}
    // new
    public String isDuplicateCusFields(String userName, String phone, String email, String taxCode) {
        // tim cac custome trung du lieu
        List<User> cus = userService.searchUserFieldsByOR(userName, phone, email, null);
        Integer id = customerDAO.getCustomerIdByTaxCode(taxCode);

        if (id != null) {
            return "Tax Code is already registered by another customer";
        }

        if (cus != null && !cus.isEmpty()) {
            for (User cu : cus) {

                if (userName != null && userName.trim().equalsIgnoreCase(cu.getUserName())) {
                    return "Username already exists in the system";
                }
                if (email != null && email.trim().equalsIgnoreCase(cu.getEmail())) {
                    return "Email address is already registered";
                }
                if (phone != null && phone.trim().equalsIgnoreCase(cu.getPhone())) {
                    return "Phone number is already in use!";
                }
            }
        }
        return "SUCCESS";
    }
    
    public boolean updateCustomerDTO(User u, Customer c) {
        boolean userUpdated = userService.updateUser(u);
        boolean customerUpdated = updateCustomer(c);
        return userUpdated && customerUpdated;
    }

    public Customer createCustomerDTO(User u, Customer c) {
        String isDuplicate = isDuplicateCusFields(u.getUserName(), u.getPhone(), u.getEmail(), c.getTaxCode());
        if (isDuplicate.contentEquals("SUCCESS")) {
            return customerDAO.createCustomer(u, c);
        }
        return null;
    }

    public boolean updateCustomer(Customer customer) {
        return customerDAO.updateCustomer(customer);
    }
    
    public String getLastError() {
        return customerDAO.getLastError();
    }
    public Customer getCustomerByUserId(int userId) {
        return customerDAO.getCustomerByCusId(userId);
    }
    public CustomerDTO getCustomerDTOByCustomerId(int id) {
        return customerDAO.getCustomerDTOByCustomerId(id);
    }
    public List<User> getAllSalesExecutiveUsers() {

        int salesExecutiveRoleId = roleService.getRoleIdByName("Sales Executive");
        
        if (salesExecutiveRoleId == 0) {
            salesExecutiveRoleId = 2; // Sales Executive trong DB 
        }

        return userService.searchUserFieldsByOR(null, null, null, salesExecutiveRoleId);
    }
}
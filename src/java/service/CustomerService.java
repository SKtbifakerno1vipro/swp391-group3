package service;

import dal.*;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import model.User;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    private String error = "";
    
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
        List<User> cus = userService.searchUserFieldsByOR(userName, phone, email);
        Integer id = customerDAO.getCustomerIdByTaxCode(taxCode);

        // 2. Trường hợp 1: Phát hiện trùng Mã Số Thuế trước (vì biến id đã check riêng lẻ)
        if (id != null) {
            return "Tax Code is already registered by another customer";
        }

        // 3. Trường hợp 2: Kiểm tra danh sách User trả về xem trùng cụ thể trường nào
        if (cus != null && !cus.isEmpty()) {
            for (User cu : cus) {
                // Sử dụng equalsIgnoreCase để ép chữ hoa/chữ thường check cho chính xác
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
        // 4. Trường hợp 3: Không trùng bất kỳ trường nào cả, dữ liệu hoàn toàn sạch
        return "SUCCESS";
    }

    public boolean updateCustomerDTO(User u, Customer c) {
        boolean userUpdated = userService.updateUser(u);
        boolean customerUpdated = updateCustomer(c);
        return userUpdated && customerUpdated;
    }

public Customer createCustomerDTO(User u, Customer c) {
        String isDuplicate = isDuplicateCusFields(u.getUserName(), u.getPhone(), u.getEmail(), c.getTaxCode());
        if (isDuplicate.contentEquals("SUCESS")) {
            return customerDAO.createCustomer(u, c);
        }
        return null;
    }

    public boolean updateCustomer(Customer customer) {
        return customerDAO.updateCustomer(customer);
    }

    public String getLastError() {
        return customerDAO.getLastError() + error;
    }
}
package service;

import dal.*;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import model.*;
import java.sql.Connection;
import utils.*;

public class CustomerService {
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    
    private List<String> cusTypeList = Arrays.asList("CUSTOMER", "LOYAL CUSTOMER"); 
    
    public List<String> getCusTypeList() {
        return cusTypeList;
    }
    // new
    
    public List<CustomerDTO> getSearchAndPaginatedCusDTOs(String searchName, String searchSdt, String searchEmail, String searchMst,
            String typeCus, Integer assignedToUserId, int page, int pageSize) {
        
        List<CustomerDTO> dtoList = new ArrayList<>();

        List<Customer> customerList = customerDAO.searchAndPaginateCustomers(searchName, searchSdt, searchEmail, searchMst, typeCus, assignedToUserId, page, pageSize);
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
                dtoList.add(new CustomerDTO(c, u));
            }
        }
        return dtoList;
    }
    // new 
    public int getTotalPages(String searchName, String searchSdt, String searchEmail, String searchMst,
            String typeCus, Integer assignedToUserId, int pageSize) {
        // Goi ham đem tong so dong thoa man đieu kien loc duoi DAO
        int totalRecords = customerDAO.getTotalCustomersCount(searchName, searchSdt, searchEmail, searchMst, typeCus, assignedToUserId);
        
        if (totalRecords == 0) return 1;
        
        // tinh tong so trang lam tron len
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
                CustomerDTO dto = new CustomerDTO(c, u);
                dtoList.add(dto);
            }
        }
        return dtoList;
    }
    // new 
    public CustomerDTO getCustomerDTOByCusId(int customerId) {

    Customer c = customerDAO.getCustomerByCusId(customerId);
    if (c == null) {
        return null;
    }
    
    int userId = c.getUserId();
    User u = userService.getUserByIdFullParameter(userId);

    if (u == null) {
        return null;
    }
    CustomerDTO dto = new CustomerDTO(c, u);
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
        boolean customerUpdated = customerDAO.updateCustomerDynamic(c);
        return userUpdated && customerUpdated;
    }

    public String createCustomerDTO(User user, Customer customer) {
        
        String validate = isDuplicateCusFields(user.getUserName(), user.getPhone(), user.getEmail(), customer.getTaxCode());
        if (!validate.contentEquals("SUCCESS")) {
            return validate;
        }
        
        String pass = PasswordUtils.generateRandomText();
        user.setPassword(pass);
        
        Connection conn = userService.getConnection(); 
        
        try {
            //tat che do tu dong luu cua database sql
            conn.setAutoCommit(false);

            int generatedUserId = userService.createUserFullParameter(user,conn);
            
            if (generatedUserId == -1) {
                System.out.println("Cannot create user account");
                conn.rollback(); // huy bo neu loi
                return null;
            }

            customer.setUserId(generatedUserId);

            boolean isCustomerInserted = customerDAO.insertCustomer(customer,conn);
            
            if (isCustomerInserted) {

                String emailSubject = "Chào mừng thành viên mới - Hệ thống SWP391";
                String emailBody = "<h3>Xin chào bạn," + user.getUserName() +"</h3>"
                                 + "<p>Tài khoản khách hàng của bạn trên hệ thống đã được khởi tạo thành công!</p>"
                                 + "<p>Vui lòng đăng nhập hệ thống để trải nghiệm dịch vụ của chúng tôi.</p>"
                                 + "<h3>" + pass + "</h3>"
                                 + "<br/><p>Trân trọng,</p><p>Đội ngũ hỗ trợ kỹ thuật.</p>";

                boolean isSent = EmailUtils.sendEmail(user.getEmail(), emailSubject, emailBody);
                if (!isSent) {
                    conn.rollback();
                    return "Error when send email to customer";
                }
                conn.commit(); // gui xong email moi tao
            } else {
                // Buoc 3 loi -> Rollback đe xoa luon tai khoan User vua tao o Buoc 1
                System.out.println("Lỗi: Tạo Customer thất bại! Tiến hành khôi phục dữ liệu.");
                conn.rollback(); 
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback(); // Dính exception là hủy hết
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true); // Trả lại trạng thái ban đầu cho Connection
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null; 
    }
    
    public String getLastError() {
        return customerDAO.getLastError();
    }
    public Customer getCustomerByCusId(int userId) {
        return customerDAO.getCustomerByCusId(userId);
    }
    public List<User> getAllSalesExecutiveUsers() {
        Integer salesExecutiveRoleId = roleService.getRoleIdByName("Sale Staff");

        if (salesExecutiveRoleId == null) {
            salesExecutiveRoleId = 4; // default sale staff role in seed data
        }

        return userService.searchUserFieldsByOR(null, null, null, salesExecutiveRoleId);
    }
}
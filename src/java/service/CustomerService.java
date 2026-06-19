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

    public CustomerDTO getCustomerDTOById(int id) {
        return customerDAO.getCustomerDTOById(id);
    }

    private List<String> cusTypeList = Arrays.asList("CUSTOMER", "LOYAL CUSTOMER");

    public List<String> getCusTypeList() {
        return cusTypeList;
    }
    // new

    public List<CustomerDTO> getSearchAndPaginatedCusDTOs(String searchName, String searchSdt, String searchEmail, String searchMst,
            String typeCus, Integer assignedToUserId, int page, int pageSize) {
        
        return customerDAO.searchAndPaginateCustomers(searchName, searchSdt, searchEmail, searchMst, typeCus, assignedToUserId, page, pageSize);
    }

    // new 
    public int getTotalPages(String searchName, String searchSdt, String searchEmail, String searchMst,
            String typeCus, Integer assignedToUserId, int pageSize) {
        // Goi ham đem tong so dong thoa man đieu kien loc duoi DAO
        int totalRecords = customerDAO.getTotalCustomersCount(searchName, searchSdt, searchEmail, searchMst, typeCus, assignedToUserId);

        if (totalRecords == 0) {
            return 1;
        }

        // tinh tong so trang lam tron len
        return (int) Math.ceil((double) totalRecords / pageSize);
    }

    // new
    public List<CustomerDTO> getAllCustomerDTOs() {
        return customerDAO.getAllCustomerDTOs();
    }

    //nguyenkiem - begin
    public CustomerDTO getCustomerDTOByUserId(int userId) {
        return customerDAO.getCustomerDTOByUserId(userId);
    }
    // nguyenkien - end
    
    // new 
    public CustomerDTO getCustomerDTOByCusId(int customerId) {
        return customerDAO.getCustomerDTOById(customerId);
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

            int generatedUserId = userService.createUserFullParameter(user, conn);

            if (generatedUserId == -1) {
                System.out.println("Cannot create user account");
                conn.rollback(); // huy bo neu loi
                return null;
            }

            customer.setUserId(generatedUserId);

            boolean isCustomerInserted = customerDAO.insertCustomer(customer, conn);

            if (isCustomerInserted) {
                int customerRoleId = roleService.getRoleIdByName("Customer");
                if (user.getRoleId() == customerRoleId) {
                    String emailSubject = "Chào mừng thành viên mới - Po Bread";
                    String emailBody = "<div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; max-width: 600px; margin: 0 auto; padding: 30px; border: 1px solid #e0e0e0; border-radius: 16px; background-color: #ffffff; box-shadow: 0 4px 12px rgba(0,0,0,0.05);\">"
                                     + "    <div style=\"text-align: center; margin-bottom: 24px; border-bottom: 2px solid #eaeaea; padding-bottom: 16px;\">"
                                     + "        <h2 style=\"color: #4A7C59; margin: 0; font-size: 26px; font-weight: 700; font-family: Georgia, serif;\">Po Bread</h2>"
                                     + "        <p style=\"color: #888888; margin: 5px 0 0 0; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;\">Hệ Thống Quản Lý Quy Trình Bán Hàng</p>"
                                     + "    </div>"
                                     + "    <div style=\"margin-bottom: 24px;\">"
                                     + "        <h3 style=\"color: #333333; margin-top: 0;\">Xin chào, <span style=\"color: #4A7C59;\">" + user.getUserName() + "</span>!</h3>"
                                     + "        <p style=\"color: #555555; font-size: 15px;\">Chào mừng bạn đến với <strong>Po Bread</strong>. Tài khoản khách hàng của bạn đã được khởi tạo thành công trên hệ thống của chúng tôi.</p>"
                                     + "        <p style=\"color: #555555; font-size: 15px;\">Dưới đây là thông tin đăng nhập cá nhân của bạn:</p>"
                                     + "    </div>"
                                     + "    <div style=\"background-color: #f7f9f7; border: 1px solid #e2ece2; border-radius: 12px; padding: 20px; margin-bottom: 24px;\">"
                                     + "        <table style=\"width: 100%; border-collapse: collapse;\">"
                                     + "            <tr>"
                                     + "                <td style=\"padding: 6px 0; color: #666666; font-size: 14px; width: 140px; font-weight: bold;\">Tên đăng nhập:</td>"
                                     + "                <td style=\"padding: 6px 0; color: #333333; font-size: 15px; font-weight: 600;\">" + user.getUserName() + "</td>"
                                     + "            </tr>"
                                     + "            <tr>"
                                     + "                <td style=\"padding: 6px 0; color: #666666; font-size: 14px; font-weight: bold;\">Mật khẩu tạm thời:</td>"
                                     + "                <td style=\"padding: 6px 0; color: #d9534f; font-size: 16px; font-weight: bold; font-family: monospace;\">" + pass + "</td>"
                                     + "            </tr>"
                                     + "        </table>"
                                     + "    </div>"
                                     + "    <div style=\"text-align: center; margin-bottom: 28px;\">"
                                     + "        <a href=\"http://localhost:8080/swp391-group3/login\" style=\"display: inline-block; padding: 12px 30px; background-color: #4A7C59; color: #ffffff; text-decoration: none; border-radius: 25px; font-weight: bold; font-size: 15px; box-shadow: 0 4px 8px rgba(74, 124, 89, 0.25);\">"
                                     + "            Đăng nhập hệ thống"
                                     + "        </a>"
                                     + "    </div>"
                                     + "    <div style=\"border-top: 1px solid #eaeaea; padding-top: 20px; color: #888888; font-size: 12px;\">"
                                     + "        <p style=\"margin: 0 0 10px 0; color: #d9534f; font-weight: bold;\">Lưu ý bảo mật:</p>"
                                     + "        <ul style=\"margin: 0; padding-left: 20px; color: #666666;\">"
                                     + "            <li>Vì lý do bảo mật, vui lòng tiến hành thay đổi mật khẩu ngay sau lần đăng nhập đầu tiên.</li>"
                                     + "            <li>Tuyệt đối không chia sẻ thông tin đăng nhập này với bất kỳ ai để đảm bảo an toàn tài khoản.</li>"
                                     + "        </ul>"
                                     + "        <hr style=\"border: none; border-top: 1px dashed #eaeaea; margin: 20px 0;\"/>"
                                     + "        <p style=\"text-align: center; margin: 0; font-weight: 600;\">Trân trọng,<br/>Đội ngũ hỗ trợ kỹ thuật Po Bread.</p>"
                                     + "    </div>"
                                     + "</div>";

                    boolean isSent = EmailUtils.sendEmail(user.getEmail(), emailSubject, emailBody);
                    if (!isSent) {
                        conn.rollback();
                        return "Error when send email to customer";
                    }
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
                if (conn != null) {
                    conn.rollback(); // Dính exception là hủy hết
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // Trả lại trạng thái ban đầu cho Connection
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public String getLastError() {
        return customerDAO.getLastError();
    }
    
    public Customer getCustomerByUserId(int userId) {
        return customerDAO.getCustomerByUserId(userId);

    public Customer getCustomerByCusId(int userId) {
        return customerDAO.getCustomerByCusId(userId);
    }

    public List<User> getAllSalesExecutiveUsers() {
        int salesExecutiveRoleId = roleService.getRoleIdByName("Sale Staff");

        if (salesExecutiveRoleId <= 0) {
            salesExecutiveRoleId = 4; // default sale staff role in seed data
        }

        return userService.searchUserFieldsByOR(null, null, null, salesExecutiveRoleId);
    }
}

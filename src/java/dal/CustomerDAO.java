package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import model.User;

public class CustomerDAO extends DBContext {
    
    String error = "";
    
    private Customer mapCustomer(ResultSet rs) throws Exception {
        Customer c = new Customer();
        c.setCustomerId(rs.getInt("customer_id"));
        c.setUserId((Integer) rs.getObject("user_id"));
        c.setTaxCode(rs.getString("tax_code"));
        c.setCustomerType(rs.getString("customer_type"));
        c.setCompanyName(rs.getString("company_name"));
        c.setAssignedToUserId((Integer) rs.getObject("assigned_to_user_id"));
        if (rs.getTimestamp("created_at") != null) {
            c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        return c;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>(); 
        String sql = "SELECT customer_id, tax_code, customer_type, company_name, user_id, assigned_to_user_id "
                + "FROM customer";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Customer c = mapCustomer(rs);
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "getAllCustomers: " + e.getMessage();
        }
        return list;
    }
    
    public Customer getCustomerByCusId(int id) {
        try {
            String sql = "SELECT customer_id, tax_code, customer_type, company_name, user_id, assigned_to_user_id "
                    + "FROM customer WHERE customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "getCustomerByCustomerId" + e.getMessage();
        }
        return null;
    }

    public Integer getCustomerIdByTaxCode(String taxCode) {
        String sql = "SELECT customer_id FROM customer WHERE tax_code = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, taxCode != null ? taxCode.trim() : "");
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("customer_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "getCustomerIdByTaxCode: " + e.getMessage();
        }
        return null; // Trả về null nếu không tìm thấy khách hàng nào khớp với mã số thuế này
    }

    public Customer createCustomer(User user, Customer customer) {
        UserDAO userDAO = new UserDAO();
        try {
            userDAO.createUser(user);
            String sqlGetId = "SELECT user_id FROM [user] WHERE user_name = ?";
            PreparedStatement stmId = connection.prepareStatement(sqlGetId);
            stmId.setString(1, user.getUserName());
            ResultSet rs = stmId.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("user_id");

                String sqlCustomer = "INSERT INTO [customer] (user_id, tax_code, customer_type, company_name, assigned_to_user_id, created_at, updated_at) "
                        + "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";

                PreparedStatement stmCustomer = connection.prepareStatement(sqlCustomer);
                stmCustomer.setInt(1, userId);
                stmCustomer.setString(2, customer.getTaxCode());
                stmCustomer.setString(3, customer.getCustomerType());
                stmCustomer.setString(4, customer.getCompanyName());
                if (customer.getAssignedToUserId() != null) {
                    stmCustomer.setInt(5, customer.getAssignedToUserId());
                } else {
                    stmCustomer.setNull(5, Types.INTEGER);
                }
                stmCustomer.executeUpdate();
                customer.setUserId(userId);
                return customer;
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "createCustomer " + e.getMessage();
        }
        return null;
    }

    public boolean updateCustomer(Customer customer) {
        try {
            String sql = "UPDATE [customer] SET tax_code = ?, customer_type = ?, company_name = ?, assigned_to_user_id = ?, updated_at = GETDATE() WHERE customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, customer.getTaxCode());
            stm.setString(2, customer.getCustomerType());
            stm.setString(3, customer.getCompanyName());
            if (customer.getAssignedToUserId() != null) {
                stm.setInt(4, customer.getAssignedToUserId());
            } else {
                stm.setNull(4, Types.INTEGER);
            }
            stm.setInt(5, customer.getCustomerId());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            error = "updateCustomer " + e.getMessage();
        }
        return false;
    }
    
    public String getLastError() {
        return error;
    }
    
    // tạo tạm để dùng
    public Integer getRoleIdByName(String roleName) {
        String sql = "SELECT role_id FROM role WHERE role_name = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, roleName != null ? roleName.trim() : "");
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("role_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "getRoleIdByName: " + e.getMessage();
        }
        return null; // Trả về null nếu không tìm thấy tên vai trò này trong DB
    }
}

package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.User;
import dto.*;

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

    public boolean updateCustomerDynamic(Customer customer) {
    // 1. Pre-condition check: user_id is mandatory for the WHERE clause
    if (customer.getUserId() == null || customer.getUserId() <= 0) {
        System.out.println("Error: Invalid user_id provided for the update condition!");
        return false;
    }
    
    StringBuilder sql = new StringBuilder("UPDATE [customer] SET ");
    
    List<Object> parameters = new ArrayList<>();

    if (customer.getTaxCode() != null && !customer.getTaxCode().trim().isEmpty()) {
        sql.append("tax_code = ?, ");
        parameters.add(customer.getTaxCode());
    }

    if (customer.getCustomerType() != null && !customer.getCustomerType().trim().isEmpty()) {
        sql.append("customer_type = ?, ");
        parameters.add(customer.getCustomerType());
    }

    if (customer.getCompanyName() != null && !customer.getCompanyName().trim().isEmpty()) {
        sql.append("company_name = ?, ");
        parameters.add(customer.getCompanyName());
    }

    if (customer.getAssignedToUserId() != null) {
        sql.append("assigned_to_user_id = ? ");
        parameters.add(customer.getAssignedToUserId());
    }

    // 3. If no fields were appended for update -> Terminate early
    if (parameters.isEmpty()) {
        System.out.println("Warning: No fields have changed. Update skipped!");
        return false;
    }

    sql.append(" WHERE user_id = ?");
    parameters.add(customer.getUserId()); // Add user_id to the end of the parameters list

    try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
        
        // Loop to dynamically bind parameters to corresponding "?" markers
        for (int i = 0; i < parameters.size(); i++) {
            Object param = parameters.get(i);
            
            // Map the Java types properly
            if (param instanceof String) {
                stm.setString(i + 1, (String) param);
            } else if (param instanceof Integer) {
                stm.setInt(i + 1, (Integer) param);
            } else {
                stm.setObject(i + 1, param);
            }
        }
        System.out.println("Thực thi câu lệnh: " + stm);
        // Execute and return execution status
        return stm.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        error = "updateCustomerDynamic error: " + e.getMessage();
    }
    return false;
}
    
    public boolean insertCustomer(Customer customer, Connection conn) {

    String sql = "INSERT INTO [customer] (tax_code, customer_type, company_name, user_id, assigned_to_user_id) "
               + "VALUES (?, ?, ?, ?, ?)";
    
    try (PreparedStatement stm = conn.prepareStatement(sql)) {
        
        // 1. tax_code
        if (customer.getTaxCode() != null && !customer.getTaxCode().trim().isEmpty()) {
            stm.setString(1, customer.getTaxCode());
        } else {
            stm.setNull(1, java.sql.Types.VARCHAR);
        }
        
        // 2. customer_type
        if (customer.getCustomerType() != null && !customer.getCustomerType().trim().isEmpty()) {
            stm.setString(2, customer.getCustomerType());
        } else {
            stm.setNull(2, java.sql.Types.VARCHAR);
        }
        // 3. company_name
        stm.setString(3, customer.getCompanyName());
        
        // 4. user_id
        stm.setInt(4, customer.getUserId());
        
        // 5. assigned_to_user_id
        if (customer.getAssignedToUserId() != null) {
            stm.setInt(5, customer.getAssignedToUserId());
        } else {
            stm.setNull(5, java.sql.Types.INTEGER);
        }
        return stm.executeUpdate() > 0;
        
    } catch (Exception e) {
        e.printStackTrace();
        this.error = "insertCustomer: " + e.getMessage();
    }
    return false;
}
    
    public String getLastError() {
        return error;
    }
    
    public List<Customer> searchAndPaginateCustomers(String searchName, String type, int page, int pageSize) {
        List<Customer> list = new ArrayList<>();

        // 1. Dùng LEFT JOIN để kéo dữ liệu từ bảng [user] sang so khớp
        String sql = "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, c.assigned_to_user_id "
                   + ", u.created_at, u.updated_at "
                   + "FROM customer c "
                   + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                   + "WHERE 1=1 "; 

        boolean hasSearch = (searchName != null && !searchName.isBlank());
        if (hasSearch) {
            sql += "AND (u.full_name LIKE ? OR u.phone LIKE ? OR c.tax_code LIKE ? OR u.email LIKE ?) ";
        }

        if (type != null && !type.isBlank()) {
            sql += "AND c.customer_type = ? ";
        }

        // 4. Đuôi phân trang cố định
        sql += "ORDER BY c.customer_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; //DESC

        int offset = (page - 1) * pageSize;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;

            if (hasSearch) {
                String searchPattern = "%" + searchName.trim() + "%";
                stm.setString(index++, searchPattern); // u.full_name
                stm.setString(index++, searchPattern); // u.phone
                stm.setString(index++, searchPattern); // c.tax_code
                stm.setString(index++, searchPattern); // u.email
            }

            // 6. customer_type
            if (type != null && !type.isBlank()) {
                stm.setString(index++, type.trim());
            }

            // 7. Gán tham số phân trang
            stm.setInt(index++, offset);
            stm.setInt(index++, pageSize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapCustomer(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "searchAndPaginateCustomers: " + e.getMessage();
        }
        return list;
    }
    
    public int getTotalCustomersCount(String searchName, String type) {
        String sql = "SELECT COUNT(*) FROM customer c LEFT JOIN [user] u ON c.user_id = u.user_id WHERE 1=1 ";

        boolean hasSearch = (searchName != null && !searchName.isBlank());
        if (hasSearch) {
            sql += "AND (u.full_name LIKE ? OR u.phone LIKE ? OR c.tax_code LIKE ? OR u.email LIKE ?) ";
        }
        if (type != null && !type.isBlank()) {
            sql += "AND c.customer_type = ? ";
        }

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            if (hasSearch) {
                String searchPattern = "%" + searchName.trim() + "%";
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
                stm.setString(index++, searchPattern);
            }
            if (type != null && !type.isBlank()) {
                stm.setString(index++, type.trim());
            }

            ResultSet rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}

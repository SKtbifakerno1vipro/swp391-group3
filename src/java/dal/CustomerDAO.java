package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import model.*;
import dto.*;
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

    private CustomerDTO mapCustomerDTO(ResultSet rs) throws Exception {
        Customer c = mapCustomer(rs);

        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUserName(rs.getString("user_name"));
        u.setEmail(rs.getString("email"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setGender(rs.getString("gender"));
        u.setAddress(rs.getString("address"));
        u.setStatus(rs.getString("account_status"));
        u.setRoleId(rs.getInt("role_id"));
        if (rs.getTimestamp("created_at") != null) {
            u.setCreateAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            u.setUpdateAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        u.setCreatedBy(rs.getInt("created_by"));
        u.setUpdatedBy(rs.getInt("updated_by"));

        return new CustomerDTO(c, u);
    }

    public List<CustomerDTO> getAllCustomerDTOs() {
        List<CustomerDTO> list = new ArrayList<>();
        String sql = "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, c.assigned_to_user_id, "
                + "u.user_name, u.email, u.full_name, u.phone, u.gender, u.address, u.account_status, u.role_id, "
                + "u.created_at, u.updated_at, u.created_by, u.updated_by "
                + "FROM customer c "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                CustomerDTO dto = mapCustomerDTO(rs);
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "getAllCustomerDTOs: " + e.getMessage();
        }
        return list;
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
        return null;
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

            // Loop to dynamically bind parameters to corresponding "D" markers
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
            System.out.println("ThÃ¡Â»Â±c thi cÃƒÂ¢u lÃ¡Â»â€¡nh: " + stm);
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

    public List<CustomerDTO> searchAndPaginateCustomers(String searchName, String searchSdt, String searchEmail, String searchMst,
            String typeCus, Integer assignedToUserId, int page, int pageSize) {
        List<CustomerDTO> list = new ArrayList<>();

        // 1. Khoi tao cau lenh SQL co ban
        StringBuilder sql = new StringBuilder(
                "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, c.assigned_to_user_id, "
                + "u.user_name, u.email, u.full_name, u.phone, u.gender, u.address, u.account_status, u.role_id, "
                + "u.created_at, u.updated_at, u.created_by, u.updated_by "
                + "FROM customer c "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE 1=1 "
        );

        // 2. Kiem tra trÆ°á»£t Ä‘ieu kien va build SQL Ä‘ong
        boolean hasName = (searchName != null && !searchName.isBlank());
        boolean hasSdt = (searchSdt != null && !searchSdt.isBlank());
        boolean hasEmail = (searchEmail != null && !searchEmail.isBlank());
        boolean hasMst = (searchMst != null && !searchMst.isBlank());
        boolean hasType = (typeCus != null && !typeCus.isBlank());
        boolean hasAssigned = (assignedToUserId != null && assignedToUserId > 0);
        
        if (hasName) {
            sql.append("AND u.full_name LIKE ? ");
            String strList[] = searchName.split("\\s+");
            String last = "";
            for (String string : strList) {
                last += string;
                last += " ";
            }
            searchName = last;
        }
        if (hasSdt) {
            sql.append("AND u.phone LIKE ? ");
        }
        if (hasEmail) {
            sql.append("AND u.email LIKE ? ");
        }
        if (hasMst) {
            sql.append("AND c.tax_code LIKE ? ");
        }
        if (hasType) {
            sql.append("AND c.customer_type = ? ");
        }
        if (hasAssigned) {
            sql.append("AND c.assigned_to_user_id = ? ");
        }

        // 3. Ä uoi phan trang co Ä‘inh
        sql.append("ORDER BY c.customer_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        int offset = (page - 1) * pageSize;
        
        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            int index = 1;

            // 4. Gan gia tri vao PreparedStatement theo Ä‘ung thu tu Ä‘a build o tren
            if (hasName) {
                stm.setString(index++, "%" + searchName.trim() + "%");
            }
            if (hasSdt) {
                stm.setString(index++, "%" + searchSdt.trim() + "%");
            }
            if (hasEmail) {
                stm.setString(index++, "%" + searchEmail.trim() + "%");
            }
            if (hasMst) {
                stm.setString(index++, "%" + searchMst.trim() + "%");
            }
            if (hasType) {
                stm.setString(index++, typeCus.trim());
            }
            if (hasAssigned) {
                stm.setInt(index++, assignedToUserId);
            }

            // 5. Gan tham so phan trang luon o cuoi cung
            stm.setInt(index++, offset);
            stm.setInt(index++, pageSize);

            // 6. Thuc thi truy van
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    list.add(mapCustomerDTO(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "searchAndPaginateCustomers: " + e.getMessage();
        }
        System.out.println("searchAndPaginateCustomers: " + list);
        return list;
    }
    
    public int getTotalCustomersCount(String searchName, String searchSdt, String searchEmail, String searchMst,
            String typeCus, Integer assignedToUserId) {

        // 1. Khoi tao cau lenh SQL co ban
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM customer c "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE 1=1 "
        );

        // 2. Kiem tra Ã„â€˜ieu kien va build SQL Ã„â€˜ong
        boolean hasName = (searchName != null && !searchName.isBlank());
        boolean hasSdt = (searchSdt != null && !searchSdt.isBlank());
        boolean hasEmail = (searchEmail != null && !searchEmail.isBlank());
        boolean hasMst = (searchMst != null && !searchMst.isBlank());
        boolean hasType = (typeCus != null && !typeCus.isBlank());
        boolean hasAssigned = (assignedToUserId != null && assignedToUserId > 0);
        
        if (hasName) {
            sql.append("AND u.full_name LIKE ? ");
        }
        if (hasSdt) {
            sql.append("AND u.phone LIKE ? ");
        }
        if (hasEmail) {
            sql.append("AND u.email LIKE ? ");
        }
        if (hasMst) {
            sql.append("AND c.tax_code LIKE ? ");
        }
        if (hasType) {
            sql.append("AND c.customer_type = ? ");
        }
        if (hasAssigned) {
            sql.append("AND c.assigned_to_user_id = ? ");
        }
        
        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            int index = 1;

            // 4. Gan gia tri vao PreparedStatement theo Ã„â€˜ung thu tu Ã„â€˜a build o tren
            if (hasName) {
                stm.setString(index++, "%" + searchName.trim() + "%");
            }
            if (hasSdt) {
                stm.setString(index++, "%" + searchSdt.trim() + "%");
            }
            if (hasEmail) {
                stm.setString(index++, "%" + searchEmail.trim() + "%");
            }
            if (hasMst) {
                stm.setString(index++, "%" + searchMst.trim() + "%");
            }
            if (hasType) {
                stm.setString(index++, typeCus.trim());
            }
            if (hasAssigned) {
                stm.setInt(index++, assignedToUserId);
            }
            // 6. Thuc thi truy van
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            error = "searchAndPaginateCustomers_Total: " + e.getMessage();
        }
        return 0;
    }

    public Customer getCustomerByUserId(int userId) {
        try {
            String sql = "SELECT customer_id, tax_code, customer_type, company_name, user_id, assigned_to_user_id "
                    + "FROM customer WHERE user_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public CustomerDTO getCustomerDTOById(int id) {
        try {
            String sql = "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, c.assigned_to_user_id, "
                    + "u.user_name, u.email, u.full_name, u.phone, u.gender, u.address, u.account_status, u.role_id, "
                    + "u.created_at, u.updated_at, u.created_by, u.updated_by "
                    + "FROM customer c "
                    + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                    + "WHERE c.customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapCustomerDTO(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

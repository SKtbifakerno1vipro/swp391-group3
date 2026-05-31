package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
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
    
    public List<Customer> searchAndPaginateCustomers(String searchName, String type, int page, int pageSize) {
        List<Customer> list = new ArrayList<>();

        // 1. Dùng LEFT JOIN để kéo dữ liệu từ bảng [user] sang so khớp
        String sql = "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, c.assigned_to_user_id "
                   + ", u.created_at, u.updated_at "
                   + "FROM customer c "
                   + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                   + "WHERE 1=1 "; 

        // 2. Xử lý cụm tìm kiếm chung (Gộp bằng toán tử OR và bọc trong ngoặc đơn để không phá vỡ logic các điều kiện khác)
        boolean hasSearch = (searchName != null && !searchName.isBlank());
        if (hasSearch) {
            sql += "AND (u.full_name LIKE ? OR u.phone LIKE ? OR c.tax_code LIKE ? OR u.email LIKE ?) ";
        }

        // 3. Điều kiện loại khách hàng (Bắt buộc thỏa mãn đồng thời nên dùng AND bên ngoài)
        if (type != null && !type.isBlank()) {
            sql += "AND c.customer_type = ? ";
        }

        // 4. Đuôi phân trang cố định
        sql += "ORDER BY c.customer_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        int offset = (page - 1) * pageSize;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;

            // 5. Gán giá trị động cho cụm OR (1 từ khóa searchName được gán lặp lại cho 4 dấu chấm hỏi)
            if (hasSearch) {
                String searchPattern = "%" + searchName.trim() + "%";
                stm.setString(index++, searchPattern); // u.full_name
                stm.setString(index++, searchPattern); // u.phone
                stm.setString(index++, searchPattern); // c.tax_code
                stm.setString(index++, searchPattern); // u.email
            }

            // 6. Gán giá trị cho customer_type
            if (type != null && !type.isBlank()) {
                stm.setString(index++, type.trim());
            }

            // 7. Gán tham số phân trang
            stm.setInt(index++, offset);
            stm.setInt(index++, pageSize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapCustomer(rs)); // Trả về Customer thô, map bằng hàm nội bộ sẵn có của bạn
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

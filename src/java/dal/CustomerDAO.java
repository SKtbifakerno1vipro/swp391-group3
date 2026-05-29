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

    public CustomerDTO getCustomerDTOByCustomerId(int id) {
        try {
            String sql = "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, "
                    + "c.assigned_to_user_id, c.created_at, c.updated_at, "
                    + "u.user_id AS u_id, u.email, u.full_name, u.phone, u.account_status, u.role_id, r.role_name "
                    + "FROM customer c "
                    + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                    + "LEFT JOIN role r ON u.role_id = r.role_id "
                    + "WHERE c.customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Customer c = mapCustomer(rs);
                User u = null;
                String rName = null;
                if (rs.getObject("u_id") != null) {
                    u = new User();
                    u.setUserId(rs.getInt("u_id"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPhone(rs.getString("phone"));
                    u.setStatus(rs.getString("account_status"));
                    u.setRoleId((Integer) rs.getObject("role_id"));
                    rName = rs.getString("role_name");
                }
                return new CustomerDTO(c, u, rName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CustomerDTO> getAllCustomerDTOs() {
        List<CustomerDTO> list = new ArrayList<>();
        try {
            String sql = "SELECT c.customer_id, c.tax_code, c.customer_type, c.company_name, c.user_id, "
                    + "c.assigned_to_user_id, c.created_at, c.updated_at, "
                    + "u.full_name, u.email, u.phone, u.account_status "
                    + "FROM customer c LEFT JOIN [user] u ON c.user_id = u.user_id";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Customer c = mapCustomer(rs);
                User u = new User();
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setStatus(rs.getString("account_status"));
                u.setPhone(rs.getString("phone"));
                list.add(new CustomerDTO(c, u, null));
            }
        } catch (Exception e) {
            System.out.println("getAllCustomerDTOs" + e.getMessage());
        }
        return list;
    }

    public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM customer WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (Exception e) {
            System.out.println("getCustomerByUserId" + e.getMessage());
        }
        return null;
    }

    public List<User> getAllUsers() {
        UserDAO uDAO = new UserDAO();
        return uDAO.getAllUsers();
    }

    public Customer getCustomerByCustomerId(int id) {
        try {
            String sql = "SELECT * FROM [customer] WHERE customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapCustomer(rs);
            }
        } catch (Exception e) {
            System.out.println("getCustomerByCustomerId" + e.getMessage());
        }
        return null;
    }

    public User getUserByEmail(String email) {
        return null;
    }

    public User getUserById(int userId) {
        UserDAO uDAO = new UserDAO();
        return uDAO.getUserById(userId);
    }

    public Integer getRoleIdByName(String roleName) {
        try {
            String sql = "SELECT role_id FROM role WHERE role_name = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, roleName);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt("role_id");
            }
        } catch (Exception e) {
            System.out.println("getRoleIdByName" + e.getMessage());
        }
        return null;
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
            System.out.println("createCustomer" + e.getMessage());
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
            System.out.println("updateCustomer" + e.getMessage());
        }
        return false;
    }

    public String getLastError() {
        return "";
    }
}

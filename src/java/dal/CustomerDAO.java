package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import model.User;
import service.CustomerService;
import service.UserService;

public class CustomerDAO extends DBContext {
    private final UserService userService = new UserService();
    public CustomerDTO getCustomerDTOByCustomerId(int id) {
        try {
            String sql = "select c.*, u.user_id as u_id, u.email, u.full_name, u.role_id, r.role_name from customer c "
                    + "left join [user] u on c.user_id = u.user_id left join role r on u.role_id = r.role_id where c.customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setUserId((Integer) rs.getObject("user_id"));
                c.setTaxCode(rs.getString("tax_code"));
                c.setType(rs.getString("type"));
                User u = null;
                String rName = null;
                if (rs.getObject("u_id") != null) {
                    u = new User();
                    u.setUserId(rs.getInt("u_id"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
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
            String sql = "select * from customer c left join [user] u on c.user_id = u.user_id";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {

                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setUserId((Integer) rs.getObject("user_id"));
                c.setTaxCode(rs.getString("tax_code"));
                c.setType(rs.getString("type"));
                User u = new User();
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setStatus(rs.getString("status"));
                u.setPhone(rs.getString("phone"));
                list.add(new CustomerDTO(c, u, null));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


       public Customer getCustomerByUserId(int userId) {
        String sql = "SELECT * FROM customer WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setUserId((Integer) rs.getObject("user_id"));
                c.setTaxCode(rs.getString("tax_code"));
                c.setType(rs.getString("type"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        UserDAO uDAO = new UserDAO();
        return uDAO.getAllUsers();
    }

    public Customer getCustomerByCustomerId(int id) {
        try {
            String sql = "select * from [customer] where customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setUserId((Integer) rs.getObject("user_id"));
                c.setTaxCode(rs.getString("tax_code"));
                c.setType(rs.getString("type"));
                c.setCreateBy((Integer) rs.getObject("create_by"));
                if (rs.getTimestamp("create_at") != null) {
                    c.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                }
                if (rs.getTimestamp("update_at") != null) {
                    c.setUpdateAt(rs.getTimestamp("update_at").toLocalDateTime());
                }
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
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
            e.printStackTrace();
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
                String sqlCustomer = "INSERT INTO [customer] (user_id, tax_code, type, create_by) VALUES (?,?,?,?)";
                PreparedStatement stmCustomer = connection.prepareStatement(sqlCustomer);
                stmCustomer.setInt(1, userId);
                stmCustomer.setString(2, customer.getTaxCode());
                stmCustomer.setString(3, customer.getType());
                if (customer.getCreateBy() != null) {
                    stmCustomer.setInt(4, customer.getCreateBy());
                } else {
                    stmCustomer.setNull(4, java.sql.Types.INTEGER);
                }

                stmCustomer.executeUpdate();
                customer.setUserId(userId);
                return customer;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        try {
            String sql = "UPDATE [user] SET full_name = ?, phone = ?, status = ?, password = ?, update_at = GETDATE() WHERE user_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getPhone());
            stm.setString(3, user.getStatus());
            stm.setString(4, user.getPassword());
            stm.setInt(5, user.getUserId());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateCustomer(Customer customer) {
        try {
            String sql = "UPDATE [customer] SET tax_code = ?, type = ?, update_at = GETDATE() WHERE customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, customer.getTaxCode());
            stm.setString(2, customer.getType());
            stm.setInt(3, customer.getCustomerId());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getLastError() {
        return "";
    }
}

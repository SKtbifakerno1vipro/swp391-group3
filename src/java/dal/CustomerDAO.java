package dal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import dto.CustomerDTO;
import model.User;
public class CustomerDAO extends DBContext {
    public CustomerDTO getCustomerDTOByCustomerId(int id) {
        try {
            String sql = "select c.*, u.user_id as u_id, u.email, u.full_name, u.role_id, r.role_name from customer c "
                    + "left join [user] u on c.user_id = u.user_id left join role r on u.role_id = r.role_id where c.customer_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Customer c = new Customer(); c.setCustomerId(rs.getInt("customer_id")); c.setUserId((Integer) rs.getObject("user_id"));
                c.setTaxCode(rs.getString("tax_code")); c.setType(rs.getString("type"));
                User u = null; String rName = null;
                if (rs.getObject("u_id") != null) {
                    u = new User(); u.setUserId(rs.getInt("u_id")); u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name")); u.setRoleId((Integer) rs.getObject("role_id"));
                    rName = rs.getString("role_name");
                }
                return new CustomerDTO(c, u, rName);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    public List<CustomerDTO> getAllCustomerDTOs() {
        List<CustomerDTO> list = new ArrayList<>();
        try {
            String sql = "select * from customer c left join [user] u on c.user_id = u.user_id";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Customer c = new Customer(); c.setCustomerId(rs.getInt("customer_id")); c.setUserId((Integer) rs.getObject("user_id")); c.setTaxCode(rs.getString("tax_code"));
                c.setTaxCode(rs.getString("tax_code")); c.setType(rs.getString("type"));
                User u = new User(); u.setFullName(rs.getString("full_name")); u.setEmail(rs.getString("email")); u.setStatus(rs.getString("status"));
                u.setPhone(rs.getString("phone"));
                list.add(new CustomerDTO(c, u, null));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public List<User> getAllUsers() { return new ArrayList<>(); }
    public Customer getCustomerByCustomerId(int id) { return null; }
    public User getUserByEmail(String email) { return null; }
    public User getUserById(int userId) { return null; }
    public Integer getRoleIdByName(String roleName) { return 0; }
    public Customer createUserAndCustomer(User user, Customer customer) { return null; }
    public boolean updateUser(User user) { return false; }
    public boolean updateCustomer(Customer customer) { return false; }
    public String getLastError() { return ""; }
}
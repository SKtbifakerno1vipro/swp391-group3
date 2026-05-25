package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.CustomerOrder;
import model.Customer;
import model.User;
import dto.CustomerOrderDTO;

public class CustomerOrderDAO extends DBContext {

    public List<CustomerOrderDTO> getAllCustomerOrders() {
        List<CustomerOrderDTO> list = new ArrayList<>();
        String sql = "SELECT co.*, c.tax_code, u.full_name " +
                     "FROM customer_order co " +
                     "JOIN customer c ON co.customer_id = c.customer_id " +
                     "LEFT JOIN [user] u ON c.user_id = u.user_id " +
                     "ORDER BY co.create_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerOrder co = new CustomerOrder();
                co.setCustomerOrderId(rs.getInt("customer_order_id"));
                co.setCustomerId(rs.getInt("customer_id"));
                co.setStatus(rs.getString("status"));
                co.setCreateBy((Integer) rs.getObject("create_by"));
                if (rs.getTimestamp("create_at") != null) {
                    co.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                }
                
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setTaxCode(rs.getString("tax_code"));
                
                User u = new User();
                u.setFullName(rs.getString("full_name"));
                
                list.add(new CustomerOrderDTO(co, c, u));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

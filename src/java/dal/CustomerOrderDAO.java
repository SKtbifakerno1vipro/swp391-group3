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
                list.add(mapResultSetToDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public CustomerOrderDTO getCustomerOrderDTOById(int id) {
        String sql = "SELECT co.*, c.tax_code, u.full_name " +
                     "FROM customer_order co " +
                     "JOIN customer c ON co.customer_id = c.customer_id " +
                     "LEFT JOIN [user] u ON c.user_id = u.user_id " +
                     "WHERE co.customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDTO(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<dto.CustomerOrderDetailDTO> getDetailsByOrderId(int orderId) {
        List<dto.CustomerOrderDetailDTO> details = new ArrayList<>();
        String sql = "SELECT cod.*, p.product_name, p.selling_price, p.unit " +
                     "FROM customer_order_detail cod " +
                     "JOIN product p ON cod.product_id = p.product_id " +
                     "WHERE cod.customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.CustomerOrderDetail cod = new model.CustomerOrderDetail();
                cod.setCustomerOrderDetailId(rs.getInt("customer_order_detail_id"));
                cod.setCustomerOrderId(rs.getInt("customer_order_id"));
                cod.setProductId(rs.getInt("product_id"));
                cod.setQuantity(rs.getInt("quantity"));

                model.Product p = new model.Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setSellingPrice(rs.getDouble("selling_price"));
                p.setUnit(rs.getString("unit"));

                dto.CustomerOrderDetailDTO detailDto = new dto.CustomerOrderDetailDTO();
                detailDto.setDetail(cod);
                detailDto.setProduct(p);
                details.add(detailDto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public boolean createOrder(CustomerOrder order, List<model.CustomerOrderDetail> details) {
        String insertOrderSql = "INSERT INTO customer_order (customer_id, status, create_by, create_at, update_at) VALUES (?, ?, ?, GETDATE(), GETDATE())";
        String insertDetailSql = "INSERT INTO customer_order_detail (customer_order_id, product_id, quantity) VALUES (?, ?, ?)";
        
        try {
            connection.setAutoCommit(false);
            
            // 1. Insert Order and get generated ID
            try (PreparedStatement psOrder = connection.prepareStatement(insertOrderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getCustomerId());
                psOrder.setString(2, order.getStatus());
                psOrder.setObject(3, order.getCreateBy());
                
                int affectedRows = psOrder.executeUpdate();
                if (affectedRows == 0) {
                    connection.rollback();
                    return false;
                }
                
                int orderId;
                try (ResultSet generatedKeys = psOrder.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    } else {
                        connection.rollback();
                        return false;
                    }
                }
                
                // 2. Insert Details
                try (PreparedStatement psDetail = connection.prepareStatement(insertDetailSql)) {
                    for (model.CustomerOrderDetail detail : details) {
                        psDetail.setInt(1, orderId);
                        psDetail.setInt(2, detail.getProductId());
                        psDetail.setInt(3, detail.getQuantity());
                        psDetail.addBatch();
                    }
                    psDetail.executeBatch();
                }
            }
            
            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private CustomerOrderDTO mapResultSetToDTO(ResultSet rs) throws java.sql.SQLException {
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
        
        CustomerOrderDTO dto = new CustomerOrderDTO();
        dto.setCustomerOrder(co);
        dto.setCustomer(c);
        dto.setCustomerUser(u);
        return dto;
    }

}

package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.CustomerOrder;
import model.Customer;
import model.User;
import dto.CustomerOrderDTO;
import java.sql.Timestamp;
import model.CustomerContract;

public class CustomerOrderDAO extends DBContext {

    public List<CustomerOrderDTO> getAllCustomerOrders() {
        List<CustomerOrderDTO> list = new ArrayList<>();
        String sql = "SELECT co.*, c.tax_code, u.full_name "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "ORDER BY co.customer_order_id DESC";

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
        String sql = "SELECT co.*, c.tax_code, u.full_name "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE co.customer_order_id = ?";
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

    public List<dto.CustomerOrderDTO> getDetailsByOrderId(int orderId) {
        List<dto.CustomerOrderDTO> details = new ArrayList<>();
        String sql = "SELECT cod.*, p.product_name, p.unit "
                + "FROM customer_order_detail cod "
                + "JOIN product p ON cod.product_id = p.product_id "
                + "WHERE cod.customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.CustomerOrderDetail cod = new model.CustomerOrderDetail();
                cod.setCustomerOrderDetailId(rs.getInt("customer_order_detail_id"));
                cod.setCustomerOrderId(rs.getInt("customer_order_id"));
                cod.setProductId(rs.getInt("product_id"));
                cod.setQuantity(rs.getInt("quantity"));
                cod.setCostPrice(rs.getDouble("cost_price"));
                cod.setSellingPrice(rs.getDouble("selling_price"));

                model.Product p = new model.Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));

                p.setSellingPrice(rs.getDouble("selling_price"));

                p.setUnit(rs.getString("unit"));

                dto.CustomerOrderDTO detailDto = new dto.CustomerOrderDTO();
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
        String insertOrderSql = "INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        String insertDetailSql = "INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES (?, ?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            // 1. Insert Order and get generated ID
            try (PreparedStatement psOrder = connection.prepareStatement(insertOrderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getCustomerId());
                psOrder.setInt(2, order.getCustomerContractId());
                psOrder.setString(3, order.getOrderStatus());
                psOrder.setObject(4, order.getCreatedBy());

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
                        psDetail.setDouble(4, detail.getCostPrice());
                        psDetail.setDouble(5, detail.getSellingPrice());
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
        co.setCustomerContractId(rs.getInt("customer_contract_id"));
        co.setOrderStatus(rs.getString("order_status"));
        co.setCreatedBy((Integer) rs.getObject("created_by"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            co.setCreatedAt(createdAt.toLocalDateTime());
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

    public List<CustomerContract> getContractsByCustomerId(int customerId) {
        List<CustomerContract> list = new ArrayList<>();
        String sql = "SELECT * FROM customer_contract WHERE customer_id = ? AND contract_status = 'SIGNED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerContract cc = new CustomerContract();
                cc.setContractId(rs.getInt("customer_contract_id"));
                cc.setContractNumber(rs.getString("contract_number"));
                cc.setStatus(rs.getString("contract_status"));
                list.add(cc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

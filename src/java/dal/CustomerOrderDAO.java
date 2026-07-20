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
import model.CustomerOrderDetail;
import model.Product;

public class CustomerOrderDAO extends DBContext {

    public static String lastError = "";

    public List<CustomerOrderDTO> getAllCustomerOrders() {
        return searchOrdersWithPaging(null, 0, 0, null, null, 0, null);
    }

    public CustomerOrderDTO getCustomerOrderDTOById(int id) {
        String sql = "SELECT co.*, c.tax_code, c.user_id, c.assigned_to_user_id, u.full_name "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE co.customer_order_id = ? AND (co.order_status IS NULL OR co.order_status <> 'DELETED')";
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

    public CustomerOrderDTO getOrderByContractId(int contractId) {
        String sql = "SELECT co.*, c.tax_code, c.user_id, c.assigned_to_user_id, u.full_name "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE co.customer_contract_id = ? AND (co.order_status IS NULL OR co.order_status <> 'DELETED') "
                + "ORDER BY co.customer_order_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDTO(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CustomerOrderDTO> getDetailsByOrderId(int orderId) {
        List<CustomerOrderDTO> details = new ArrayList<>();
        String sql = "SELECT cod.*, qd.product_name, qd.unit, qd.product_id, qd.tax_percent, qd.discount_percent "
                + "FROM customer_order_detail cod "
                + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "WHERE cod.customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerOrderDetail cod = new CustomerOrderDetail();
                cod.setCustomerOrderDetailId(rs.getInt("customer_order_detail_id"));
                cod.setCustomerOrderId(rs.getInt("customer_order_id"));
                cod.setQuotationDetailId(rs.getInt("quotation_detail_id"));
                cod.setQuantity(rs.getInt("quantity"));
                cod.setCostPrice(rs.getDouble("cost_price"));
                cod.setSellingPrice(rs.getDouble("selling_price"));
                cod.setTaxPercent(rs.getDouble("tax_percent"));
                cod.setDiscountPercent(rs.getDouble("discount_percent"));

                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setSellingPrice(rs.getDouble("selling_price"));
                p.setUnit(rs.getString("unit"));

                CustomerOrderDTO detailDto = new CustomerOrderDTO();
                detailDto.setDetail(cod);
                detailDto.setProduct(p);
                details.add(detailDto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    public double getTotalPriceFromQuotationByOrderId(int orderId) {
        String sql = "SELECT q.total_price "
                + "FROM customer_order co "
                + "JOIN customer_contract cc ON co.customer_contract_id = cc.customer_contract_id "
                + "JOIN quotation q ON cc.quotation_id = q.quotation_id "
                + "WHERE co.customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total_price");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean createOrder(CustomerOrder order, List<model.CustomerOrderDetail> details) {
        String insertOrderSql = "INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        String insertDetailSql = "INSERT INTO customer_order_detail (customer_order_id, quotation_detail_id, quantity, cost_price, selling_price) VALUES (?, ?, ?, ?, ?)";

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
                    for (CustomerOrderDetail detail : details) {
                        psDetail.setInt(1, orderId);
                        psDetail.setInt(2, detail.getQuotationDetailId());
                        psDetail.setInt(3, detail.getQuantity());
                        psDetail.setDouble(4, detail.getCostPrice());
                        psDetail.setDouble(5, detail.getSellingPrice());
                        psDetail.addBatch();
                    }
                    psDetail.executeBatch();
                }

                // 3. Deduct stock from products
                String deductStockSql = "UPDATE product SET quantity_available = quantity_available - ? WHERE product_id = ?";
                try (PreparedStatement psStock = connection.prepareStatement(deductStockSql)) {
                    for (CustomerOrderDetail detail : details) {
                        psStock.setInt(1, detail.getQuantity());
                        psStock.setInt(2, detail.getProductId());
                        psStock.addBatch();
                    }
                    psStock.executeBatch();
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
            lastError = e.getMessage();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    public boolean updateOrderStatus(int orderId, String status) {
        String checkStatusSql = "SELECT order_status FROM customer_order WHERE customer_order_id = ?";
        String updateStatusSql = "UPDATE customer_order SET order_status = ? WHERE customer_order_id = ?";
        
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            
            String currentStatus = null;
            try (PreparedStatement psCheck = connection.prepareStatement(checkStatusSql)) {
                psCheck.setInt(1, orderId);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next()) {
                        currentStatus = rs.getString("order_status");
                    }
                }
            }
            
            if (currentStatus == null) {
                connection.rollback();
                return false;
            }
            
            // If transitioning to CANCELLED and it wasn't CANCELLED before
            if ("CANCELLED".equalsIgnoreCase(status) && !"CANCELLED".equalsIgnoreCase(currentStatus)) {
                // Get items
                String getItemsSql = "SELECT qd.product_id, cod.quantity "
                        + "FROM customer_order_detail cod "
                        + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                        + "WHERE cod.customer_order_id = ?";
                List<int[]> items = new ArrayList<>();
                try (PreparedStatement psGetItems = connection.prepareStatement(getItemsSql)) {
                    psGetItems.setInt(1, orderId);
                    try (ResultSet rsItems = psGetItems.executeQuery()) {
                        while (rsItems.next()) {
                            int productId = rsItems.getInt("product_id");
                            int quantity = rsItems.getInt("quantity");
                            items.add(new int[]{productId, quantity});
                        }
                    }
                }
                
                // Add back quantity_available to products
                String restoreStockSql = "UPDATE product SET quantity_available = quantity_available + ? WHERE product_id = ?";
                try (PreparedStatement psRestore = connection.prepareStatement(restoreStockSql)) {
                    for (int[] item : items) {
                        psRestore.setInt(1, item[1]); // quantity
                        psRestore.setInt(2, item[0]); // product_id
                        psRestore.addBatch();
                    }
                    psRestore.executeBatch();
                }
            }
            
            // Update order status
            try (PreparedStatement psUpdate = connection.prepareStatement(updateStatusSql)) {
                psUpdate.setString(1, status);
                psUpdate.setInt(2, orderId);
                int affected = psUpdate.executeUpdate();
                if (affected > 0) {
                    // Update acceptance_status in acceptance_record table
                    String updateAccSql = "UPDATE acceptance_record SET acceptance_status = ?, updated_at = GETDATE() WHERE customer_order_id = ?";
                    try (PreparedStatement psAcc = connection.prepareStatement(updateAccSql)) {
                        psAcc.setString(1, status);
                        psAcc.setInt(2, orderId);
                        psAcc.executeUpdate();
                    } catch (Exception eAcc) {
                        System.out.println("Failed to update acceptance_record status: " + eAcc.getMessage());
                    }

                    connection.commit();
                    return true;
                } else {
                    connection.rollback();
                    return false;
                }
            }
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(originalAutoCommit);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public boolean deleteCustomerOrder(int orderId) {
        String sql = "UPDATE customer_order SET order_status = 'DELETED' WHERE customer_order_id = ?";
        String sqlAcc = "UPDATE acceptance_record SET acceptance_status = 'DELETED', updated_at = GETDATE() WHERE customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (PreparedStatement psAcc = connection.prepareStatement(sqlAcc)) {
                    psAcc.setInt(1, orderId);
                    psAcc.executeUpdate();
                } catch (Exception eAcc) {
                    System.out.println("Failed to update acceptance_record on delete: " + eAcc.getMessage());
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
        c.setUserId((Integer) rs.getObject("user_id"));
        c.setAssignedToUserId((Integer) rs.getObject("assigned_to_user_id"));

        User u = new User();
        u.setFullName(rs.getString("full_name"));

        CustomerOrderDTO dto = new CustomerOrderDTO();
        dto.setCustomerOrder(co);
        dto.setCustomer(c);
        dto.setCustomerUser(u);
        return dto;
    }

    public List<CustomerOrderDTO> getAllCustomerOrdersByName(String keyword) {
        List<CustomerOrderDTO> list = new ArrayList<>();
        String sql = "SELECT co.*, c.tax_code, c.user_id, c.assigned_to_user_id, u.full_name "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE u.full_name like ? "
                + "or c.tax_code like ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tai su dung ham mapResultSetToDTO đa co san trong DAO cua ban
                list.add(mapResultSetToDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private String getRoleFilter(int userId, String roleName) {
        if (userId > 0 && roleName != null) {
            if (roleName.toLowerCase().contains("sale")) {
                return " AND c.assigned_to_user_id = " + userId + " ";
            } else if (roleName.toLowerCase().contains("customer")) {
                return " AND c.user_id = " + userId + " ";
            }
        }
        return "";
    }

    public int getTotalOrders(int userId, String roleName) {
        String sql = "SELECT COUNT(*) FROM customer_order co " +
                     "JOIN customer c ON co.customer_id = c.customer_id " +
                     "WHERE (co.order_status IS NULL OR co.order_status <> 'DELETED') " + getRoleFilter(userId, roleName);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String getOrderByClause(String sortBy, String sortOrder) {
        String col = "co.customer_order_id";
        if ("orderId".equals(sortBy)) col = "co.customer_order_id";
        else if ("customerName".equals(sortBy)) col = "u.full_name";
        else if ("taxCode".equals(sortBy)) col = "c.tax_code";
        else if ("status".equals(sortBy)) col = "co.order_status";

        String dir = "asc".equalsIgnoreCase(sortOrder) ? "ASC" : "DESC";
        return "ORDER BY " + col + " " + dir;
    }


    public int getTotalOrdersBySearch(String keyword, int userId, String roleName) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM customer_order co ")
                .append("JOIN customer c ON co.customer_id = c.customer_id ")
                .append("LEFT JOIN [user] u ON c.user_id = u.user_id WHERE (co.order_status IS NULL OR co.order_status <> 'DELETED') ");

        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        if (hasKeyword) {
            sql.append("AND (u.full_name LIKE ? OR c.tax_code LIKE ?) ");
        }
        sql.append(getRoleFilter(userId, roleName));

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            if (hasKeyword) {
                String p = "%" + keyword.trim() + "%";
                ps.setString(1, p);
                ps.setString(2, p);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<CustomerOrderDTO> searchOrdersWithPaging(String keyword, int pageIndex, int pageSize, String sortBy, String sortOrder, int userId, String roleName) {
        List<CustomerOrderDTO> list = new ArrayList<>();
        String orderBy = getOrderByClause(sortBy, sortOrder);
        String filter = getRoleFilter(userId, roleName);

        StringBuilder sql = new StringBuilder("SELECT co.*, c.tax_code, c.user_id, c.assigned_to_user_id, u.full_name FROM customer_order co ")
                .append("JOIN customer c ON co.customer_id = c.customer_id ")
                .append("LEFT JOIN [user] u ON c.user_id = u.user_id WHERE (co.order_status IS NULL OR co.order_status <> 'DELETED') ");

        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
        if (hasKeyword) {
            sql.append("AND (u.full_name LIKE ? OR c.tax_code LIKE ?) ");
        }

        sql.append(filter).append(" ").append(orderBy);

        boolean hasPaging = (pageIndex > 0 && pageSize > 0);
        if (hasPaging) {
            sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (hasKeyword) {
                String p = "%" + keyword.trim() + "%";
                ps.setString(paramIdx++, p);
                ps.setString(paramIdx++, p);
            }
            if (hasPaging) {
                ps.setInt(paramIdx++, (pageIndex - 1) * pageSize);
                ps.setInt(paramIdx++, pageSize);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDTO(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

   
    public int getTotalOrdersCountByCusId(int cusId) {
        String sql = "SELECT COUNT(*) FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE c.customer_id = ? AND (co.order_status IS NULL OR co.order_status <> 'DELETED')";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cusId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<CustomerOrderDTO> getListCustomerOrderDTOByCusId(int cusId) {
        List<CustomerOrderDTO> list = new ArrayList<>();

       
        String sql = "SELECT co.*, c.tax_code, c.user_id, c.assigned_to_user_id, u.full_name "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "WHERE co.customer_id = ? AND (co.order_status IS NULL OR co.order_status <> 'DELETED') "
                + "ORDER BY co.created_at DESC"; // Sắp xếp đơn hàng mới nhất lên đầu

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, cusId);

            try (ResultSet rs = ps.executeQuery()) {
                
                while (rs.next()) {
                    list.add(mapResultSetToDTO(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
}

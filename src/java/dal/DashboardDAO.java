package dal;

import dto.ContractCustomerDTO;
import dto.DashboardSummaryDTO;
import dto.RoleStatisticDTO;
import dto.StatusStatisticDTO;
import dto.ActivityDTO;
import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.util.ArrayList;

import java.util.HashMap;

import java.util.LinkedHashMap;

import java.util.List;

import java.util.Map;

public class DashboardDAO extends DBContext {

    public int count(String tableName) {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO count error: " + e.getMessage());
        }
        return 0;
    }

    public int countWhere(String tableName, String columnName, String value) {

        String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE " + columnName + " = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, value);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(1);

                }

            }

        } catch (Exception e) {

            System.out.println("DashboardDAO countWhere error: " + e.getMessage());

        }

        return 0;

    }

    public Map<String, Integer> countByStatus(String tableName, String statusColumn, Integer saleId) {
        Map<String, Integer> statusCounts = new LinkedHashMap<>();
        String sql = "SELECT " + tableName + "." + statusColumn + ", COUNT(*) AS total FROM " + tableName + " ";
        if (saleId != null) {
            sql += " LEFT JOIN customer c ON " + tableName + ".customer_id = c.customer_id ";
            sql += " WHERE c.assigned_to_user_id = ? ";
        }
        sql += " GROUP BY " + tableName + "." + statusColumn;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    statusCounts.put(rs.getString(statusColumn), rs.getInt("total"));
                }
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO countByStatus error: " + e.getMessage());
        }
        return statusCounts;
    }

    public List<Map<String, Object>> getRecentContracts(int limit) {
        return getRecentContracts(limit, null);
    }

    public List<Map<String, Object>> getRecentContracts(int limit, Integer saleId) {
        List<Map<String, Object>> contracts = new ArrayList<>();
        String sql = "SELECT TOP (?) cc.customer_contract_id, cc.contract_number, cc.contract_status, cc.created_at, "
                + "c.company_name, "
                + "COALESCE(SUM(qd.quantity * qd.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100) "
                + "* (1 + COALESCE(qd.tax_percent, 0) / 100)), 0) AS contract_value "
                + "FROM customer_contract cc "
                + "LEFT JOIN customer c ON cc.customer_id = c.customer_id "
                + "LEFT JOIN quotation_detail qd ON cc.quotation_id = qd.quotation_id ";
        if (saleId != null) {
            sql += "WHERE c.assigned_to_user_id = ? ";
        }
        sql += "GROUP BY cc.customer_contract_id, cc.contract_number, cc.contract_status, cc.created_at, c.company_name "
                + "ORDER BY cc.created_at DESC, cc.customer_contract_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            if (saleId != null) {
                ps.setInt(2, saleId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> contract = new HashMap<>();
                    contract.put("id", rs.getInt("customer_contract_id"));
                    contract.put("contractNumber", rs.getString("contract_number"));
                    contract.put("status", rs.getString("contract_status"));
                    contract.put("createdAt", rs.getTimestamp("created_at"));
                    contract.put("companyName", rs.getString("company_name"));
                    contract.put("value", rs.getBigDecimal("contract_value"));
                    contracts.add(contract);
                }
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO getRecentContracts error: " + e.getMessage());
        }
        return contracts;
    }

    public List<Map<String, Object>> getRecentOrders(int limit) {
        return getRecentOrders(limit, null);
    }

    public List<Map<String, Object>> getRecentOrders(int limit, Integer saleId) {
        List<Map<String, Object>> orders = new ArrayList<>();
        String sql = "SELECT TOP (?) co.customer_order_id, co.order_status, co.created_at, "
                + "c.company_name, u.full_name "
                + "FROM customer_order co "
                + "LEFT JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id ";
        if (saleId != null) {
            sql += "WHERE c.assigned_to_user_id = ? ";
        }
        sql += "ORDER BY co.created_at DESC, co.customer_order_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            if (saleId != null) {
                ps.setInt(2, saleId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("id", rs.getInt("customer_order_id"));
                    order.put("status", rs.getString("order_status"));
                    order.put("createdAt", rs.getTimestamp("created_at"));
                    order.put("companyName", rs.getString("company_name"));
                    order.put("customerName", rs.getString("full_name"));
                    orders.add(order);
                }
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO getRecentOrders error: " + e.getMessage());
        }
        return orders;
    }

    public double getTotalRevenue() {
        return getTotalRevenue(null);
    }

    public double getTotalRevenue(Integer saleId) {
        String sql = "SELECT SUM(cod.quantity * cod.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100.0)) as total_revenue "
                + "FROM customer_order_detail cod "
                + "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id "
                + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "LEFT JOIN customer c ON co.customer_id = c.customer_id "
                + "WHERE co.order_status IN ('COMPLETED','DELIVERED', 'SHIPPING') ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total_revenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalOrders() {
        return getTotalOrders(null);
    }

    public int getTotalOrders(Integer saleId) {
        String sql = "SELECT COUNT(*) as total_orders FROM customer_order co LEFT JOIN customer c ON co.customer_id = c.customer_id ";
        if (saleId != null) {
            sql += "WHERE c.assigned_to_user_id = ? ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_orders");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalCustomers() {
        return getTotalCustomers(null);
    }

    public int getTotalCustomers(Integer saleId) {
        String sql = "SELECT COUNT(*) as total_customers FROM customer ";
        if (saleId != null) {
            sql += "WHERE assigned_to_user_id = ? ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_customers");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) as total_products FROM product";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total_products");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int getTotalQuotations(Integer saleId) {
        String sql = "SELECT COUNT(*) FROM quotation q LEFT JOIN customer c ON q.customer_id = c.customer_id ";
        if (saleId != null) {
            sql += "WHERE c.assigned_to_user_id = ? ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) ps.setInt(1, saleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalContracts(Integer saleId) {
        String sql = "SELECT COUNT(*) FROM customer_contract cc LEFT JOIN customer c ON cc.customer_id = c.customer_id ";
        if (saleId != null) {
            sql += "WHERE c.assigned_to_user_id = ? ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) ps.setInt(1, saleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Double> getRevenueByMonth() {
        Map<String, Double> revenueMap = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(co.created_at, 'yyyy-MM') as month, SUM(cod.quantity * cod.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100.0)) as revenue "
                + "FROM customer_order_detail cod "
                + "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id "
                + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "WHERE co.order_status IN ('Completed', 'DELIVERED') "
                + "GROUP BY FORMAT(co.created_at, 'yyyy-MM') "
                + "ORDER BY month ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                revenueMap.put(rs.getString("month"), rs.getDouble("revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueMap;
    }

    public Map<String, Integer> getOrderStatusStats() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT order_status, COUNT(*) as count FROM customer_order GROUP BY order_status";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.put(rs.getString("order_status"), rs.getInt("count"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.product_name, SUM(cod.quantity) as total_sold "
                + "FROM customer_order_detail cod "
                + "JOIN product p ON cod.product_id = p.product_id "
                + "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id "
                + "WHERE co.order_status IN ('Completed', 'DELIVERED') "
                + "GROUP BY p.product_name "
                + "ORDER BY total_sold DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("product_name", rs.getString("product_name"));
                item.put("total_sold", rs.getInt("total_sold"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getStaffPerformance() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT u.full_name, COUNT(DISTINCT co.customer_order_id) as total_orders, "
                + "SUM(CASE WHEN co.order_status IN ('Completed', 'DELIVERED') THEN cod.quantity * cod.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100.0) ELSE 0 END) as total_revenue "
                + "FROM [user] u "
                + "JOIN customer_order co ON u.user_id = co.created_by "
                + "LEFT JOIN customer_order_detail cod ON co.customer_order_id = cod.customer_order_id "
                + "LEFT JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "GROUP BY u.full_name "
                + "ORDER BY total_revenue DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("staff_name", rs.getString("full_name"));
                item.put("total_orders", rs.getInt("total_orders"));
                item.put("total_revenue", rs.getDouble("total_revenue"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //=================Officier admin
    /**
     * created by vtpp That function will count all of quotation have status is
     * acceptance
     *
     * @return the number of quotation accepted
     */
    public int countQuotationAwaitingContract() {
        String sql = """
                   select  count(*)
                   from quotation q join customer_contract c
                   on q.quotation_id= c.quotation_id
                   where q.quotation_status='ACCEPTED'
                   and c.contract_status is null""";
        try (PreparedStatement ps = connection.prepareCall(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countQuotationAwaitingContract" + e.getMessage());
        }
        return 0;
    }

    public int countContractInProgress() {
        String sql = """
                     select count(*)
                     from dbo.customer_contract c
                     where c.contract_status 
                     in ('DRAFT','PENDING_REVIEW','CUSTOMER_CHECK')""";
        try (PreparedStatement ps = connection.prepareCall(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countContractInProgress" + e.getMessage());
        }
        return 0;
    }

    /**
     * created by vtpp
     *
     * @param limit
     * @return
     */
    public List<ContractCustomerDTO> getContractNeedingAction(int limit) {
        List<ContractCustomerDTO> list = new ArrayList<>();
        String sql = """
                    select top (?)
                    c.customer_contract_id, c.contract_number, c.contract_status,
                    c.updated_at, cust.company_name
                    from customer_contract c join customer cust
                    on c.customer_id= cust.customer_id
                    where c.contract_status in ('PENDING_REVIEW','DRAFT')
                    order by c.updated_at desc""";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ContractCustomerDTO dto = new ContractCustomerDTO();

                    dto.setContractId(rs.getInt("customer_contract_id"));
                    dto.setContractNumber(rs.getString("contract_number"));
                    dto.setContractStatus(rs.getString("contract_status"));
                    dto.setCustomerName(rs.getString("company_name"));

                    if (rs.getTimestamp("updated_at") != null) {
                        dto.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            System.out.println("getContractsNeedingAction error: " + e.getMessage());
        }
        return list;
    }

    public Map<String, Integer> countContractStatusForOfficer() {
        Map<String, Integer> statusCounts = new LinkedHashMap<>();
        String sql = "SELECT contract_status as c_status, COUNT(*) AS total "
                + "FROM customer_contract "
                + "WHERE contract_status IS NOT NULL "
                + "GROUP BY contract_status";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statusCounts.put(rs.getString("c_status"), rs.getInt("total"));
            }
        } catch (Exception e) {
            System.out.println("countContractStatusForOfficer error: " + e.getMessage());
        }
        return statusCounts;
    }

    public int countActiveContracts() {
        String sql = "SELECT COUNT(*) FROM customer_contract WHERE contract_status IN ('SIGNED')";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countActiveContracts error: " + e.getMessage());
        }
        return 0;
    }

    public int countDraftContracts() {
        String sql = "SELECT COUNT(*) FROM customer_contract WHERE contract_status = 'DRAFT'";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("countDraftContracts error: " + e.getMessage());
        }
        return 0;
    }

    // --- System Admin Dashboard Specific Methods ---

    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM [user]";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getTotalUsers error: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalContracts() {
        String sql = "SELECT COUNT(*) FROM customer_contract";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getTotalContracts error: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalInvoices() {
        String sql = "SELECT COUNT(*) FROM invoice";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getTotalInvoices error: " + e.getMessage());
        }
        return 0;
    }

    public List<RoleStatisticDTO> getUsersByRole() {
        List<RoleStatisticDTO> list = new ArrayList<>();
        String sql = "SELECT r.role_name, COUNT(*) AS total "
                   + "FROM [user] u "
                   + "JOIN role r ON u.role_id = r.role_id "
                   + "GROUP BY r.role_name";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new RoleStatisticDTO(
                    rs.getString("role_name"),
                    rs.getInt("total")
                ));
            }
        } catch (Exception e) {
            System.out.println("getUsersByRole error: " + e.getMessage());
        }
        return list;
    }

    public List<StatusStatisticDTO> getContractsByStatus() {
        List<StatusStatisticDTO> list = new ArrayList<>();
        String sql = "SELECT contract_status, COUNT(*) AS total "
                   + "FROM customer_contract "
                   + "GROUP BY contract_status";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new StatusStatisticDTO(
                    rs.getString("contract_status"),
                    rs.getInt("total")
                ));
            }
        } catch (Exception e) {
            System.out.println("getContractsByStatus error: " + e.getMessage());
        }
        return list;
    }

    public List<StatusStatisticDTO> getOrdersByStatus() {
        List<StatusStatisticDTO> list = new ArrayList<>();
        String sql = "SELECT order_status, COUNT(*) AS total "
                   + "FROM customer_order "
                   + "GROUP BY order_status";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new StatusStatisticDTO(
                    rs.getString("order_status"),
                    rs.getInt("total")
                ));
            }
        } catch (Exception e) {
            System.out.println("getOrdersByStatus error: " + e.getMessage());
        }
        return list;
    }

    public List<ActivityDTO> getRecentActivities() {
        List<ActivityDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 10 sal.created_at, u.full_name, sal.action_type, sal.affected_object, sal.description "
                   + "FROM system_audit_log sal "
                   + "LEFT JOIN [user] u ON sal.user_id = u.user_id "
                   + "ORDER BY sal.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                java.sql.Timestamp ts = rs.getTimestamp("created_at");
                java.time.LocalDateTime ldt = (ts != null) ? ts.toLocalDateTime() : null;
                list.add(new ActivityDTO(
                    ldt,
                    rs.getString("full_name"),
                    rs.getString("action_type"),
                    rs.getString("affected_object"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) {
            System.out.println("getRecentActivities error: " + e.getMessage());
        }
        return list;
    }

}

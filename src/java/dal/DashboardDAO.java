package dal;

import dto.ContractCustomerDTO;
import dto.*;
import dto.RoleStatisticDTO;
import dto.StatusStatisticDTO;
import dto.ActivityDTO;
import dto.RecentInvoiceDTO;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import dto.TopProductDTO;
import dto.TopCustomerDTO;
import  java.sql.Timestamp;
import  java.time.LocalDateTime;
import model.Quotation;
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

    public List<StatusStatisticDTO> countByStatus(String tableName, String statusColumn, Integer saleId) {
        return countByStatus(tableName, statusColumn, saleId, null);
    }

    public List<StatusStatisticDTO> countByStatus(String tableName, String statusColumn, Integer saleId, String period) {
        List<StatusStatisticDTO> statusCounts = new ArrayList<>();
        String sql = "SELECT " + tableName + "." + statusColumn + ", COUNT(*) AS total FROM " + tableName + " ";
        if (saleId != null) {
            sql += " LEFT JOIN customer c ON " + tableName + ".customer_id = c.customer_id ";
        }
        sql += " WHERE 1=1 ";
        if (saleId != null) {
            sql += " AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition(tableName + ".created_at", period);
        sql += " GROUP BY " + tableName + "." + statusColumn;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    statusCounts.add(new StatusStatisticDTO(rs.getString(statusColumn), rs.getInt("total")));
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
        return getRecentOrders(limit, null, null);
    }

    public List<Map<String, Object>> getRecentOrders(int limit, Integer saleId) {
        return getRecentOrders(limit, saleId, null);
    }

    public List<Map<String, Object>> getRecentOrders(int limit, Integer saleId, String period) {
        List<Map<String, Object>> orders = new ArrayList<>();
        String sql = "SELECT TOP (?) co.customer_order_id, co.order_status, co.created_at, "
                + "c.company_name, u.full_name "
                + "FROM customer_order co "
                + "LEFT JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id WHERE 1=1 ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("co.created_at", period);
        sql += "ORDER BY co.created_at DESC, co.customer_order_id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, limit);
            if (saleId != null) {
                ps.setInt(idx++, saleId);
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

    private String getPeriodSqlCondition(String dateColumn, String period) {
        if ("today".equalsIgnoreCase(period)) {
            return " AND CAST(" + dateColumn + " AS DATE) = CAST(GETDATE() AS DATE) ";
        } else if ("week".equalsIgnoreCase(period)) {
            return " AND " + dateColumn + " >= DATEADD(wk, DATEDIFF(wk, 0, GETDATE()), 0) ";
        } else if ("month".equalsIgnoreCase(period)) {
            return " AND " + dateColumn + " >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) ";
        }
        return "";
    }

    public double getTotalRevenue() {
        return getTotalRevenue(null, null);
    }

    public double getTotalRevenue(Integer saleId) {
        return getTotalRevenue(saleId, null);
    }

    public double getTotalRevenue(Integer saleId, String period) {
        String sql = "SELECT SUM(cod.quantity * cod.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100.0)) as total_revenue "
                + "FROM customer_order_detail cod "
                + "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id "
                + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "LEFT JOIN customer c ON co.customer_id = c.customer_id "
                + "WHERE co.order_status IN ('COMPLETED','DELIVERED', 'SHIPPING') ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("co.created_at", period);
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
        return getTotalOrders(null, null);
    }

    public int getTotalOrders(Integer saleId) {
        return getTotalOrders(saleId, null);
    }

    public int getTotalOrders(Integer saleId, String period) {
        String sql = "SELECT COUNT(*) as total_orders FROM customer_order co LEFT JOIN customer c ON co.customer_id = c.customer_id WHERE 1=1 ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("co.created_at", period);
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
        return getTotalQuotations(saleId, null);
    }

    public int getTotalQuotations(Integer saleId, String period) {
        String sql = "SELECT COUNT(*) FROM quotation q LEFT JOIN customer c ON q.customer_id = c.customer_id WHERE 1=1 ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("q.created_at", period);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
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

    public int getTotalContracts(Integer saleId) {
        return getTotalContracts(saleId, null);
    }

    public int getTotalContracts(Integer saleId, String period) {
        String sql = "SELECT COUNT(*) FROM customer_contract cc LEFT JOIN customer c ON cc.customer_id = c.customer_id WHERE 1=1 ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("cc.created_at", period);
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (saleId != null) {
                ps.setInt(1, saleId);
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

    public List<StatusStatisticDTO> getOrderStatusStats() {
        List<StatusStatisticDTO> stats = new ArrayList<>();
        String sql = "SELECT order_status, COUNT(*) as count FROM customer_order GROUP BY order_status";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                stats.add(new StatusStatisticDTO(rs.getString("order_status"), rs.getInt("count")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    public List<TopProductDTO> getTopSellingProducts(int limit) {
        return getTopSellingProducts(limit, null, null);
    }

    public List<TopProductDTO> getTopSellingProducts(int limit, Integer saleId) {
        return getTopSellingProducts(limit, saleId, null);
    }

    public List<TopProductDTO> getTopSellingProducts(int limit, Integer saleId, String period) {
        List<TopProductDTO> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.product_name, SUM(cod.quantity) as total_sold "
                + "FROM customer_order_detail cod "
                + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "JOIN product p ON qd.product_id = p.product_id "
                + "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id ";
        if (saleId != null) {
            sql += "JOIN customer c ON co.customer_id = c.customer_id ";
        }
        sql += "WHERE co.order_status IN ('COMPLETED', 'Completed', 'DELIVERED', 'SHIPPING') ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("co.created_at", period);
        sql += "GROUP BY p.product_name "
                + "ORDER BY total_sold DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, limit);
            if (saleId != null) {
                ps.setInt(idx++, saleId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TopProductDTO item = new TopProductDTO();
                item.setProductName(rs.getString("product_name"));
                item.setTotalSold(rs.getInt("total_sold"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (list.isEmpty()) {
            list.add(new TopProductDTO("Dummy Product (No real sales)", 50));
        }
        return list;
    }

    public List<TopCustomerDTO> getTopCustomersByOrderCount(int limit, Integer saleId) {
        return getTopCustomersByOrderCount(limit, saleId, null);
    }

    public List<TopCustomerDTO> getTopCustomersByOrderCount(int limit, Integer saleId, String period) {
        List<TopCustomerDTO> list = new ArrayList<>();
        String sql = "SELECT TOP (?) c.company_name, COUNT(co.customer_order_id) as total_orders "
                + "FROM customer_order co "
                + "JOIN customer c ON co.customer_id = c.customer_id WHERE 1=1 ";
        if (saleId != null) {
            sql += "AND c.assigned_to_user_id = ? ";
        }
        sql += getPeriodSqlCondition("co.created_at", period);
        sql += "GROUP BY c.company_name "
                + "ORDER BY total_orders DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, limit);
            if (saleId != null) {
                ps.setInt(idx++, saleId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TopCustomerDTO item = new TopCustomerDTO();
                item.setCompanyName(rs.getString("company_name"));
                item.setTotalOrders(rs.getInt("total_orders"));
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

    //Officier admin
    /**
     * created by vtpp That function will count all of quotation have status is
     * accepted
     *
     * @return the number of quotation accepted
     */
    public int countQuotationAwaitingContract() {
        String sql = """
                   select count(*)
                   from quotation q
                   left join customer_contract c on q.quotation_id = c.quotation_id
                   where q.quotation_status='ACCEPTED'
                   and c.customer_contract_id is null""";
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

    public List<Quotation> getQuotationsAwaitingContract(int limit, String startDate, String endDate) {
        List<model.Quotation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT TOP (?) q.quotation_id, q.customer_id, q.quotation_date, q.quotation_status, q.created_at, cust.company_name
            FROM quotation q
            JOIN customer cust ON q.customer_id = cust.customer_id
            LEFT JOIN customer_contract c ON q.quotation_id = c.quotation_id
            WHERE q.quotation_status = 'ACCEPTED' AND c.customer_contract_id is null
        """);

        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND q.created_at >= ? ");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND q.created_at <= ? ");
        }
        sql.append(" ORDER BY q.created_at DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, limit);
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate + " 00:00:00");
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate + " 23:59:59");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Quotation q = new model.Quotation();
                    q.setQuotationId(rs.getInt("quotation_id"));
                    q.setCustomerName(rs.getString("company_name"));
                    q.setQuotationStatus(rs.getString("quotation_status"));
                    list.add(q);
                }
            }
        } catch (Exception e) {
            System.out.println("getQuotationsAwaitingContract error: " + e.getMessage());
        }
        return list;
    }

    /**
     * created by vtpp
     *
     * @return the number of contract have status is draft, pending and customer
     * check
     */
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
     * @return the list contract need to solve for officer
     */
    public List<ContractCustomerDTO> getContractNeedingAction(int limit, String startDate, String endDate) {
        List<ContractCustomerDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                    select top (?)
                    c.customer_contract_id, c.contract_number, c.contract_status,
                    c.updated_at, cust.company_name
                    from customer_contract c join customer cust
                    on c.customer_id= cust.customer_id
                    where c.contract_status in ('PENDING_REVIEW','DRAFT') """);

        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND c.updated_at >= ? ");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND c.updated_at <= ? ");
        }
        sql.append(" order by c.updated_at desc");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, limit);
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate + " 00:00:00");
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate + " 23:59:59");
            }

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
            System.out.println("getContractNeedingAction with dates: " + e.getMessage());
        }
        return list;
    }

    public List<StatusStatisticDTO> countContractStatusForOfficer() {
        List<StatusStatisticDTO> statusCounts = new ArrayList<>();
        String sql = """
                     SELECT contract_status as c_status, COUNT(*) AS total 
                     FROM customer_contract 
                     WHERE contract_status IS NOT NULL 
                     GROUP BY contract_status""";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statusCounts.add(new StatusStatisticDTO(rs.getString("c_status"), rs.getInt("total")));
            }
        } catch (Exception e) {
            System.out.println("countContractStatusForOfficer error: " + e.getMessage());
        }
        return statusCounts;
    }

    /**
     * created by vtpp
     *
     * @return the number of contract have status is signed
     */
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
               Timestamp ts = rs.getTimestamp("created_at");
                LocalDateTime ldt = (ts != null) ? ts.toLocalDateTime() : null;
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

    /**
     * created by vtpp
     *
     * @return the number of total invoice, total invoice paid and unpaid
     */
    public InvoiceSummaryDTO getInvoiceSummaryForOfficer() {
        InvoiceSummaryDTO summary = new InvoiceSummaryDTO();
        String sql = """
                   SELECT 
                       COUNT( i.invoice_id) as total_invoices, 
                       SUM(CASE WHEN p.payment_status = 'COMPLETED' THEN i.total_amount ELSE 0 END) as paid_amount, 
                       SUM(CASE WHEN p.payment_status !='COMPLETED' THEN i.total_amount ELSE 0 END) as unpaid_amount 
                   FROM invoice i 
                   JOIN payment p ON i.invoice_id = p.invoice_id 
                   WHERE i.invoice_status != 'UNRELEASED'
                     '""";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                summary.setTotalInvoices(rs.getInt("total_invoices"));
                summary.setPaidAmount(rs.getBigDecimal("paid_amount") != null ? rs.getBigDecimal("paid_amount") : BigDecimal.ZERO);
                summary.setUnpaidAmount(rs.getBigDecimal("unpaid_amount") != null ? rs.getBigDecimal("unpaid_amount") : BigDecimal.ZERO);
            }
        } catch (Exception e) {
            System.out.println("getInvoiceSummaryForOfficer error: " + e.getMessage());
        }
        return summary;
    }

    /**
     * created by vtpp
     *
     * @return the list recent invoice
     */
    public List<RecentInvoiceDTO> getRecentInvoicesForOfficer(int limit, String startDate, String endDate) {
        return getRecentInvoicesForOfficer(limit, startDate, endDate, null);
    }

    public List<RecentInvoiceDTO> getRecentInvoicesForOfficer(int limit, String startDate, String endDate, String period) {
        List<RecentInvoiceDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT TOP (?) i.invoice_id, i.invoice_no, i.issue_date, i.total_amount, i.invoice_status, "
                + "c.contract_number, cu.company_name, o.customer_order_id "
                + "FROM invoice i "
                + "  JOIN customer_contract c ON i.customer_contract_id = c.customer_contract_id "
                + "  JOIN customer cu ON c.customer_id = cu.customer_id "
                + "  JOIN customer_order o ON i.customer_order_id = o.customer_order_id "
                + "WHERE 1=1 ");

        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND i.issue_date >= ? ");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND i.issue_date <= ? ");
        }
        sql.append(getPeriodSqlCondition("i.issue_date", period));
        sql.append(" ORDER BY i.issue_date DESC, i.invoice_id DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, limit);
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    dto.RecentInvoiceDTO inv = new dto.RecentInvoiceDTO();
                    inv.setInvoiceId(rs.getInt("invoice_id"));
                    inv.setInvoiceNo(rs.getString("invoice_no"));
                    inv.setIssueDate(rs.getDate("issue_date"));
                    inv.setTotalAmount(rs.getBigDecimal("total_amount"));
                    inv.setInvoiceStatus(rs.getString("invoice_status"));
                    inv.setContractNumber(rs.getString("contract_number"));
                    inv.setCompanyName(rs.getString("company_name"));
                    inv.setOrderId(rs.getInt("customer_order_id"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            System.out.println("getRecentInvoicesForOfficer with dates error: " + e.getMessage());
        }
        return list;
    }

    // ==========================================
    // WAREHOUSE DASHBOARD METHODS
    // ==========================================

    public int getPendingImportRequestsCount() {
        String sql = "SELECT COUNT(*) FROM import_request WHERE status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getPendingImportRequestsCount error: " + e.getMessage());
        }
        return 0;
    }

    public int getPendingOrdersCount() {
        String sql = "SELECT COUNT(*) FROM customer_order WHERE order_status NOT IN ('COMPLETED', 'CANCELLED')";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getPendingOrdersCount error: " + e.getMessage());
        }
        return 0;
    }

    public int getLowStockProductsCount() {
        String sql = "SELECT COUNT(*) FROM product WHERE quantity_available <= reorder_level AND product_status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("getLowStockProductsCount error: " + e.getMessage());
        }
        return 0;
    }

    public List<Map<String, Object>> getLowStockProductsList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT p.product_name, c.category_name, p.quantity_available, p.reorder_level "
                   + "FROM product p "
                   + "JOIN category c ON p.category_id = c.category_id "
                   + "WHERE p.quantity_available <= p.reorder_level AND p.product_status = 'ACTIVE' "
                   + "ORDER BY p.quantity_available ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("productName", rs.getString("product_name"));
                map.put("categoryName", rs.getString("category_name"));
                int available = rs.getInt("quantity_available");
                int reorder = rs.getInt("reorder_level");
                map.put("available", available);
                map.put("reorderLevel", reorder);
                
                String status = "Low";
                if (available == 0 || available <= reorder * 0.2 || available <= 5) {
                    status = "Critical";
                }
                map.put("status", status);
                list.add(map);
            }
        } catch (Exception e) {
            System.out.println("getLowStockProductsList error: " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getPendingImportRequestsList(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) ir.import_id, p.product_name, ir.quantity, u.full_name AS creator_name, ir.created_date "
                   + "FROM import_request ir "
                   + "JOIN product p ON ir.product_id = p.product_id "
                   + "JOIN [user] u ON ir.created_by = u.user_id "
                   + "WHERE ir.status = 1 "
                   + "ORDER BY ir.created_date DESC, ir.import_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("importId", rs.getInt("import_id"));
                    map.put("productName", rs.getString("product_name"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("creatorName", rs.getString("creator_name"));
                    map.put("createdDate", rs.getTimestamp("created_date"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("getPendingImportRequestsList error: " + e.getMessage());
        }
        return list;
    }

    public List<Map<String, Object>> getRecentOrdersList(int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP (?) co.customer_order_id, c.company_name, co.order_status, co.created_at "
                   + "FROM customer_order co "
                   + "JOIN customer c ON co.customer_id = c.customer_id "
                   + "ORDER BY co.created_at DESC, co.customer_order_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("orderId", rs.getInt("customer_order_id"));
                    map.put("companyName", rs.getString("company_name"));
                    map.put("status", rs.getString("order_status"));
                    map.put("createdAt", rs.getTimestamp("created_at"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            System.out.println("getRecentOrdersList error: " + e.getMessage());
        }
        return list;
    }

    public List<ProductSalesItemDTO> getProductSalesReport(String startDate, String endDate, Integer staffId) {
        List<ProductSalesItemDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.product_name, "
          + "       SUM(cod.quantity) as total_quantity, "
          + "       AVG(cod.selling_price) as avg_price, "
          + "       SUM(cod.quantity * cod.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100.0)) as total_amount "
          + "FROM customer_order_detail cod "
          + "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id "
          + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
          + "JOIN product p ON qd.product_id = p.product_id "
          + "LEFT JOIN quotation q ON qd.quotation_id = q.quotation_id "
          + "LEFT JOIN customer c ON co.customer_id = c.customer_id "
          + "WHERE co.order_status IN ('COMPLETED', 'Completed', 'DELIVERED', 'SHIPPING') "
        );

        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND co.created_at >= ? ");
            params.add(startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND co.created_at <= ? ");
            params.add(endDate + " 23:59:59");
        }
        if (staffId != null && staffId > 0) {
            sql.append(" AND (c.assigned_to_user_id = ? OR co.created_by = ? OR q.created_by = ?) ");
            params.add(staffId);
            params.add(staffId);
            params.add(staffId);
        }

        sql.append(" GROUP BY p.product_name ORDER BY total_amount DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductSalesItemDTO item = new ProductSalesItemDTO();
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("total_quantity"));
                    item.setPrice(rs.getDouble("avg_price"));
                    item.setAmount(rs.getDouble("total_amount"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.out.println("getProductSalesReport Error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getAllStaffUsers() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.full_name, u.user_name "
                   + "FROM [user] u "
                   + "LEFT JOIN role r ON u.role_id = r.role_id "
                   + "WHERE u.account_status = 'ACTIVE' "
                   + "  AND (u.role_id = 4 OR LOWER(r.role_name) LIKE '%sale%') "
                   + "ORDER BY u.full_name ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("userId", rs.getInt("user_id"));
                    map.put("fullName", rs.getString("full_name"));
                    map.put("userName", rs.getString("user_name"));
                    list.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

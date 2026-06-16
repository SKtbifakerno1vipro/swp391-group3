package dal;

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

    public Map<String, Integer> countByStatus(String tableName, String statusColumn) {
        Map<String, Integer> statusCounts = new LinkedHashMap<>();
        String sql = "SELECT " + statusColumn + ", COUNT(*) AS total FROM " + tableName + " GROUP BY " + statusColumn;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statusCounts.put(rs.getString(statusColumn), rs.getInt("total"));
            }
        } catch (Exception e) {
            System.out.println("DashboardDAO countByStatus error: " + e.getMessage());
        }
        return statusCounts;
    }


    public List<Map<String, Object>> getRecentContracts(int limit) {
        List<Map<String, Object>> contracts = new ArrayList<>();
        String sql = "SELECT TOP (?) cc.customer_contract_id, cc.contract_number, cc.contract_status, cc.created_at, "
                + "c.company_name, "
                + "COALESCE(SUM(qd.quantity * qd.selling_price * (1 - COALESCE(qd.discount_percent, 0) / 100) "
                + "* (1 + COALESCE(qd.tax_percent, 0) / 100)), 0) AS contract_value "
                + "FROM customer_contract cc "
                + "LEFT JOIN customer c ON cc.customer_id = c.customer_id "
                + "LEFT JOIN quotation_detail qd ON cc.quotation_id = qd.quotation_id "
                + "GROUP BY cc.customer_contract_id, cc.contract_number, cc.contract_status, cc.created_at, c.company_name "
                + "ORDER BY cc.created_at DESC, cc.customer_contract_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
        List<Map<String, Object>> orders = new ArrayList<>();
        String sql = "SELECT TOP (?) co.customer_order_id, co.order_status, co.created_at, "
                + "c.company_name, u.full_name "
                + "FROM customer_order co "
                + "LEFT JOIN customer c ON co.customer_id = c.customer_id "
                + "LEFT JOIN [user] u ON c.user_id = u.user_id "
                + "ORDER BY co.created_at DESC, co.customer_order_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
}

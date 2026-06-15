package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO extends DBContext {

    public double getTotalRevenue() {
        String sql = "SELECT SUM(cod.quantity * cod.selling_price) as total_revenue " +
                     "FROM customer_order_detail cod " +
                     "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id " +
                     "WHERE co.order_status = 'Completed'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
        String sql = "SELECT COUNT(*) as total_orders FROM customer_order";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
        String sql = "SELECT COUNT(*) as total_customers FROM customer";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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

    public Map<String, Double> getRevenueByMonth() {
        Map<String, Double> revenueMap = new HashMap<>();
        String sql = "SELECT FORMAT(co.created_at, 'yyyy-MM') as month, SUM(cod.quantity * cod.selling_price) as revenue " +
                     "FROM customer_order_detail cod " +
                     "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id " +
                     "WHERE co.order_status = 'Completed' " +
                     "GROUP BY FORMAT(co.created_at, 'yyyy-MM') " +
                     "ORDER BY month DESC";
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
        String sql = "SELECT TOP (?) p.product_name, SUM(cod.quantity) as total_sold " +
                     "FROM customer_order_detail cod " +
                     "JOIN product p ON cod.product_id = p.product_id " +
                     "JOIN customer_order co ON cod.customer_order_id = co.customer_order_id " +
                     "WHERE co.order_status = 'Completed' " +
                     "GROUP BY p.product_name " +
                     "ORDER BY total_sold DESC";
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
        String sql = "SELECT u.full_name, COUNT(DISTINCT co.customer_order_id) as total_orders, " +
                     "SUM(CASE WHEN co.order_status = 'Completed' THEN cod.quantity * cod.selling_price ELSE 0 END) as total_revenue " +
                     "FROM [user] u " +
                     "JOIN customer_order co ON u.user_id = co.created_by " +
                     "LEFT JOIN customer_order_detail cod ON co.customer_order_id = cod.customer_order_id " +
                     "GROUP BY u.full_name " +
                     "ORDER BY total_revenue DESC";
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
}

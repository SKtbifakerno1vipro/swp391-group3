package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

public class RevenueDAO extends DBContext {

    public Map<String, Double> getRevenueByDay(String startDate, String endDate, Integer userId) {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = "SELECT CAST(co.created_at AS DATE) as date, SUM(cod.quantity * cod.selling_price) as revenue " +
                     "FROM customer_order co " +
                     "JOIN customer_order_detail cod ON co.customer_order_id = cod.customer_order_id " +
                     "WHERE co.order_status IN ('Completed', 'DELIVERED') ";
        
        if (startDate != null && !startDate.isEmpty()) {
            sql += "AND co.created_at >= ? ";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += "AND co.created_at <= ? ";
        }
        if (userId != null) {
            sql += "AND co.created_by = ? ";
        }
        
        sql += "GROUP BY CAST(co.created_at AS DATE) ORDER BY date ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate + " 23:59:59");
            }
            if (userId != null) {
                ps.setInt(paramIndex++, userId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("date"), rs.getDouble("revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public Map<String, Double> getRevenueByMonth(String startDate, String endDate, Integer userId) {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(co.created_at, 'yyyy-MM') as month, SUM(cod.quantity * cod.selling_price) as revenue " +
                     "FROM customer_order co " +
                     "JOIN customer_order_detail cod ON co.customer_order_id = cod.customer_order_id " +
                     "WHERE co.order_status IN ('Completed', 'DELIVERED') ";

        if (startDate != null && !startDate.isEmpty()) {
            sql += "AND co.created_at >= ? ";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += "AND co.created_at <= ? ";
        }
        if (userId != null) {
            sql += "AND co.created_by = ? ";
        }

        sql += "GROUP BY FORMAT(co.created_at, 'yyyy-MM') ORDER BY month ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate + " 23:59:59");
            }
            if (userId != null) {
                ps.setInt(paramIndex++, userId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("month"), rs.getDouble("revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }

    public Map<String, Double> getRevenueByYear(String startDate, String endDate, Integer userId) {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = "SELECT YEAR(co.created_at) as year, SUM(cod.quantity * cod.selling_price) as revenue " +
                     "FROM customer_order co " +
                     "JOIN customer_order_detail cod ON co.customer_order_id = cod.customer_order_id " +
                     "WHERE co.order_status IN ('Completed', 'DELIVERED') ";

        if (startDate != null && !startDate.isEmpty()) {
            sql += "AND co.created_at >= ? ";
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql += "AND co.created_at <= ? ";
        }
        if (userId != null) {
            sql += "AND co.created_by = ? ";
        }

        sql += "GROUP BY YEAR(co.created_at) ORDER BY year ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate + " 23:59:59");
            }
            if (userId != null) {
                ps.setInt(paramIndex++, userId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                data.put(rs.getString("year"), rs.getDouble("revenue"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
}

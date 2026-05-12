package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public int getTotalHouses() {
        try {
            stm = connection.prepareStatement("SELECT COUNT(*) FROM Houses");
            rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalRooms() {
        try {
            stm = connection.prepareStatement("SELECT COUNT(*) FROM Rooms");
            rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getOccupiedRooms() {
        try {
            stm = connection.prepareStatement(
                "SELECT COUNT(*) FROM Rooms WHERE Status='O'");
            rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getMonthlyRevenue() {
        String sql = """
            SELECT SUM(electric_bill + water_bill + room_price + other)
            FROM Invoices
            WHERE status='P'
            AND MONTH(GETDATE()) = MONTH(GETDATE())
            """;

        try {
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}
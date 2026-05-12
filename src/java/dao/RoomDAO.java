package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Room;

public class RoomDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public List<Room> getByHouse(String houseId) {
        List<Room> list = new ArrayList<>();
        String sql = "select * from dbo.Rooms where HouseID= ?   ";

        try {
            stm = connection.prepareCall(sql);
            stm.setString(1, houseId);
            rs = stm.executeQuery();
            while (rs.next()) {
                Room r = new Room(rs.getString("RoomID"),
                        rs.getString("Status"),
                        rs.getString("HouseID"));

                list.add(r);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Room r) {
        String sql = "insert into Rooms values(?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, r.getRoomID());
            stm.setString(2, r.getStatus()); // default is available
            stm.setString(3, r.getHouseID());
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(String roomId) {
        String sql = "delete from dbo.Rooms where RoomID= ? ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, roomId);
            stm.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(String roomId, String status) {
        String sql = "update dbo.Rooms set Status=? where RoomID= ? ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, status);
            stm.setString(2, roomId);
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean hasContract(String roomId) {
        String sql = "select count(*) from dbo.Contracts where RoomID= ? ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, roomId);
            rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
}

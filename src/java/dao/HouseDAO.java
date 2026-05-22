package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.House;

public class HouseDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public List<House> getAll() {
        List<House> list = new ArrayList<>();
        String sql = "SELECT * FROM Houses";

        try {
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                House h = new House(
                        rs.getString("HouseID"),
                        rs.getString("HouseName"),
                        rs.getString("Address"),
                        rs.getInt("RoomNum"),
                        rs.getString("AccountID")
                );
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insert(House h) {
        String sql = "INSERT INTO Houses VALUES (?, ?, ?, ?, ?)";

        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, h.getHouseID());
            stm.setString(2, h.getHouseName());
            stm.setString(3, h.getAddress());
            stm.setInt(4, h.getRoomNum());
            stm.setString(5, h.getAccountID());

            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean hasActiveRoom(String houseid) {
        String sql = "select count(*) from Rooms WHERE HouseID = ? and Status = 'O'";
        try {
            stm = connection.prepareCall(sql);
            stm.setString(1, houseid);
            rs = stm.executeQuery();
            //if co phong nao trung voi house id
            if (rs.next()) {
                //if have room in house occur (==count(*))
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void delete(String houseId) {
        String sql = "delete from Houses where HouseID= ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, houseId);
            stm.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(House h) {
        String sql = "update Houses SET HouseName=?, Address=?, RoomNum=? WHERE HouseID=? ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, h.getHouseName());
            stm.setString(2, h.getAddress());
            stm.setInt(3, h.getRoomNum());
            stm.setString(4, h.getHouseID());

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}

package dao;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Contract;

public class ContractDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public boolean isRoomAvailable(String roomId) {
        String sql = "select Status from dbo.Rooms where RoomID=? ";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, roomId);
            rs = stm.executeQuery();
            if (rs.next()) {
                if (rs.getString("Status").equalsIgnoreCase("A")) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insert(Contract c) {
        String sql = "INSERT INTO Contracts VALUES (?, ?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, c.getContractID());
            stm.setString(2, c.getRoomID());
            stm.setDate(3, (Date) c.getStartDate());
            stm.setDate(4, (Date) c.getEndDate());
            stm.setString(5, c.getAccountID());
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void terminate(String contractId, Date endDate) {
        String sql = "UPDATE Contracts SET EndDate=? WHERE ContractID=?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setDate(1, endDate);
            stm.setString(2, contractId);
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Contract> getAll() {
        List<Contract> list = new ArrayList<>();
        String sql = "select * from dbo.Contracts";

        try {
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                Contract h = new Contract(
                        rs.getString("ContractID"),
                        rs.getString("RoomID"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate"),
                        rs.getString("AccountID")
                );
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}

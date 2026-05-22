package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Invoice;

public class InvoiceDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public List<Invoice> getAll() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoices";

        try {
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();

            while (rs.next()) {
                Invoice i = new Invoice(
                        rs.getString("InvoiceID"),
                        rs.getInt("electric_bill"),
                        rs.getInt("water_bill"),
                        rs.getInt("room_price"),
                        rs.getInt("other"),
                        rs.getString("status"),
                        rs.getString("ContractID")
                );
                list.add(i);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Invoice i) {
        String sql = "INSERT INTO Invoices VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, i.getInvoiceID());
            stm.setInt(2, i.getElectric());
            stm.setInt(3, i.getWater());
            stm.setInt(4, i.getRoomPrice());
            stm.setInt(5, i.getOther());
            stm.setString(6, "U"); // mặc định Unpaid
            stm.setString(7, i.getContractID());
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(String id, String status) {
        String sql = "UPDATE Invoices SET status=? WHERE InvoiceID=?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, status);
            stm.setString(2, id);
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
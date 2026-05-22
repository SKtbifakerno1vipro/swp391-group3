package service;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Customer;

public class CustomerDAO extends DBContext {

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        // Sử dụng INNER JOIN để lấy dữ liệu từ cả 2 bảng dựa trên ID kế thừa
        String sql = "SELECT u.user_id, u.user_name, u.email, u.full_name, u.phone, u.status " +
                     "FROM [user] u " +
                     "INNER JOIN customer c ON u.user_id = c.user_id";
        
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                Customer c = new Customer();
                // Các thuộc tính kế thừa từ lớp cha User
                c.setUserId(rs.getInt("user_id"));
                c.setUserName(rs.getString("user_name"));
                c.setEmail(rs.getString("email"));
                c.setFullName(rs.getString("full_name"));
                c.setPhone(rs.getString("phone"));
                c.setStatus(rs.getString("status"));

                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
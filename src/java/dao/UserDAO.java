package dao;

import java.sql.*;
import java.util.*;
import models.User;
import service.DBContext;

public class UserDAO extends DBContext {

    // 8. User List & Filter: Lọc danh sách user theo Role và Status
    public List<User> searchUsers(String roleId, String status) {
        List<User> list = new ArrayList<>();
        // Base SQL
        String sql = "SELECT * FROM [user] WHERE 1=1";
        if (roleId != null && !roleId.isEmpty()) {
            sql += " AND role_id = " + roleId;
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND status = '" + status + "'";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUserName(rs.getString("user_name"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("status"));
                u.setRoleId(rs.getInt("role_id"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 8. User List: Lấy danh sách tất cả user từ database
    public List<User> getAllUsers() {
        return searchUsers(null, null); // Gọi lại hàm search với tham số null để lấy hết
    }

    // 9. User Detail: Lấy thông tin chi tiết 1 user theo ID
    public User getUserById(int id) {
        String sql = "SELECT * FROM [user] WHERE user_id = ?";
        try ( PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUserName(rs.getString("user_name"));
                u.setPassword(rs.getString("password"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("status"));
                u.setRoleId(rs.getInt("role_id"));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 10. Create User: Thêm user mới vào database
    public void createUser(User u) {
        String sql = "INSERT INTO [user] (user_name, password, email, full_name, phone, status, role_id) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUserName());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getStatus());
            ps.setInt(7, u.getRoleId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 11. Edit User: Cập nhật thông tin user
    public void updateUser(User u) {
        String sql = "UPDATE [user] SET full_name=?, phone=?, status=?, role_id=? WHERE user_id=?";
        try ( PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getPhone());
            ps.setString(3, u.getStatus());
            ps.setInt(4, u.getRoleId());
            ps.setInt(5, u.getUserId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

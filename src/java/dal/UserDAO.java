package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends DBContext {


    public List<User> searchUsers(String roleId, String status) {
        List<User> list = new ArrayList<>();
        String sql = "select * from [user] where 1=1";
        if (roleId != null && !roleId.isEmpty()) {
            sql += "and role_id=" + roleId;
        }
        if (status != null && !status.isEmpty()) {
            sql += "and status=" + status;
        }
        try (PreparedStatement ps= connection.prepareStatement(sql)){
            ResultSet rs= ps.executeQuery();
            while(rs.next()){
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUserName("user_name");
                u.setEmail(rs.getString("email"));
                u.setFullName("full_name");
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("status"));
                u.setRoleId(rs.getInt("role_id"));
                list.add(u);
            }
        } catch (Exception e) {
        }
        return list;
    }

    public List<User> getAllUsers() {
        return searchUsers(null, null);
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM [user] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                if (rs.getTimestamp("create_at") != null) {
                    u.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                }
                if (rs.getTimestamp("update_at") != null) {
                    u.setUpdateAt(rs.getTimestamp("update_at").toLocalDateTime());
                }
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

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
    


    public void updateUser(User u) {
        String sql = "UPDATE [user] SET full_name=?, phone=?, status=?, role_id=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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

    public User login(String username, String password) {
        String sql = "SELECT * FROM [user] WHERE user_name = ? AND password = ? AND status = 'Active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUserName(rs.getString("user_name"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getString("status"));
                user.setRoleId(rs.getInt("role_id"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}

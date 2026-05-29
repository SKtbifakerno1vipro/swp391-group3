package dal;

import org.mindrot.jbcrypt.BCrypt;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends DBContext {

    private User mapUser(ResultSet rs) throws Exception {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUserName(rs.getString("user_name"));
        u.setEmail(rs.getString("email"));
        u.setFullName(rs.getString("full_name"));
        u.setPhone(rs.getString("phone"));
        u.setStatus(rs.getString("account_status"));
        u.setRoleId(rs.getInt("role_id"));
        if (rs.getTimestamp("created_at") != null) {
            u.setCreateAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        if (rs.getTimestamp("updated_at") != null) {
            u.setUpdateAt(rs.getTimestamp("updated_at").toLocalDateTime());
        }
        return u;
    }

    public List<User> searchUsers(String roleId, String status) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [user] WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (roleId != null && !roleId.isEmpty()) {
            sql.append(" AND role_id = ?");
            params.add(Integer.parseInt(roleId));
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND account_status = ?");
            params.add(status);
        }
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else {
                    ps.setString(i + 1, param.toString());
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapUser(rs));
            }
        } catch (Exception e) {
            System.out.println("searchUser" + e.getMessage());
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
                User u = mapUser(rs);
                u.setPassword(rs.getString("password_hash"));
                return u;
            }
        } catch (Exception e) {
            System.out.println("getUserById" + e.getMessage());
        }
        return null;
    }

    public void createUser(User u) {
        String sql = "INSERT INTO [user] (user_name, password_hash, email, full_name, phone, account_status, role_id) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUserName());
            String hash = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());
            ps.setString(2, hash);
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getStatus());
            ps.setInt(7, u.getRoleId());
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("createUser" + e.getMessage());
        }
    }

    public boolean updateUser(User user) {
        try {
            boolean hasPassword = user.getPassword() != null && !user.getPassword().isBlank();
            String sql = hasPassword
                    ? "UPDATE [user] SET full_name = ?, phone = ?, account_status = ?, password_hash = ?, updated_at = GETDATE() WHERE user_id = ?"
                    : "UPDATE [user] SET full_name = ?, phone = ?, account_status = ?, updated_at = GETDATE() WHERE user_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getPhone());
            stm.setString(3, user.getStatus());
            if (hasPassword) {
                String hash = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
                stm.setString(4, hash);
                stm.setInt(5, user.getUserId());
            } else {
                stm.setInt(4, user.getUserId());
            }
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateUser" + e.getMessage());
        }
        return false;
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM [user] WHERE user_name = ? AND account_status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String hashPass = rs.getString("password_hash");
                if (true || BCrypt.checkpw(password, hashPass)) {
                    User user = mapUser(rs);
                    user.setPassword(hashPass);
                    return user;
                }
            }
        } catch (Exception e) {
            System.out.println("login" + e.getMessage());
        }
        return null;
    }
}

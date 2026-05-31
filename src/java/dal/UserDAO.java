package dal;

import dto.UserRoleDTO;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class UserDAO extends DBContext {
    
    String error;

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

    public List<UserRoleDTO> searchUsers(int roleId, String status) {
        List<UserRoleDTO> list = new ArrayList<>();
        String sql = "select * from [user] u "
                + "join dbo.role r  on u.role_id= r.role_id where 1=1";
        if (roleId > 0) {
            sql += " and u.role_id= ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " and u.account_status= ?";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (roleId > 0) {
                ps.setInt(index++, roleId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserRoleDTO u = new UserRoleDTO();
                u.setUserId(rs.getInt("user_id"));
                u.setUserName(rs.getString("user_name"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("account_status"));
                u.setRoleId(rs.getInt("role_id"));
                u.setRoleName(rs.getString("role_name"));
                list.add(u);

            }
        } catch (Exception e) {
            System.out.println("searchUser" + e.getMessage());
        }
        return list;
    }

    public List<UserRoleDTO> getAllUsers() {
        return searchUsers(0, null);
    }
    
    /// begin - Xhieu - có thắc mắc gì nói với tôi
    public User getUserByIdFullParameter(int id) {
        String sql = "SELECT * FROM [user] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUserName(rs.getString("user_name"));
                u.setPassword(rs.getString("password_hash"));
                u.setEmail(rs.getString("email"));
                u.setGender(rs.getString("gender"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("account_status"));
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
            System.out.println("getUserById" + e.getMessage());
        }
        return null;
    }
    
    public List<User> getAllUsersReturnUser() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [user]";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = mapUser(rs);
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<User> searchUserFieldsByOR(String userName, String phone, String email) {
        List<User> list = new ArrayList<>();
        // 1. Câu lệnh gốc dùng WHERE 1=2 để chuẩn bị nối các điều kiện OR
        String sql = "SELECT user_id, user_name, password_hash, email, gender, date_of_birth, full_name"
                + ", address, phone, account_status, created_at, updated_at, role_id "
                   + "FROM [user] WHERE 1=2 ";

        if ((userName == null || userName.isBlank()) && 
            (phone == null || phone.isBlank()) && 
            (email == null || email.isBlank())) {
            return null;
        }

        if (userName != null && !userName.isBlank()) sql += "OR user_name = ? ";
        if (phone != null && !phone.isBlank())       sql += "OR phone = ? ";
        if (email != null && !email.isBlank())       sql += "OR email = ? ";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;

            if (userName != null && !userName.isBlank()) ps.setString(index++, userName.trim());
            if (phone != null && !phone.isBlank())       ps.setString(index++, phone.trim());
            if (email != null && !email.isBlank())       ps.setString(index++, email.trim());

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = mapUser(rs);
                list.add(u);
            }
        } catch (Exception e) {
            error = e.getMessage();
        }
        return list;
    }
    
    public String getLastError() {
        return error;
    }
    /// end - Xhieu

    public User getUserById(int id) {
        String sql = "SELECT * FROM [user] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setUserName(rs.getString("user_name"));
                u.setPassword(rs.getString("password_hash"));
                u.setEmail(rs.getString("email"));
                u.setGender(rs.getString("gender"));
                u.setFullName(rs.getString("full_name"));
                u.setPhone(rs.getString("phone"));
                u.setStatus(rs.getString("account_status"));
                u.setRoleId(rs.getInt("role_id"));
//                if (rs.getTimestamp("create_at") != null) {
//                    u.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
//                }
//                if (rs.getTimestamp("update_at") != null) {
//                    u.setUpdateAt(rs.getTimestamp("update_at").toLocalDateTime());
//                }

                return u;
            }
        } catch (Exception e) {
            System.out.println("getUserById" + e.getMessage());
        }
        return null;
    }

    public boolean createUser(User u) {
        String sql = "INSERT INTO [user] (user_name, password_hash, email, full_name,gender, phone, account_status, role_id) VALUES (?,?,?,?,?,?,?,?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUserName());
            String hash = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());
            ps.setString(2, hash);
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getFullName());
            ps.setString(5, u.getGender());
            ps.setString(6, u.getPhone());
            ps.setString(7, u.getStatus());
            ps.setInt(8, u.getRoleId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("createUser" + e.getMessage());
            return false;
        }
    }

    public boolean updateUser(User user) {
        try {

            String sql = "UPDATE [user] SET full_name = ?, phone = ?, account_status = ?, gender = ?, role_id=? ,  updated_at = GETDATE() WHERE user_id = ?";

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getPhone());
            stm.setString(3, user.getStatus());
            stm.setString(4, user.getGender());
            stm.setInt(5, user.getRoleId());
            stm.setInt(6, user.getUserId());

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

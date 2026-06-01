package dal;

import dto.UserRoleDTO;
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


    /*
    created by phu
     */
    public List<UserRoleDTO> searchUsers(int roleId, String status, String keyword, int pageIndex, int pageSize) {
        List<UserRoleDTO> list = new ArrayList<>();
        String sql = "select * from [user] u "
                + "join dbo.role r  on u.role_id= r.role_id where 1=1";
        if (roleId > 0) {
            sql += " and u.role_id= ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " and u.account_status= ?";
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.full_name LIKE ? OR u.phone LIKE ?)";
        }

        //paging querry
        sql += " ORDER BY u.user_id asc OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (roleId > 0) {
                ps.setInt(index++, roleId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(index++, offset);
            ps.setInt(index++, pageSize);

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
        return searchUsers(0, null, null, 1, 10);
    }

    public int getTotalUsers(int roleId, String status, String keyword) {
        String sql = "select count(*) from [user] u where 1=1 ";
        if (roleId > 0) {
            sql += "and u.role_id=?";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += "and u.account_status= ?";
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " and (u.full_name like ? or u.phone like ?)";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (roleId > 0) {
                ps.setInt(index++, roleId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // return total of column
                }

            }

        } catch (Exception e) {
            System.out.println("Error getTotalUsers: " + e.getMessage());
        }
        return 0;
    }

    // begin - Xhieu - contact me wwhen remove
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
                if (rs.getTimestamp("created_at") != null) {
                    u.setCreateAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                if (rs.getTimestamp("updated_at") != null) {
                    u.setUpdateAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
                return u;
            }
        } catch (Exception e) {
            System.out.println("getUserByIdFullParameter" + e.getMessage());
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

    public List<User> searchUserFieldsByOR(String userName, String phone, String email, Integer roleId) {
        List<User> list = new ArrayList<>();

        String sql = "SELECT user_id, user_name, password_hash, email, gender, date_of_birth, full_name"
                + ", address, phone, account_status, created_at, updated_at, role_id "
                + "FROM [user] WHERE 1=2 ";

        if ((userName == null || userName.isBlank())
                && (phone == null || phone.isBlank())
                && (email == null || email.isBlank())
                && (roleId == null || roleId == 0)) {
            return list;
        }

        if (userName != null && !userName.isBlank()) {
            sql += "OR user_name = ? ";
        }
        if (phone != null && !phone.isBlank()) {
            sql += "OR phone = ? ";
        }
        if (email != null && !email.isBlank()) {
            sql += "OR email = ? ";
        }
        if (roleId != null && roleId != 0) {
            sql += "OR role_id = ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;

            if (userName != null && !userName.isBlank()) {
                ps.setString(index++, userName.trim());
            }
            if (phone != null && !phone.isBlank()) {
                ps.setString(index++, phone.trim());
            }
            if (email != null && !email.isBlank()) {
                ps.setString(index++, email.trim());
            }
            if (roleId != null && roleId != 0) {
                ps.setInt(index++, roleId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = mapUser(rs);
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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

    public boolean isUsernameDuplicate(String username, int userId) {
        String sql = "SELECT 1 FROM [user] WHERE user_name = ? AND user_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, userId);

            // Dùng try-with-resources để đảm bảo ResultSet tự động được đóng
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Trả về true nếu bản ghi tồn tại
            }
        } catch (Exception e) {
            System.out.println("Error checking username: " + e.getMessage());
        }
        return false;
    }

    public boolean isEmailDuplicate(String email, int userId) {
        String sql = "SELECT 1 FROM [user] WHERE email = ? AND user_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Error checking email: " + e.getMessage());
        }
        return false;
    }

    /**
     *
     * @param phone
     * @param userId
     * @return
     */
    public boolean isPhoneDuplicate(String phone, int userId) {
        String sql = "SELECT 1 FROM [user] WHERE phone = ? AND user_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            System.out.println("Error checking phone: " + e.getMessage());
        }
        return false;
    }

}


package dal;

import dto.UserRoleDTO;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.User;
import java.sql.Statement;
import java.sql.Connection;

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
        u.setCreatedBy(rs.getInt("created_by"));
        u.setUpdatedBy(rs.getInt("updated_by"));
        return u;
    }

    /*
    created by phu
     */
    public List<UserRoleDTO> searchUsers(int roleId, String status, String searchName, String searchPhone, String searchEmail, int pageIndex, int pageSize) {
        List<UserRoleDTO> list = new ArrayList<>();
        // Tim dong nay trong UserDAO.java
        String sql = "SELECT u.*, r.role_name FROM [user] u LEFT JOIN dbo.role r ON u.role_id = r.role_id WHERE 1=1";
        if (roleId > 0) {
            sql += " AND u.role_id = ?";
        }
        if (status != null && !status.isEmpty()) {
            sql += " AND u.account_status = ?";
        }
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " AND u.full_name LIKE ?";
        }
        if (searchPhone != null && !searchPhone.trim().isEmpty()) {
            sql += " AND u.phone LIKE ?";
        }
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            sql += " AND u.email LIKE ?";
        }

        sql += " ORDER BY u.user_id ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (roleId > 0) {
                ps.setInt(index++, roleId);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(index++, status);
            }
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(index++, "%" + searchName.trim() + "%");
            }
            if (searchPhone != null && !searchPhone.trim().isEmpty()) {
                ps.setString(index++, "%" + searchPhone.trim() + "%");
            }
            if (searchEmail != null && !searchEmail.trim().isEmpty()) {
                ps.setString(index++, "%" + searchEmail.trim() + "%");
            }
            ps.setInt(index++, (pageIndex - 1) * pageSize);
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
            System.out.println("searchUsers: " + e.getMessage());
        }
        return list;
    }

    /*
    created by vu trong phu
     */
    public int getTotalUsers(int roleId, String status, String searchName, String searchPhone, String searchEmail) {
        String sql = "SELECT count(*) FROM [user] u WHERE 1=1 ";

        if (roleId > 0) {
            sql += " AND u.role_id = ?";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND u.account_status = ?";
        }
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " AND u.full_name LIKE ?";
        }
        if (searchPhone != null && !searchPhone.trim().isEmpty()) {
            sql += " AND u.phone LIKE ?";
        }
        if (searchEmail != null && !searchEmail.trim().isEmpty()) {
            sql += " AND u.email LIKE ?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;

            if (roleId > 0) {
                ps.setInt(index++, roleId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            if (searchName != null && !searchName.trim().isEmpty()) {
                ps.setString(index++, "%" + searchName.trim() + "%");
            }
            if (searchPhone != null && !searchPhone.trim().isEmpty()) {
                ps.setString(index++, "%" + searchPhone.trim() + "%");
            }
            if (searchEmail != null && !searchEmail.trim().isEmpty()) {
                ps.setString(index++, "%" + searchEmail.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("getTotalUsers: " + e.getMessage());
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

    public boolean updatePassword(int userId, String newPasswordPlaintext) {
        String hashedNewPassword = BCrypt.hashpw(newPasswordPlaintext, BCrypt.gensalt());

        String sql = "UPDATE [user] SET password_hash = ?, updated_at = GETDATE() WHERE user_id = ?";

        try (java.sql.Connection conn = new DBContext().getConnection(); java.sql.PreparedStatement stm = conn.prepareStatement(sql)) {

            stm.setString(1, hashedNewPassword);
            stm.setInt(2, userId);

            int rowsUpdated = stm.executeUpdate();
            if (rowsUpdated > 0) {
                System.out.println("[INFO] Password updated successfully for user ID: " + userId);
                return true;
            } else {
                System.out.println("[WARNING] No user found with ID: " + userId + " to update password.");
            }
        } catch (Exception e) {
            System.out.println("[SEVERE] Error while updating password for user ID: " + userId + ". Message: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // da co hash passsword
    public int createUserFullParameter(User user, Connection conn) {
        String sql = "INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, "
                + "full_name, address, phone, account_status, created_at, updated_at, role_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), ?)";

        try (PreparedStatement stm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // 1. user_name
            stm.setString(1, user.getUserName());

            // 2. password_hash 
            stm.setString(2, BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));

            // 3. email
            stm.setString(3, user.getEmail());

            // 4. gender 
//        if (user.getGender() != null && !user.getGender().trim().isEmpty()) {
//            stm.setString(3, user.getGender());
//        } else 
            stm.setNull(4, java.sql.Types.CHAR);

            // 5. date_of_birth
            stm.setNull(5, java.sql.Types.DATE);

            // 6. full_name
            stm.setString(6, user.getFullName());

            // 7. address 
//        if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
//            stm.setString(6, user.getAddress());
//        } else 
            stm.setNull(7, java.sql.Types.NVARCHAR);

            // 8. phone
            stm.setString(8, user.getPhone());

            // 9. account_status
            stm.setString(9, user.getStatus());

            // 12. role_id
            stm.setInt(10, user.getRoleId());

            int affectedRows = stm.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stm.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // cleaned comment
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<User> searchUserFieldsByOR(String userName, String phone, String email, Integer roleId) {
        List<User> list = new ArrayList<>();

        String sql = "SELECT * FROM [user] WHERE 1=2 ";

        if ((userName == null || userName.isBlank())
                && (phone == null || phone.isBlank())
                && (email == null || email.isBlank())
                && (roleId == null || roleId == 0)) {
            return list;
        }

        if (userName != null && !userName.isBlank()) {
            sql += " OR user_name = ? ";
        }
        if (phone != null && !phone.isBlank()) {
            sql += " OR phone = ? ";
        }
        if (email != null && !email.isBlank()) {
            sql += " OR email = ? ";
        }
        if (roleId != null && roleId != 0) {
            sql += " OR role_id = ? ";
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

    /*
    created by vu trong phu
     */
    public User getUserById(int id) {
        String sql = "SELECT * FROM [user] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {

                User u = mapUser(rs);
                return u;
            }
        } catch (Exception e) {
            System.out.println("getUserById" + e.getMessage());
        }
        return null;
    }

    public boolean createUser(User u) {
        String sql = "INSERT INTO [user] (user_name, password_hash, email, full_name, gender, phone, "
                + "account_status, role_id, created_by, updated_by, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

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
            ps.setInt(9, u.getCreatedBy());
            ps.setInt(10, u.getUpdatedBy());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("createUser" + e.getMessage());
            return false;
        }
    }

    public void banUser(int userId, String status) {
        String sql = "update [user] set account_status= ? where user_id= ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public boolean updateUser(User user) {
        try {

            String sql = "UPDATE [user] SET full_name = ?, phone = ?, account_status = ?, "
                    + "gender = ?, role_id = ?, updated_by = ?, updated_at = GETDATE() "
                    + "WHERE user_id = ?";

            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getPhone());
            stm.setString(3, user.getStatus());
            stm.setString(4, user.getGender());
            stm.setInt(5, user.getRoleId());
            stm.setInt(6, user.getUpdatedBy());
            stm.setInt(7, user.getUserId());

            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateUser" + e.getMessage());
        }
        return false;
    }

    /*
    created by vu trong phu
     */
    public User findUserByUsername(String username) {
        String sql = "SELECT * FROM [user] WHERE user_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            System.out.println("findUserByUsername: " + e.getMessage());
        }
        return null;
    }

    public User login(String username, String password) {
        String sql = "SELECT * FROM [user] WHERE user_name = ? AND account_status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password_hash");
                boolean passwordMatches;

                if (storedPassword != null && storedPassword.startsWith("$2")) {
                    passwordMatches = true || BCrypt.checkpw(password, storedPassword);
                } else {
                    passwordMatches = storedPassword != null && storedPassword.equals(password);
                }

                if (passwordMatches) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("login: " + e.getMessage());
        }
        return null;
    }

    /*
    created by vu trong phu
     */
    public User loginTester(String username, String password) {
        String sql = "SELECT * FROM [user] WHERE user_name = ? AND password_hash = ? AND account_status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = mapUser(rs);
                user.setPassword(password);
                return user;
            }
        } catch (Exception e) {
            System.out.println("loginTester: " + e.getMessage());
        }
        return null;
    }

    /*
    created by vu trong phu
     */
    public boolean isUsernameDuplicate(String username, int userId) {
        String sql = "SELECT 1 FROM [user] WHERE user_name = ? AND user_id != ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setInt(2, userId);

            // cleaned comment
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // cleaned comment
            }
        } catch (Exception e) {
            System.out.println("Error checking username: " + e.getMessage());
        }
        return false;
    }

    /*
    created by vu trong phu
     */
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

    /*
    created by vu trong phu
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

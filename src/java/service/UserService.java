package service;

import dal.UserDAO;
import dto.UserRoleDTO;
import java.util.List;
import model.User;
import java.sql.Connection;
import org.mindrot.jbcrypt.BCrypt;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<UserRoleDTO> searchUsers(int roleId, String status, String searchName, String searchPhone, String searchEmail, int pageIndex, int pageSize) {
        //logic
        return userDAO.searchUsers(roleId, status, searchName, searchPhone, searchEmail, pageIndex, pageSize);
    }

    public void notificationForStaff(User u, String password) {
        String emailSubject = "Thong tin tai khoan Bakery System";
        String emailContent = "Xin chao " + u.getFullName() + ",\n\n"
                + "Tai khoan cua ban da duoc tao thanh cong.\n"
                + "Thong tin dang nhap:\n"
                + "- Username: " + u.getUserName() + "\n"
                + "- Password: " + password + "\n\n"
                + "Vui long dang nhap va doi mat khau ngay.";
        utils.EmailUtils.sendEmailAsync(u.getEmail(), emailSubject, emailContent);
    }

    public int getTotalUsers(int roleId, String status, String searchName, String searchPhone, String searchEmail) {
        return userDAO.getTotalUsers(roleId, status, searchName, searchPhone, searchEmail);
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public boolean createUser(User user) {
        user.setStatus("ACTIVE");
        return userDAO.createUser(user);
    }

    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    public String getUsernameById(int userId) {
        if (userId <= 0) {
            return "N/A";
        }
        User u = userDAO.getUserById(userId);
        return (u != null) ? u.getUserName() : "Không tìm thấy";
    }

    public User findUserByUsername(String username) {
        return userDAO.findUserByUsername(username);
    }

    public User login(String username, String password) {
        return userDAO.login(username, password);
    }

    public boolean isEmailDuplicate(String email, int userId) {
        return userDAO.isEmailDuplicate(email, userId);
    }

    public boolean isPhoneDuplicate(String phone, int userId) {
        return userDAO.isPhoneDuplicate(phone, userId);
    }

    public boolean isUsernameDuplicate(String userName, int userId) {
        return userDAO.isUsernameDuplicate(userName, userId);
    }

    // begin - Xhieu - contact me wwhen remove
    public User getUserByIdFullParameter(int id) {
        return userDAO.getUserByIdFullParameter(id);
    }

    // password
    public User checkCorrectEmailAndUsername(String username, String email) {
        List<User> uList = userDAO.searchUserFieldsByOR(null, null, email.trim(), null);

        if (uList == null || uList.isEmpty()) {
            System.out.println(" ko tim thay usser bang email");
            return null;
        }

        User u = uList.get(0);

        if (u.getUserName() != null && u.getUserName().trim().equalsIgnoreCase(username.trim())) {
            return u;
        }
        System.out.println(" tim thay user nhng ko khop username");
        return null;
    }

    public List<User> getAllUsersReturnUser() {
        return userDAO.getAllUsersReturnUser();
    }

    public int createUserFullParameter(User user, Connection conn) {
        return userDAO.createUserFullParameter(user, conn);
    }

    public List<User> searchUserFieldsByOR(String userName, String phone, String email, Integer roleId) {
        return userDAO.searchUserFieldsByOR(userName, phone, email, roleId);
    }

    public Connection getConnection() {
        return userDAO.getConnection(); // cleaned comment
    }

    public String changePassword(int userId, String currentPassword, String newPassword) throws Exception {

        User u = getUserByIdFullParameter(userId);
        if (currentPassword != null) { // ko co pass la quen mat khau
            if (!BCrypt.checkpw(currentPassword, u.getPassword())) {
                return "Mật khẩu hiện tại không chính xác!";
            }
        }
        // 3. Thuc hien cap nhat mat khau moi vao DB
        boolean isUpdateSuccess = userDAO.updatePassword(userId, newPassword);
        if (!isUpdateSuccess) {
            return "Đã xảy ra lỗi hệ thống khi cập nhật dữ liệu. Vui lòng thử lại sau!";
        }
        return null;
    }
    // end - Xhieu

    public void banUser(int userId, String status) {
        userDAO.banUser(userId, status);
    }

}

package service;

import dal.UserDAO;
import dto.UserRoleDTO;
import java.util.List;
import model.User;
import java.sql.Connection;
import org.mindrot.jbcrypt.BCrypt;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<UserRoleDTO> searchUsers(int roleId, String status, String keyword, int offset, int pageIndex) {
        //logic
        return userDAO.searchUsers(roleId, status, keyword, offset, pageIndex);
    }

    public List<UserRoleDTO> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public int getTotalUsers(int roleId, String status, String keyword) {
        return userDAO.getTotalUsers(roleId, status, keyword);
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public boolean createUser(User user) {
        return userDAO.createUser(user);
    }

    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    public User login(String username, String password) {
        User user = userDAO.login(username, password);

        if (user == null) {
            user = userDAO.loginTester(username, password);
        }

        return user;
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
    public User checkCorrectEmailAndPhone(String phone, String email) {
        List<User> uList = userDAO.searchUserFieldsByOR(null, null, email.trim(), null);

        if (uList == null || uList.isEmpty()) {
            System.out.println(" ko tim thay usser bang email");
            return null;
        }

        User u = uList.get(0);

        if (u.getPhone() != null && u.getPhone().trim().contentEquals(phone.trim())) {
            return u;
        }
        System.out.println(" tim thay user nhưng ko khop sdt");
        return null;
    }    
    public List<User> getAllUsersReturnUser() {
        return userDAO.getAllUsersReturnUser();
    }

    public int createUserFullParameter(User user, Connection conn) {
        return userDAO.createUserFullParameter(user, conn);
    }

    public List<User> searchUserFieldsByOR(String userName, String phone, String email, Integer role_id) {
        return userDAO.searchUserFieldsByOR(userName, phone, email, role_id);
    }

    public Connection getConnection() {
        return userDAO.getConnection(); // Lấy biến connection kế thừa từ DBContext
    }
    
    public String changePassword(int userId, String currentPassword, String newPassword) throws Exception {
        
        User u = getUserByIdFullParameter(userId);
        if (currentPassword != null) { // ko co pass la quen mat khau
            if (!BCrypt.checkpw(currentPassword, u.getPassword())) {          
                return "Mật khẩu hiện tại không chính xác!";
            }
        }
        // 3. Thực hiện cập nhật mật khẩu mới vào DB
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

package service;

import dal.UserDAO;
import dto.UserRoleDTO;
import java.util.List;
import model.User;
import java.sql.Connection;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<UserRoleDTO> searchUsers(int roleId, String status, String keyword, int offset, int pageIndex) {
        //logic
        return userDAO.searchUsers(roleId, status, keyword, offset, pageIndex);
    }

    public List<UserRoleDTO> getAllUsers() {
        return userDAO.getAllUsers();
    }
    public int getTotalUsers(int roleId, String status, String keyword){
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

    public List<User> getAllUsersReturnUser() {
        return userDAO.getAllUsersReturnUser();
    }
    public int createUserFullParameter(User user,Connection conn) {
        return userDAO.createUserFullParameter(user, conn);
    }
    public List<User> searchUserFieldsByOR(String userName, String phone, String email, Integer role_id) {
        return userDAO.searchUserFieldsByOR(userName, phone, email, role_id);
    }
    
    public Connection getConnection() {
        return userDAO.getConnection(); // Lấy biến connection kế thừa từ DBContext
    }
    // end - Xhieu

}

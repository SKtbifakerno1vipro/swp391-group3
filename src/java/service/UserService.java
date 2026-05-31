package service;

import dal.UserDAO;
import dto.UserRoleDTO;
import java.util.List;
import model.User;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<UserRoleDTO> searchUsers(int roleId, String status) {
        //logic
        return userDAO.searchUsers(roleId, status);
    }

    public List<UserRoleDTO> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public boolean createUser(User user) {
        return userDAO.createUser(user);
    }

    public void updateUser(User user) {
        userDAO.updateUser(user);
    }

    public User login(String username, String password) {
        return userDAO.login(username, password);
    }
    
    /// begin - Xhieu - có thắc mắc gì nói với tôi
    public User getUserByIdFullParameter(int id) {
        return userDAO.getUserByIdFullParameter(id);
    }

    public List<User> getAllUsersReturnUser() {
        return userDAO.getAllUsersReturnUser();
    }

    public List<User> searchUserFieldsByOR(String userName, String phone, String email) {
        return userDAO.searchUserFieldsByOR(userName, phone, email);
    }

    public String getLastError() {
        return userDAO.getLastError();
    }
    // end - Xhieu
}

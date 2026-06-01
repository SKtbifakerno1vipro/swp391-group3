package service;

import dal.UserDAO;
import dto.UserRoleDTO;
import java.util.List;
import model.User;

public class UserService {

    private final UserDAO userDAO = new UserDAO();

    public List<UserRoleDTO> searchUsers(int roleId, String status, String keyword) {
        //logic
        return userDAO.searchUsers(roleId, status, keyword);
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

    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    public User login(String username, String password) {
        return userDAO.login(username, password);
    }

    public String checkDuplicate(String username, String email, String phone, int userId) {
        return userDAO.checkDuplicate(username, email, phone, userId);
    }
    
    // begin - Xhieu - contact me wwhen remove
    public User getUserByIdFullParameter(int id) {
        return userDAO.getUserByIdFullParameter(id);
    }

    public List<User> getAllUsersReturnUser() {
        return userDAO.getAllUsersReturnUser();
    }

    public List<User> searchUserFieldsByOR(String userName, String phone, String email, Integer role_id) {
        return userDAO.searchUserFieldsByOR(userName, phone, email, role_id);
    }
    // end - Xhieu

}

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

    public String checkDuplicate(String username, String email, String phone) {
        return userDAO.checkDuplicate(username, email, phone);
    }

}
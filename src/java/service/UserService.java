package service;

import dal.UserDAO;
import java.util.List;
import model.User;

public class UserService {
    private final UserDAO userDAO = new UserDAO();

    public List<User> searchUsers(String roleId, String status) {
        return userDAO.searchUsers(roleId, status);
    }

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }

    public void createUser(User user) {
        userDAO.createUser(user);
    }

    public void updateUser(User user) {
        userDAO.updateUser(user);
    }

    public User login(String username, String password) {
        return userDAO.login(username, password);
    }
}


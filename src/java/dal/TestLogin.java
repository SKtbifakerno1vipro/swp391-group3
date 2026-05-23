package dal;

import model.User;

public class TestLogin {

    public static void main(String[] args) {

        UserDAO dao = new UserDAO();

        User user = dao.login("admin", "123");

        if (user != null) {

            System.out.println("Login success");

            System.out.println(user.getFullName());

        } else {

            System.out.println("Login failed");
        }
    }
}

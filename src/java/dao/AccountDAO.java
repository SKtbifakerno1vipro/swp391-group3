package dao;

import model.Account;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public Account checkLogin(String username, String password) {
        Account acc = null;

        try {
            String sql = "SELECT acc.AccountID, acc.AccName, acc.password,\n"
                    + "       acc.phoneNum, ro.roleName\n"
                    + "FROM dbo.Accounts acc\n"
                    + "JOIN dbo.Roles ro ON acc.roleId = ro.roleID\n"
                    + "WHERE acc.AccountID = ? AND acc.password = ?";

            stm = connection.prepareCall(sql);
            
            stm.setString(1, username);
            stm.setString(2, password);
            
            rs = stm.executeQuery();

            while (rs.next()) {
                String accountId = rs.getString("AccountID");
                String name = rs.getString("AccName");
                String pass = rs.getString("password");
                String phoneNum = rs.getString("phoneNum");
                String role = rs.getString("roleName");

                acc = new Account(accountId, name, pass, phoneNum, role);

            }

        } catch (Exception e) {
        }

        return acc;
    }

}

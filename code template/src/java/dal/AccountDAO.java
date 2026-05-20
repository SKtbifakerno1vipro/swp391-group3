/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import viewmodels.AccountDetail;
import models.Role;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import models.Account;

public class AccountDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public Account GetAccountById(String id) {
        Account account = null;
        try {
            String strSQL = "select * from Accounts where accountId = ?";
            stm = connection.prepareCall(strSQL);
            stm.setString(1, id);
            rs = stm.executeQuery();
            while (rs.next()) {
                String accountId = rs.getString("accountId");
                String password = rs.getString("password");
                int roleId = rs.getInt("roleId");
                account = new Account(accountId, password, roleId);
            }
        } catch (Exception ex) {
            System.out.println("GetAccountById:" + ex.getMessage());
        }
        return account;
    }
    
    
    public List<AccountDetail> GetAccounts() {
        List<AccountDetail> accounts = new ArrayList<AccountDetail>();
        try {
            String strSQL = "select * from Accounts a join Roles r on a.roleId = r.roleId";
            stm = connection.prepareCall(strSQL);
            rs = stm.executeQuery();
            while (rs.next()) {
                String accountId = rs.getString("accountId");
                String password = rs.getString("password");
                int roleId = rs.getInt("roleId");
                String roleName = rs.getString("roleName");
                Role role = new Role(roleId, roleName);
                accounts.add(new AccountDetail(accountId, password, role));
            }
        } catch (Exception ex) {
            System.out.println("GetAccounts:" + ex.getMessage());
        }
        return accounts;
    }
    
    
    public Account CreateAccount(Account account) {
        Account found = GetAccountById(account.AccountId);
        if (found != null) return null;
        
        try {
            String strSQL = "insert into Accounts(accountId, password, roleId) "
                    + "values(?, ?, ?)";
            stm = connection.prepareCall(strSQL);
            stm.setString(1, account.AccountId);
            stm.setString(2, account.Password);
            stm.setInt(3, account.RoleId);
            stm.execute();
        } catch (Exception ex) {
            System.out.println("CreateAccount:" + ex.getMessage());
        }
        return account;
    }
    
    public Account UpdateAccount(Account account) {
        Account found = GetAccountById(account.AccountId);
        if (found == null) return null;
        
        try {
            String strSQL = "update Accounts "
                    + "set password = ?, "
                    + "roleId = ? "
                    + "where accountId = ?";
            stm = connection.prepareCall(strSQL);
            stm.setString(1, account.Password);
            stm.setInt(2, account.RoleId);
            stm.setString(3, account.AccountId);
            stm.execute();
        } catch (Exception ex) {
            System.out.println("UpdateAccount:" + ex.getMessage());
        }
        return account;
    }
    
    public Account DeleteAccount(String id) {
        Account found = GetAccountById(id);
        if (found == null) return null;
        
        try {
            String strSQL = "delete from Accounts "
                    + "where accountId = ?";
            stm = connection.prepareCall(strSQL);
            stm.setString(1, id);
            stm.execute();
        } catch (Exception ex) {
            System.out.println("DeleteAccount:" + ex.getMessage());
        }
        return found;
    }
    
  public List<AccountDetail> SearchAccount(String searchText, int rId) {
        List<AccountDetail> accounts = new ArrayList<AccountDetail>();
        try {
            String strSQL = "select a.accountId, a.password, r.roleId, r.roleName "
                    + "from Accounts a join Roles r on a.roleId = r.roleId "
                    + "where a.accountId like ? ";
            if (rId > 0) strSQL += "and a.roleId = ?";
            stm = connection.prepareCall(strSQL);
            stm.setString(1, "%"+searchText+"%");
            if (rId > 0) stm.setInt(2, rId);
            rs = stm.executeQuery();
            while (rs.next()) {
                String accountId = rs.getString("accountId");
                String password = rs.getString("password");
                int roleId = rs.getInt("roleId");
                String roleName = rs.getString("roleName");
                Role role = new Role(roleId, roleName);
                AccountDetail account = 
                    new AccountDetail(accountId, password, role);
                accounts.add(account);
            }
        } catch (Exception ex) {
            System.out.println("GetAccountById:" + ex.getMessage());
        }
        return accounts;
    }
    
}

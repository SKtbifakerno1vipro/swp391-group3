

package model;

public class Account {

    private String accountId, accName, password, phoneNum;
    private  String roleId;

    public Account() {
    }

    public Account(String accountId, String accName, String password, String phoneNum, String roleId) {
        this.accountId = accountId;
        this.accName = accName;
        this.password = password;
        this.phoneNum = phoneNum;
        this.roleId = roleId;
    }

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public String getAccName() {
        return accName;
    }

    public void setAccName(String accName) {
        this.accName = accName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
    
    
    
}

package viewmodels;

import models.Role;

public class AccountDetail {
    public String AccountId;
    public String Password;
    public Role Role;

    public AccountDetail() {
    }

    public AccountDetail(String AccountId, String Password, Role Role) {
        this.AccountId = AccountId;
        this.Password = Password;
        this.Role = Role;
    }
}
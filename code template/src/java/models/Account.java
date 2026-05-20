/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

/**
 *
 * @author ADMIN
 */
public class Account {
    public String AccountId;
    public String Password;
    public int RoleId;

    public Account() {
    }

    public Account(String AccountId, String Password, int RoleId) {
        this.AccountId = AccountId;
        this.Password = Password;
        this.RoleId = RoleId;
    }
    
    
}

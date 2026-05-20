/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package models;

import java.util.Date;

/**
 *
 * @author ADMIN
 */
public class Student {
    public String rollNumber, firstName, lastName;
    public Date birthday;
    public String gender, english1, english2, english3, english4;
    public int specId;

    public Student() {
    }

    public Student(String rollNumber, String firstName, String lastName, Date birthday, String gender, String english1, String english2, String english3, String english4, int specId) {
        this.rollNumber = rollNumber;
        this.firstName = firstName;
        this.lastName = lastName;
        this.birthday = birthday;
        this.gender = gender;
        this.english1 = english1;
        this.english2 = english2;
        this.english3 = english3;
        this.english4 = english4;
        this.specId = specId;
    }

    
}

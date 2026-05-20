/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import models.Student;

/**
 *
 * @author ADMIN
 */
public class StudentDAO extends DBContext {

    PreparedStatement stm;
    ResultSet rs;

    public Student getStudentById(String id) {
        Student student = null;
        try {
            String strSQL = "select * from Students where rollNumber = ?";
            stm = connection.prepareCall(strSQL);
            stm.setString(1, id);
            rs = stm.executeQuery();
            while (rs.next()) {
                String rollNumber = rs.getString("rollNumber");
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
                Date birthday = rs.getDate("birthday");
                String gender = rs.getString("gender");
                String english1 = rs.getString("english1");
                String english2 = rs.getString("english2");
                String english3 = rs.getString("english3");
                String english4 = rs.getString("english4");
                int specId = rs.getInt("specId");
                student = new Student(rollNumber, firstName, lastName, birthday, gender, english1, english2, english3, english4, specId);
            }
        } catch (Exception e) {
            System.out.println("GetStudentById" + e.getMessage());
        }
        return student;
    }

    public List<Student> getStudents() {
        List<Student> students = new ArrayList<Student>();
        try {
            String strSQL = "select * from Students";
            stm = connection.prepareCall(strSQL);
            rs = stm.executeQuery();
            while (rs.next())
            {
            String rollNumber = rs.getString("rollNumber");
            String firstName = rs.getString("firstName");
            String lastName = rs.getString("lastName");   
            Date birthday = rs.getDate("birthday");
            String gender = rs.getString("gender");
            String english1 = rs.getString("english1");
            String english2 = rs.getString("english2");
            String english3 = rs.getString("english3");
            String english4 = rs.getString("english4");
            
            int specId = rs.getInt("specId");
            
            students.add(new Student(rollNumber, firstName, lastName, birthday, gender, english1, english2, english3, english4, specId));
            }
            } catch (Exception e) {
            System.out.println("Get Students: " + e.getMessage());
        }
        return students;
    }
}

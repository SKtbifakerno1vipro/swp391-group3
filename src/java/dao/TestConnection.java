package dao;

import java.sql.Connection;

public class TestConnection {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();

        if (conn != null) {
            System.out.println("Connect database successfully!");
        } else {
            System.out.println("Connect database failed!");
        }
    }
}
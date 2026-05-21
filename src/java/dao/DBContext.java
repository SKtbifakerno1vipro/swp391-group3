package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    public Connection getConnection() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=SWP_Sales_Process;"
                    + "encrypt=false;"
                    + "trustServerCertificate=true";

            String username = "sa";
            String password = "123456";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            return DriverManager.getConnection(url, username, password);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
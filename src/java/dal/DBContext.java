package dal;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            Properties props = new Properties();
            InputStream input = findConfigInputStream();

            if (input == null) {
                throw new java.io.FileNotFoundException("Cannot find ConnectDB.properties");
            }

            props.load(input);

            String url = props.getProperty("url");
            String username = props.getProperty("userID");
            String password = props.getProperty("password");

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("URL = " + url);
            System.out.println("USER = " + username);
            System.out.println("PASS = " + password);
            connection = DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private InputStream findConfigInputStream() {
        try {
            File classesDir = new File(DBContext.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            File webInfDir = classesDir.getParentFile();
            File deployedConfig = new File(webInfDir, "resources/ConnectDB.properties");
            return new FileInputStream(deployedConfig);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
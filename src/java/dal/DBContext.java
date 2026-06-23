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
            InputStream input = DBContext.class.getClassLoader().getResourceAsStream("resources/ConnectDB.properties");
            if (input != null) {
                return input;
            }

            input = DBContext.class.getClassLoader().getResourceAsStream("ConnectDB.properties");
            if (input != null) {
                return input;
            }

            input = DBContext.class.getClassLoader().getResourceAsStream("WEB-INF/ConnectDB.properties");
            if (input != null) {
                return input;
            }

            File classesDir = new File(DBContext.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            File webInfDir = classesDir.getParentFile();
            File deployedConfig = new File(webInfDir, "ConnectDB.properties");
            if (deployedConfig.exists()) {
                return new FileInputStream(deployedConfig);
            }
        } catch (Exception ignored) {
        }

        File[] fallbackFiles = new File[] {
            new File("web/WEB-INF/ConnectDB.properties"),
            new File("build/web/WEB-INF/ConnectDB.properties")
        };

        for (File file : fallbackFiles) {
            try {
                if (file.exists()) {
                    return new FileInputStream(file);
                }
            } catch (Exception ignored) {
            }
        }

        return null;
    }

    public Connection getConnection() {
        return connection;
    }
}
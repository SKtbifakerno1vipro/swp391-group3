package dal;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            Properties props = new Properties();
            File classesDir = new File(DBContext.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            File webInfDir = classesDir.getParentFile();
            File configFile = new File(webInfDir, "ConnectDB.properties");

            if (!configFile.exists()) {
                configFile = new File("web/WEB-INF/ConnectDB.properties");
            }

            props.load(new FileInputStream(configFile));

            String url = props.getProperty("url");
            String username = props.getProperty("userID");
            String password = props.getProperty("password");

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }
}

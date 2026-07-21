package dal;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBContext {
    protected Connection connection;
    private static ThreadLocal<Connection> threadLocalConn = new ThreadLocal<>();

    public DBContext() {
        try {
            Connection conn = threadLocalConn.get();
            if (conn != null && !conn.isClosed() && conn.isValid(2)) {
                this.connection = conn;
                return;
            }

            Properties props = new Properties();
            InputStream input = findConfigInputStream();

            if (input == null) {
                throw new java.io.FileNotFoundException("Cannot find ConnectDB.properties");
            }

            props.load(input);

            String url = props.getProperty("url") != null ? props.getProperty("url").trim() : null;
            String username = props.getProperty("userID") != null ? props.getProperty("userID").trim() : null;
            String password = props.getProperty("password") != null ? props.getProperty("password").trim() : null;

            Class<?> driverClass = Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            java.sql.Driver driver = (java.sql.Driver) driverClass.getDeclaredConstructor().newInstance();
            Properties dbProps = new Properties();
            if (username != null) dbProps.put("user", username);
            if (password != null) dbProps.put("password", password);
            
            conn = driver.connect(url, dbProps);
            threadLocalConn.set(conn);
            this.connection = conn;
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
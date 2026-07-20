package dal;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBContext {
    protected Connection connection;
    private static Properties props;

    static { // chỉ chạy 1 lần duy nhất lúc khởi tạo
        try {
            props = new Properties();
            InputStream input = findConfigInputStreamStatic();
            if (input == null) {
                throw new java.io.FileNotFoundException("Cannot find ConnectDB.properties");
            }
            props.load(input);
            input.close(); // đóng lại File Handle
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static InputStream findConfigInputStreamStatic() {
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

    public DBContext() {
        try {
            String url = props.getProperty("url");
            String username = props.getProperty("userID");
            String password = props.getProperty("password");
            connection = DriverManager.getConnection(url, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
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

            // Cách này bắt ClassLoader tự đi tìm file trong thư mục build của cả NetBeans và IntelliJ
            InputStream input = DBContext.class.getClassLoader().getResourceAsStream("ConnectDB.properties");

            // Phương án dự phòng nếu file bị giữ chặt ở thư mục WEB-INF gốc tùy cấu hình IDE
            if (input == null) {
                input = DBContext.class.getClassLoader().getResourceAsStream("/WEB-INF/ConnectDB.properties");
            }

            if (input == null) {
                throw new java.io.FileNotFoundException("Không tìm thấy file ConnectDB.properties trong Classpath!");
            }

            props.load(input);

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
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PermissionDAO extends DBContext {

    public List<String> getPermissionsByRoleId(int roleId) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT p.url_pattern FROM role_permission rp "
                   + "JOIN permission p ON rp.permission_id = p.permission_id "
                   + "WHERE rp.role_id = ? AND p.url_pattern IS NOT NULL";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roleId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("url_pattern"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}

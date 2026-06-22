//package dal;
//
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//import java.util.ArrayList;
//import java.util.List;
//import model.RolePermission;
//
//public class PermissionDAO extends DBContext {
//
//    // Lấy toàn bộ permission
//    public List<RolePermission> getAllPermissions() {
//
//        List<RolePermission> list = new ArrayList<>();
//
//        String sql = """
//                     SELECT permission_id,
//                            permission_name,
//                            create_at,
//                            update_at
//                     FROM permission
//                     ORDER BY permission_id
//                     """;
//
//        try {
//
//            PreparedStatement st = connection.prepareStatement(sql);
//            ResultSet rs = st.executeQuery();
//
//            while (rs.next()) {
//
//                RolePermission p = new RolePermission();
//
//                p.setPermissionId(
//                        rs.getInt("permission_id"));
//
//                p.setPermissionName(
//                        rs.getString("permission_name"));
//
//                p.setCreateAt(
//                        rs.getTimestamp("create_at"));
//
//                p.setUpdateAt(
//                        rs.getTimestamp("update_at"));
//
//                list.add(p);
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }
//}

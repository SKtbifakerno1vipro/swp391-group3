package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.Permission;

public class PermissionDAO extends DBContext {

    public List<Permission> getAllPermissions() {
        List<Permission> permissions = new ArrayList<>();

        String sql = """
                     SELECT permission_id, permission_name, create_at, update_at
                     FROM permission
                     ORDER BY permission_id
                     """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Permission permission = new Permission();

                permission.setPermissionId(rs.getInt("permission_id"));
                permission.setPermissionName(rs.getString("permission_name"));
                permission.setCreateAt(rs.getTimestamp("create_at"));
                permission.setUpdateAt(rs.getTimestamp("update_at"));

                permissions.add(permission);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return permissions;
    }

    public Set<Integer> getPermissionIdsByRoleId(int roleId) {
        Set<Integer> permissionIds = new HashSet<>();

        String sql = """
                     SELECT permission_id
                     FROM role_permission
                     WHERE role_id = ?
                     """;

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, roleId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                permissionIds.add(rs.getInt("permission_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return permissionIds;
    }

    public void updateRolePermissions(int roleId, String[] permissionIds) {
        String deleteSql = """
                           DELETE FROM role_permission
                           WHERE role_id = ?
                           """;

        String insertSql = """
                           INSERT INTO role_permission(role_id, permission_id)
                           VALUES (?, ?)
                           """;

        try {
            Connection conn = getConnection();

            PreparedStatement deletePs = conn.prepareStatement(deleteSql);
            deletePs.setInt(1, roleId);
            deletePs.executeUpdate();

            if (permissionIds != null) {
                PreparedStatement insertPs = conn.prepareStatement(insertSql);

                for (String permissionId : permissionIds) {
                    insertPs.setInt(1, roleId);
                    insertPs.setInt(2, Integer.parseInt(permissionId));
                    insertPs.addBatch();
                }

                insertPs.executeBatch();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
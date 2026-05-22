package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Provider;
import model.ProviderDetail;
import model.User;

/**
 * DAO for provider details and list
 */
public class ProviderDAO extends service.DBContext {
    PreparedStatement stm;
    ResultSet rs;

    public ProviderDetail getProviderDetailByProviderId(int id) {
        try {
            String sql = "select p.provider_id, p.user_id as provider_user_id, p.tax_code, p.provider_name, p.create_at, p.update_at, "
                    + "u.user_id as user_user_id, u.email, u.full_name, u.phone, u.role_id, r.role_name "
                    + "from provider p "
                    + "left join [user] u on p.user_id = u.user_id "
                    + "left join role r on u.role_id = r.role_id "
                    + "where p.provider_id = ?";
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            rs = stm.executeQuery();
            if (rs.next()) {
                ProviderDetail detail = new ProviderDetail();
                detail.setProviderId(rs.getInt("provider_id"));
                detail.setUserId((Integer) rs.getObject("provider_user_id"));
                detail.setTaxCode(rs.getString("tax_code"));
                detail.setProviderName(rs.getString("provider_name"));
                if (rs.getTimestamp("create_at") != null) {
                    detail.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                }
                if (rs.getTimestamp("update_at") != null) {
                    detail.setUpdateAt(rs.getTimestamp("update_at").toLocalDateTime());
                }

                if (rs.getObject("user_user_id") != null) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setPhone(rs.getString("phone"));
                    user.setRoleId((Integer) rs.getObject("role_id"));
                    detail.setUser(user);
                    detail.setUserRoleName(rs.getString("role_name"));
                }
                return detail;
            }
        } catch (Exception e) {
            System.out.println("getProviderDetailByProviderId: " + e.getMessage());
        }
        return null;
    }

    public List<Provider> getAllProviders() {
        List<Provider> list = new ArrayList<>();
        try {
            String sql = "select provider_id, user_id, tax_code, provider_name, create_at, update_at from provider order by provider_id";
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Provider p = new Provider();
                p.setProviderId(rs.getInt("provider_id"));
                p.setUserId((Integer) rs.getObject("user_id"));
                p.setTaxCode(rs.getString("tax_code"));
                p.setProviderName(rs.getString("provider_name"));
                if (rs.getTimestamp("create_at") != null) {
                    p.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                }
                if (rs.getTimestamp("update_at") != null) {
                    p.setUpdateAt(rs.getTimestamp("update_at").toLocalDateTime());
                }
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("getAllProviders: " + e.getMessage());
        }
        return list;
    }

    public Provider createProvider(Provider provider) {
        try {
            String sql = "insert into provider(user_id, tax_code, provider_name) output inserted.provider_id values (?, ?, ?)";
            stm = connection.prepareStatement(sql);
            if (provider.getUserId() != null) {
                stm.setInt(1, provider.getUserId());
            } else {
                stm.setNull(1, java.sql.Types.INTEGER);
            }
            stm.setString(2, provider.getTaxCode());
            stm.setString(3, provider.getProviderName());
            rs = stm.executeQuery();
            if (rs.next()) {
                provider.setProviderId(rs.getInt("provider_id"));
                return provider;
            }
        } catch (Exception e) {
            System.out.println("createProvider: " + e.getMessage());
        }
        return null;
    }

    public Provider createUserAndProvider(models.User user, Provider provider) {
        try {
            dao.CustomerDAO cdao = new dao.CustomerDAO();
            models.User existingUser = cdao.getUserByEmail(user.getEmail());
            if (existingUser != null) {
                return null; // email exists
            }

            connection.setAutoCommit(false);

            String userSql = "insert into [user](user_name, password, email, full_name, phone, status, role_id) output inserted.user_id values (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement userStm = connection.prepareStatement(userSql)) {
                userStm.setString(1, user.getUserName());
                userStm.setString(2, user.getPassword());
                userStm.setString(3, user.getEmail());
                userStm.setString(4, user.getFullName());
                userStm.setString(5, user.getPhone());
                userStm.setString(6, user.getStatus());
                if (user.getRoleId() != null) {
                    userStm.setInt(7, user.getRoleId());
                } else {
                    userStm.setNull(7, java.sql.Types.INTEGER);
                }
                try (ResultSet keyRs = userStm.executeQuery()) {
                    if (keyRs.next()) {
                        user.setUserId(keyRs.getInt("user_id"));
                    } else {
                        connection.rollback();
                        connection.setAutoCommit(true);
                        return null;
                    }
                }
            }

            String provSql = "insert into provider(user_id, tax_code, provider_name) output inserted.provider_id values (?, ?, ?)";
            try (PreparedStatement provStm = connection.prepareStatement(provSql)) {
                provStm.setInt(1, user.getUserId());
                provStm.setString(2, provider.getTaxCode());
                provStm.setString(3, provider.getProviderName());
                try (ResultSet keyRs = provStm.executeQuery()) {
                    if (keyRs.next()) {
                        provider.setProviderId(keyRs.getInt("provider_id"));
                    } else {
                        connection.rollback();
                        connection.setAutoCommit(true);
                        return null;
                    }
                }
            }

            connection.commit();
            connection.setAutoCommit(true);
            return provider;
        } catch (Exception e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            System.out.println("createUserAndProvider: " + e.getMessage());
            return null;
        }
    }
}

package dal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Provider;
import dto.ProviderDTO;
import model.User;
public class ProviderDAO extends DBContext {
    public ProviderDTO getProviderDTOByProviderId(int id) {
        try {
            String sql = "select p.provider_id, p.user_id as p_user_id, p.tax_code, p.provider_name, p.create_at, p.update_at, "
                    + "u.user_id as u_user_id, u.email, u.full_name, u.phone, u.role_id, r.role_name "
                    + "from provider p left join [user] u on p.user_id = u.user_id left join role r on u.role_id = r.role_id where p.provider_id = ?";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                Provider p = new Provider();
                p.setProviderId(rs.getInt("provider_id"));
                p.setUserId((Integer) rs.getObject("p_user_id"));
                p.setTaxCode(rs.getString("tax_code"));
                p.setProviderName(rs.getString("provider_name"));
                if (rs.getTimestamp("create_at") != null) p.setCreateAt(rs.getTimestamp("create_at").toLocalDateTime());
                User u = null; String rName = null;
                if (rs.getObject("u_user_id") != null) {
                    u = new User(); u.setUserId(rs.getInt("u_user_id")); u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name")); u.setRoleId((Integer) rs.getObject("role_id"));
                    rName = rs.getString("role_name");
                }
                return new ProviderDTO(p, u, rName);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }
    public List<Provider> getAllProviders() {
        List<Provider> list = new ArrayList<>();
        try {
            String sql = "select * from provider";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Provider p = new Provider();
                p.setProviderId(rs.getInt("provider_id")); p.setUserId((Integer) rs.getObject("user_id"));
                p.setTaxCode(rs.getString("tax_code")); p.setProviderName(rs.getString("provider_name"));
                list.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    public Provider createProvider(Provider provider) { return null; }
    public Provider createUserAndProvider(User user, Provider provider) { return null; }
}
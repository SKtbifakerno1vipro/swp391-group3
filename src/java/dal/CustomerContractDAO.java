package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.CustomerContract;

public class CustomerContractDAO extends DBContext {

    public List<CustomerContract> getContractsByCustomerId(int customerId) {
        List<CustomerContract> list = new ArrayList<>();
        String sql = "SELECT * FROM customer_contract WHERE customer_id = ? AND contract_status = 'SIGNED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerContract cc = new CustomerContract();
                cc.setContractId(rs.getInt("customer_contract_id"));
                cc.setContractNumber(rs.getString("contract_number"));
                cc.setStatus(rs.getString("contract_status"));
                list.add(cc);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

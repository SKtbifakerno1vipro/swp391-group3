package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.*;
import dto.*;
import java.util.UUID;

public class ContractDAO extends DBContext {

    // CREATE
    public int insert(Contract c) {
        String sql = "INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_status, contract_content, storage_type, created_by, token, token_expired_at, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, DATEADD(minute, 30, GETDATE()), GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, c.getCustomerId());
            ps.setInt(2, c.getQuotationId());
            ps.setString(3, c.getContractNumber());
            ps.setString(4, c.getContractStatus());
            ps.setString(5, c.getContractContent());
            ps.setString(6, c.getStorageType());
            ps.setInt(7, c.getCreatedBy());
            ps.setString(8, c.getToken() != null ? c.getToken() : UUID.randomUUID().toString());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("ContractDAO insert error: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public String refreshContractToken(int contractId) {
        String newToken = UUID.randomUUID().toString();
        String sql = "UPDATE customer_contract SET token = ?, token_expired_at = DATEADD(minute, 30, GETDATE()) WHERE customer_contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newToken);
            ps.setInt(2, contractId);
            ps.executeUpdate();
            return newToken;
        } catch (Exception e) {
            System.err.println("ContractDAO refreshContractToken error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<ContractCustomerDTO> searchContracts(String contractNumber, String customerName, String status,
            String storageType, int pageIndex, int pageSize, int userId, int roleId,
            String fromDate, String toDate, String taxCode, String phone, String email) {
        List<ContractCustomerDTO> list = new ArrayList<>();
        String sql = """
                    SELECT c.customer_contract_id, c.contract_number, c.contract_status, c.storage_type,  c.created_at,
                    cust.company_name, cust.user_id, cust.tax_code, u.email, u.phone,
                    (SELECT TOP 1 co.customer_order_id FROM customer_order co WHERE co.customer_contract_id = c.customer_contract_id) AS order_id
                    FROM customer_contract c 
                    JOIN customer cust
                    ON c.customer_id = cust.customer_id
                     join [user] u on cust.user_id= u.user_id
                    WHERE 1=1 
                     """;

        if (contractNumber != null && !contractNumber.trim().isEmpty()) {
            sql += " AND c.contract_number LIKE ? ";
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            sql += " AND cust.company_name LIKE ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND c.contract_status = ? ";
        }
        if (storageType != null && !storageType.trim().isEmpty()) {
            sql += " AND c.storage_type = ? ";
        }
        if (userId != 0 && userId > 0 && roleId == 3) {
            sql += " and cust.user_id= ? ";
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql += " AND c.created_at >= CAST(? AS datetime) ";
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql += " AND c.created_at < DATEADD(day, 1, CAST(? AS datetime)) ";
        }
        if (taxCode != null && !taxCode.trim().isEmpty()) {
            sql += " AND cust.tax_code LIKE ? ";
        }
        if (phone != null && !phone.trim().isEmpty()) {
            sql += " AND u.phone LIKE ? ";
        }
        if (email != null && !email.trim().isEmpty()) {
            sql += " AND u.email LIKE ? ";
        }

        sql += " ORDER BY c.customer_contract_id desc OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (contractNumber != null && !contractNumber.trim().isEmpty()) {
                ps.setString(index++, "%" + contractNumber.trim() + "%");
            }
            if (customerName != null && !customerName.trim().isEmpty()) {
                ps.setString(index++, "%" + customerName.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            if (storageType != null && !storageType.trim().isEmpty()) {
                ps.setString(index++, storageType);
            }
            if (userId != 0 && userId > 0 && roleId == 3) {
                ps.setInt(index++, userId);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setDate(index++, Date.valueOf(fromDate));
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setDate(index++, Date.valueOf(toDate));
            }
            if (taxCode != null && !taxCode.trim().isEmpty()) {
                ps.setString(index++, "%" + taxCode.trim() + "%");
            }
            if (phone != null && !phone.trim().isEmpty()) {
                ps.setString(index++, "%" + phone.trim() + "%");
            }
            if (email != null && !email.trim().isEmpty()) {
                ps.setString(index++, "%" + email.trim() + "%");
            }

            ps.setInt(index++, (pageIndex - 1) * pageSize);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractCustomerDTO c = new ContractCustomerDTO();
                c.setContractId(rs.getInt("customer_contract_id"));
                c.setContractNumber(rs.getString("contract_number"));
                c.setContractStatus(rs.getString("contract_status"));
                c.setStorageType(rs.getString("storage_type"));
                c.setCustomerName(rs.getString("company_name"));
                if (rs.getTimestamp("created_at") != null) {
                    c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                c.setTaxCode(rs.getString("tax_code"));
                c.setPhone(rs.getString("phone"));
                c.setEmail(rs.getString("email"));
                c.setOrderId(rs.getInt("order_id"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("searchContracts error: " + e.getMessage());
        }
        return list;
    }

    public int getTotalContracts(String contractNumber, String customerName, String status,
            String storageType, int pageIndex, int pageSize, int userId, int roleId,
            String fromDate, String toDate, String taxCode, String phone, String email) {

        String sql = "SELECT COUNT(*) FROM customer_contract c "
                + " JOIN customer cust ON c.customer_id = cust.customer_id "
                + " JOIN [user] u ON cust.user_id = u.user_id "
                + "WHERE 1=1 ";
        if (contractNumber != null && !contractNumber.trim().isEmpty()) {
            sql += " AND c.contract_number LIKE ? ";
        }
        if (customerName != null && !customerName.trim().isEmpty()) {
            sql += " AND cust.company_name LIKE ? ";
        }
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND c.contract_status = ? ";
        }
        if (storageType != null && !storageType.trim().isEmpty()) {
            sql += " AND c.storage_type = ? ";
        }
        if (userId != 0 && userId > 0 && roleId == 3) {
            sql += " and cust.user_id= ? ";
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql += " AND c.created_at >= CAST(? AS datetime) ";
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql += " AND c.created_at < DATEADD(day, 1, CAST(? AS datetime)) ";
        }
        if (taxCode != null && !taxCode.trim().isEmpty()) {
            sql += " AND cust.tax_code LIKE ? ";
        }
        if (phone != null && !phone.trim().isEmpty()) {
            sql += " AND u.phone LIKE ? ";
        }
        if (email != null && !email.trim().isEmpty()) {
            sql += " AND u.email LIKE ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (contractNumber != null && !contractNumber.trim().isEmpty()) {
                ps.setString(index++, "%" + contractNumber.trim() + "%");
            }
            if (customerName != null && !customerName.trim().isEmpty()) {
                ps.setString(index++, "%" + customerName.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            if (storageType != null && !storageType.trim().isEmpty()) {
                ps.setString(index++, storageType);
            }
            if (userId != 0 && userId > 0 && roleId == 3) {
                ps.setInt(index++, userId);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setDate(index++, Date.valueOf(fromDate));
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setDate(index++, Date.valueOf(toDate));
            }
            if (taxCode != null && !taxCode.trim().isEmpty()) {
                ps.setString(index++, "%" + taxCode.trim() + "%");
            }
            if (phone != null && !phone.trim().isEmpty()) {
                ps.setString(index++, "%" + phone.trim() + "%");
            }
            if (email != null && !email.trim().isEmpty()) {
                ps.setString(index++, "%" + email.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("getTotalContracts error: " + e.getMessage());
        }
        return 0;
    }

    public Contract getContractById(int id) {
        String sql = """
                     SELECT *, cu.company_name FROM customer_contract  co 
                     join dbo.customer cu on co.customer_id= cu.customer_id
                     WHERE customer_contract_id = ?""";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("customer_contract_id"));
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setCustomerName(rs.getString("company_name"));
                    c.setQuotationId(rs.getInt("quotation_id"));
                    c.setContractNumber(rs.getString("contract_number"));
                    c.setContractContent(rs.getString("contract_content"));
                    c.setStorageType(rs.getString("storage_type"));
                    c.setContractStatus(rs.getString("contract_status"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setUpdatedBy(rs.getInt("updated_by"));
                    c.setToken(rs.getString("token"));
                    if (rs.getTimestamp("created_at") != null) {
                        c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    if (rs.getTimestamp("updated_at") != null) {
                        c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Contract getContractByToken(String token) {
        String sql = """
                     SELECT *, cu.company_name FROM customer_contract  co 
                     join dbo.customer cu on co.customer_id= cu.customer_id
                     WHERE token = ?""";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("customer_contract_id"));
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setCustomerName(rs.getString("company_name"));
                    c.setQuotationId(rs.getInt("quotation_id"));
                    c.setContractNumber(rs.getString("contract_number"));
                    c.setContractContent(rs.getString("contract_content"));
                    c.setStorageType(rs.getString("storage_type"));
                    c.setContractStatus(rs.getString("contract_status"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setUpdatedBy(rs.getInt("updated_by"));
                    c.setToken(rs.getString("token"));
                    if (rs.getTimestamp("created_at") != null) {
                        c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    if (rs.getTimestamp("updated_at") != null) {
                        c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * created by vtpp that function validate token when user is guest
     *
     * @param contractId
     * @param token
     * @return
     */
    public boolean validateToken(int contractId, String token) {
        String sql = "SELECT COUNT(*) FROM customer_contract WHERE customer_contract_id = ? AND token = ? AND (token_expired_at > GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ps.setString(2, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean checkOwnContractByCustomer(Contract contract, User user) {
        String sql = """
                    select count(1) from dbo.customer_contract c
                    join dbo.customer cust on c.customer_id = cust.customer_id
                    where c.customer_contract_id =? and cust.user_id= ?
                     and cust.customer_id >0 
                    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contract.getContractId());
            ps.setInt(2, user.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return false;
    }

    public Contract getContractByQuotationId(int quotationId) {
        String sql = """
                     SELECT *, cu.company_name FROM customer_contract  co 
                      join dbo.customer cu on co.customer_id= cu.customer_id
                      WHERE co.quotation_id = ?""";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quotationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("customer_contract_id"));
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setCustomerName(rs.getString("company_name"));
                    c.setQuotationId(rs.getInt("quotation_id"));
                    c.setContractNumber(rs.getString("contract_number"));
                    c.setContractContent(rs.getString("contract_content"));
                    c.setStorageType(rs.getString("storage_type"));
                    c.setContractStatus(rs.getString("contract_status"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setUpdatedBy(rs.getInt("updated_by"));
                    c.setToken(rs.getString("token"));
                    if (rs.getTimestamp("created_at") != null) {
                        c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    if (rs.getTimestamp("updated_at") != null) {
                        c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Contract> getSignedContractsByCustomerId(int customerId) {
        List<model.Contract> list = new ArrayList<>();
        // Truy vấn các hợp đồng đã Ký (SIGNED) của khách hàng
        String sql = "SELECT * FROM customer_contract WHERE customer_id = ? AND contract_status = 'SIGNED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Contract c = new model.Contract();
                    c.setContractId(rs.getInt("customer_contract_id"));
                    c.setContractNumber(rs.getString("contract_number"));
                    c.setContractStatus(rs.getString("contract_status"));
                    // Mapping thêm các trường khác nếu cần thiết
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // UPDATE
    public boolean update(Contract c) {
        String sql = "UPDATE customer_contract SET "
                + "contract_number = ?, "
                + "contract_content = ?, "
                + "contract_status = ?, "
                + "effective_date = ?, "
                + "end_date = ?, "
                + "signed_date = ?, "
                + "updated_by = ?, "
                + "updated_at = GETDATE() "
                + "WHERE customer_contract_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, c.getContractNumber());
            ps.setString(2, c.getContractContent());
            ps.setString(3, c.getContractStatus());
            ps.setTimestamp(4, c.getEffectiveDate() != null ? Timestamp.valueOf(c.getEffectiveDate()) : null);
            ps.setTimestamp(5, c.getEndDate() != null ? Timestamp.valueOf(c.getEndDate()) : null);
            ps.setTimestamp(6, c.getSignDate() != null ? Timestamp.valueOf(c.getSignDate()) : null);
            ps.setInt(7, c.getUpdatedBy());
            ps.setInt(8, c.getContractId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //nguyenkien - begin
    public boolean updateContractContent(int contractId, String contractContent) {
        String sql = "UPDATE customer_contract SET contract_content = ?, updated_at = GETDATE() WHERE customer_contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, contractContent);
            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("ContractDAO updateContractContent error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    //nguyenkien - end
    public boolean updateContractNumber(Contract c) {
        String sql = "UPDATE customer_contract SET contract_number = ? WHERE customer_contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, c.getContractNumber());
            ps.setInt(2, c.getContractId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    //////////////////////////////detail contract
    // Lấy lịch sử và danh sách item liên quan
    // Lấy lịch sử và danh sách item liên quan (Có phân trang)
    public List<ContractHistory> getHistoriesByContractId(int contractId, int userId, int roleId, int pageIndex, int pageSize) {
        List<ContractHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, u.user_name "
                + "FROM contract_edit_history h "
                + " JOIN [user] u "
                + "ON h.changed_by = u.user_id "
                + " JOIN customer_contract c ON h.contract_id = c.customer_contract_id "
                + " JOIN customer cust ON c.customer_id = cust.customer_id "
                + "WHERE h.contract_id = ? ";
        if (userId != 0 && userId > 0 && roleId == 3) {
            sql += " AND cust.user_id = ? AND u.role_id = 3 ";
        }
        sql += "ORDER BY h.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            ps.setInt(index++, contractId);
            if (userId != 0 && userId > 0 && roleId == 3) {
                ps.setInt(index++, userId);
            }
            ps.setInt(index++, (pageIndex - 1) * pageSize);
            ps.setInt(index++, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractHistory h = new ContractHistory();
                h.setHistoryId(rs.getInt("history_id"));
                h.setFromStatus(rs.getString("from_status"));
                h.setToStatus(rs.getString("to_status"));
                h.setNote(rs.getString("note"));
                h.setChangedByName(rs.getString("user_name"));
                h.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                h.setRevisionItems(getRevisionItemsByHistoryId(h.getHistoryId()));
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalHistoriesByContractId(int contractId, int userId, int roleId) {
        String sql = "SELECT COUNT(*) "
                + "FROM contract_edit_history h "
                + " JOIN [user] u "
                + "ON h.changed_by = u.user_id "
                + " JOIN customer_contract c ON h.contract_id = c.customer_contract_id "
                + " JOIN customer cust ON c.customer_id = cust.customer_id "
                + "WHERE h.contract_id = ? ";
        if (userId != 0 && userId > 0 && roleId == 3) {
            sql += " AND cust.user_id = ? AND u.role_id = 3 ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            ps.setInt(index++, contractId);
            if (userId != 0 && userId > 0 && roleId == 3) {
                ps.setInt(index++, userId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ContractHistory> getHistoriesByContractId(int contractId, int userId, int roleId) {
        List<ContractHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, u.user_name "
                + "FROM contract_edit_history h "
                + " JOIN [user] u "
                + "ON h.changed_by = u.user_id "
                + " JOIN customer_contract c ON h.contract_id = c.customer_contract_id "
                + " JOIN customer cust ON c.customer_id = cust.customer_id "
                + "WHERE h.contract_id = ? ";
        if (userId != 0 && userId > 0 && roleId == 3) {
            sql += " AND cust.user_id = ? AND u.role_id = 3 ";
        }
        sql += "ORDER BY h.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            ps.setInt(index++, contractId);
            if (userId != 0 && userId > 0 && roleId == 3) {
                ps.setInt(index++, userId);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractHistory h = new ContractHistory();
                h.setHistoryId(rs.getInt("history_id"));
                h.setFromStatus(rs.getString("from_status"));
                h.setToStatus(rs.getString("to_status"));
                h.setNote(rs.getString("note"));
                h.setChangedByName(rs.getString("user_name"));
                h.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                h.setRevisionItems(getRevisionItemsByHistoryId(h.getHistoryId()));
                list.add(h);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getMaxContractHistoryId() {
        String sql = "select max(history_id) FROM contract_edit_history";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ContractHistory> getContractHistoriesSinceId(int lastHistoryId) {
        List<ContractHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, "
                + "u.user_name, u.role_id AS changer_role_id, "
                + "c.contract_number, "
                + "cu.user_id AS customer_user_id "
                + "FROM contract_edit_history h "
                + "JOIN customer_contract c ON h.contract_id = c.customer_contract_id "
                + "JOIN customer cu ON c.customer_id = cu.customer_id "
                + "JOIN [user] u ON h.changed_by = u.user_id "
                + "WHERE h.history_id > ? "
                + "ORDER BY h.history_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lastHistoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ContractHistory h = new ContractHistory();
                    h.setHistoryId(rs.getInt("history_id"));
                    h.setContractId(rs.getInt("contract_id"));
                    h.setFromStatus(rs.getString("from_status"));
                    h.setToStatus(rs.getString("to_status"));
                    h.setNote(rs.getString("note"));
                    h.setChangedBy(rs.getObject("changed_by") != null ? rs.getInt("changed_by") : 0);
                    h.setChangedByName(rs.getString("user_name"));
                    h.setChangerRoleId(rs.getInt("changer_role_id"));
                    if (rs.getTimestamp("created_at") != null) {
                        h.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    h.setContractNumber(rs.getString("contract_number"));
                    h.setCustomerUserId(rs.getInt("customer_user_id"));
                    list.add(h);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertHistory(ContractHistory h) {
        String sql = "INSERT INTO contract_edit_history (contract_id, from_status, to_status, note, changed_by) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, h.getContractId());
            ps.setString(2, h.getFromStatus());
            ps.setString(3, h.getToStatus());
            ps.setString(4, h.getNote());
            ps.setInt(5, h.getChangedBy());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void insertRevisionItem(ContractRevisionItem item) {
        String sql = "INSERT INTO contract_revision_item (history_id, contract_id, revision_type, revision_detail) VALUES (?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, item.getHistoryId());
            ps.setInt(2, item.getContractId());
            ps.setString(3, item.getRevisionType());
            ps.setString(4, item.getRevisionDetail());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Cập nhật trạng thái của hợp đồng
    public boolean updateStatus(int contractId, String newStatus) {
        String sql = "UPDATE customer_contract SET contract_status = ? WHERE customer_contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);

            ps.setInt(2, contractId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("ContractDAO updateStatus error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách chi tiết các mục yêu cầu sửa đổi theo historyId
    public List<ContractRevisionItem> getRevisionItemsByHistoryId(int historyId) {
        List<ContractRevisionItem> items = new ArrayList<>();
        String sql = "SELECT * FROM contract_revision_item WHERE history_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, historyId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ContractRevisionItem item = new ContractRevisionItem();
                item.setRevisionItemId(rs.getInt("revision_item_id"));
                item.setHistoryId(rs.getInt("history_id"));
                item.setContractId(rs.getInt("contract_id"));
                item.setRevisionType(rs.getString("revision_type"));
                item.setRevisionDetail(rs.getString("revision_detail"));
                items.add(item);
            }
        } catch (Exception e) {
            System.err.println("ContractDAO getRevisionItemsByHistoryId error: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    public CustomerDTO getCustomerDTOByContractId(int contractId) {
        String sql = "SELECT cust.customer_id, cust.tax_code, cust.customer_type, cust.company_name, cust.user_id, cust.assigned_to_user_id, "
                + "u.user_name, u.email, u.full_name, u.phone, u.gender, u.address, u.account_status, u.role_id, "
                + "u.created_at, u.updated_at, u.created_by, u.updated_by "
                + "FROM customer_contract cc "
                + "JOIN customer cust ON cc.customer_id = cust.customer_id "
                + " JOIN [user] u ON cust.user_id = u.user_id "
                + "WHERE cc.customer_contract_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, contractId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setUserId((Integer) rs.getObject("user_id"));
                    c.setTaxCode(rs.getString("tax_code"));
                    c.setCustomerType(rs.getString("customer_type"));
                    c.setCompanyName(rs.getString("company_name"));
                    c.setAssignedToUserId((Integer) rs.getObject("assigned_to_user_id"));

                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setUserName(rs.getString("user_name"));
                    u.setEmail(rs.getString("email"));
                    u.setFullName(rs.getString("full_name"));
                    u.setPhone(rs.getString("phone"));
                    u.setGender(rs.getString("gender"));
                    u.setAddress(rs.getString("address"));
                    u.setStatus(rs.getString("account_status"));
                    u.setRoleId(rs.getInt("role_id"));
                    if (rs.getTimestamp("created_at") != null) {
                        u.setCreateAt(rs.getTimestamp("created_at").toLocalDateTime());
                    }
                    if (rs.getTimestamp("updated_at") != null) {
                        u.setUpdateAt(rs.getTimestamp("updated_at").toLocalDateTime());
                    }
                    u.setCreatedBy(rs.getInt("created_by"));
                    u.setUpdatedBy(rs.getInt("updated_by"));

                    return new CustomerDTO(c, u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}

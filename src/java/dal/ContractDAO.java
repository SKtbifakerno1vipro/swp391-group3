package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.*;
import dto.*;

public class ContractDAO extends DBContext {

    // CREATE
    public int insert(Contract c) {
        String sql = "INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_status, contract_content, storage_type, created_by, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, c.getCustomerId());
            ps.setInt(2, c.getQuotationId());
            ps.setString(3, c.getContractNumber());
            ps.setString(4, c.getContractStatus());
            ps.setString(5, c.getContractContent());
            ps.setString(6, c.getStorageType());
            ps.setInt(7, c.getCreatedBy());

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

    public List<Contract> searchContracts(String contractNumber, String customerName, String status, String storageType, int pageIndex, int pageSize) {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT c.customer_contract_id, c.contract_number, c.contract_status, c.storage_type, "
                + "c.effective_date, c.end_date, c.created_at, cust.company_name "
                + "FROM customer_contract c LEFT JOIN customer cust ON c.customer_id = cust.customer_id "
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

        sql += " ORDER BY c.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
            ps.setInt(index++, (pageIndex - 1) * pageSize);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract c = new Contract();
                c.setContractId(rs.getInt("customer_contract_id"));
                c.setContractNumber(rs.getString("contract_number"));
                c.setContractStatus(rs.getString("contract_status"));
                c.setStorageType(rs.getString("storage_type"));
                c.setCustomerName(rs.getString("company_name"));
                if (rs.getTimestamp("effective_date") != null) {
                    c.setEffectiveDate(rs.getTimestamp("effective_date").toLocalDateTime());
                }
                if (rs.getTimestamp("end_date") != null) {
                    c.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
                }
                if (rs.getTimestamp("created_at") != null) {
                    c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("searchContracts error: " + e.getMessage());
        }
        return list;
    }

    public int getTotalContracts(String contractNumber, String customerName, String status, String storageType) {
        String sql = "SELECT COUNT(*) FROM customer_contract c LEFT JOIN customer cust ON c.customer_id = cust.customer_id WHERE 1=1 ";
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
        String sql = "SELECT * FROM customer_contract WHERE customer_contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("customer_contract_id"));
                    c.setCustomerId(rs.getInt("customer_id"));
                    c.setQuotationId(rs.getInt("quotation_id"));
                    c.setContractNumber(rs.getString("contract_number"));
                    c.setContractContent(rs.getString("contract_content"));
                    c.setStorageType(rs.getString("storage_type"));
                    c.setContractStatus(rs.getString("contract_status"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setUpdatedBy(rs.getInt("updated_by"));
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

    public Contract getContractByQuotationId(int quotationId) {
        String sql = "SELECT * FROM customer_contract WHERE quotation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quotationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Contract c = new Contract();
                    c.setContractId(rs.getInt("customer_contract_id"));
                    return c;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<model.Contract> getSignedContractsByCustomerId(int customerId) {
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
                + "contract_version = ?, "
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
            ps.setString(4, c.getContractVersion());
            ps.setTimestamp(5, c.getEffectiveDate() != null ? Timestamp.valueOf(c.getEffectiveDate()) : null);
            ps.setTimestamp(6, c.getEndDate() != null ? Timestamp.valueOf(c.getEndDate()) : null);
            ps.setTimestamp(7, c.getSignDate() != null ? Timestamp.valueOf(c.getSignDate()) : null);
            ps.setInt(8, c.getUpdatedBy());
            ps.setInt(9, c.getContractId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // XHieu-begin - delete contact me
    public List<Contract> getContractsByCustomerId(int customerId) {
        List<Contract> list = new ArrayList<>();
        String sql = "SELECT c.customer_contract_id, c.contract_number, c.contract_status, c.storage_type, "
                + "c.contract_version, c.effective_date, c.end_date, c.signed_date, c.created_at, c.updated_at, cust.company_name "
                + "FROM customer_contract c LEFT JOIN customer cust ON c.customer_id = cust.customer_id "
                + "WHERE c.customer_id = ? "
                + "ORDER BY c.updated_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contract c = new Contract();
                c.setContractId(rs.getInt("customer_contract_id"));
                c.setContractNumber(rs.getString("contract_number"));
                c.setContractStatus(rs.getString("contract_status"));
                c.setStorageType(rs.getString("storage_type"));
                c.setContractVersion(rs.getString("contract_version"));
                c.setCustomerName(rs.getString("company_name"));

                if (rs.getTimestamp("effective_date") != null) {
                    c.setEffectiveDate(rs.getTimestamp("effective_date").toLocalDateTime());
                }
                if (rs.getTimestamp("end_date") != null) {
                    c.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
                }
                if (rs.getTimestamp("signed_date") != null) {
                    c.setSignDate(rs.getTimestamp("signed_date").toLocalDateTime());
                }
                if (rs.getTimestamp("created_at") != null) {
                    c.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                if (rs.getTimestamp("updated_at") != null) {
                    c.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                }
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println("getContractsByCustomerId error: " + e.getMessage());
        }
        return list;
    }
    // Xhieu - end

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
    public List<ContractHistory> getHistoriesByContractId(int contractId) {
        List<ContractHistory> list = new ArrayList<>();
        String sql = "SELECT h.*, u.user_name FROM contract_edit_history h LEFT JOIN [user] u ON h.changed_by = u.user_id WHERE h.contract_id = ? ORDER BY h.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
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

    public java.math.BigDecimal calculateTotalAmountWithTaxAndDiscount(int quotationId) {
        // Lưu ý: Thay đổi tên cột 'tax_percent' và 'discount_amount' 
        // cho đúng với database thực tế của bạn
        String sql = "SELECT q.tax_percent, q.discount_amount, "
                + "(SELECT SUM(quantity * selling_price) FROM quotation_detail WHERE quotation_id = q.quotation_id) as subtotal "
                + "FROM quotation q WHERE q.quotation_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quotationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    java.math.BigDecimal subtotal = rs.getBigDecimal("subtotal");
                    if (subtotal == null) {
                        subtotal = java.math.BigDecimal.ZERO;
                    }

          git           java.math.BigDecimal taxPercent = rs.getBigDecimal("tax_percent");
                    java.math.BigDecimal discount = rs.getBigDecimal("discount_amount");

                    if (taxPercent == null) {
                        taxPercent = java.math.BigDecimal.ZERO;
                    }
                    if (discount == null) {
                        discount = java.math.BigDecimal.ZERO;
                    }

                    // Công thức: (Subtotal + Tax) - Discount
                    // Tax = Subtotal * (taxPercent / 100)
                    java.math.BigDecimal taxAmount = subtotal.multiply(taxPercent.divide(new java.math.BigDecimal("100")));
                    java.math.BigDecimal total = subtotal.add(taxAmount).subtract(discount);

                    return total.compareTo(java.math.BigDecimal.ZERO) > 0 ? total : java.math.BigDecimal.ZERO;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

}

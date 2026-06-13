package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.*;
import dto.*;

public class ContractDAO extends DBContext {

    // CREATE
    public int insert(Contract c) {
        String sql = "INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_status, contract_content, storage_type, created_by, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                        return generatedKeys.getInt(1); // Trả về ID vừa được sinh ra (identity)
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("ContractDAO insert error: " + e.getMessage());
        }
        return -1; // Trả về -1 nếu insert thất bại
    }

    public List<Contract> searchContracts(String contractNumber, String customerName, String status, String storageType, int pageIndex, int pageSize) {
        List<Contract> list = new ArrayList<>();
        // 1. SQL: Lay cac truong hanh chinh va thong tin khach hang
        String sql = "SELECT c.customer_contract_id, c.contract_number, c.contract_status, c.storage_type, "
                + "c.effective_date, c.end_date, c.created_at, cust.company_name "
                + "FROM customer_contract c LEFT JOIN customer cust ON c.customer_id = cust.customer_id "
                + "WHERE 1=1 ";

        // Logic loc đong (4 Filters)
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

                // 2. Mapping ngay thang chinh xac (L3 Optimized)
                if (rs.getTimestamp("effective_date") != null) {
                    c.setEffectiveDate(rs.getTimestamp("effective_date").toLocalDateTime());
                }

                if (rs.getTimestamp("end_date") != null) {
                    c.setEndDate(rs.getTimestamp("end_date").toLocalDateTime());
                }

                // Đam bao lay đung ngay tao (created_at)
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

    // Ham bo tro đe đem tong so ban ghi (phuc vu phan trang)
    public int getTotalContracts(String contractNumber, String customerName, String status, String storageType) {
        String sql = "SELECT COUNT(*) FROM customer_contract c "
                + "LEFT JOIN customer cust ON c.customer_id = cust.customer_id "
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

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            if (contractNumber != null && !contractNumber.trim().isEmpty()) {
                String search = "%" + contractNumber.trim() + "%";
                ps.setString(index++, search);
            }
            if (customerName != null && !customerName.trim().isEmpty()) {
                String search = "%" + customerName.trim() + "%";
                ps.setString(index++, search);
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
                    c.setContractFileUrl(rs.getString("contract_file_url"));
                    c.setContractStatus(rs.getString("contract_status"));
                    c.setContractVersion(rs.getString("contract_version"));

                    // Xu ly cac truong thoi gian (LocalDateTime)
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

                    // Cac truong noi dung quan trong
                    c.setContractContent(rs.getString("contract_content"));
                    c.setStorageType(rs.getString("storage_type"));
                    c.setCreatedBy(rs.getInt("created_by"));
                    c.setUpdatedBy(rs.getInt("updated_by"));

                    return c;
                }
            }
        } catch (Exception e) {
            System.out.println("getContractById error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // UPDATE
    public boolean update(Contract c) {
        String sql = "UPDATE customer_contract SET "
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
            // Noi dung chinh
            ps.setString(1, c.getContractContent());
            ps.setString(2, c.getContractStatus());
            ps.setString(3, c.getContractVersion());

            // Xu ly cac truong thoi gian an toan (Null safety)
            ps.setTimestamp(4, c.getEffectiveDate() != null ? Timestamp.valueOf(c.getEffectiveDate()) : null);
            ps.setTimestamp(5, c.getEndDate() != null ? Timestamp.valueOf(c.getEndDate()) : null);
            ps.setTimestamp(6, c.getSignDate() != null ? Timestamp.valueOf(c.getSignDate()) : null);

            // Thong tin nguoi sua & Đieu kien WHERE
            ps.setInt(7, c.getUpdatedBy());
            ps.setInt(8, c.getContractId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0; // Trả về true nếu update thành công

        } catch (Exception e) {
            System.out.println("update contract error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}

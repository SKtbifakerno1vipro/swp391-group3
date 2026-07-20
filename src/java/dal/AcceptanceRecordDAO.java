package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import model.AcceptanceRecord;

public class AcceptanceRecordDAO extends DBContext {

    public String getNextRecordNo(int year) {
        String prefix = "AR-" + year + "-";
        String sql = "SELECT MAX(record_no) as max_no FROM acceptance_record WHERE record_no LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, prefix + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String maxNo = rs.getString("max_no");
                    if (maxNo != null && maxNo.startsWith(prefix)) {
                        String suffix = maxNo.substring(prefix.length());
                        try {
                            int nextVal = Integer.parseInt(suffix) + 1;
                            return String.format("%s%05d", prefix, nextVal);
                        } catch (NumberFormatException e) {
                            // ignore
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("getNextRecordNo error: " + e.getMessage());
        }
        return prefix + "00001";
    }

    public boolean insertAcceptanceRecord(AcceptanceRecord record) {
        if (record.getRecordNo() == null || record.getRecordNo().trim().isEmpty()) {
            int year = record.getAcceptanceDate() != null ? record.getAcceptanceDate().getYear() : LocalDateTime.now().getYear();
            record.setRecordNo(getNextRecordNo(year));
        }

        String sql = "INSERT INTO acceptance_record ("
                + "customer_contract_id, customer_order_id, record_no, acceptance_date, acceptance_status, "
                + "provider_name, provider_rep_name, provider_tax_code, provider_address, provider_phone, "
                + "customer_name, customer_rep_name, customer_tax_code, customer_address, customer_phone, "
                + "total_amount, created_by, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, record.getCustomerContractId());
            ps.setInt(2, record.getCustomerOrderId());
            ps.setString(3, record.getRecordNo());
            ps.setTimestamp(4, record.getAcceptanceDate() != null ? Timestamp.valueOf(record.getAcceptanceDate()) : Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(5, record.getAcceptanceStatus() != null ? record.getAcceptanceStatus() : "PENDING");
            
            ps.setString(6, record.getProviderName());
            ps.setString(7, record.getProviderRepName());
            ps.setString(8, record.getProviderTaxCode());
            ps.setString(9, record.getProviderAddress());
            ps.setString(10, record.getProviderPhone());

            ps.setString(11, record.getCustomerName());
            ps.setString(12, record.getCustomerRepName());
            ps.setString(13, record.getCustomerTaxCode());
            ps.setString(14, record.getCustomerAddress());
            ps.setString(15, record.getCustomerPhone());

            ps.setDouble(16, record.getTotalAmount());
            if (record.getCreatedBy() != null) {
                ps.setInt(17, record.getCreatedBy());
            } else {
                ps.setNull(17, Types.INTEGER);
            }

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        record.setAcceptanceRecordId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (Exception e) {
            System.out.println("insertAcceptanceRecord error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAcceptanceRecord(AcceptanceRecord record) {
        String sql = "UPDATE acceptance_record SET "
                + "record_no = ?, acceptance_date = ?, acceptance_status = ?, "
                + "provider_name = ?, provider_rep_name = ?, provider_tax_code = ?, provider_address = ?, provider_phone = ?, "
                + "customer_name = ?, customer_rep_name = ?, customer_tax_code = ?, customer_address = ?, customer_phone = ?, "
                + "total_amount = ?, updated_at = GETDATE() "
                + "WHERE acceptance_record_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, record.getRecordNo());
            ps.setTimestamp(2, record.getAcceptanceDate() != null ? Timestamp.valueOf(record.getAcceptanceDate()) : null);
            ps.setString(3, record.getAcceptanceStatus());

            ps.setString(4, record.getProviderName());
            ps.setString(5, record.getProviderRepName());
            ps.setString(6, record.getProviderTaxCode());
            ps.setString(7, record.getProviderAddress());
            ps.setString(8, record.getProviderPhone());

            ps.setString(9, record.getCustomerName());
            ps.setString(10, record.getCustomerRepName());
            ps.setString(11, record.getCustomerTaxCode());
            ps.setString(12, record.getCustomerAddress());
            ps.setString(13, record.getCustomerPhone());

            ps.setDouble(14, record.getTotalAmount());
            ps.setInt(15, record.getAcceptanceRecordId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateAcceptanceRecord error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public AcceptanceRecord getAcceptanceRecordByOrderId(int orderId) {
        String sql = "SELECT * FROM acceptance_record WHERE customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAcceptanceRecord(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("getAcceptanceRecordByOrderId error: " + e.getMessage());
        }
        return null;
    }

    public AcceptanceRecord getAcceptanceRecordById(int recordId) {
        String sql = "SELECT * FROM acceptance_record WHERE acceptance_record_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, recordId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAcceptanceRecord(rs);
                }
            }
        } catch (Exception e) {
            System.out.println("getAcceptanceRecordById error: " + e.getMessage());
        }
        return null;
    }

    public boolean updateAcceptanceStatus(int orderId, String status) {
        String sql = "UPDATE acceptance_record SET acceptance_status = ?, updated_at = GETDATE() WHERE customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updateAcceptanceStatus error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    private AcceptanceRecord mapResultSetToAcceptanceRecord(ResultSet rs) throws Exception {
        AcceptanceRecord record = new AcceptanceRecord();
        record.setAcceptanceRecordId(rs.getInt("acceptance_record_id"));
        record.setCustomerContractId(rs.getInt("customer_contract_id"));
        record.setCustomerOrderId(rs.getInt("customer_order_id"));
        record.setRecordNo(rs.getString("record_no"));
        
        Timestamp accDate = rs.getTimestamp("acceptance_date");
        if (accDate != null) {
            record.setAcceptanceDate(accDate.toLocalDateTime());
        }
        
        record.setAcceptanceStatus(rs.getString("acceptance_status"));

        record.setProviderName(rs.getString("provider_name"));
        record.setProviderRepName(rs.getString("provider_rep_name"));
        record.setProviderTaxCode(rs.getString("provider_tax_code"));
        record.setProviderAddress(rs.getString("provider_address"));
        record.setProviderPhone(rs.getString("provider_phone"));

        record.setCustomerName(rs.getString("customer_name"));
        record.setCustomerRepName(rs.getString("customer_rep_name"));
        record.setCustomerTaxCode(rs.getString("customer_tax_code"));
        record.setCustomerAddress(rs.getString("customer_address"));
        record.setCustomerPhone(rs.getString("customer_phone"));

        record.setTotalAmount(rs.getDouble("total_amount"));

        int createdByVal = rs.getInt("created_by");
        if (!rs.wasNull()) {
            record.setCreatedBy(createdByVal);
        }

        Timestamp createdTime = rs.getTimestamp("created_at");
        if (createdTime != null) {
            record.setCreatedAt(createdTime.toLocalDateTime());
        }

        Timestamp updatedTime = rs.getTimestamp("updated_at");
        if (updatedTime != null) {
            record.setUpdatedAt(updatedTime.toLocalDateTime());
        }

        return record;
    }
}

package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Payment;

public class PaymentDAO extends DBContext {

    public int insertPayment(Payment payment) {
        String sql = "INSERT INTO payment (customer_contract_id, customer_order_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by, customer_name_snapshot, customer_phone_snapshot, customer_address_snapshot, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getCustomerContractId());
            ps.setInt(2, payment.getCustomerOrderId());
            if (payment.getInvoiceId() != null) {
                ps.setInt(3, payment.getInvoiceId());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setBigDecimal(4, payment.getAmount());
            ps.setString(5, payment.getPaymentType());
            ps.setString(6, payment.getPaymentStatus());
            ps.setTimestamp(7, payment.getPaidAt() != null ? Timestamp.valueOf(payment.getPaidAt()) : null);
            if (payment.getCreatedBy() != null) {
                ps.setInt(8, payment.getCreatedBy());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            ps.setString(9, payment.getCustomerNameSnapshot());
            ps.setString(10, payment.getCustomerPhoneSnapshot());
            ps.setString(11, payment.getCustomerAddressSnapshot());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, c.contract_number, p.customer_name_snapshot as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "ORDER BY p.payment_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPayment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Payment> getPaymentsByCustomerId(int userId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, c.contract_number, p.customer_name_snapshot as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "WHERE p.created_by = ? "
                + "ORDER BY p.payment_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPayment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.*, c.contract_number, p.customer_name_snapshot as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "WHERE p.payment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToPayment(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getAnyContractId() {
        String sql = "SELECT TOP 1 customer_contract_id FROM customer_contract ORDER BY customer_contract_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("customer_contract_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 1; // absolute fallback
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE payment SET payment_status = ?, paid_at = ? WHERE payment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            if ("COMPLETED".equals(status)) {
                ps.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(2, java.sql.Types.TIMESTAMP);
            }
            ps.setInt(3, paymentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasPaymentForContract(int contractId) {
        String sql = "SELECT COUNT(*) FROM payment WHERE customer_contract_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasPaymentForOrder(int orderId) {
        String sql = "SELECT COUNT(*) FROM payment WHERE customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Payment getPaymentByOrderId(int orderId) {
        String sql = "SELECT TOP 1 * FROM payment WHERE customer_order_id = ? ORDER BY payment_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Payment getPaymentByContractId(int contractId) {
        String sql = "SELECT TOP 1 * FROM payment WHERE customer_contract_id = ? ORDER BY payment_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Payment> searchPayments(
            Integer customerUserId,
            String customerName,
            String contractNumber,
            String status,
            String startDate,
            String endDate,
            BigDecimal minAmount,
            BigDecimal maxAmount,
            int page,
            int pageSize
    ) {
        List<Payment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.contract_number, p.customer_name_snapshot as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "WHERE 1=1 "
        );

        boolean hasCustomerUser = (customerUserId != null);
        boolean hasCustomerName = (customerName != null && !customerName.isBlank());
        boolean hasContractNumber = (contractNumber != null && !contractNumber.isBlank());
        boolean hasStatus = (status != null && !status.isBlank());
        boolean hasStartDate = (startDate != null && !startDate.isBlank());
        boolean hasEndDate = (endDate != null && !endDate.isBlank());
        boolean hasMinAmount = (minAmount != null);
        boolean hasMaxAmount = (maxAmount != null);

        if (hasCustomerUser) {
            sql.append("AND p.created_by = ? ");
        }
        if (hasCustomerName) {
            sql.append("AND (p.customer_name_snapshot LIKE ? OR u.full_name LIKE ?) ");
        }
        if (hasContractNumber) {
            sql.append("AND c.contract_number LIKE ? ");
        }
        if (hasStatus) {
            sql.append("AND p.payment_status = ? ");
        }
        if (hasStartDate) {
            sql.append("AND p.paid_at >= ? ");
        }
        if (hasEndDate) {
            sql.append("AND p.paid_at <= ? ");
        }
        if (hasMinAmount) {
            sql.append("AND p.amount >= ? ");
        }
        if (hasMaxAmount) {
            sql.append("AND p.amount <= ? ");
        }

        sql.append("ORDER BY p.created_at DESC, p.payment_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        int offset = (page - 1) * pageSize;

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (hasCustomerUser) {
                ps.setInt(index++, customerUserId);
            }
            if (hasCustomerName) {
                String pattern = "%" + customerName.trim() + "%";
                ps.setString(index++, pattern);
                ps.setString(index++, pattern);
            }
            if (hasContractNumber) {
                ps.setString(index++, "%" + contractNumber.trim() + "%");
            }
            if (hasStatus) {
                ps.setString(index++, status.trim());
            }
            if (hasStartDate) {
                ps.setTimestamp(index++, parseDateTime(startDate, false));
            }
            if (hasEndDate) {
                ps.setTimestamp(index++, parseDateTime(endDate, true));
            }
            if (hasMinAmount) {
                ps.setBigDecimal(index++, minAmount);
            }
            if (hasMaxAmount) {
                ps.setBigDecimal(index++, maxAmount);
            }
            ps.setInt(index++, offset);
            ps.setInt(index++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToPayment(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getSearchPaymentsCount(
            Integer customerUserId,
            String customerName,
            String contractNumber,
            String status,
            String startDate,
            String endDate,
            BigDecimal minAmount,
            BigDecimal maxAmount
    ) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "WHERE 1=1 "
        );

        boolean hasCustomerUser = (customerUserId != null);
        boolean hasCustomerName = (customerName != null && !customerName.isBlank());
        boolean hasContractNumber = (contractNumber != null && !contractNumber.isBlank());
        boolean hasStatus = (status != null && !status.isBlank());
        boolean hasStartDate = (startDate != null && !startDate.isBlank());
        boolean hasEndDate = (endDate != null && !endDate.isBlank());
        boolean hasMinAmount = (minAmount != null);
        boolean hasMaxAmount = (maxAmount != null);

        if (hasCustomerUser) {
            sql.append("AND p.created_by = ? ");
        }
        if (hasCustomerName) {
            sql.append("AND (p.customer_name_snapshot LIKE ? OR u.full_name LIKE ?) ");
        }
        if (hasContractNumber) {
            sql.append("AND c.contract_number LIKE ? ");
        }
        if (hasStatus) {
            sql.append("AND p.payment_status = ? ");
        }
        if (hasStartDate) {
            sql.append("AND p.paid_at >= ? ");
        }
        if (hasEndDate) {
            sql.append("AND p.paid_at <= ? ");
        }
        if (hasMinAmount) {
            sql.append("AND p.amount >= ? ");
        }
        if (hasMaxAmount) {
            sql.append("AND p.amount <= ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int index = 1;
            if (hasCustomerUser) {
                ps.setInt(index++, customerUserId);
            }
            if (hasCustomerName) {
                String pattern = "%" + customerName.trim() + "%";
                ps.setString(index++, pattern);
                ps.setString(index++, pattern);
            }
            if (hasContractNumber) {
                ps.setString(index++, "%" + contractNumber.trim() + "%");
            }
            if (hasStatus) {
                ps.setString(index++, status.trim());
            }
            if (hasStartDate) {
                ps.setTimestamp(index++, parseDateTime(startDate, false));
            }
            if (hasEndDate) {
                ps.setTimestamp(index++, parseDateTime(endDate, true));
            }
            if (hasMinAmount) {
                ps.setBigDecimal(index++, minAmount);
            }
            if (hasMaxAmount) {
                ps.setBigDecimal(index++, maxAmount);
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

    // this is for realtime notification
    public List<Payment> getPaymentsSince(Timestamp sinceTime, Integer customerUserId) {
        List<Payment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, c.contract_number, p.customer_name_snapshot as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "JOIN customer cust ON c.customer_id = cust.customer_id "
                + "JOIN [user] u ON cust.user_id = u.user_id "
                + "WHERE (p.created_at > ? OR p.paid_at > ?) "
        );
        if (customerUserId != null) {
            sql.append("AND p.created_by = ? ");
        }
        sql.append("ORDER BY p.created_at ASC, p.paid_at ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setTimestamp(1, sinceTime);
            ps.setTimestamp(2, sinceTime);
            if (customerUserId != null) {
                ps.setInt(3, customerUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToPayment(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private java.sql.Timestamp parseDateTime(String input, boolean isEnd) {
        if (input == null || input.isBlank()) return null;
        try {
            String val = input.trim();
            if (val.contains("T")) {
                String formatted = val.replace("T", " ");
                if (formatted.length() == 16) {
                    formatted += ":00";
                }
                return Timestamp.valueOf(formatted);
            } else {
                if (isEnd) {
                    return Timestamp.valueOf(val + " 23:59:59");
                } else {
                    return Timestamp.valueOf(val + " 00:00:00");
                }
            }
        } catch (Exception e) {
            return null;
        }
    }

    private Payment mapResultSetToPayment(ResultSet rs) {
        Payment p = new Payment();
        try {
            p.setPaymentId(rs.getInt("payment_id"));
            p.setCustomerContractId(rs.getInt("customer_contract_id"));
            p.setCustomerOrderId(rs.getInt("customer_order_id"));
            p.setInvoiceId(rs.getObject("invoice_id") != null ? rs.getInt("invoice_id") : null);
            p.setAmount(rs.getBigDecimal("amount"));
            p.setPaymentType(rs.getString("payment_type"));
            p.setPaymentStatus(rs.getString("payment_status"));
            if (rs.getTimestamp("paid_at") != null) {
                p.setPaidAt(rs.getTimestamp("paid_at").toLocalDateTime());
            }
            p.setCreatedBy(rs.getObject("created_by") != null ? rs.getInt("created_by") : null);
            if (rs.getTimestamp("created_at") != null) {
                p.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }
            p.setCustomerNameSnapshot(rs.getString("customer_name_snapshot"));
            p.setCustomerPhoneSnapshot(rs.getString("customer_phone_snapshot"));
            p.setCustomerAddressSnapshot(rs.getString("customer_address_snapshot"));
            p.setContractNumber(rs.getString("contract_number"));
            p.setCustomerName(rs.getString("customer_name"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return p;
    }
}

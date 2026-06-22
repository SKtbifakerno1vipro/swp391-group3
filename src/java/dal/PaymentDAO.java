package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Payment;

public class PaymentDAO extends DBContext {

    public int insertPayment(Payment payment) {
        String sql = "INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getCustomerContractId());
            if (payment.getInvoiceId() != null) {
                ps.setInt(2, payment.getInvoiceId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setBigDecimal(3, payment.getAmount());
            ps.setString(4, payment.getPaymentType());
            ps.setString(5, payment.getPaymentStatus());
            ps.setTimestamp(6, payment.getPaidAt() != null ? Timestamp.valueOf(payment.getPaidAt()) : null);
            if (payment.getCreatedBy() != null) {
                ps.setInt(7, payment.getCreatedBy());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }

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
        String sql = "SELECT p.*, c.contract_number, u.full_name as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "ORDER BY p.payment_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setCustomerContractId(rs.getInt("customer_contract_id"));
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
                p.setContractNumber(rs.getString("contract_number"));
                p.setCustomerName(rs.getString("customer_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Payment> getPaymentsByCustomerId(int userId) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, c.contract_number, u.full_name as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "WHERE p.created_by = ? "
                + "ORDER BY p.payment_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setCustomerContractId(rs.getInt("customer_contract_id"));
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
                p.setContractNumber(rs.getString("contract_number"));
                p.setCustomerName(rs.getString("customer_name"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.*, c.contract_number, u.full_name as customer_name "
                + "FROM payment p "
                + "JOIN customer_contract c ON p.customer_contract_id = c.customer_contract_id "
                + "LEFT JOIN [user] u ON p.created_by = u.user_id "
                + "WHERE p.payment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setCustomerContractId(rs.getInt("customer_contract_id"));
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
                p.setContractNumber(rs.getString("contract_number"));
                p.setCustomerName(rs.getString("customer_name"));
                return p;
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
}

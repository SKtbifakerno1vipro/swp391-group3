package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Quotation;
import model.QuotationHistory;

public class QuotationDAO extends DBContext {

    public List<Quotation> getAllQuotations() {
        List<Quotation> list = new ArrayList();
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, "
                + "customer.company_name, [user].user_name "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "ORDER BY quotation.created_at DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Quotation quotation = new Quotation();
                quotation.setQuotationId(rs.getInt("quotation_id"));
                quotation.setCustomerId(rs.getInt("customer_id"));
                if (rs.getTimestamp("quotation_date") != null) {
                    quotation.setQuotationDate(rs.getTimestamp("quotation_date").toLocalDateTime());
                }
                quotation.setQuotationStatus(rs.getString("quotation_status"));
                quotation.setCreatedBy(rs.getInt("created_by"));
                if (rs.getTimestamp("created_at") != null) {
                    quotation.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                quotation.setCustomerName(rs.getString("company_name"));
                quotation.setCreatedByName(rs.getString("user_name"));
                list.add(quotation);
            }
        } catch (Exception e) {
            System.out.println("getAllQuotations error: " + e.getMessage());
        }
        return list;
    }

    public List<Quotation> searchQuotations(String searchText, String status) {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, "
                + "customer.company_name, [user].user_name "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "WHERE 1=1 "; // Có dấu cách ở cuối

        if (searchText != null && !searchText.trim().isEmpty()) {
            sql += " AND customer.company_name LIKE ? "; // Thêm dấu cách
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND quotation.quotation_status = ? "; // Thêm dấu cách
        }
        sql += " ORDER BY quotation.created_at DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int paramIndex = 1;

            if (searchText != null && !searchText.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchText + "%"); // Dùng ++ để tăng vị trí
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status); // Dùng ++ để tăng vị trí
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Quotation quotation = new Quotation();
                quotation.setQuotationId(rs.getInt("quotation_id"));
                quotation.setCustomerId(rs.getInt("customer_id"));
                if (rs.getTimestamp("quotation_date") != null) {
                    quotation.setQuotationDate(rs.getTimestamp("quotation_date").toLocalDateTime());
                }
                quotation.setQuotationStatus(rs.getString("quotation_status"));
                quotation.setCreatedBy(rs.getInt("created_by"));
                if (rs.getTimestamp("created_at") != null) {
                    quotation.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                quotation.setCustomerName(rs.getString("company_name"));
                quotation.setCreatedByName(rs.getString("user_name"));
                list.add(quotation);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<QuotationHistory> getHistoryByQuotationId(int quotationId) {
        List<QuotationHistory> histories = new ArrayList<>();
        String sql = "SELECT * FROM quotation_history WHERE quotation_id = ? ORDER BY created_at DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuotationHistory history = new QuotationHistory();
                history.setQuotationHistoryId(rs.getInt("quotation_history_id"));
                history.setQuotationId(rs.getInt("quotation_id"));
                history.setCreatedBy(rs.getInt("created_by"));
                history.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                history.setEditHistory(rs.getString("edit_history"));
                histories.add(history);
            }
        } catch (Exception e) {
            System.out.println("getHistoryByQuotationId error: " + e.getMessage());
        }
        return histories;
    }

    /*
    create by phu
    this func find quotation by id
     */
    public Quotation getQuotationById(int quotationId) {
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, "
                + "customer.company_name, [user].user_name "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "WHERE quotation.quotation_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Quotation quotation = new Quotation();
                quotation.setQuotationId(rs.getInt("quotation_id"));
                quotation.setCustomerId(rs.getInt("customer_id"));
                if (rs.getTimestamp("quotation_date") != null) {
                    quotation.setQuotationDate(rs.getTimestamp("quotation_date").toLocalDateTime());
                }
                quotation.setQuotationStatus(rs.getString("quotation_status"));
                quotation.setCreatedBy(rs.getInt("created_by"));
                if (rs.getTimestamp("created_at") != null) {
                    quotation.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }
                quotation.setCustomerName(rs.getString("company_name"));
                quotation.setCreatedByName(rs.getString("user_name"));
                return quotation;
            }
        } catch (Exception e) {
            System.out.println("getQuotationById error: " + e.getMessage());
        }
        return null;
    }

    public List<model.QuotationDetail> getQuotationDetailsByQuotationId(int quotationId) {
        List<model.QuotationDetail> list = new ArrayList<>();
        String sql = "SELECT qd.*, p.product_name "
                + "FROM dbo.quotation_detail qd "
                + "JOIN dbo.product p ON qd.product_id = p.product_id "
                + "WHERE qd.quotation_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.QuotationDetail detail = new model.QuotationDetail();
                detail.setQuotationDetailId(rs.getInt("quotation_detail_id"));
                detail.setQuotationId(rs.getInt("quotation_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setSellingPrice(rs.getBigDecimal("selling_price"));
                detail.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                detail.setTaxPercent(rs.getBigDecimal("tax_percent"));
                detail.setProductName(rs.getString("product_name"));

                // Tính toán amount tạm thời nếu cần (Quantity * SellingPrice)
                // Hoặc bạn có thể để logic này trong service
                list.add(detail);
            }
        } catch (Exception e) {
            System.out.println("getQuotationDetailsByQuotationId error: " + e.getMessage());
        }
        return list;
    }

}

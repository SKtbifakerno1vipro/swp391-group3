package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Quotation;
import model.QuotationHistory;
import java.sql.Statement;
import java.sql.Timestamp;
import model.QuotationDetail;

public class QuotationDAO extends DBContext {

    public List<Quotation> getAllQuotations() {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, quotation.total_price, "
                + "customer.company_name, [user].user_name, "
                + "CAST(CASE WHEN customer_contract.quotation_id IS NOT NULL THEN 1 ELSE 0 END AS BIT) as has_contract, "
                + "customer_contract.customer_contract_id AS contract_id "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "LEFT JOIN customer_contract ON quotation.quotation_id = customer_contract.quotation_id "
                + "ORDER BY quotation.quotation_id ASC";
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
                quotation.setHasContract(rs.getBoolean("has_contract"));
                quotation.setTotalPrice(rs.getBigDecimal("total_price"));
                
                int contractId = rs.getInt("contract_id");
                if (!rs.wasNull()) {
                    quotation.setContractId(contractId);
                }
                
                list.add(quotation);
            }
        } catch (Exception e) {
            System.out.println("getAllQuotations error: " + e.getMessage());
        }
        return list;
    }

    public List<Quotation> searchQuotations(String searchText, String status, String fromDate, String toDate) {
        return searchQuotations(searchText, status, fromDate, toDate, null);
    }

    public List<Quotation> searchQuotations(String searchText, String status, String fromDate, String toDate, Integer customerId) {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, quotation.total_price, "
                + "customer.company_name, [user].user_name, "
                + "CAST(CASE WHEN customer_contract.quotation_id IS NOT NULL THEN 1 ELSE 0 END AS BIT) as has_contract, "
                + "customer_contract.customer_contract_id AS contract_id "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "LEFT JOIN customer_contract ON quotation.quotation_id = customer_contract.quotation_id "
                + "WHERE 1=1 "; // Co dau cach o cuoi

        if (searchText != null && !searchText.trim().isEmpty()) {
            sql += " AND customer.company_name LIKE ? "; // Them dau cach
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND quotation.quotation_status = ? "; // Them dau cach
        }

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql += " AND quotation.quotation_date >= ? ";
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql += " AND quotation.quotation_date <= ? ";
        }

        if (customerId != null) {
            sql += " AND quotation.customer_id = ? ";
        }

        sql += " ORDER BY quotation.quotation_date DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int paramIndex = 1;

            if (searchText != null && !searchText.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchText + "%"); // Dung ++ de tang vi tri
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(paramIndex++, status); // Dung ++ de tang vi tri
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                ps.setString(paramIndex++, fromDate + " 00:00:00");
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                ps.setString(paramIndex++, toDate + " 23:59:59");
            }
            if (customerId != null) {
                ps.setInt(paramIndex++, customerId);
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
                quotation.setHasContract(rs.getBoolean("has_contract"));
                quotation.setTotalPrice(rs.getBigDecimal("total_price"));
                
                int contractId = rs.getInt("contract_id");
                if (!rs.wasNull()) {
                    quotation.setContractId(contractId);
                }
                
                list.add(quotation);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<QuotationHistory> getHistoryByQuotationId(int quotationId) {
        List<QuotationHistory> histories = new ArrayList<>();
        String sql = "SELECT qh.*, u.user_name FROM quotation_history qh "
                   + "LEFT JOIN [user] u ON qh.created_by = u.user_id "
                   + "WHERE qh.quotation_id = ? ORDER BY qh.created_at DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuotationHistory history = new QuotationHistory();
                history.setQuotationHistoryId(rs.getInt("quotation_history_id"));
                history.setQuotationId(rs.getInt("quotation_id"));
                history.setCreatedBy(rs.getInt("created_by"));
                history.setCreatedByName(rs.getString("user_name"));
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
    Tao boi Phu. Ham nay tim quotation theo id.
     */
    public Quotation getQuotationById(int quotationId) {
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, quotation.total_price, "
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
                quotation.setTotalPrice(rs.getBigDecimal("total_price"));
                return quotation;
            }
        } catch (Exception e) {
            System.out.println("getQuotationById error: " + e.getMessage());
        }
        return null;
    }

    public int createQuotation(Quotation quotation) {
        String sql = "INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) "
                + "VALUES (?, ?, ?, ?)";
        try {
            // RETURN_GENERATED_KEYS giup lay ID vua duoc database tu sinh.
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, quotation.getCustomerId());
            ps.setTimestamp(2, Timestamp.valueOf((quotation.getQuotationDate())));
            ps.setString(3, quotation.getQuotationStatus());
            ps.setObject(4, quotation.getCreatedBy());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);

                }

            }
        } catch (Exception e) {
            System.out.println("Create quotation error: " + e.getMessage());
        }
        return -1;
    }

    public boolean addQuotationDetail(QuotationDetail detail) {
        String sql = "INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, cost_price, selling_price, quantity, discount_percent, tax_percent) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            // Gan tung gia tri vao tung dau ? theo dung thu tu.
            ps.setInt(1, detail.getQuotationId());
            ps.setInt(2, detail.getProductId());
            ps.setString(3, detail.getProductName());
            ps.setString(4, detail.getUnit());
            ps.setBigDecimal(5, detail.getCostPrice());
            ps.setBigDecimal(6, detail.getSellingPrice());
            ps.setInt(7, detail.getQuantity());
            ps.setBigDecimal(8, detail.getDiscountPercent());
            ps.setBigDecimal(9, detail.getTaxPercent());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                updateQuotationTotalPrice(detail.getQuotationId());
            }
            return affectedRows > 0;
        } catch (Exception e) {
            System.out.println("addQuotationDetail error: " + e.getMessage());
        }
        return false;
    }

    /*
     * Tim 1 san pham da ton tai trong quotation hay chua.
     * Dung de tranh them trung 2 dong cung product.
     */
    public QuotationDetail getQuotationDetailByProduct(int quotationId, int productId) {
        String sql = "SELECT qd.quotation_detail_id, qd.quotation_id, qd.product_id, qd.quantity, "
                + "qd.discount_percent, qd.tax_percent, "
                + "qd.product_name, qd.unit, qd.cost_price, qd.selling_price "
                + "FROM quotation_detail qd "
                + "WHERE qd.quotation_id = ? AND qd.product_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                QuotationDetail detail = new QuotationDetail();
                detail.setQuotationDetailId(rs.getInt("quotation_detail_id"));
                detail.setQuotationId(rs.getInt("quotation_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setProductName(rs.getString("product_name"));
                detail.setUnit(rs.getString("unit"));
                detail.setCostPrice(rs.getBigDecimal("cost_price"));
                detail.setSellingPrice(rs.getBigDecimal("selling_price"));
                detail.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                detail.setTaxPercent(rs.getBigDecimal("tax_percent"));
                return detail;
            }
        } catch (Exception e) {
            System.out.println("getQuotationDetailByProduct error: " + e.getMessage());
        }

        return null;
    }

    /*
     * Lay danh sach san pham thuoc ve 1 quotation.
     * Mot quotation co the co nhieu dong quotation_detail.
     */
    public List<QuotationDetail> getQuotationDetailsByQuotationId(int quotationId) {
        List<QuotationDetail> details = new ArrayList<>();

        /*
         * Join quotation_detail voi product de lay them product_name.
         * Neu chi lay quotation_detail thi chi co product_id, nguoi dung kho hieu.
         */
        String sql = """
                     SELECT qd.quotation_detail_id,
                            qd.quotation_id, 
                            qd.product_id, 
                            qd.quantity, 
                            qd.discount_percent, 
                            qd.tax_percent, 
                            qd.product_name,
                            qd.unit,
                            qd.cost_price,
                            qd.selling_price
                     FROM quotation_detail qd
                     WHERE qd.quotation_id = ?""";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, quotationId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                QuotationDetail detail = new QuotationDetail();

                detail.setQuotationDetailId(rs.getInt("quotation_detail_id"));
                detail.setQuotationId(rs.getInt("quotation_id"));
                detail.setProductId(rs.getInt("product_id"));
                detail.setQuantity(rs.getInt("quantity"));
                detail.setUnit(rs.getString("unit"));
                detail.setCostPrice(rs.getBigDecimal("cost_price"));
                detail.setSellingPrice(rs.getBigDecimal("selling_price"));
                detail.setDiscountPercent(rs.getBigDecimal("discount_percent"));
                detail.setTaxPercent(rs.getBigDecimal("tax_percent"));
                detail.setProductName(rs.getString("product_name"));

                /*
                 * Tinh thanh tien cho tung dong:
                 * amount = quantity * sellingPrice * (1 - discount/100) * (1 + tax/100)
                 */
                BigDecimal quantity = new BigDecimal(detail.getQuantity());
                BigDecimal subtotal = detail.getSellingPrice().multiply(quantity);
                BigDecimal discountAmount = subtotal.multiply(detail.getDiscountPercent()).divide(new BigDecimal("100"));
                BigDecimal afterDiscount = subtotal.subtract(discountAmount);
                BigDecimal taxAmount = afterDiscount.multiply(detail.getTaxPercent()).divide(new BigDecimal("100"));
                BigDecimal amount = afterDiscount.add(taxAmount);

                detail.setAmount(amount);
                details.add(detail);
            }
        } catch (Exception e) {
            System.out.println("getQuotationDetailsByQuotationId error: " + e.getMessage());
        }

        return details;
    }

    /*
     * Cap nhat 1 dong quotation_detail.
     * Dung khi sales sua quantity, price, discount, tax trong trang detail.
     */
    public boolean updateQuotationDetail(QuotationDetail detail) {
        String sql = "UPDATE quotation_detail "
                + "SET quantity = ?, "
                + "selling_price = ?, "
                + "discount_percent = ?, "
                + "tax_percent = ? "
                + "WHERE quotation_detail_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);

            // Gan gia tri moi vao cau SQL.
            ps.setInt(1, detail.getQuantity());
            ps.setBigDecimal(2, detail.getSellingPrice());
            ps.setBigDecimal(3, detail.getDiscountPercent());
            ps.setBigDecimal(4, detail.getTaxPercent());

            // Dung quotation_detail_id de biet can update dong nao.
            ps.setInt(5, detail.getQuotationDetailId());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                updateQuotationTotalPrice(detail.getQuotationId());
            }
            return affectedRows > 0;
        } catch (Exception e) {
            System.out.println("updateQuotationDetail error: " + e.getMessage());
        }

        return false;
    }

    /*
     * Cap nhat dong loat discount va tax cho toan bo san pham trong quotation.
     */
    public boolean updateDiscountAndTaxForAll(int quotationId, BigDecimal discountPercent, BigDecimal taxPercent) {
        String sql = "UPDATE quotation_detail "
                + "SET discount_percent = ?, tax_percent = ? "
                + "WHERE quotation_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBigDecimal(1, discountPercent);
            ps.setBigDecimal(2, taxPercent);
            ps.setInt(3, quotationId);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                updateQuotationTotalPrice(quotationId);
            }
            return affectedRows > 0;
        } catch (Exception e) {
            System.out.println("updateDiscountAndTaxForAll error: " + e.getMessage());
        }
        return false;
    }

    /*
     * Them 1 dong lich su cho quotation.
     * Dung khi tao moi hoac cap nhat quotation detail.
     */
    public boolean addQuotationHistory(int quotationId, Integer createdBy, String editHistory) {
        String sql = "INSERT INTO quotation_history (quotation_id, created_by, edit_history) "
                + "VALUES (?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId);
            ps.setObject(2, createdBy);
            ps.setString(3, editHistory);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void updateStatus(int quotationId, String status) {
        String sql = "UPDATE quotation SET quotation_status = ? WHERE quotation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, quotationId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // XHieu-begin - delete contact me
    public List<Quotation> getQuotationsByCustomerId(int customerId) {
        List<Quotation> list = new ArrayList<>();
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, quotation.total_price, "
                + "customer.company_name, [user].user_name, "
                + "CAST(CASE WHEN customer_contract.quotation_id IS NOT NULL THEN 1 ELSE 0 END AS BIT) as has_contract, "
                + "customer_contract.customer_contract_id AS contract_id "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "LEFT JOIN customer_contract ON quotation.quotation_id = customer_contract.quotation_id "
                + "WHERE quotation.customer_id = ? "
                + "ORDER BY quotation.quotation_id ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, customerId);
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
                quotation.setHasContract(rs.getBoolean("has_contract"));
                quotation.setTotalPrice(rs.getBigDecimal("total_price"));
                
                int contractId = rs.getInt("contract_id");
                if (!rs.wasNull()) {
                    quotation.setContractId(contractId);
                }
                
                list.add(quotation);
            }
        } catch (Exception e) {
            System.out.println("getQuotationsByCustomerId error: " + e.getMessage());
        }
        return list;
    }

    // Xhieu - end
    /*
     * Xoa 1 dong san pham khoi quotation_detail.
     */
    public boolean deleteQuotationDetail(int quotationDetailId) {
        int quotationId = -1;
        String getQuotationIdSql = "SELECT quotation_id FROM quotation_detail WHERE quotation_detail_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(getQuotationIdSql)) {
            ps.setInt(1, quotationDetailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    quotationId = rs.getInt("quotation_id");
                }
            }
        } catch (Exception e) {
            System.out.println("Error getting quotation_id before delete: " + e.getMessage());
        }

        String sql = "DELETE FROM quotation_detail WHERE quotation_detail_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationDetailId);

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0 && quotationId != -1) {
                updateQuotationTotalPrice(quotationId);
            }
            return affectedRows > 0;
        } catch (Exception e) {
            System.out.println("deleteQuotationDetail error: " + e.getMessage());
        }

        return false;
    }

    public void updateQuotationTotalPrice(int quotationId) {
        String sql = "UPDATE q "
                + "SET q.total_price = COALESCE(("
                + "    SELECT SUM("
                + "        qd.quantity * qd.selling_price * (1.0 - COALESCE(qd.discount_percent, 0.0) / 100.0) * (1.0 + COALESCE(qd.tax_percent, 0.0) / 100.0)"
                + "    ) "
                + "    FROM quotation_detail qd "
                + "    WHERE qd.quotation_id = q.quotation_id"
                + "), 0.00) "
                + "FROM quotation q "
                + "WHERE q.quotation_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quotationId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println("updateQuotationTotalPrice error: " + e.getMessage());
        }
    }

    public boolean hasDraftQuotation(int customerId) {
        String sql = "SELECT COUNT(*) FROM quotation WHERE customer_id = ? AND quotation_status = 'DRAFT'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.out.println("hasDraftQuotation error: " + e.getMessage());
        }
        return false;
    }
}

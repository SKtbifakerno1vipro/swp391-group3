package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Invoice;
import dto.InvoiceItemDTO;

public class InvoiceDAO extends DBContext {

    public String getNextInvoiceNo(int year) {
        String sql = "SELECT MAX(invoice_no) as max_no FROM invoice WHERE YEAR(issue_date) = ? AND invoice_no LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String maxNo = rs.getString("max_no");
                    if (maxNo != null && maxNo.matches("^\\d{8}$")) {
                        int nextVal = Integer.parseInt(maxNo) + 1;
                        return String.format("%08d", nextVal);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("getNextInvoiceNo error: " + e.getMessage());
        }
        return "00000001";
    }

    public String validateInvoice(Invoice invoice, String phone) {
        // Validate Invoice No if set manually
        if (!"UNRELEASED".equals(invoice.getInvoiceStatus())) {
            String invoiceNo = invoice.getInvoiceNo();
            if (invoiceNo != null && !invoiceNo.trim().isEmpty() && !invoiceNo.equals("0") && !invoiceNo.startsWith("INV-")) {
                if (!invoiceNo.matches("^\\d{8}$")) {
                    return "Số hóa đơn phải là số gồm đúng 8 chữ số!";
                }
            }
        }

        // Validate Tax Code (Reference: Validation.validateTaxCode)
        String taxCode = invoice.getBuyerTaxCode();
        if (taxCode == null || taxCode.trim().isEmpty()) {
            return "Mã số thuế người mua không được để trống!";
        }
        String trimmedTax = taxCode.trim();
        if (!trimmedTax.matches("^\\d{10}$") && !trimmedTax.matches("^\\d{10}-\\d{3}$")) {
            return "Mã số thuế không đúng định dạng (Phải gồm 10 số hoặc 13 số dạng XXXXXXXXXX-XXX)!";
        }

        // Validate Phone (Reference: Validation.validatePhone)
        if (phone == null || phone.trim().isEmpty()) {
            return "Số điện thoại người mua không được để trống!";
        }
        String trimmedPhone = phone.trim();
        if (!trimmedPhone.matches("^\\d{10}$")) {
            return "Số điện thoại không đúng định dạng (Phải gồm đúng 10 chữ số)!";
        }

        return null; // Valid
    }

    public boolean insertInvoice(Invoice invoice) {
        // Generate invoice_symbol based on invoice_type and year
        String type = invoice.getInvoiceType();
        int year = (invoice.getIssueDate() != null) ? invoice.getIssueDate().getYear() : java.time.LocalDate.now().getYear();
        String yy = String.format("%02d", year % 100);
        String symbol = ("VAT".equalsIgnoreCase(type) ? "1K" : "2K") + yy + "TYY";
        invoice.setInvoiceSymbol(symbol);

        // Auto-generate invoice_no if empty/invalid/default (only for non-draft invoices)
        if (!"UNRELEASED".equals(invoice.getInvoiceStatus())) {
            if (invoice.getInvoiceNo() == null || invoice.getInvoiceNo().trim().isEmpty() 
                    || invoice.getInvoiceNo().equals("0")
                    || !invoice.getInvoiceNo().matches("^\\d{8}$")) {
                invoice.setInvoiceNo(getNextInvoiceNo(year));
            }
        }
        String sql = "INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, "
                + "invoice_type, invoice_symbol, seller_name, seller_tax_code, seller_address, seller_phone, "
                + "buyer_name, buyer_tax_code, buyer_address, sub_total, tax_amount, total_amount, customer_note, internal_note, created_by, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, invoice.getCustomerContractId());
            ps.setInt(2, invoice.getCustomerOrderId());
            ps.setString(3, invoice.getInvoiceNo());
            ps.setTimestamp(4, invoice.getIssueDate() != null ? Timestamp.valueOf(invoice.getIssueDate()) : null);
            ps.setString(5, invoice.getInvoiceStatus());
            ps.setString(6, invoice.getInvoiceType());
            ps.setString(7, invoice.getInvoiceSymbol());
            
            ps.setString(8, invoice.getSellerName());
            ps.setString(9, invoice.getSellerTaxCode());
            ps.setString(10, invoice.getSellerAddress());
            ps.setString(11, invoice.getSellerPhone());
            
            ps.setString(12, invoice.getBuyerName());
            ps.setString(13, invoice.getBuyerTaxCode());
            ps.setString(14, invoice.getBuyerAddress());
            
            ps.setBigDecimal(15, invoice.getSubTotal());
            ps.setBigDecimal(16, invoice.getTaxAmount());
            ps.setBigDecimal(17, invoice.getTotalAmount());
            
            ps.setString(18, invoice.getCustomerNote());
            ps.setString(19, invoice.getInternalNote());
            
            if (invoice.getCreatedBy() != null) {
                ps.setInt(20, invoice.getCreatedBy());
            } else {
                ps.setNull(20, Types.INTEGER);
            }

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        invoice.setInvoiceId(generatedKeys.getInt(1));
                        return true;
                    }
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM invoice ORDER BY invoice_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToInvoice(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoices(int totalRow, int page, int totalPage, int pageSize) {
        return getInvoices(null, null, null, null, null, totalRow, page, totalPage, pageSize);
    }

    public List<Invoice> getInvoices(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate, int totalRow, int page, int totalPage, int pageSize) {
        List<Invoice> list = new ArrayList<>();
        try {
            String sql = "select * from invoice WHERE 1 = 1";
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                sql += " and buyer_name LIKE ?";
            }
            if (status != null && !status.trim().isEmpty()) {
                sql += " and invoice_status = ?";
            }
            if (type != null && !type.trim().isEmpty()) {
                sql += " and invoice_type = ?";
            }
            if (startDate != null) {
                sql += " and issue_date >= ?";
            }
            if (endDate != null) {
                sql += " and issue_date <= ?";
            }
            
            sql += " \n order by invoice_id desc";

            if ((page > 0 && page <= totalPage) && totalRow > 0) {
                sql += """
                   \n offset ? rows
                   fetch next ? rows only
                   """;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                ps.setString(index++, "%" + searchBuyerName.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(index++, type);
            }
            if (startDate != null) {
                ps.setTimestamp(index++, Timestamp.valueOf(startDate));
            }
            if (endDate != null) {
                ps.setTimestamp(index++, Timestamp.valueOf(endDate));
            }

            if ((page > 0 && page <= totalPage) && totalRow > 0) {
                ps.setInt(index++, (int) ((page - 1) * pageSize));
                ps.setInt(index++, pageSize);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Invoice invoice = mapResultSetToInvoice(rs);
                list.add(invoice);
            }
        } catch (Exception e) {
            System.out.println("getInvoices error: " + e.getMessage());
        }
        return list;
    }

    public int countInvoices() {
        return countInvoices(null, null, null, null, null);
    }

    public int countInvoices(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate) {
        try {
            String sql = "select COUNT(*) as total from invoice WHERE 1 = 1";
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                sql += " and buyer_name LIKE ?";
            }
            if (status != null && !status.trim().isEmpty()) {
                sql += " and invoice_status = ?";
            }
            if (type != null && !type.trim().isEmpty()) {
                sql += " and invoice_type = ?";
            }
            if (startDate != null) {
                sql += " and issue_date >= ?";
            }
            if (endDate != null) {
                sql += " and issue_date <= ?";
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                ps.setString(index++, "%" + searchBuyerName.trim() + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            if (type != null && !type.trim().isEmpty()) {
                ps.setString(index++, type);
            }
            if (startDate != null) {
                ps.setTimestamp(index++, Timestamp.valueOf(startDate));
            }
            if (endDate != null) {
                ps.setTimestamp(index++, Timestamp.valueOf(endDate));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println("countInvoices error: " + e.getMessage());
        }
        return 0;
    }

    public Invoice getInvoiceById(int id) {
        String sql = "SELECT * FROM invoice WHERE invoice_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToInvoice(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Invoice getInvoiceByOrderId(int orderId) {
        String sql = "SELECT * FROM invoice WHERE customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToInvoice(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Invoice> getInvoicesByContractId(int contractId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM invoice WHERE customer_contract_id = ? ORDER BY invoice_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToInvoice(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoicesByOrderId(int orderId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM invoice WHERE customer_order_id = ? ORDER BY invoice_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToInvoice(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateInvoiceStatus(int id, String status) {
        String sql = "UPDATE invoice SET invoice_status = ? WHERE invoice_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Invoice mapResultSetToInvoice(ResultSet rs) throws Exception {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(rs.getInt("invoice_id"));
        invoice.setCustomerContractId(rs.getInt("customer_contract_id"));
        invoice.setCustomerOrderId(rs.getInt("customer_order_id"));
        invoice.setInvoiceNo(rs.getString("invoice_no"));
        
        if (rs.getTimestamp("issue_date") != null) {
            invoice.setIssueDate(rs.getTimestamp("issue_date").toLocalDateTime());
        }
        
        invoice.setInvoiceStatus(rs.getString("invoice_status"));
        invoice.setInvoiceType(rs.getString("invoice_type"));
        invoice.setInvoiceSymbol(rs.getString("invoice_symbol"));
        
        invoice.setSellerName(rs.getString("seller_name"));
        invoice.setSellerTaxCode(rs.getString("seller_tax_code"));
        invoice.setSellerAddress(rs.getString("seller_address"));
        invoice.setSellerPhone(rs.getString("seller_phone"));
        
        invoice.setBuyerName(rs.getString("buyer_name"));
        invoice.setBuyerTaxCode(rs.getString("buyer_tax_code"));
        invoice.setBuyerAddress(rs.getString("buyer_address"));
        
        invoice.setSubTotal(rs.getBigDecimal("sub_total"));
        invoice.setTaxAmount(rs.getBigDecimal("tax_amount"));
        invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
        
        invoice.setCustomerNote(rs.getString("customer_note"));
        invoice.setInternalNote(rs.getString("internal_note"));
        
        invoice.setCreatedBy(rs.getObject("created_by") != null ? rs.getInt("created_by") : null);
        
        if (rs.getTimestamp("created_at") != null) {
            invoice.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        
        return invoice;
    }

    public boolean updateInvoice(Invoice invoice) {
        String sql = "UPDATE invoice SET "
                + "invoice_no = ?, issue_date = ?, invoice_status = ?, invoice_type = ?, invoice_symbol = ?, "
                + "buyer_name = ?, buyer_tax_code = ?, buyer_address = ?, "
                + "customer_note = ?, internal_note = ?, seller_phone = ? "
                + "WHERE invoice_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, invoice.getInvoiceNo());
            ps.setTimestamp(2, invoice.getIssueDate() != null ? Timestamp.valueOf(invoice.getIssueDate()) : null);
            ps.setString(3, invoice.getInvoiceStatus());
            ps.setString(4, invoice.getInvoiceType());
            ps.setString(5, invoice.getInvoiceSymbol());
            
            ps.setString(6, invoice.getBuyerName());
            ps.setString(7, invoice.getBuyerTaxCode());
            ps.setString(8, invoice.getBuyerAddress());
            
            ps.setString(9, invoice.getCustomerNote());
            ps.setString(10, invoice.getInternalNote());
            ps.setString(11, invoice.getSellerPhone());
            ps.setInt(12, invoice.getInvoiceId());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<InvoiceItemDTO> getInvoiceItemsByOrderId(int orderId) {
        List<InvoiceItemDTO> list = new ArrayList<>();
        String sql = "SELECT qd.product_id, qd.product_name, qd.unit, cod.quantity, qd.selling_price, "
                + "qd.discount_percent, qd.tax_percent "
                + "FROM customer_order_detail cod "
                + "JOIN quotation_detail qd ON cod.quotation_detail_id = qd.quotation_detail_id "
                + "WHERE cod.customer_order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    String productName = rs.getString("product_name");
                    String unit = rs.getString("unit");
                    int quantity = rs.getInt("quantity");
                    double sellingPrice = rs.getDouble("selling_price");
                    double discountPercent = rs.getDouble("discount_percent");
                    double taxPercent = rs.getDouble("tax_percent");

                    // Tính toán các giá trị tiền trên từng dòng sản phẩm
                    double lineAmount = Double.parseDouble(String.format("%.2f", quantity * sellingPrice));
                    double lineDiscount = Double.parseDouble(String.format("%.2f", lineAmount * (discountPercent / 100.0)));
                    double lineTax = Double.parseDouble(String.format("%.2f", (lineAmount - lineDiscount) * (taxPercent / 100.0)));
                    double lineTotal = Double.parseDouble(String.format("%.2f", lineAmount - lineDiscount + lineTax));

                    InvoiceItemDTO item = new InvoiceItemDTO(
                        productId, productName, unit, quantity, sellingPrice,
                        discountPercent, taxPercent, lineDiscount, lineTax
                    );
                    item.setLineAmount(lineAmount);
                    item.setLineTotal(lineTotal);

                    list.add(item);
                }
            }
        } catch (Exception e) {
            System.out.println("getInvoiceItemsByOrderId error: " + e.getMessage());
        }
        return list;
    }
}

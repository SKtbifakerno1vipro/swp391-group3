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
import java.sql.SQLException;
import service.CustomerService;

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

    public String validateInvoice(Invoice invoice) {
        CustomerService cService = new CustomerService();
        if ("RELEASED".equals(invoice.getInvoiceStatus())) {
            String invoiceNo = invoice.getInvoiceNo();
            if (invoiceNo != null && !invoiceNo.trim().isEmpty() && !invoiceNo.equals("0") && !invoiceNo.startsWith("INV-")) {
                if (!invoiceNo.matches("^\\d{8}$")) {
                    return "Số hóa đơn phải là số gồm đúng 8 chữ số!";
                }
            }
        }
        
        String taxCode = invoice.getBuyerTaxCode();
        if (taxCode == null || taxCode.trim().isEmpty()) {
            return "Mã số thuế người mua không được để trống!";
        }
        
        String trimmedTax = taxCode.trim();
        if (!trimmedTax.matches("^\\d{10}$") && !trimmedTax.matches("^\\d{10}-\\d{3}$")) {
            return "Mã số thuế không đúng định dạng (Phải gồm 10 số hoặc 13 số dạng XXXXXXXXXX-XXX)!";
        }
        String phone = invoice.getBuyerPhone();
        if (phone == null || phone.trim().isEmpty()) {
            return "Số điện thoại người mua không được để trống!";
        }
        String trimmedPhone = phone.trim();
        if (!trimmedPhone.matches("^\\d{10}$")) {
            return "Số điện thoại không đúng định dạng (Phải gồm đúng 10 chữ số)!";
        }

        String symbol = invoice.getInvoiceSymbol();
        if (symbol == null || symbol.trim().isEmpty()) {
            return "Ký hiệu hóa đơn không được để trống!";
        }
        String trimmedSymbol = symbol.trim().toUpperCase();
        if (!trimmedSymbol.matches("^(1K|2K)\\d{2}TYY$")) {
            return "Ký hiệu hóa đơn không đúng định dạng (Phải có dạng 1K[năm]TYY cho VAT hoặc 2K[năm]TYY cho loại khác)!";
        }
        String type = invoice.getInvoiceType();
        String expectedPrefix = "VAT".equalsIgnoreCase(type) ? "1K" : "2K";
        if (!trimmedSymbol.startsWith(expectedPrefix)) {
            return "Ký hiệu hóa đơn không khớp với loại hóa đơn (Loại " + (type != null ? type : "chưa xác định") + " phải bắt đầu bằng " + expectedPrefix + ")!";
        }
        int year = (invoice.getIssueDate() != null) ? invoice.getIssueDate().getYear() : java.time.LocalDate.now().getYear();
        String yy = String.format("%02d", year % 100);
        if (!trimmedSymbol.substring(2, 4).equals(yy)) {
            return "Ký hiệu hóa đơn không khớp với năm phát hành (Phải chứa năm '" + yy + "')!";
        }

        return null; 
    }

    public boolean insertInvoice(Invoice invoice) {
        String type = invoice.getInvoiceType();
        int year = (invoice.getIssueDate() != null) ? invoice.getIssueDate().getYear() : java.time.LocalDate.now().getYear();
        String yy = String.format("%02d", year % 100);
        String symbol = ("VAT".equalsIgnoreCase(type) ? "1K" : "2K") + yy + "TYY";
        invoice.setInvoiceSymbol(symbol);

        if (!"UNRELEASED".equals(invoice.getInvoiceStatus())) {
            if (invoice.getInvoiceNo() == null || invoice.getInvoiceNo().trim().isEmpty()
                    || invoice.getInvoiceNo().equals("0")
                    || !invoice.getInvoiceNo().matches("^\\d{8}$")) {
                invoice.setInvoiceNo(getNextInvoiceNo(year));
            }
        }
        String sql = "INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, "
                + "invoice_type, invoice_symbol, seller_name, seller_tax_code, seller_address, seller_phone, "
                + "buyer_name, buyer_tax_code, buyer_address, buyer_phone, total_amount, customer_note, internal_note, created_by, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
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
            ps.setString(15, invoice.getBuyerPhone());

            ps.setDouble(16, invoice.getTotalAmount());

            ps.setString(17, invoice.getCustomerNote());
            ps.setString(18, invoice.getInternalNote());

            if (invoice.getCreatedBy() != null) {
                ps.setInt(19, invoice.getCreatedBy());
            } else {
                ps.setNull(19, Types.INTEGER);
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

    public List<Invoice> getInvoices(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate, int totalRow, int page, int totalPage, int pageSize, boolean forCustomer, int userId) {
        List<Invoice> list = new ArrayList<>();
        try {
            String sql = "select iv.*, cc.contract_number from invoice iv"
                    + " left join customer_contract cc on iv.customer_contract_id = cc.customer_contract_id";
            if (forCustomer) {
                sql += " join customer_order co on iv.customer_order_id = co.customer_order_id"
                        + " join customer c on co.customer_id = c.customer_id";
            }
            sql += " WHERE 1 = 1";
            if (forCustomer && userId > 0) {
                sql += " and c.user_id = ? and iv.invoice_status = 'RELEASED'";
            }
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                searchBuyerName = searchBuyerName.trim();
                searchBuyerName = searchBuyerName.replaceAll("\\s+", " ");
                sql += " and (iv.buyer_name LIKE ? OR iv.invoice_no LIKE ? OR iv.buyer_tax_code LIKE ? OR iv.buyer_phone LIKE ? OR cc.contract_number LIKE ?)";
            }
            if (status != null && !status.trim().isEmpty()) {
                status = status.trim();
                status = status.replaceAll("\\s+", " ");
                sql += " and iv.invoice_status = ?";
            }
            if (type != null && !type.trim().isEmpty()) {
                type = type.trim();
                type = type.replaceAll("\\s+", " ");
                sql += " and iv.invoice_type = ?";
            }
            if (startDate != null) {
                sql += " and iv.issue_date >= ?";
            }
            if (endDate != null) {
                sql += " and iv.issue_date <= ?";
            }

            sql += " \n order by iv.invoice_id desc";

            if ((page > 0 && page <= totalPage) && totalRow > 0) {
                sql += """
                   \n offset ? rows
                   fetch next ? rows only
                   """;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (forCustomer && userId > 0) {
                ps.setInt(index++, userId);
            }
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                String searchLike = "%" + searchBuyerName.trim() + "%";
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
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
            e.printStackTrace();
        }
        return list;
    }

    public int countInvoices(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate, boolean forCustomer, int userId) {
        try {
            String sql = "select COUNT(iv.invoice_id) as total from invoice iv"
                    + " left join customer_contract cc on iv.customer_contract_id = cc.customer_contract_id";
            if (forCustomer) {
                sql += " join customer_order co on iv.customer_order_id = co.customer_order_id"
                        + " join customer c on co.customer_id = c.customer_id";
            }
            sql += " WHERE 1 = 1";
            if (forCustomer) {
                sql += " and c.user_id = ?";
            }
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                sql += " and (iv.buyer_name LIKE ? OR iv.invoice_no LIKE ? OR iv.buyer_tax_code LIKE ? OR iv.buyer_phone LIKE ? OR cc.contract_number LIKE ?)";
            }
            if (status != null && !status.trim().isEmpty()) {
                sql += " and iv.invoice_status = ?";
            }
            if (type != null && !type.trim().isEmpty()) {
                sql += " and iv.invoice_type = ?";
            }
            if (startDate != null) {
                sql += " and iv.issue_date >= ?";
            }
            if (endDate != null) {
                sql += " and iv.issue_date <= ?";
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (forCustomer) {
                ps.setInt(index++, userId);
            }
            if (searchBuyerName != null && !searchBuyerName.trim().isEmpty()) {
                String searchLike = "%" + searchBuyerName.trim() + "%";
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
                ps.setString(index++, searchLike);
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
            e.printStackTrace();
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

    public Invoice getInvoiceByContractId(int contractId) {
        String sql = "SELECT TOP 1 * FROM invoice WHERE customer_contract_id = ? ORDER BY invoice_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
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
        invoice.setBuyerPhone(rs.getString("buyer_phone"));

        invoice.setTotalAmount(rs.getDouble("total_amount"));

        invoice.setCustomerNote(rs.getString("customer_note"));
        invoice.setInternalNote(rs.getString("internal_note"));

        invoice.setCreatedBy(rs.getObject("created_by") != null ? rs.getInt("created_by") : null);

        if (rs.getTimestamp("created_at") != null) {
            invoice.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        }
        try {
            int colIdx = rs.findColumn("updated_at");
            if (colIdx > 0 && rs.getTimestamp(colIdx) != null) {
                invoice.setUpdatedAt(rs.getTimestamp(colIdx).toLocalDateTime());
            }
        } catch (SQLException e) {
            System.out.println("error getInvoice: updateAt column");
        }
        try {
            int colIdx = rs.findColumn("contract_number");
            if (colIdx > 0) {
                invoice.setContractNo(rs.getString(colIdx));
            }
        } catch (SQLException e) {
            System.out.println("error getInvoice: contract_number column");
        }

        return invoice;
    }

    public boolean updateInvoice(Invoice invoice) {
        String sql = "UPDATE invoice SET "
                + "invoice_no = ?, issue_date = ?, invoice_status = ?, invoice_type = ?, invoice_symbol = ?, "
                + "buyer_name = ?, buyer_tax_code = ?, buyer_address = ?, "
                + "customer_note = ?, internal_note = ?, seller_phone = ?, "
                + "updated_at = GETDATE() "
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

    public List<Invoice> getInvoicesSince(Timestamp sinceTime, Integer customerUserId) {
        List<Invoice> list = new ArrayList<>();
        String sql = 
                "SELECT iv.* "
                + "FROM invoice iv "
                + "JOIN customer_order co ON iv.customer_order_id = co.customer_order_id "
                + "JOIN customer c ON co.customer_id = c.customer_id "
                + "WHERE (iv.created_at > ? OR iv.updated_at > ? OR iv.issue_date > ?) ";

        if (customerUserId != null) {
            sql += ("AND c.user_id = ? AND iv.invoice_status = 'RELEASED' ");
        }
        sql+=("ORDER BY iv.created_at ASC, iv.updated_at ASC, iv.issue_date ASC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setTimestamp(1, sinceTime);
            ps.setTimestamp(2, sinceTime);
            ps.setTimestamp(3, sinceTime);
            if (customerUserId != null) {
                ps.setInt(4, customerUserId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToInvoice(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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

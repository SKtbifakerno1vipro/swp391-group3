package tool;

import dal.DBContext;
import dto.CustomerDTO;
import dto.UserRoleDTO;
import model.Customer;
import model.Product;
import model.Quotation;
import model.QuotationDetail;
import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.UUID;
import java.math.BigDecimal;

public class ToolDAO extends DBContext implements AutoCloseable {

    public ToolDAO() {
        super();
    }

    public List<CustomerDTO> getAllCustomers() throws SQLException {
        List<CustomerDTO> list = new ArrayList<>();
        String sql = "SELECT c.customer_id, c.company_name, c.user_id FROM customer c JOIN [user] u ON c.user_id = u.user_id";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer cObj = new Customer();
                cObj.setCustomerId(rs.getInt("customer_id"));
                cObj.setCompanyName(rs.getString("company_name"));
                cObj.setUserId(rs.getInt("user_id"));
                
                CustomerDTO dto = new CustomerDTO();
                dto.setCustomer(cObj);
                list.add(dto);
            }
        }
        return list;
    }

    public List<Product> getAllActiveProducts() throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT product_id, product_name, unit, selling_price, cost_price FROM product WHERE product_status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setUnit(rs.getString("unit"));
                p.setSellingPrice(rs.getDouble("selling_price"));
                p.setCostPrice(rs.getDouble("cost_price"));
                list.add(p);
            }
        }
        return list;
    }

    public List<UserRoleDTO> getAllActiveManagers() throws SQLException {
        List<UserRoleDTO> list = new ArrayList<>();
        String sql = "SELECT u.user_id, u.full_name, u.user_name FROM [user] u WHERE u.role_id = 2 AND u.account_status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserRoleDTO dto = new UserRoleDTO();
                dto.setUserId(rs.getInt("user_id"));
                dto.setFullName(rs.getString("full_name"));
                dto.setUserName(rs.getString("user_name"));
                list.add(dto);
            }
        }
        return list;
    }

    public CustomerDTO getCustomerById(int customerId) throws SQLException {
        String sql = "SELECT c.customer_id, c.company_name, c.tax_code, u.full_name, u.phone, u.email, u.user_id " +
                     "FROM customer c JOIN [user] u ON c.user_id = u.user_id WHERE c.customer_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer cObj = new Customer();
                    cObj.setCustomerId(rs.getInt("customer_id"));
                    cObj.setCompanyName(rs.getString("company_name"));
                    cObj.setTaxCode(rs.getString("tax_code"));
                    cObj.setUserId(rs.getInt("user_id"));
                    
                    CustomerDTO dto = new CustomerDTO();
                    dto.setCustomer(cObj);
                    
                    User uObj = new User();
                    uObj.setUserId(rs.getInt("user_id"));
                    uObj.setFullName(rs.getString("full_name"));
                    uObj.setPhone(rs.getString("phone"));
                    uObj.setEmail(rs.getString("email"));
                    dto.setUser(uObj);
                    return dto;
                }
            }
        }
        return null;
    }

    public User getManagerById(int managerId) throws SQLException {
        String sql = "SELECT user_id, full_name, user_name FROM [user] WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setFullName(rs.getString("full_name"));
                    u.setUserName(rs.getString("user_name"));
                    return u;
                }
            }
        }
        return null;
    }

    public Product getProductById(int productId) throws SQLException {
        String sql = "SELECT product_id, product_name, unit, selling_price, cost_price FROM product WHERE product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setUnit(rs.getString("unit"));
                    p.setSellingPrice(rs.getDouble("selling_price"));
                    p.setCostPrice(rs.getDouble("cost_price"));
                    return p;
                }
            }
        }
        return null;
    }

    /**
     * Executes the entire database creation pipeline (Quotation, Details, Contract, History, Signature)
     * in a single ACID transaction.
     */
    public PipelineResult runCreationPipeline(int customerId, int managerId, CustomerDTO customerDTO, 
                                             User managerUser, List<QuotationDetail> details, 
                                             String template, Properties config) throws SQLException {
        
        boolean originalAutoCommit = connection.getAutoCommit();
        try {
            connection.setAutoCommit(false);

            // Calculate total price of details first
            BigDecimal totalPrice = BigDecimal.ZERO;
            for (QuotationDetail detail : details) {
                BigDecimal qty = new BigDecimal(detail.getQuantity());
                BigDecimal price = detail.getSellingPrice() != null ? detail.getSellingPrice() : BigDecimal.ZERO;
                BigDecimal taxFactor = BigDecimal.ONE.add(detail.getTaxPercent().divide(BigDecimal.valueOf(100)));
                BigDecimal discountFactor = BigDecimal.ONE.subtract(detail.getDiscountPercent().divide(BigDecimal.valueOf(100)));
                BigDecimal itemTotal = price.multiply(qty).multiply(taxFactor).multiply(discountFactor);
                totalPrice = totalPrice.add(itemTotal);
            }

            // 1. Insert Quotation
            int quotationId = -1;
            String sqlQuotation = "INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by, total_price) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(sqlQuotation, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
                ps.setString(3, "ACCEPTED");
                ps.setInt(4, managerId);
                ps.setBigDecimal(5, totalPrice);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        quotationId = rs.getInt(1);
                    }
                }
            }

            if (quotationId <= 0) {
                throw new SQLException("Failed to retrieve generated Quotation ID.");
            }

            // 2. Insert Quotation Details
            String sqlDetail = "INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, cost_price, selling_price, quantity, discount_percent, tax_percent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = connection.prepareStatement(sqlDetail)) {
                for (QuotationDetail detail : details) {
                    ps.setInt(1, quotationId);
                    ps.setInt(2, detail.getProductId());
                    ps.setString(3, detail.getProductName());
                    ps.setString(4, detail.getUnit());
                    ps.setBigDecimal(5, detail.getCostPrice());
                    ps.setBigDecimal(6, detail.getSellingPrice());
                    ps.setInt(7, detail.getQuantity());
                    ps.setBigDecimal(8, detail.getDiscountPercent());
                    ps.setBigDecimal(9, detail.getTaxPercent());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // 3. Compile template locally
            Quotation tempQ = new Quotation();
            tempQ.setQuotationId(quotationId);
            tempQ.setQuotationDate(LocalDateTime.now());
            String contractContent = fillTemplateLocally(tempQ, customerDTO, details, template, config);

            // 4. Generate contract metadata
            String year = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy"));
            String contractNumber = String.format("%03d", quotationId) + "/" + year + "-HĐ";
            String token = UUID.randomUUID().toString();

            // 5. Insert Contract
            int contractId = -1;
            String sqlContract = "INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_status, contract_content, storage_type, created_by, token, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
            try (PreparedStatement ps = connection.prepareStatement(sqlContract, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setInt(2, quotationId);
                ps.setString(3, contractNumber);
                ps.setString(4, "APPROVED");
                ps.setString(5, contractContent);
                ps.setString(6, "TEXT");
                ps.setInt(7, managerId);
                ps.setString(8, token);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        contractId = rs.getInt(1);
                    }
                }
            }

            if (contractId <= 0) {
                throw new SQLException("Failed to retrieve generated Contract ID.");
            }

            // 6. Insert Contract History
            String sqlHistory = "INSERT INTO contract_edit_history (contract_id, from_status, to_status, note, changed_by, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
            try (PreparedStatement ps = connection.prepareStatement(sqlHistory)) {
                ps.setInt(1, contractId);
                ps.setString(2, "DRAFT");
                ps.setString(3, "APPROVED");
                ps.setString(4, "Hợp đồng được tạo tự động qua Tool và được Manager duyệt sẵn.");
                ps.setInt(5, managerId);
                ps.executeUpdate();
            }

            // 7. Generate signature filename
            String sigFileName = "Manager_" + managerUser.getFullName() + "_" + contractNumber;
            sigFileName = standardFileNameLocally(sigFileName) + "_" + System.currentTimeMillis() + ".png";

            // 8. Insert Signature
            String sqlSignature = "INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at) VALUES (?, ?, ?, ?, ?, GETDATE(), ?, GETDATE())";
            try (PreparedStatement ps = connection.prepareStatement(sqlSignature)) {
                ps.setInt(1, contractId);
                ps.setString(2, sigFileName);
                ps.setString(3, sigFileName);
                ps.setInt(4, managerId);
                ps.setString(5, managerUser.getFullName());
                ps.setInt(6, managerId);
                ps.executeUpdate();
            }

            connection.commit();
            
            PipelineResult result = new PipelineResult();
            result.quotationId = quotationId;
            result.contractId = contractId;
            result.sigFileName = sigFileName;
            return result;
            
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(originalAutoCommit);
        }
    }

    private String fillTemplateLocally(Quotation q, CustomerDTO cust, List<QuotationDetail> details,
            String template, Properties config) {

        template = template.replace("{customer_name}",
                cust.getCustomer().getCompanyName() != null ? cust.getCustomer().getCompanyName() : "");
        template = template.replace("{customer_address}",
                cust.getUser().getAddress() != null ? cust.getUser().getAddress() : "");
        template = template.replace("{customer_phone}",
                cust.getUser().getPhone() != null ? cust.getUser().getPhone() : "");
        template = template.replace("{customer_tax}",
                cust.getCustomer().getTaxCode() != null ? cust.getCustomer().getTaxCode() : "");
        template = template.replace("{user_full_name}",
                cust.getUser().getFullName() != null ? cust.getUser().getFullName() : "");
        template = template.replace("{tax_code_B}",
                cust.getCustomer().getTaxCode() != null ? cust.getCustomer().getTaxCode() : "");

        template = template.replace("{company_name}",
                config.getProperty("company_name", ""));
        template = template.replace("{company_address}",
                config.getProperty("company_address", ""));
        template = template.replace("{company_phone}",
                config.getProperty("company_phone", ""));
        template = template.replace("{company_tax}",
                config.getProperty("company_tax_code", ""));
        template = template.replace("{company_rep}",
                config.getProperty("company_rep_name", ""));
        template = template.replace("{company_position}",
                config.getProperty("company_position", ""));
        template = template.replace("{tax_code_A}",
                config.getProperty("tax_code", ""));

        StringBuilder productRows = new StringBuilder();
        int index = 1;

        BigDecimal total = BigDecimal.ZERO;
        if (details != null && !details.isEmpty()) {
            for (QuotationDetail item : details) {
                BigDecimal qty = new BigDecimal(item.getQuantity());
                BigDecimal price = item.getSellingPrice() != null
                        ? item.getSellingPrice() : BigDecimal.ZERO;
                BigDecimal subtotal = price.multiply(qty);

                productRows.append("<tr>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:center;'>").append(index++).append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px;'>").append(item.getProductName() != null ? item.getProductName() : "").append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:center;'>").append(item.getUnit() != null ? item.getUnit() : "").append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:center;'>").append(item.getQuantity()).append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:right;'>")
                        .append(String.format("%,.0f", price)).append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:right;'>")
                        .append(String.format("%,.0f", subtotal)).append("</td>")
                        .append("</tr>");

                BigDecimal taxFactor = BigDecimal.ONE.add(item.getTaxPercent().divide(BigDecimal.valueOf(100)));
                BigDecimal discountFactor = BigDecimal.ONE.subtract(item.getDiscountPercent().divide(BigDecimal.valueOf(100)));
                BigDecimal itemTotal = price.multiply(qty).multiply(taxFactor).multiply(discountFactor);
                total = total.add(itemTotal);
            }
        } else {
            productRows.append("<tr><td colspan='6' style='text-align:center;'>No products found</td></tr>");
        }
        template = template.replace("{product_list}", productRows.toString());

        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        template = template.replace("{sign_date}", LocalDate.now().format(fmt));

        LocalDate effective = (q.getQuotationDate() != null)
                ? q.getQuotationDate().toLocalDate()
                : LocalDate.now();

        template = template.replace("{effective_date}", effective.format(fmt));
        template = template.replace("{end_date}", effective.plusYears(1).format(fmt));

        String year = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy"));
        String newContractNumber = String.format("%03d", q.getQuotationId()) + "/" + year + "-HĐ";
        template = template.replace("{contract_number}", newContractNumber);

        template = template.replace("{total_amount}", String.format("%,.0f", total));

        return template;
    }

    private String standardFileNameLocally(String value) {
        if (value == null) {
            return "signature_";
        }
        String result = value.trim().replaceAll("[\\s+]", "_");
        result = result.replaceAll("[\\\\/:*?\"<>|]", "");
        return result;
    }

    @Override
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("[ToolDAO] Connection closed successfully via AutoCloseable.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static class PipelineResult {
        public int quotationId;
        public int contractId;
        public String sigFileName;
    }
}

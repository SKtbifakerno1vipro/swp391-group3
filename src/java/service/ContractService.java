package service;

import model.*;
import dto.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import dal.*;

public class ContractService {

    private final ContractDAO contractDAO = new ContractDAO();

    public String fillTemplate(Quotation q, CustomerDTO cust, List<QuotationDetail> details,
            String template, Properties config) {

        template = template.replace("{customer_name}",
                cust.getCompanyName() != null ? cust.getCompanyName() : "");
        template = template.replace("{customer_address}",
                cust.getAddress() != null ? cust.getAddress() : "");
        template = template.replace("{customer_phone}",
                cust.getPhone() != null ? cust.getPhone() : "");
        template = template.replace("{customer_tax}",
                cust.getTaxCode() != null ? cust.getTaxCode() : "");

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

        StringBuilder productRows = new StringBuilder();
        int stt = 1;
        Locale locale = Locale.US;

        if (details != null && !details.isEmpty()) {
            for (QuotationDetail item : details) {
                BigDecimal qty = new BigDecimal(item.getQuantity());
                BigDecimal price = item.getSellingPrice() != null
                        ? item.getSellingPrice() : BigDecimal.ZERO;
                BigDecimal subtotal = price.multiply(qty);

                productRows.append("<tr>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:center;'>").append(stt++).append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px;'>").append(item.getProductName() != null ? item.getProductName() : "")
                        .append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:center;'>").append("").append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:center;'>").append(item.getQuantity()).append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:right;'>")
                        .append(String.format(locale, "%,.0f", price)).append("</td>")
                        .append("<td style='border: 1px solid black; padding: 5px; text-align:right;'>")
                        .append(String.format(locale, "%,.0f", subtotal)).append("</td>")
                        .append("</tr>");
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

        String year = java.time.LocalDate.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("yyyy"));
        String newContractNumber = String.format("%03d", q.getQuotationId()) + "/" + year + "-HĐ";
        template = template.replace("{contract_number}",
                newContractNumber);

        BigDecimal total = contractDAO.calculateTotalAmountWithTaxAndDiscount(q.getQuotationId()) != null
                ? contractDAO.calculateTotalAmountWithTaxAndDiscount(q.getQuotationId()) : BigDecimal.ZERO;
        template = template.replace("{total_amount}",
                String.format(locale, "%,.0f", total));

        return template;
    }

    public List<Contract> searchContracts(String contractNumber, String customerName, String status,
            String storageType, int pageIndex, int pageSize, int userId, int roleId) {
        return contractDAO.searchContracts(contractNumber, customerName, status, storageType, pageIndex, pageSize, userId, roleId);
    }

    public int getTotalContracts(String contractNumber, String customerName, String status, String storageType) {
        return contractDAO.getTotalContracts(contractNumber, customerName, status, storageType);
    }

    public Contract getContractById(int id) {
        return contractDAO.getContractById(id);
    }

    public int insert(Contract c) {
        return contractDAO.insert(c);
    }

    public List<ContractHistory> getHistoriesByContractId(int contractId) {
        return contractDAO.getHistoriesByContractId(contractId);
    }

    public int insertHistory(ContractHistory h) {
        return contractDAO.insertHistory(h);
    }

    public void insertRevisionItem(ContractRevisionItem item) {
        contractDAO.insertRevisionItem(item);
    }

    public boolean update(Contract c) {
        return contractDAO.update(c);
    }

    public boolean updateStatus(int contractId, String newStatus) {
        return contractDAO.updateStatus(contractId, newStatus);
    }

    public Contract getContractByQuotationId(int quotationId) {
        return contractDAO.getContractByQuotationId(quotationId);
    }

    // XHieu-begin - delete contact me
    public List<Contract> getContractsByCustomerId(int customerId) {
        return contractDAO.getContractsByCustomerId(customerId);
    }
    // Xhieu - end
}

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
                config.getProperty("company_name", "CNG TY TNHH SWP"));
        template = template.replace("{company_address}",
                config.getProperty("company_address", "H Ni"));
        template = template.replace("{company_phone}",
                config.getProperty("company_phone", "0123456789"));
        template = template.replace("{company_tax}",
                config.getProperty("company_tax_code", "0101010101"));
        template = template.replace("{company_rep}",
                config.getProperty("company_rep_name", "Gim c"));
        template = template.replace("{company_position}",
                config.getProperty("company_position", "Gim c"));

        // ------------------------------------------------------------------
        // cleaned comment
        // ------------------------------------------------------------------
        StringBuilder productRows = new StringBuilder();
        int stt = 1;
        Locale locale = Locale.US; // cleaned comment

        if (details != null && !details.isEmpty()) {
            for (QuotationDetail item : details) {
                // cleaned comment
                BigDecimal qty = new BigDecimal(item.getQuantity());
                BigDecimal price = item.getSellingPrice() != null
                        ? item.getSellingPrice() : BigDecimal.ZERO;
                BigDecimal subtotal = price.multiply(qty);

                // cleaned comment
                String unit = "";
//                        (item.getUnit() != null && !item.getUnit().isEmpty())
// cleaned comment

                productRows.append("<tr>")
                        .append("<td style='text-align:center;'>").append(stt++).append("</td>")
                        .append("<td>").append(item.getProductName() != null ? item.getProductName() : "")
                        .append("</td>")
                        .append("<td style='text-align:center;'>").append(unit).append("</td>")
                        .append("<td style='text-align:center;'>").append(item.getQuantity()).append("</td>")
                        .append("<td style='text-align:right;'>")
                        .append(String.format(locale, "%,.0f", price)).append("</td>")
                        .append("<td style='text-align:right;'>")
                        .append(String.format(locale, "%,.0f", subtotal)).append("</td>")
                        .append("</tr>");
            }
        } else {
            productRows.append("<tr><td colspan='6' style='text-align:center;'>")
                    .append("Khng c sn phm no")
                    .append("</td></tr>");
        }
        template = template.replace("{product_list}", productRows.toString());

        // ------------------------------------------------------------------
        // cleaned comment
        // ------------------------------------------------------------------
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // cleaned comment
        template = template.replace("{sign_date}", LocalDate.now().format(fmt));

        // cleaned comment
        // cleaned comment
        LocalDate effective = (q.getQuotationDate() != null)
                ? q.getQuotationDate().toLocalDate()
                : LocalDate.now();

        template = template.replace("{effective_date}", effective.format(fmt));
        template = template.replace("{end_date}", effective.plusYears(1).format(fmt));

        // ------------------------------------------------------------------
        // cleaned comment
        // ------------------------------------------------------------------
        template = template.replace("{contract_number}",
                q.getQuotationId() + "/HKT"); // cleaned comment

        BigDecimal total = q.getTotalAmount() != null ? q.getTotalAmount() : BigDecimal.ZERO;
        template = template.replace("{total_amount}",
                String.format(locale, "%,.0f", total));

        return template;
    }

    // XHieu-begin - delete contact me

    public List<Contract> getContractsByCustomerId(int customerId) {
        return contractDAO.getContractsByCustomerId(customerId);
    }
    // Xhieu - end
}

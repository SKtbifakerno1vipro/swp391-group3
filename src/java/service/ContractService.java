package service;

import model.*;
import dto.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

public class ContractService {

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
                config.getProperty("company_name", "COMPANY LTD SWP"));
        template = template.replace("{company_address}",
                config.getProperty("company_address", "Hanoi"));
        template = template.replace("{company_phone}",
                config.getProperty("company_phone", "0123456789"));
        template = template.replace("{company_tax}",
                config.getProperty("company_tax_code", "0101010101"));
        template = template.replace("{company_rep}",
                config.getProperty("company_rep_name", "Director"));
        template = template.replace("{company_position}",
                config.getProperty("company_position", "Director"));

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

        template = template.replace("{contract_number}",
                q.getQuotationId() + "/HKT");

        BigDecimal total = q.getTotalAmount() != null ? q.getTotalAmount() : BigDecimal.ZERO;
        template = template.replace("{total_amount}",
                String.format(locale, "%,.0f", total));

        return template;
    }
}

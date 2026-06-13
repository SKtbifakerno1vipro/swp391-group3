package service;

import model.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

public class ContractService {


    public String fillTemplate(Quotation q, Customer cust, List<QuotationDetail> details,
                               String template, Properties config) {

        // ------------------------------------------------------------------
        // 1. THÔNG TIN KHÁCH HÀNG (BÊN B)
        // ------------------------------------------------------------------
        template = template.replace("{customer_name}",
                cust.getCompanyName() != null ? cust.getCompanyName() : "");
//        template = template.replace("{customer_address}",
//                cust.getAddress() != null ? cust.getAddress() : "");
//        template = template.replace("{customer_phone}",
//                cust.getPhone() != null ? cust.getPhone() : "");
//        template = template.replace("{customer_tax}",
//                cust.getTaxCode() != null ? cust.getTaxCode() : "");

        // ------------------------------------------------------------------
        // 2. THÔNG TIN CÔNG TY (BÊN A) TỪ FILE config.properties
        // ------------------------------------------------------------------
        template = template.replace("{company_name}",
                config.getProperty("company_name", "CÔNG TY TNHH SWP"));
        template = template.replace("{company_address}",
                config.getProperty("company_address", "Hà Nội"));
        template = template.replace("{company_phone}",
                config.getProperty("company_phone", "0123456789"));
        template = template.replace("{company_tax}",
                config.getProperty("company_tax_code", "0101010101"));
        template = template.replace("{company_rep}",
                config.getProperty("company_rep_name", "Giám Đốc"));
        template = template.replace("{company_position}",
                config.getProperty("company_position", "Giám đốc"));

        // ------------------------------------------------------------------
        // 3. TẠO BẢNG SẢN PHẨM {product_list}
        // ------------------------------------------------------------------
        StringBuilder productRows = new StringBuilder();
        int stt = 1;
        Locale locale = Locale.US; // Đảm bảo dấu phẩy là phân cách hàng nghìn

        if (details != null && !details.isEmpty()) {
            for (QuotationDetail item : details) {
                // Tính thành tiền (Quantity * SellingPrice) - dùng BigDecimal để tránh overflow
                BigDecimal qty = new BigDecimal(item.getQuantity());
                BigDecimal price = item.getSellingPrice() != null ?
                        item.getSellingPrice() : BigDecimal.ZERO;
                BigDecimal subtotal = price.multiply(qty);

                // Đơn vị: nếu model có getUnit() thì dùng, ngược lại "Cái"
                String unit ="";
//                        (item.getUnit() != null && !item.getUnit().isEmpty())
//                        ? item.getUnit() : "Cái";

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
                    .append("Không có sản phẩm nào")
                    .append("</td></tr>");
        }
        template = template.replace("{product_list}", productRows.toString());

        // ------------------------------------------------------------------
        // 4. ĐẶT THÔNG TIN NGÀY THÁNG (placeholder ngày)
        // ------------------------------------------------------------------
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // {sign_date} : ngày hiện tại
        template = template.replace("{sign_date}", LocalDate.now().format(fmt));

        // {effective_date} và {end_date}
        // Nếu quotation có ngày, dùng nó; nếu không, dùng ngày hiện tại
        LocalDate effective = (q.getQuotationDate() != null)
                ? q.getQuotationDate().toLocalDate()
                : LocalDate.now();

        template = template.replace("{effective_date}", effective.format(fmt));
        template = template.replace("{end_date}", effective.plusYears(1).format(fmt));

        // ------------------------------------------------------------------
        // 5. THÔNG TIN KHÁC (số hợp đồng, tổng tiền)
        // ------------------------------------------------------------------
        template = template.replace("{contract_number}",
                q.getQuotationId() + "/HĐKT"); // demo: 5/HĐKT

        BigDecimal total = q.getTotalAmount() != null ? q.getTotalAmount() : BigDecimal.ZERO;
        template = template.replace("{total_amount}",
                String.format(locale, "%,.0f", total));

        return template;
    }
}
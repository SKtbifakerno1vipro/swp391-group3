package service;


import model.*;
import java.util.List;
import java.util.Properties;

public class ContractService {

    public String fillTemplate(Quotation q, Customer cust, List<QuotationDetail> details, String template, Properties config) {
        
        // 1. Thay thế thông tin Khách hàng (Bên B)
        template = template.replace("{customer_name}", cust.getCompanyName() != null ? cust.getCompanyName() : "");
//        template = template.replace("{customer_address}", cust.getAddress() != null ? cust.getAddress() : "");
//        template = template.replace("{customer_phone}", cust.getPhone() != null ? cust.getPhone() : "");
        template = template.replace("{customer_tax}", cust.getTaxCode() != null ? cust.getTaxCode() : "");

        // 2. Thay thế thông tin Công ty (Bên A) từ config
        template = template.replace("{company_name}", config.getProperty("company_name", "CÔNG TY TNHH ABC"));
        template = template.replace("{company_address}", config.getProperty("company_address", ""));
        template = template.replace("{company_phone}", config.getProperty("company_phone", ""));
        template = template.replace("{company_tax}", config.getProperty("company_tax_code", ""));
        template = template.replace("{company_rep}", config.getProperty("company_rep_name", ""));
        template = template.replace("{company_position}", config.getProperty("company_position", "Giám đốc"));

        // 3. Xử lý danh sách sản phẩm {product_list}
        StringBuilder productRows = new StringBuilder();
        int stt = 1;
        for (QuotationDetail item : details) {
            productRows.append("<tr>")
                       .append("<td>").append(stt++).append("</td>")
                       .append("<td>").append(item.getProductName()).append("</td>")
//                       .append("<td>").append(item.getUnit()).append("</td>")
                       .append("<td>").append(item.getQuantity()).append("</td>")
                       .append("<td>").append(String.format("%,.0f", item.getSellingPrice())).append("</td>")
//                       .append("<td>").append(String.format("%,.0f", item.getQuantity() * item.getSellingPrice())).append("</td>")
                       .append("</tr>");
        }
        template = template.replace("{product_list}", productRows.toString());

        // 4. Các thông tin khác
        template = template.replace("{contract_number}", q.getQuotationId() + "/HĐKT"); // Demo số hợp đồng
        template = template.replace("{sign_date}", java.time.LocalDate.now().toString());
        template = template.replace("{total_amount}", String.format("%,.0f", q.getTotalAmount()));
        template = template.replace("{effective_date}", q.getQuotationDate().toLocalDate().toString());
        template = template.replace("{end_date}", q.getQuotationDate().toLocalDate().plusYears(1).toString());

        return template;
    }
}

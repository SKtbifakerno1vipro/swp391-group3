package service;

import model.*;
import dto.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Properties;
import dal.*;
import utils.EmailUtils;

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
        template = template.replace("{user_full_name}",
                cust.getFullName() != null ? cust.getFullName() : "");
        template = template.replace("{tax_code_B}",
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
        template = template.replace("{tax_code_A}",
                config.getProperty("tax_code", ""));

        StringBuilder productRows = new StringBuilder();
        int index = 1;

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

        //contract_number
        String year = LocalDate.now()
                .format(DateTimeFormatter.ofPattern("yyyy"));
        String newContractNumber = String.format("%03d", q.getQuotationId()) + "/" + year + "-HĐ";
        template = template.replace("{contract_number}",
                newContractNumber);

        BigDecimal total = contractDAO.calculateTotalAmountWithTaxAndDiscount(q.getQuotationId()) != null
                ? contractDAO.calculateTotalAmountWithTaxAndDiscount(q.getQuotationId()) : BigDecimal.ZERO;
        template = template.replace("{total_amount}",
                String.format("%,.0f", total));

        return template;
    }

    public boolean validateToken(int contractId, String token) {
        return contractDAO.validateToken(contractId, token);
    }

    public void noticeCustomerCheckContract(int contractId, String baseUrl) {
        Contract contract = contractDAO.getContractById(contractId);
        CustomerDTO customer = contractDAO.getCustomerDTOByContractId(contractId);

        String secureUrl = baseUrl + "contract-detail?id=" + contractId + "&token=" + contract.getToken();

        String subject = "Công Ty TNHH Pơ Bread - Gửi bản thảo Hợp đồng Mua Bán Nguyên Vật Liệu Làm Bánh để Quý khách kiểm tra";

        String content = "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "    <meta charset=\"UTF-8\">"
                + "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
                + "</head>"
                + "<body style=\"margin: 0; padding: 20px; background-color: #f4f5f7;\">"
                + "    <div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; max-width: 600px; margin: 0 auto; padding: 30px; border: 1px solid #e0e0e0; border-radius: 16px; background-color: #ffffff; box-shadow: 0 4px 12px rgba(0,0,0,0.05);\">"
                + "        <div style=\"text-align: center; margin-bottom: 24px; border-bottom: 2px solid #eaeaea; padding-bottom: 16px;\">"
                + "            <h2 style=\"color: #4A7C59; margin: 0; font-size: 26px; font-weight: 700; font-family: Georgia, serif;\">Pơ Bread</h2>"
                + "            <p style=\"color: #888888; margin: 5px 0 0 0; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;\">Thông Báo Hệ Thống</p>"
                + "        </div>"
                + "        <div style=\"margin-bottom: 24px;\">"
                + "            <h3 style=\"color: #333333; margin-top: 0;\">Kính chào Quý khách, <span style=\"color: #4A7C59;\">" + customer.getCompanyName() + "</span>!</h3>"
                + "            <p style=\"color: #555555; font-size: 15px;\">Yêu cầu kiểm tra thông tin hợp đồng số <strong>" + contract.getContractNumber() + "</strong> đã được khởi tạo và sẵn sàng để Quý khách xem xét.</p>"
                + "            <p style=\"color: #555555; font-size: 15px;\">Vui lòng nhấp vào nút bên dưới để truy cập hệ thống và kiểm tra nội dung hợp đồng trước khi thực hiện ký kết:</p>"
                + "        </div>"
                + "        <div style=\"text-align: center; margin-bottom: 28px;\">"
                + "            <a href=\"" + secureUrl + "\" style=\"display: inline-block; padding: 12px 30px; background-color: #4A7C59; color: #ffffff; text-decoration: none; border-radius: 25px; font-weight: bold; font-size: 15px; box-shadow: 0 4px 8px rgba(74, 124, 89, 0.25);\">"
                + "                Xem Chi Tiết Hợp Đồng"
                + "            </a>"
                + "        </div>"
                + "        <div style=\"background-color: #fcf8e3; border: 1px solid #fbeed5; border-radius: 12px; padding: 15px; margin-bottom: 24px; color: #c09853;\">"
                + "            <p style=\"margin: 0; font-size: 14px;\"><strong>Lưu ý:</strong> Hợp đồng đang ở trạng thái <strong>CUSTOMER_CHECK</strong>. Quý khách vui lòng kiểm tra kỹ các thông tin cá nhân, danh sách sản phẩm, và điều khoản thanh toán.</p>"
                + "        </div>"
                + "        <div style=\"border-top: 1px solid #eaeaea; padding-top: 20px; color: #888888; font-size: 12px; text-align: center;\">"
                + "            <p style=\"margin: 0;\">Đây là email tự động từ hệ thống quản lý hợp đồng Pơ Bread. Vui lòng không phản hồi trực tiếp email này.</p>"
                + "        </div>"
                + "    </div>"
                + "</body>"
                + "</html>";
        EmailUtils.sendEmailAsync(customer.getEmail(), subject, content);
    }

    public List<ContractCustomerDTO> searchContracts(String contractNumber, String customerName, String status,
            String storageType, int pageIndex, int pageSize, int userId, int roleId,
            String fromDate, String toDate, String taxCode, String phone, String email) {
        return contractDAO.searchContracts(contractNumber, customerName, status, storageType, pageIndex, pageSize, userId, roleId,
                fromDate, toDate, taxCode, phone, email);
    }

    public int getTotalContracts(String contractNumber, String customerName, String status,
            String storageType, int pageIndex, int pageSize, int userId, int roleId,
            String fromDate, String toDate, String taxCode, String phone, String email) {

        return contractDAO.getTotalContracts(contractNumber, customerName, status, storageType, pageIndex, pageSize, userId, roleId,
                fromDate, toDate, taxCode, phone, email);
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



    // nguyen kien - begin
    public boolean updateContractContent(int contractId, String contractContent) {
        return contractDAO.updateContractContent(contractId, contractContent);
    }
    // nguyenkien - end
}

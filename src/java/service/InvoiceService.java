package service;

import dal.InvoiceDAO;
import dal.CustomerDAO;
import dal.CustomerOrderDAO;
import dto.InvoiceItemDTO;
import dto.CustomerDTO;
import dto.CustomerOrderDTO;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import model.Invoice;
import model.User;
import utils.EmailUtils;

public class InvoiceService {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    public List<Invoice> getInvoices(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate, int totalRow, int page, int totalPage, int pageSize) {
        return invoiceDAO.getInvoices(searchBuyerName, status, type, startDate, endDate, totalRow, page, totalPage, pageSize, false, 0);
    }
    
    public List<Invoice> getInvoices() {
        return invoiceDAO.getInvoices(null, null, null, null, null, 0, 0, 0, 0, false, 0);
    }
    
    public List<Invoice> getInvoicesSince(Timestamp sinceTime, Integer customerUserId){
        return invoiceDAO.getInvoicesSince(sinceTime, customerUserId);
    }

    public List<Invoice> getInvoicesForCustomer(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate, int totalRow, int page, int totalPage, int pageSize, int userId) {
        return invoiceDAO.getInvoices(searchBuyerName, status, type, startDate, endDate, totalRow, page, totalPage, pageSize, true, userId);
    }
            
    public int countInvoices(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate) {
        return invoiceDAO.countInvoices(searchBuyerName, status, type, startDate, endDate, false, 0);
    }

    public int countInvoicesForCustomer(String searchBuyerName, String status, String type, LocalDateTime startDate, LocalDateTime endDate, int userId) {
        return invoiceDAO.countInvoices(searchBuyerName, status, type, startDate, endDate, true, userId);
    }

    public List<InvoiceItemDTO> getInvoiceItemsByOrderId(int orderId) {
        return invoiceDAO.getInvoiceItemsByOrderId(orderId);
    }

    public double calculateGoodsAmount(List<InvoiceItemDTO> details) {
        double totalGoodsAmt = 0;
        if (details != null) {
            for (InvoiceItemDTO item : details) {
                totalGoodsAmt += item.getLineAmount();
            }
        }
        return Double.parseDouble(String.format("%.2f", totalGoodsAmt));
    }

    public double calculateDiscountAmount(List<InvoiceItemDTO> details) {
        double discountAmount = 0.0;
        if (details != null) {
            for (InvoiceItemDTO item : details) {
                discountAmount += item.getLineDiscount();
            }
        }
        return Double.parseDouble(String.format("%.2f", discountAmount));
    }

    public double calculateTaxAmount(List<InvoiceItemDTO> details) {
        double totalTaxAmt = 0;
        if (details != null) {
            for (InvoiceItemDTO item : details) {
                totalTaxAmt += item.getLineTax();
            }
        }
        return Double.parseDouble(String.format("%.2f", totalTaxAmt));
    }

    public Invoice getInvoiceById(int id) {
        return invoiceDAO.getInvoiceById(id);
    }

    public Invoice getInvoiceByContractId(int contractId) {
        return invoiceDAO.getInvoiceByContractId(contractId);
    }

    public Invoice getInvoiceByOrderId(int orderId) {
        return invoiceDAO.getInvoiceByOrderId(orderId);
    }

    public String getNextInvoiceNo(int year) {
        return invoiceDAO.getNextInvoiceNo(year);
    }

    public String validateInvoice(Invoice invoice) {
        return invoiceDAO.validateInvoice(invoice);
    }

    public boolean updateInvoice(Invoice invoice) {
        return invoiceDAO.updateInvoice(invoice);
    }

    public boolean insertInvoice(Invoice invoice) {
        return invoiceDAO.insertInvoice(invoice);
    }

    public boolean updateInvoiceStatus(int id, String status) {
        return invoiceDAO.updateInvoiceStatus(id, status);
    }
    
    public void emailIssueInvoice(int invoiceId, String baseUrl) {
        Invoice invoice = getInvoiceById(invoiceId);
        if (invoice == null) return;

        CustomerOrderDAO orderDAO = new CustomerOrderDAO();
        CustomerOrderDTO orderDTO = orderDAO.getCustomerOrderDTOById(invoice.getCustomerOrderId());
        if (orderDTO == null) return;

        CustomerDAO customerDAO = new CustomerDAO();
        CustomerDTO customerDTO = customerDAO.getCustomerDTOById(orderDTO.getCustomer().getCustomerId());
        if (customerDTO == null || customerDTO.getUser() == null) return;

//        String recipientEmail = customerDTO.getUser().getEmail();
//        if (recipientEmail == null || recipientEmail.trim().isEmpty()) return;

        

        String subject = "Công Ty TNHH Pơ Bread - Thông báo phát hành hóa đơn điện tử";
        
        String typeDesc = "VAT".equalsIgnoreCase(invoice.getInvoiceType()) ? "Hóa đơn giá trị gia tăng" : "Hóa đơn bán hàng";
        
        String issueDateStr = "";
        if (invoice.getIssueDate() != null) {
            java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            issueDateStr = invoice.getIssueDate().format(formatter);
        }

        String totalAmountStr = String.format("%,.0f", invoice.getTotalAmount());

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
                + "            <p style=\"color: #888888; margin: 5px 0 0 0; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;\">Thông Báo Phát Hành Hóa Đơn Điện Tử</p>"
                + "        </div>"
                + "        <div style=\"margin-bottom: 24px;\">"
                + "            <h3 style=\"color: #333333; margin-top: 0;\">Kính gửi Quý khách, <span style=\"color: #4A7C59;\">" + invoice.getBuyerName() + "</span>!</h3>"
                + "            <p style=\"color: #555555; font-size: 15px;\">Chúng tôi xin trân trọng thông báo về việc phát hành hóa đơn điện tử cho giao dịch mua hàng của Quý khách tại hệ thống Pơ Bread.</p>"
                + "            <p style=\"color: #555555; font-size: 15px;\">Việc áp dụng hóa đơn điện tử này tuân thủ đầy đủ quy định pháp luật hiện hành theo Nghị định 123/2020/NĐ-CP và Thông tư 78/2021/TT-BTC của Bộ Tài chính.</p>"
                + "        </div>"
                + "        <div style=\"background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 24px;\">"
                + "            <h4 style=\"margin-top: 0; margin-bottom: 15px; color: #334155; border-bottom: 1px solid #e2e8f0; padding-bottom: 8px; font-weight: bold;\">THÔNG TIN HÓA ĐƠN CHI TIẾT</h4>"
                + "            <table style=\"width: 100%; font-size: 14px; border-collapse: collapse; color: #475569;\">"
                + "                <tr>"
                + "                    <td style=\"padding: 6px 0; font-weight: bold; width: 40%;\">Mẫu hóa đơn:</td>"
                + "                    <td style=\"padding: 6px 0; color: #0f172a;\">" + typeDesc + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"padding: 6px 0; font-weight: bold;\">Ký hiệu hóa đơn:</td>"
                + "                    <td style=\"padding: 6px 0; color: #0f172a;\">" + invoice.getInvoiceSymbol() + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"padding: 6px 0; font-weight: bold;\">Số hóa đơn:</td>"
                + "                    <td style=\"padding: 6px 0; color: #dc2626; font-weight: bold;\">" + invoice.getInvoiceNo() + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"padding: 6px 0; font-weight: bold;\">Ngày phát hành:</td>"
                + "                    <td style=\"padding: 6px 0; color: #0f172a;\">" + issueDateStr + "</td>"
                + "                </tr>"
                + "                <tr>"
                + "                    <td style=\"padding: 6px 0; font-weight: bold;\">Tổng tiền thanh toán:</td>"
                + "                    <td style=\"padding: 6px 0; color: #1e3a8a; font-weight: bold;\">" + totalAmountStr + " VND</td>"
                + "                </tr>"
                + "            </table>"
                + "        </div>"
                + "        <div style=\"text-align: center; margin-bottom: 28px;\">"
                + "            <a href=\"" + baseUrl + "\" style=\"display: inline-block; padding: 12px 30px; background-color: #4A7C59; color: #ffffff; text-decoration: none; border-radius: 25px; font-weight: bold; font-size: 15px; box-shadow: 0 4px 8px rgba(74, 124, 89, 0.25);\">"
                + "                Vui lòng truy cập vào hệ thống để xem chi tiết."
                + "            </a>"
                + "        </div>"
                + "        <div style=\"background-color: #f0fdf4; border: 1px solid #dcfce7; border-radius: 12px; padding: 15px; margin-bottom: 24px; color: #166534; font-size: 13px;\">"
                + "            <p style=\"margin: 0 0 8px 0; font-weight: bold;\">Đơn vị phát hành (Người bán):</p>"
                + "            <p style=\"margin: 0;\"><strong>Tên đơn vị:</strong> " + invoice.getSellerName() + "</p>"
                + "            <p style=\"margin: 0;\"><strong>Mã số thuế:</strong> " + invoice.getSellerTaxCode() + "</p>"
                + "            <p style=\"margin: 0;\"><strong>Địa chỉ:</strong> " + invoice.getSellerAddress() + "</p>"
                + "            <p style=\"margin: 0;\"><strong>Điện thoại:</strong> " + invoice.getSellerPhone() + "</p>"
                + "        </div>"
                + "        <div style=\"color: #64748b; font-size: 13px; margin-bottom: 24px;\">"
                + "            <p style=\"margin: 0;\">Nếu cần thêm thông tin hỗ trợ về hóa đơn, Quý khách vui lòng liên hệ Bộ phận Kế toán của chúng tôi qua Hotline hoặc gửi yêu cầu về email hỗ trợ để được giải đáp kịp thời.</p>"
                + "        </div>"
                + "        <div style=\"border-top: 1px solid #eaeaea; padding-top: 20px; color: #888888; font-size: 12px; text-align: center;\">"
                + "            <p style=\"margin: 0;\">Đây là email tự động từ hệ thống quản lý hóa đơn Pơ Bread. Vui lòng không phản hồi trực tiếp email này.</p>"
                + "        </div>"
                + "    </div>"
                + "</body>"
                + "</html>";

        EmailUtils.sendEmailAsync("maytinhasus2@gmail.com", subject, content, customerDTO.getUser().getUserId());
    }
}

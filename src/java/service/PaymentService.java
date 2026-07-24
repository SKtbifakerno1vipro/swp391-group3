package service;

import dal.PaymentDAO;
import dal.ContractDAO;
import dal.QuotationDAO;
import model.Payment;
import model.Contract;
import model.QuotationDetail;
import model.CustomerOrderDetail;
import model.CustomerOrder;
import dto.CustomerDTO;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class PaymentService {
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public int insertPayment(Payment payment) {
        return paymentDAO.insertPayment(payment);
    }
    
    public List<Payment> searchPayments(
            Integer customerUserId,
            String customerName,
            String contractNumber,
            String status,
            String startDate,
            String endDate,
            BigDecimal minAmount,
            BigDecimal maxAmount,
            int page,
            int pageSize
    ) {
        return paymentDAO.searchPayments(customerUserId, customerName, contractNumber, status, startDate, endDate, minAmount, maxAmount, page, pageSize);
    }

    public int getSearchPaymentsCount(
            Integer customerUserId,
            String customerName,
            String contractNumber,
            String status,
            String startDate,
            String endDate,
            BigDecimal minAmount,
            BigDecimal maxAmount
    ) {
        return paymentDAO.getSearchPaymentsCount(customerUserId, customerName, contractNumber, status, startDate, endDate, minAmount, maxAmount);
    }

    public Payment getPaymentById(int paymentId) {
        return paymentDAO.getPaymentById(paymentId);
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        boolean updated = paymentDAO.updatePaymentStatus(paymentId, status);
        if (updated && "COMPLETED".equalsIgnoreCase(status)) {
            try {
                Payment payment = getPaymentById(paymentId);
                if (payment != null) {
                    sendPaymentSuccessEmail(payment);
                }
            } catch (Exception e) {
                System.err.println("[PaymentService] Failed to trigger payment success email: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return updated;
    }

    public void sendPaymentSuccessEmail(Payment payment) {
        if (payment == null) return;
        String recipientEmail = payment.getCustomerEmailSnapshot();
        if (recipientEmail == null || recipientEmail.isBlank()) {
            System.out.println("[PaymentService] No customer email snapshot available for Payment ID: " + payment.getPaymentId() + ". Skipping email.");
            return;
        }

        java.text.NumberFormat currencyFormatter = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
        String formattedAmount = (payment.getAmount() != null) ? currencyFormatter.format(payment.getAmount()) : "0 VNĐ";

        String paidTime = (payment.getPaidAt() != null) 
            ? payment.getPaidAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"))
            : java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));

        String customerName = (payment.getCustomerNameSnapshot() != null && !payment.getCustomerNameSnapshot().isBlank())
            ? payment.getCustomerNameSnapshot() : "Quý khách";

        String contractNo = (payment.getContractNumber() != null) ? payment.getContractNumber() : "N/A";

        String subject = "Công Ty TNHH Pơ Bread - Xác nhận Thanh toán Giao dịch #" + payment.getPaymentId() + " Thành Công";

        String content = "<!DOCTYPE html>"
                + "<html>"
                + "<head><meta charset=\"UTF-8\"></head>"
                + "<body style=\"margin: 0; padding: 20px; background-color: #f4f5f7;\">"
                + "    <div style=\"font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; max-width: 600px; margin: 0 auto; padding: 30px; border: 1px solid #e0e0e0; border-radius: 16px; background-color: #ffffff; box-shadow: 0 4px 12px rgba(0,0,0,0.05);\">"
                + "        <div style=\"text-align: center; margin-bottom: 24px; border-bottom: 2px solid #eaeaea; padding-bottom: 16px;\">"
                + "            <h2 style=\"color: #4A7C59; margin: 0; font-size: 26px; font-weight: 700; font-family: Georgia, serif;\">Pơ Bread</h2>"
                + "            <p style=\"color: #888888; margin: 5px 0 0 0; font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;\">Xác Nhận Thanh Toán Thành Công</p>"
                + "        </div>"
                + "        <div style=\"margin-bottom: 24px;\">"
                + "            <h3 style=\"color: #333333; margin-top: 0;\">Kính chào <span style=\"color: #4A7C59;\">" + customerName + "</span>,</h3>"
                + "            <p style=\"color: #555555; font-size: 15px;\">Hệ thống Pơ Bread xin thông báo giao dịch thanh toán trực tuyến qua <strong>VNPay</strong> cho hợp đồng/đơn hàng của Quý khách đã hoàn tất thành công.</p>"
                + "        </div>"
                + "        <div style=\"background-color: #f9fbf9; border: 1px solid #dcefe1; border-radius: 12px; padding: 20px; margin-bottom: 24px;\">"
                + "            <h4 style=\"margin: 0 0 12px 0; color: #4A7C59; border-bottom: 1px dashed #c2e2cc; padding-bottom: 8px;\">Chi Tiết Giao Dịch</h4>"
                + "            <table style=\"width: 100%; border-collapse: collapse; font-size: 14px; color: #444444;\">"
                + "                <tr><td style=\"padding: 6px 0; font-weight: 600;\">Mã giao dịch:</td><td style=\"padding: 6px 0; text-align: right;\">#" + payment.getPaymentId() + "</td></tr>"
                + "                <tr><td style=\"padding: 6px 0; font-weight: 600;\">Số hợp đồng:</td><td style=\"padding: 6px 0; text-align: right;\">" + contractNo + "</td></tr>"
                + "                <tr><td style=\"padding: 6px 0; font-weight: 600;\">Số tiền đã thanh toán:</td><td style=\"padding: 6px 0; text-align: right; color: #4A7C59; font-weight: bold; font-size: 16px;\">" + formattedAmount + "</td></tr>"
                + "                <tr><td style=\"padding: 6px 0; font-weight: 600;\">Phương thức:</td><td style=\"padding: 6px 0; text-align: right;\">VNPay Gateway</td></tr>"
                + "                <tr><td style=\"padding: 6px 0; font-weight: 600;\">Thời gian thanh toán:</td><td style=\"padding: 6px 0; text-align: right;\">" + paidTime + "</td></tr>"
                + "            </table>"
                + "        </div>"
                + "        <div style=\"border-top: 1px solid #eaeaea; padding-top: 20px; color: #888888; font-size: 12px; text-align: center;\">"
                + "            <p style=\"margin: 0;\">Cảm ơn Quý khách đã tin tưởng và sử dụng dịch vụ của Pơ Bread.</p>"
                + "            <p style=\"margin: 4px 0 0 0;\">Đây là email tự động, vui lòng không phản hồi trực tiếp email này.</p>"
                + "        </div>"
                + "    </div>"
                + "</body></html>";

        utils.EmailUtils.sendEmailAsync(recipientEmail, subject, content, payment.getUserId());
    }

    public Payment getPaymentByContractId(int contractId) {
        return paymentDAO.getPaymentByContractId(contractId);
    }


    public synchronized void createPendingPaymentForOrder(CustomerOrder order) {
        int orderId = order.getCustomerOrderId();
        int contractId = order.getCustomerContractId();
        System.out.println("[PaymentService] Creating pending payment for Order ID: " + orderId + ", Contract ID: " + contractId);
        
        if (paymentDAO.hasPaymentForOrder(orderId)) {
            System.out.println("[PaymentService] Payment already exists for Order ID: " + orderId + ". Skipping creation.");
            return;
        }
        
        try {
            CustomerOrderService customerOrderService = new CustomerOrderService();
            CustomerService customerService = new CustomerService();
            double calculatedTotal = customerOrderService.getTotalPriceFromQuotationByOrderId(orderId);
            BigDecimal totalAmount = BigDecimal.valueOf(calculatedTotal);

            CustomerDTO customer = customerService.getCustomerDTOById(order.getCustomerId());
            if (customer == null || customer.getUser() == null) {
                System.err.println("[PaymentService] Could not resolve Customer or User for customer ID: " + order.getCustomerId() + ". Skipping payment creation.");
                return;
            }
            Integer customerUserId = customer.getUser().getUserId();
            String customerName = customer.getUser().getFullName();
            String customerPhone = customer.getUser().getPhone();
            String customerAddress = customer.getUser().getAddress();
            String customerEmail = customer.getUser().getEmail();
            String customerTaxCode = customer.getCustomer().getTaxCode();
            String companyName = customer.getCustomer().getCompanyName();

            Payment payment = new Payment();
            payment.setCustomerContractId(contractId);
            payment.setCustomerOrderId(orderId);
            payment.setAmount(totalAmount);
            payment.setPaymentType("VNPAY");
            payment.setPaymentStatus("PENDING");
            payment.setCreatedAt(LocalDateTime.now());
            payment.setUserId(customerUserId);
            // Chốt snapshot ngay lúc tạo
            payment.setCustomerNameSnapshot(customerName);
            payment.setCustomerPhoneSnapshot(customerPhone);
            payment.setCustomerAddressSnapshot(customerAddress);
            payment.setCustomerEmailSnapshot(customerEmail);
            payment.setCustomerTaxCodeSnapshot(customerTaxCode);
            payment.setCompanyNameSnapshot(companyName);

            int generatedId = paymentDAO.insertPayment(payment);
            System.out.println("[PaymentService] Successfully auto-created PENDING payment ID: " + generatedId + " for Order ID: " + orderId + ", Amount: " + totalAmount);
            
        } catch (Exception e) {
            System.err.println("[PaymentService] Failed to create pending payment for order ID " + orderId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }

    public BigDecimal getTotalPendingAmountByUserId(int userId) {
        return paymentDAO.getTotalPendingAmountByUserId(userId);
    }

    public BigDecimal getTotalPaidAmountByUserId(int userId) {
        return paymentDAO.getTotalPaidAmountByUserId(userId);
    }
}

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

    public List<Payment> getAllPayments() {
        return paymentDAO.getAllPayments();
    }

    public List<Payment> getPaymentsByCustomerId(int userId) {
        return paymentDAO.getPaymentsByCustomerId(userId);
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
        return paymentDAO.updatePaymentStatus(paymentId, status);
    }

    public Payment getPaymentByContractId(int contractId) {
        return paymentDAO.getPaymentByContractId(contractId);
    }

    public boolean hasPaymentForContract(int contractId) {
        return paymentDAO.hasPaymentForContract(contractId);
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
            double calculatedTotal = customerOrderService.getTotalPriceFromQuotationByOrderId(orderId);
            BigDecimal totalAmount = BigDecimal.valueOf(calculatedTotal);
            
            CustomerService customerService = new CustomerService();
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
            String customerTaxCode = customer.getCustomer() != null ? customer.getCustomer().getTaxCode() : null;
            String companyName = customer.getCustomer() != null ? customer.getCustomer().getCompanyName() : null;
            
            Payment payment = new Payment();
            payment.setCustomerContractId(contractId);
            payment.setCustomerOrderId(orderId);
            payment.setAmount(totalAmount);
            payment.setPaymentType("VNPAY");
            payment.setPaymentStatus("PENDING");
            payment.setCreatedAt(LocalDateTime.now());
            payment.setUserId(customerUserId);
            // Chốt snapshot ngay lúc tạo — chuẩn thực tế
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
}

package service;

import dal.PaymentDAO;
import dal.ContractDAO;
import dal.QuotationDAO;
import model.Payment;
import model.Contract;
import model.QuotationDetail;
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

    public Payment getPaymentById(int paymentId) {
        return paymentDAO.getPaymentById(paymentId);
    }

    public int getAnyContractId() {
        return paymentDAO.getAnyContractId();
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        return paymentDAO.updatePaymentStatus(paymentId, status);
    }

    public boolean hasPaymentForContract(int contractId) {
        return paymentDAO.hasPaymentForContract(contractId);
    }

    public void createPendingPaymentForContractIfNotExists(int contractId) {
        if (!hasPaymentForContract(contractId)) {
            try {
                ContractDAO contractDAO = new ContractDAO();
                Contract ctr = contractDAO.getContractById(contractId);
                if (ctr != null) {
                    QuotationDAO quotationDao = new QuotationDAO();
                    List<QuotationDetail> qDetails = quotationDao.getQuotationDetailsByQuotationId(ctr.getQuotationId());
                    double total = 0;
                    for (QuotationDetail detail : qDetails) {
                        total += detail.getAmount().doubleValue();
                    }
                    
                    Payment payment = new Payment();
                    payment.setCustomerContractId(contractId);
                    payment.setAmount(BigDecimal.valueOf(total));
                    payment.setPaymentType("VNPAY");
                    payment.setPaymentStatus("PENDING");
                    payment.setCreatedAt(LocalDateTime.now());
                    
                    CustomerService customerService = new CustomerService();
                    CustomerDTO customer = customerService.getCustomerDTOById(ctr.getCustomerId());
                    if (customer != null) {
                        int customerUserId = customer.getUser().getUserId();
                        payment.setCreatedBy(customerUserId);
                        insertPayment(payment);
                    } else {
                        System.err.println("Could not resolve Customer user ID for contract customer ID: " + ctr.getCustomerId());
                    }
                }
            } catch (Exception ex) {
                System.err.println("Failed to auto-create payment on signature: " + ex.getMessage());
                ex.printStackTrace();
            }
        }
    }
}

package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Payment {
    private int paymentId;
    private int customerContractId;
    private Integer customerOrderId;
    private Integer invoiceId;
    private BigDecimal amount;
    private String paymentType;
    private String paymentStatus;
    private LocalDateTime paidAt;
    private Integer userId;
    private LocalDateTime createdAt;

    // Snapshot fields
    private String customerNameSnapshot;
    private String customerPhoneSnapshot;
    private String customerAddressSnapshot;
    private String customerTaxCodeSnapshot;
    private String companyNameSnapshot;
    private String customerEmailSnapshot;
    private String createdByNameSnapshot;

    // Transient fields for display convenience
    private String contractNumber;
    private String customerName;
    private boolean canIssue;
    private Invoice invoice;

    public Invoice getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice invoice) {
        this.invoice = invoice;
    }

    public Payment() {}

    public int getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }

    public int getCustomerContractId() {
        return customerContractId;
    }

    public void setCustomerContractId(int customerContractId) {
        this.customerContractId = customerContractId;
    }

    public Integer getCustomerOrderId() {
        return customerOrderId;
    }

    public void setCustomerOrderId(Integer customerOrderId) {
        this.customerOrderId = customerOrderId;
    }

    public Integer getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(Integer invoiceId) {
        this.invoiceId = invoiceId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getContractNumber() {
        return contractNumber;
    }

    public void setContractNumber(String contractNumber) {
        this.contractNumber = contractNumber;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public boolean isCanIssue() {
        return canIssue;
    }

    public void setCanIssue(boolean canIssue) {
        this.canIssue = canIssue;
    }
    

    public String getFormattedPaidAt() {
        if (this.paidAt != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            return this.paidAt.format(formatter);
        }
        return "N/A";
    }

    public String getFormattedCreatedAt() {
        if (this.createdAt != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            return this.createdAt.format(formatter);
        }
        return "N/A";
    }

    public String getCustomerNameSnapshot() {
        return customerNameSnapshot;
    }

    public void setCustomerNameSnapshot(String customerNameSnapshot) {
        this.customerNameSnapshot = customerNameSnapshot;
    }

    public String getCustomerPhoneSnapshot() {
        return customerPhoneSnapshot;
    }

    public void setCustomerPhoneSnapshot(String customerPhoneSnapshot) {
        this.customerPhoneSnapshot = customerPhoneSnapshot;
    }

    public String getCustomerAddressSnapshot() {
        return customerAddressSnapshot;
    }

    public void setCustomerAddressSnapshot(String customerAddressSnapshot) {
        this.customerAddressSnapshot = customerAddressSnapshot;
    }

    public String getCustomerTaxCodeSnapshot() {
        return customerTaxCodeSnapshot;
    }

    public void setCustomerTaxCodeSnapshot(String customerTaxCodeSnapshot) {
        this.customerTaxCodeSnapshot = customerTaxCodeSnapshot;
    }

    public String getCompanyNameSnapshot() {
        return companyNameSnapshot;
    }

    public void setCompanyNameSnapshot(String companyNameSnapshot) {
        this.companyNameSnapshot = companyNameSnapshot;
    }

    public String getCustomerEmailSnapshot() {
        return customerEmailSnapshot;
    }

    public void setCustomerEmailSnapshot(String customerEmailSnapshot) {
        this.customerEmailSnapshot = customerEmailSnapshot;
    }

    public String getCreatedByNameSnapshot() {
        return createdByNameSnapshot;
    }

    public void setCreatedByNameSnapshot(String createdByNameSnapshot) {
        this.createdByNameSnapshot = createdByNameSnapshot;
    }
}

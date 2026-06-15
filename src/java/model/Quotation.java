package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Quotation {

    private int quotationId;
    private int customerId;
    private LocalDateTime quotationDate;
    private String quotationStatus;
    private Integer createdBy;
    private LocalDateTime createdAt;

    // Field phu đe hien thi
    private String customerName;    //hien thi ten khach hang thay vi chi customer_id
    private String createdByName;   //hien thi ten nhan vien bao gia thi vi chi created_by
    private BigDecimal totalAmount; //hien thi tong tien cua bao gia

    public Quotation() {
    }

    public Quotation(int quotationId, int customerId, LocalDateTime quotationDate, String quotationStatus, Integer createdBy, LocalDateTime createdAt, String customerName, String createdByName, BigDecimal totalAmount) {
        this.quotationId = quotationId;
        this.customerId = customerId;
        this.quotationDate = quotationDate;
        this.quotationStatus = quotationStatus;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.customerName = customerName;
        this.createdByName = createdByName;
        this.totalAmount = totalAmount;
    }

    public int getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public LocalDateTime getQuotationDate() {
        return quotationDate;
    }

    public void setQuotationDate(LocalDateTime quotationDate) {
        this.quotationDate = quotationDate;
    }

    public String getQuotationStatus() {
        return quotationStatus;
    }

    public void setQuotationStatus(String quotationStatus) {
        this.quotationStatus = quotationStatus;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

}

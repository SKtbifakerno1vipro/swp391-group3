package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Quotation {
    private int quotationId;
    private Integer customerOrderId;
    private LocalDateTime quotationDate;
    private String status;
    private BigDecimal totalAmount;
    private Integer createdBy;
    private LocalDateTime createdAt;

    public Quotation() {}

    public int getQuotationId() { return quotationId; }
    public void setQuotationId(int quotationId) { this.quotationId = quotationId; }
    public Integer getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(Integer customerOrderId) { this.customerOrderId = customerOrderId; }
    public LocalDateTime getQuotationDate() { return quotationDate; }
    public void setQuotationDate(LocalDateTime quotationDate) { this.quotationDate = quotationDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

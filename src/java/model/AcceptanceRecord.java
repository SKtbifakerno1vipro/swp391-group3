package model;

import java.time.LocalDateTime;

public class AcceptanceRecord {
    private int acceptanceRecordId;
    private int customerContractId;
    private int customerOrderId;
    private String recordNo;
    private LocalDateTime acceptanceDate;
    private String acceptanceStatus;

    // Provider / Seller info snapshot (Bên A)
    private String providerName;
    private String providerRepName;
    private String providerTaxCode;
    private String providerAddress;
    private String providerPhone;

    // Customer / Buyer info snapshot (Bên B)
    private String customerName;
    private String customerRepName;
    private String customerTaxCode;
    private String customerAddress;
    private String customerPhone;

    // Financial summary
    private double totalAmount;

    // Timestamps
    private Integer createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public AcceptanceRecord() {
    }

    public int getAcceptanceRecordId() {
        return acceptanceRecordId;
    }

    public void setAcceptanceRecordId(int acceptanceRecordId) {
        this.acceptanceRecordId = acceptanceRecordId;
    }

    public int getCustomerContractId() {
        return customerContractId;
    }

    public void setCustomerContractId(int customerContractId) {
        this.customerContractId = customerContractId;
    }

    public int getCustomerOrderId() {
        return customerOrderId;
    }

    public void setCustomerOrderId(int customerOrderId) {
        this.customerOrderId = customerOrderId;
    }

    public String getRecordNo() {
        return recordNo;
    }

    public void setRecordNo(String recordNo) {
        this.recordNo = recordNo;
    }

    public LocalDateTime getAcceptanceDate() {
        return acceptanceDate;
    }

    public void setAcceptanceDate(LocalDateTime acceptanceDate) {
        this.acceptanceDate = acceptanceDate;
    }

    public String getAcceptanceStatus() {
        return acceptanceStatus;
    }

    public void setAcceptanceStatus(String acceptanceStatus) {
        this.acceptanceStatus = acceptanceStatus;
    }

    public String getProviderName() {
        return providerName;
    }

    public void setProviderName(String providerName) {
        this.providerName = providerName;
    }

    public String getProviderRepName() {
        return providerRepName;
    }

    public void setProviderRepName(String providerRepName) {
        this.providerRepName = providerRepName;
    }

    public String getProviderTaxCode() {
        return providerTaxCode;
    }

    public void setProviderTaxCode(String providerTaxCode) {
        this.providerTaxCode = providerTaxCode;
    }

    public String getProviderAddress() {
        return providerAddress;
    }

    public void setProviderAddress(String providerAddress) {
        this.providerAddress = providerAddress;
    }

    public String getProviderPhone() {
        return providerPhone;
    }

    public void setProviderPhone(String providerPhone) {
        this.providerPhone = providerPhone;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerRepName() {
        return customerRepName;
    }

    public void setCustomerRepName(String customerRepName) {
        this.customerRepName = customerRepName;
    }

    public String getCustomerTaxCode() {
        return customerTaxCode;
    }

    public void setCustomerTaxCode(String customerTaxCode) {
        this.customerTaxCode = customerTaxCode;
    }

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
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

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

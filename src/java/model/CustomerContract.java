package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CustomerContract {
    private int contractId;
    private Integer customerOrderId;
    private String contractNumber;
    private BigDecimal totalAmount;
    private String status;
    private Integer contractVersion;
    private LocalDateTime signedAt;

    public CustomerContract() {}

    public int getContractId() { return contractId; }
    public void setContractId(int contractId) { this.contractId = contractId; }
    public Integer getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(Integer customerOrderId) { this.customerOrderId = customerOrderId; }
    public String getContractNumber() { return contractNumber; }
    public void setContractNumber(String contractNumber) { this.contractNumber = contractNumber; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getContractVersion() { return contractVersion; }
    public void setContractVersion(Integer contractVersion) { this.contractVersion = contractVersion; }
    public LocalDateTime getSignedAt() { return signedAt; }
    public void setSignedAt(LocalDateTime signedAt) { this.signedAt = signedAt; }
}


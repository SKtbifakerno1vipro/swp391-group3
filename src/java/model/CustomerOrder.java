package model;

import java.time.LocalDateTime;

public class CustomerOrder {
    private int customerOrderId;
    private int customerId;
    private int customerContractId;
    private String orderStatus;
    private Integer createdBy;
    private LocalDateTime createdAt;

    public CustomerOrder() {}

    public int getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(int customerOrderId) { this.customerOrderId = customerOrderId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getCustomerContractId() { return customerContractId; }
    public void setCustomerContractId(int customerContractId) { this.customerContractId = customerContractId; }
    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}

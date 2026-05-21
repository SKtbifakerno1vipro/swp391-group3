package model;

import java.time.LocalDateTime;

public class CustomerOrder {
    private int customerOrderId;
    private int customerId;
    private String status;
    private Integer createBy;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;

    public CustomerOrder() {}

    public int getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(int customerOrderId) { this.customerOrderId = customerOrderId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getCreateBy() { return createBy; }
    public void setCreateBy(Integer createBy) { this.createBy = createBy; }
    public LocalDateTime getCreateAt() { return createAt; }
    public void setCreateAt(LocalDateTime createAt) { this.createAt = createAt; }
    public LocalDateTime getUpdateAt() { return updateAt; }
    public void setUpdateAt(LocalDateTime updateAt) { this.updateAt = updateAt; }
}

package model;

import java.time.LocalDateTime;

public class ProviderOrder {
    private int providerOrderId;
    private Integer customerOrderId;
    private Integer assignedBy;
    private LocalDateTime assignedAt;
    private String status;

    public ProviderOrder() {}

    public int getProviderOrderId() { return providerOrderId; }
    public void setProviderOrderId(int providerOrderId) { this.providerOrderId = providerOrderId; }
    public Integer getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(Integer customerOrderId) { this.customerOrderId = customerOrderId; }
    public Integer getAssignedBy() { return assignedBy; }
    public void setAssignedBy(Integer assignedBy) { this.assignedBy = assignedBy; }
    public LocalDateTime getAssignedAt() { return assignedAt; }
    public void setAssignedAt(LocalDateTime assignedAt) { this.assignedAt = assignedAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

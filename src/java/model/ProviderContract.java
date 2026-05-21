package model;

import java.time.LocalDate;

public class ProviderContract {
    private int contractId;
    private Integer providerOrderId;
    private LocalDate startDate;
    private LocalDate endDate;
    private String status;

    public ProviderContract() {}

    public int getContractId() { return contractId; }
    public void setContractId(int contractId) { this.contractId = contractId; }
    public Integer getProviderOrderId() { return providerOrderId; }
    public void setProviderOrderId(Integer providerOrderId) { this.providerOrderId = providerOrderId; }
    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}

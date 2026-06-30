package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class ContractHistory {

    private int historyId;
    private int contractId;
    private String fromStatus, toStatus, editStatus, contractVersion, note;
    private int changedBy;
    private String changedByName;
    private LocalDateTime createdAt;
    
    // Additional fields for realtime notifications
    private int customerUserId;
    private String contractNumber;

    private List<ContractRevisionItem> revisionItems;

    public ContractHistory() {
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public String getFromStatus() {
        return fromStatus;
    }

    public void setFromStatus(String fromStatus) {
        this.fromStatus = fromStatus;
    }

    public String getToStatus() {
        return toStatus;
    }

    public void setToStatus(String toStatus) {
        this.toStatus = toStatus;
    }

    public String getEditStatus() {
        return editStatus;
    }

    public void setEditStatus(String editStatus) {
        this.editStatus = editStatus;
    }

    public String getContractVersion() {
        return contractVersion;
    }

    public void setContractVersion(String contractVersion) {
        this.contractVersion = contractVersion;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public String getChangedByName() {
        return changedByName;
    }

    public void setChangedByName(String changedByName) {
        this.changedByName = changedByName;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getCustomerUserId() {
        return customerUserId;
    }

    public void setCustomerUserId(int customerUserId) {
        this.customerUserId = customerUserId;
    }

    public String getContractNumber() {
        return contractNumber;
    }

    public void setContractNumber(String contractNumber) {
        this.contractNumber = contractNumber;
    }

    public List<ContractRevisionItem> getRevisionItems() {
        return revisionItems;
    }

    public void setRevisionItems(List<ContractRevisionItem> revisionItems) {
        this.revisionItems = revisionItems;
    }

    public String getCreateTimeString() {
        if (this.getCreatedAt() == null) {
            return "N/A";
        }
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
        return this.getCreatedAt().format(fmt);
    }
    
}

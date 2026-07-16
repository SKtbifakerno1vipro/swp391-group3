package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class QuotationHistory {

    private int quotationHistoryId;
    private int quotationId;
    private Integer createdBy; // Integer cho phep null, int thi khong.
    private String createdByName; // Store user name
    private LocalDateTime createdAt;
    private String editHistory;

    public QuotationHistory() {
    }

    public QuotationHistory(int quotationHistoryId, int quotationId, Integer createdBy, String createdByName, LocalDateTime createdAt, String editHistory) {
        this.quotationHistoryId = quotationHistoryId;
        this.quotationId = quotationId;
        this.createdBy = createdBy;
        this.createdByName = createdByName;
        this.createdAt = createdAt;
        this.editHistory = editHistory;
    }

    public int getQuotationHistoryId() {
        return quotationHistoryId;
    }

    public void setQuotationHistoryId(int quotationHistoryId) {
        this.quotationHistoryId = quotationHistoryId;
    }

    public int getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
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

    public String getFormattedCreatedAt() {
        if (this.createdAt != null) {
            DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
            return this.createdAt.format(formatter);
        }
        return "";
    }

    public String getEditHistory() {
        return editHistory;
    }

    public void setEditHistory(String editHistory) {
        this.editHistory = editHistory;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }
}

package  model;
import java.time.LocalDateTime;

public class QuotationHistory {
    private int quotationHistoryId;
    private int quotationId;
    private Integer createdBy; // int ko đuoc phep rong nhung integer thi co
    private LocalDateTime createdAt;
    private String editHistory;
    
    public QuotationHistory(){   
    }
    
    public QuotationHistory(int quotationHistoryId, int quotationId, Integer createdBy, LocalDateTime createdAt, String editHistory) {
        this.quotationHistoryId = quotationHistoryId;
        this.quotationId = quotationId;
        this.createdBy = createdBy;
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

    public String getEditHistory() {
        return editHistory;
    }

    public void setEditHistory(String editHistory) {
        this.editHistory = editHistory;
    }
    
    
}


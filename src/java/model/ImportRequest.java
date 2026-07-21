package model;

import java.sql.Timestamp;

public class ImportRequest {
    private int importId;
    private int productId;
    private String productName; // Dùng để hiển thị tên sản phẩm
    private int quantity;
    private int status; // 1: Pending, 2: Imported, 3: Cancelled
    private int createdBy;
    private String createdByName; // Dùng để hiển thị tên người tạo
    private Timestamp createdDate;
    private Integer importedBy;
    private String importedByName; // Dùng để hiển thị tên người nhập kho
    private Timestamp importedDate;
    private String note;
    private String wareHousenote; // Ghi chú khi hủy yêu cầu nhập kho của Warehouse

    public ImportRequest() {
    }

    public int getImportId() {
        return importId;
    }

    public void setImportId(int importId) {
        this.importId = importId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Integer getImportedBy() {
        return importedBy;
    }

    public void setImportedBy(Integer importedBy) {
        this.importedBy = importedBy;
    }

    public String getImportedByName() {
        return importedByName;
    }

    public void setImportedByName(String importedByName) {
        this.importedByName = importedByName;
    }

    public Timestamp getImportedDate() {
        return importedDate;
    }

    public void setImportedDate(Timestamp importedDate) {
        this.importedDate = importedDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getWareHousenote() {
        return wareHousenote;
    }

    public void setWareHousenote(String wareHousenote) {
        this.wareHousenote = wareHousenote;
    }
}

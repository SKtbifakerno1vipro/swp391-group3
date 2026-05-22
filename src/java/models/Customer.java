package models;

import java.time.LocalDateTime;

public class Customer extends User{
    private int customerId;
    private Integer userId;
    private String taxCode;
    private String type;
    private String createBy;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;

    public Customer() {}
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getTaxCode() { return taxCode; }
    public void setTaxCode(String taxCode) { this.taxCode = taxCode; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getCreateBy() { return createBy; }
    public void setCreateBy(String createBy) { this.createBy = createBy; }
    @Override
    public LocalDateTime getCreateAt() {
        return createAt;
    }
    @Override
    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }

    @Override
    public LocalDateTime getUpdateAt() {
        return updateAt;
    }
    @Override
    public void setUpdateAt(LocalDateTime updateAt) {
        this.updateAt = updateAt;
    }
    
}

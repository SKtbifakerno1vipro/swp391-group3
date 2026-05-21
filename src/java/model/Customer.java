package model;

import java.time.LocalDateTime;

public class Customer {

    private int customerId;
    private Integer userId;
    private String taxCode;
    private String type;
    private Integer createBy;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;

    public Customer() {
    }

    public Customer(int customerId, Integer userId, String taxCode, String type, Integer createBy, LocalDateTime createAt, LocalDateTime updateAt) {
        this.customerId = customerId;
        this.userId = userId;
        this.taxCode = taxCode;
        this.type = type;
        this.createBy = createBy;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getTaxCode() {
        return taxCode;
    }

    public void setTaxCode(String taxCode) {
        this.taxCode = taxCode;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getCreateBy() {
        return createBy;
    }

    public void setCreateBy(Integer createBy) {
        this.createBy = createBy;
    }

    public LocalDateTime getCreateAt() {
        return createAt;
    }

    public void setCreateAt(LocalDateTime createAt) {
        this.createAt = createAt;
    }

    public LocalDateTime getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(LocalDateTime updateAt) {
        this.updateAt = updateAt;
    }
}

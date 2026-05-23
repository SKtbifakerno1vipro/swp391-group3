package model;

import java.time.LocalDateTime;

public class Customer extends User {

    private int customerId;
    private String taxCode;
    private String type;
    private Integer createBy;

    public Customer() {
        super();
    }

    public Customer(int customerId, Integer userId, String taxCode, String type, Integer createBy, LocalDateTime createAt, LocalDateTime updateAt) {
        super();
        this.setUserId(userId);
        this.setCreateAt(createAt);
        this.setUpdateAt(updateAt);
        this.customerId = customerId;
        this.taxCode = taxCode;
        this.type = type;
        this.createBy = createBy;
    }

    // Constructor đầy đủ kết hợp cả thuộc tính User và Customer
    public Customer(int customerId, String taxCode, String type, Integer createBy,
                    int userId, String userName, String password, String email,
                    String fullName, String phone, String status, Integer roleId,
                    LocalDateTime createAt, LocalDateTime updateAt) {
        super(userId, userName, password, email, fullName, phone, status, roleId, createAt, updateAt);
        this.customerId = customerId;
        this.taxCode = taxCode;
        this.type = type;
        this.createBy = createBy;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
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
}

package model;

import java.time.LocalDateTime;

public class Provider extends User {
    private int providerId;
    private String taxCode;
    private String providerName;

    public Provider() {
        super();
    }

    public Provider(int providerId, Integer userId, String taxCode, String providerName, LocalDateTime createAt, LocalDateTime updateAt) {
        super();
        this.setUserId(userId);
        this.setCreateAt(createAt);
        this.setUpdateAt(updateAt);
        this.providerId = providerId;
        this.taxCode = taxCode;
        this.providerName = providerName;
    }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }
    public String getTaxCode() { return taxCode; }
    public void setTaxCode(String taxCode) { this.taxCode = taxCode; }
    public String getProviderName() { return providerName; }
    public void setProviderName(String providerName) { this.providerName = providerName; }
}

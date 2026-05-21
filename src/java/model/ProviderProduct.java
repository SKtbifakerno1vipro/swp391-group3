package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ProviderProduct {
    private int providerId;
    private int productId;
    private BigDecimal costPrice;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;

    public ProviderProduct() {}

    public ProviderProduct(int providerId, int productId, BigDecimal costPrice) {
        this.providerId = providerId;
        this.productId = productId;
        this.costPrice = costPrice;
    }

    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public BigDecimal getCostPrice() { return costPrice; }
    public void setCostPrice(BigDecimal costPrice) { this.costPrice = costPrice; }
    public LocalDateTime getCreateAt() { return createAt; }
    public void setCreateAt(LocalDateTime createAt) { this.createAt = createAt; }
    public LocalDateTime getUpdateAt() { return updateAt; }
    public void setUpdateAt(LocalDateTime updateAt) { this.updateAt = updateAt; }
}

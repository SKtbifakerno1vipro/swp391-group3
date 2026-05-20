package models;

public class ProviderOrderDetail {
    private int providerOrderDetailId;
    private int providerOrderId;
    private int productId;
    private int quantity;

    public ProviderOrderDetail() {}

    public int getProviderOrderDetailId() { return providerOrderDetailId; }
    public void setProviderOrderDetailId(int providerOrderDetailId) { this.providerOrderDetailId = providerOrderDetailId; }
    public int getProviderOrderId() { return providerOrderId; }
    public void setProviderOrderId(int providerOrderId) { this.providerOrderId = providerOrderId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}

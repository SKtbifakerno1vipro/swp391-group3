package models;

public class CustomerOrderDetail {
    private int customerOrderDetailId;
    private int customerOrderId;
    private int productId;
    private int quantity;

    public CustomerOrderDetail() {}

    public int getCustomerOrderDetailId() { return customerOrderDetailId; }
    public void setCustomerOrderDetailId(int customerOrderDetailId) { this.customerOrderDetailId = customerOrderDetailId; }
    public int getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(int customerOrderId) { this.customerOrderId = customerOrderId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}

package model;

import java.math.BigDecimal;

public class CustomerOrderDetail {
    private int customerOrderDetailId;
    private int customerOrderId;
    private int productId;
    private int quantity;
    private double costPrice;
    private double sellingPrice;
    private int quotationDetailId;
    private double taxPercent;

    public CustomerOrderDetail() {}
    
    public int getCustomerOrderDetailId() { return customerOrderDetailId; }
    public void setCustomerOrderDetailId(int customerOrderDetailId) { this.customerOrderDetailId = customerOrderDetailId; }
    public int getCustomerOrderId() { return customerOrderId; }
    public void setCustomerOrderId(int customerOrderId) { this.customerOrderId = customerOrderId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getCostPrice() { return costPrice; }
    public void setCostPrice(double costPrice) { this.costPrice = costPrice; }
    public double getSellingPrice() { return sellingPrice; }
    public void setSellingPrice(double sellingPrice) { this.sellingPrice = sellingPrice; }
    
    public int getQuotationDetailId() { return quotationDetailId; }
    public void setQuotationDetailId(int quotationDetailId) { this.quotationDetailId = quotationDetailId; }

    public double getTaxPercent() { return taxPercent; }
    public void setTaxPercent(double taxPercent) { this.taxPercent = taxPercent; }
}

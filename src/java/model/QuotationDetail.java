package model;

import java.math.BigDecimal;

public class QuotationDetail {

    private int quotationDetailId;
    private int quotationId;
    private Integer quantity;
    private BigDecimal sellingPrice;
    private BigDecimal discountPercent;
    private BigDecimal taxPercent;
    private BigDecimal amount;

    public QuotationDetail() {
    }

    public int getQuotationDetailId() {
        return quotationDetailId;
    }

    public void setQuotationDetailId(int quotationDetailId) {
        this.quotationDetailId = quotationDetailId;
    }

    public int getQuotationId() {
        return quotationId;
    }

    public void setQuotationId(int quotationId) {
        this.quotationId = quotationId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    public BigDecimal getTaxPercent() {
        return taxPercent;
    }

    public void setTaxPercent(BigDecimal taxPercent) {
        this.taxPercent = taxPercent;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
}

package dto;

public class InvoiceItemDTO {
    private int productId;
    private String productName;
    private String unit;
    private int quantity;
    private double sellingPrice;
    private double discountPercent;
    private double taxPercent;
    
    // Các trường tính toán của từng dòng (line amounts)
    private double lineAmount;      // quantity * sellingPrice
    private double lineDiscount;    // lineAmount * (discountPercent / 100)
    private double lineTax;         // (lineAmount - lineDiscount) * (taxPercent / 100)
    private double lineTotal;       // lineAmount - lineDiscount + lineTax

    public InvoiceItemDTO() {
    }

    public InvoiceItemDTO(int productId, String productName, String unit, int quantity, double sellingPrice, 
                          double discountPercent, double taxPercent, double lineDiscount, 
                          double lineTax) {
        this.productId = productId;
        this.productName = productName;
        this.unit = unit;
        this.quantity = quantity;
        this.sellingPrice = sellingPrice;
        this.discountPercent = discountPercent;
        this.taxPercent = taxPercent;
        this.lineAmount = quantity * sellingPrice;
        this.lineDiscount = lineDiscount;
        this.lineTax = lineTax;
        this.lineTotal = this.lineAmount - lineDiscount + lineTax;
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

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public double getTaxPercent() {
        return taxPercent;
    }

    public void setTaxPercent(double taxPercent) {
        this.taxPercent = taxPercent;
    }

    public double getLineAmount() {
        return lineAmount;
    }

    public void setLineAmount(double lineAmount) {
        this.lineAmount = lineAmount;
    }

    public double getLineDiscount() {
        return lineDiscount;
    }

    public void setLineDiscount(double lineDiscount) {
        this.lineDiscount = lineDiscount;
    }

    public double getLineTax() {
        return lineTax;
    }

    public void setLineTax(double lineTax) {
        this.lineTax = lineTax;
    }

    public double getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(double lineTotal) {
        this.lineTotal = lineTotal;
    }
}

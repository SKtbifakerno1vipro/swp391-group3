package model;

public class Category {
    private int categoryId;
    private String categoryName;
    private int totalProduct;
    private int status = 1;

    public Category() {}

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public int getTotalProduct() { return totalProduct; }
    public void setTotalProduct(int totalProduct) { this.totalProduct = totalProduct; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}


package dto;

import model.CustomerOrderDetail;
import model.Product;

public class CustomerOrderDetailDTO {
    private CustomerOrderDetail detail;
    private Product product;

    public CustomerOrderDetailDTO() {}

    public CustomerOrderDetail getDetail() {
        return detail;
    }

    public void setDetail(CustomerOrderDetail detail) {
        this.detail = detail;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }
}

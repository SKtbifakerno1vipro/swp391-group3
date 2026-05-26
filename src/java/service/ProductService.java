package service;

import dal.ProductDAO;
import java.util.List;
import model.Product;

public class ProductService {
    private final ProductDAO productDAO = new ProductDAO();

    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    public Product getProductById(int id) {
        return productDAO.getProductById(id);
    }
}

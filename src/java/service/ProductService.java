package service;

import dal.ProductDAO;
import java.util.List;
import model.Category;
import model.Product;

public class ProductService {
    private final ProductDAO productDAO = new ProductDAO();

    public List<Product> getAllProducts() {
        return productDAO.getAllProducts();
    }

    public Product getProductById(int id) {
        return productDAO.getProductById(id);
    }
    
    public boolean createProduct(Product product){
        return productDAO.createProduct(product);
    }
    
    public boolean updateProduct(Product product){
        return productDAO.updateProduct(product);
    }
    
    public List<Product> searchProduct(String searchText, Integer categoryId, String status){
        return productDAO.searchProduct(searchText, categoryId, status);
    }
    
    public List<Category> getAllCategory(){
        return productDAO.getAllCategory();
    }
}

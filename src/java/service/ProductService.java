package service;

import dal.ProductDAO;
import java.util.List;
import model.Category;
import model.Product;

public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();

    public Product getProductById(int id) {
        return productDAO.getProductById(id);
    }

    public boolean createProduct(Product product) {
        return productDAO.createProduct(product);
    }

    public boolean updateProduct(Product product) {
        return productDAO.updateProduct(product);
    }

    public List<Product> searchProduct(String searchText, Integer categoryId, String sort, String status, Double minPrice, Double maxPrice, int totalRow, int page, int totalPage, int pageSize) {
        return productDAO.searchProduct(searchText, categoryId, sort, status, minPrice, maxPrice, totalRow, page, totalPage, pageSize);
    }
    
    public List<Product> getAllProducts(){
        return productDAO.searchProduct(null, null, null, null, null, null, 0, 0, 0, 0);
    }

    public List<Category> getAllCategory() {
        return productDAO.getAllCategory();
    }

    public List<String> getProductUnit() {
        return productDAO.getProductUnit();
    }

    public List<String> getProductStatus() {
        return productDAO.getProductStatus();
    }

    public boolean deleteProduct(int productId){
        return productDAO.deleteProduct(productId);
    }
    public String getUpdateByWithProductId(int id) {
        return productDAO.getUpdateByWithProductId(id);
    }

    public int countProduct(String searchText, Integer categoryId, String status, Double minPrice, Double maxPrice) {
        return productDAO.countProduct(searchText, categoryId, status, minPrice, maxPrice);
    }

    public int calculateTotalPage(int totalRow, int pageSize) {
        if (totalRow < pageSize) {
            return 1;
        }
        return (int) Math.ceil((double) totalRow / pageSize);
    }
    
    public int nomalizePage(int page, int totalPage){
        if(page < 1){
            return 1;
        }
        if(page > totalPage){
            return totalPage;
        }
        return page;
    }

    public boolean isProductNameExists(String productName, Integer excludeProductId) {
        return productDAO.isProductNameExists(productName, excludeProductId);
    }

    public boolean updateQuantityReserve(int productId, int quantityReserve) {
        return productDAO.updateQuantityReserve(productId, quantityReserve);
    }
}

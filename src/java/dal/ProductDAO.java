package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Product;

public class ProductDAO extends DBContext {

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "select * from product p join category c on p.category_id = c.category_id WHERE product_status = 'ACTIVE'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("getAllProducts: " + e.getMessage());
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "select * from product p join category c on p.category_id = c.category_id WHERE product_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToProduct(rs);
            }
        } catch (Exception e) {
            System.out.println("getProductById: " + e.getMessage());
        }
        return null;
    }

    public boolean createProduct(Product product) {
        Product found = getProductById(product.getProductId());
        if (found != null) {
            return false;
        }
        try {
            String sql = "INSERT INTO product (product_name, cost_price, selling_price, [description], "
                    + "unit, product_status, reorder_level, quantity_available, category_id, updated_by) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setBigDecimal(2, product.getCostPrice());
            ps.setBigDecimal(3, product.getSellingPrice());
            ps.setString(4, product.getDescription());
            ps.setString(5, product.getUnit());
            ps.setString(6, product.getProductStatus());
            ps.setInt(7, product.getReorderLevel());
            ps.setInt(8, product.getQuantityAvailable());
            ps.setObject(9, product.getCategoryId());
            ps.setObject(10, product.getUpdatedBy());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.out.println("createProduct: " + e.getMessage());
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        Product found = getProductById(product.getProductId());
        if (found == null) {
            return false;
        }
        try {
            String sql = "UPDATE product SET product_name = ?, cost_price = ?, selling_price = ?, "
                    + "[description] = ?, unit = ?, product_status = ?, reorder_level = ?, "
                    + "quantity_available = ?, category_id = ?, updated_by = ?, updated_at = GETDATE() "
                    + "WHERE product_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setBigDecimal(2, product.getCostPrice());
            ps.setBigDecimal(3, product.getSellingPrice());
            ps.setString(4, product.getDescription());
            ps.setString(5, product.getUnit());
            ps.setString(6, product.getProductStatus());
            ps.setInt(7, product.getReorderLevel());
            ps.setInt(8, product.getQuantityAvailable());
            ps.setObject(9, product.getCategoryId());
            ps.setObject(10, product.getUpdatedBy());
            ps.setInt(11, product.getProductId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.out.println("updateProduct: " + e.getMessage());
            return false;
        }
    }

    public List<Product> searchProduct(String searchText, Integer categoryId, String status) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = """
                         select * from product p join category c on p.category_id = c.category_id WHERE 1 = 1
                         """;
            if (searchText != null && !searchText.trim().isEmpty()) {
                sql += " and product_name LIKE ?";
            }
            if (categoryId != null && categoryId != 0) {
                sql += " and p.category_id = " + categoryId;
            }
            if (status != null && !status.trim().isEmpty()) {
                sql += " and p.product_status = ?";
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            if (searchText != null && !searchText.trim().isEmpty()) {
                ps.setString(1, "%" + searchText + "%");
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(2, status);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                list.add(p);
            }
            return list;
        } catch (Exception e) {
            System.out.println("searchProduct: " + e.getMessage());
        }
        return null;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setCostPrice(rs.getBigDecimal("cost_price"));
        p.setSellingPrice(rs.getBigDecimal("selling_price"));
        p.setDescription(rs.getString("description"));
        p.setUnit(rs.getString("unit"));
        p.setProductStatus(rs.getString("product_status"));
        p.setReorderLevel(rs.getInt("reorder_level"));
        p.setQuantityAvailable(rs.getInt("quantity_available"));

        int updatedBy = rs.getInt("updated_by");
        if (!rs.wasNull()) {
            p.setUpdatedBy(updatedBy);
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            p.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            p.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }

    public List<Category> getAllCategory() {
        List<Category> list = new ArrayList<>();
        try {
            String sql = "select * from category";
                         
                        
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setCategoryName(rs.getString("category_name"));
                list.add(c);
            }
            return list;
        } catch (Exception e) {
            System.out.println("getAllCategory: " + e.getMessage());
        }
        return null;
    }
}

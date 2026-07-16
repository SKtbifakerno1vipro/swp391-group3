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

        try {
            String sql = "INSERT INTO product (product_name, cost_price, selling_price, [description], "
                    + "unit, product_status, quantity_available, category_id, updated_by) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setDouble(2, product.getCostPrice());
            ps.setDouble(3, product.getSellingPrice());
            ps.setString(4, product.getDescription());
            ps.setString(5, product.getUnit());
            ps.setString(6, product.getProductStatus());
            ps.setInt(7, product.getQuantityAvailable());
            if (product.getCategoryId() != null) {
                ps.setInt(8, product.getCategoryId());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            if (product.getUpdatedBy() != null) {
                ps.setInt(9, product.getUpdatedBy());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("createProduct: " + e.getMessage());

        }
        return false;
    }

    public boolean updateProduct(Product product) {
        Product found = getProductById(product.getProductId());
        if (found == null) {
            return false;
        }
        try {
            String sql = "UPDATE product SET product_name = ?, cost_price = ?, selling_price = ?, "
                    + "[description] = ?, unit = ?, product_status = ?, "
                    + "quantity_available = ?, category_id = ?, updated_by = ?, updated_at = GETDATE() "
                    + "WHERE product_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, product.getProductName());
            ps.setDouble(2, product.getCostPrice());
            ps.setDouble(3, product.getSellingPrice());
            ps.setString(4, product.getDescription());
            ps.setString(5, product.getUnit());
            ps.setString(6, product.getProductStatus());
            ps.setInt(7, product.getQuantityAvailable());
            ps.setObject(8, product.getCategoryId());
            ps.setObject(9, product.getUpdatedBy());
            ps.setInt(10, product.getProductId());

            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("updateProduct: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteProduct(int productId){
        Product found = getProductById(productId);
        if (found == null) {
            return false;
        } 
        try {
            String sql = """
                         update product
                         set product_status = 'INACTIVE'
                         where product_id = ? and product_status = 'ACTIVE'
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.executeUpdate();
            Product p = getProductById(productId);
            if (p.getProductStatus().equals("INACTIVE")) {
                return true;
            }
        } catch (Exception e) {
            System.out.println("deleteProduct: "+e.getMessage());
        }
        return false;
    }
    
    public List<Product> searchProduct(String searchText, Integer categoryId, String sort, String status, int totalRow, int page, int totalPage, int pageSize) {
        List<Product> list = new ArrayList<>();
        try {
            String sql = """
                         select * from product p join category c on p.category_id = c.category_id WHERE 1 = 1
                         """;
            if (searchText != null && !searchText.trim().isEmpty()) {
                sql += " and product_name LIKE ?";
            }
            if (categoryId != null && categoryId > 0) {
                sql += " and p.category_id = ?";
            }
            if (status != null && !status.trim().isEmpty()) {
                sql += " and p.product_status = ?";
            }
            
            if (sort != null && !sort.trim().isEmpty()) {
                if (sort.equals("increase")) {
                    sql += " \n order by p.selling_price";
                } else if (sort.equals("decrease")) {
                    sql += " \n order by p.selling_price desc";
                } else if (sort.equals("default")) {
                    sql += " \n order by p.product_id";
                }
            } else {
                sql += " \n order by p.product_id";
            }

            if ((page > 0 && page <= totalPage)  && totalRow > 0) {
                sql += """
                   \n offset ? rows
                   fetch next ? rows only
                   """;
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (searchText != null && !searchText.trim().isEmpty()) {
                ps.setString(index++, "%" + searchText + "%");
            }
            if (categoryId != null && categoryId != 0) {
                ps.setInt(index++, categoryId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }

            if ((page > 0 && page <= totalPage)  && totalRow > 0) {

                ps.setInt(index++, (int) ((page - 1) * pageSize));
                ps.setInt(index++, pageSize);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = mapResultSetToProduct(rs);
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println("searchProduct: " + e.getMessage());
        }
        return list;
    }

    private Product mapResultSetToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setCostPrice(rs.getDouble("cost_price"));
        p.setSellingPrice(rs.getDouble("selling_price"));
        p.setDescription(rs.getString("description"));
        p.setUnit(rs.getString("unit"));
        p.setProductStatus(rs.getString("product_status"));
        p.setQuantityAvailable(rs.getInt("quantity_available"));
        p.setQuantityReserve(rs.getInt("quantity_reserve"));

        int updatedBy = rs.getInt("updated_by");
        if (!rs.wasNull()) {
            p.setUpdatedBy(updatedBy);
        }
        Timestamp createdAt = rs.getTimestamp("created_at");
        p.setCreatedAt(createdAt);
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        p.setUpdatedAt(updatedAt);
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }

    public int countProduct(String searchText, Integer categoryId, String status) {
        try {
            String sql = """
                         select COUNT(*) as total
                         from product p join category c on c.category_id = p.category_id
                         where 1=1
                         """;
            if (searchText != null && !searchText.trim().isEmpty()) {
                sql += " and product_name LIKE ?";
            }
            if (categoryId != null && categoryId > 0) {
                sql += " and p.category_id = ?";
            }
            if (status != null && !status.trim().isEmpty()) {
                sql += " and p.product_status = ?";
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (searchText != null && !searchText.trim().isEmpty()) {
                ps.setString(index++, "%" + searchText + "%");
            }
            if (categoryId != null && categoryId != 0) {
                ps.setInt(index++, categoryId);
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setString(index++, status);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) {
            System.out.println("countProduct: " + e.getMessage());
        }
        return 0;
    }

    public String getUpdateByWithProductId(int id) {
        try {
            String sql = """
                         select u.user_name as update_by from product p join [user] u on u.user_id = p.updated_by
                         where product_id = ?
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("update_by");
            }
        } catch (Exception e) {
            System.out.println("getUpdateByWithProductId: " + e.getMessage());
        }
        return null;
    }

    public List<String> getProductUnit() {
        List<String> list = new ArrayList<>();
        try {
            String sql = """
                         select unit from product
                         where unit is not null
                         group by unit
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("unit"));
            }
        } catch (Exception e) {
            System.out.println("getProductUnit: " + e.getMessage());
        }
        return list;
    }

    public List<String> getProductStatus() {
        List<String> list = new ArrayList<>();
        try {
            String sql = """
                         select product_status from product
                         where product_status is not null
                         group by product_status
                         """;
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("product_status"));
            }
        } catch (Exception e) {
            System.out.println("getProductStatus: " + e.getMessage());
        }
        return list;
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

    public boolean isProductNameExists(String productName, Integer excludeProductId) {
        String sql = "SELECT COUNT(*) FROM product WHERE LOWER(product_name) = LOWER(?)";
        if (excludeProductId != null && excludeProductId > 0) {
            sql += " AND product_id != ?";
        }
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, productName.trim());
            if (excludeProductId != null && excludeProductId > 0) {
                ps.setInt(2, excludeProductId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("Error in isProductNameExists: " + e.getMessage());
        }
        return false;
    }

    public boolean updateQuantityReserve(int productId, int quantityReserve) {
        String sql = "UPDATE product SET quantity_reserve = ? WHERE product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantityReserve);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("updateQuantityReserve: " + e.getMessage());
        }
        return false;
    }
}

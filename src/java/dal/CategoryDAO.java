package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Category;

public class CategoryDAO extends DBContext {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT category_id, category_name FROM category ORDER BY category_id";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO getAllCategories error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public Category getCategoryById(int categoryId) {
        String sql = "SELECT category_id, category_name FROM category WHERE category_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, categoryId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapCategory(rs);
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO getCategoryById error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public int createCategory(String categoryName) {
        String sql = "INSERT INTO category (category_name) VALUES (?)";
        try {
            PreparedStatement stm = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stm.setString(1, categoryName);
            int affectedRows = stm.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = stm.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("CategoryDAO createCategory error: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateCategory(Category category) {
        String sql = "UPDATE category SET category_name = ? WHERE category_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, category.getCategoryName());
            stm.setInt(2, category.getCategoryId());
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("CategoryDAO updateCategory error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM category WHERE category_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, categoryId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("CategoryDAO deleteCategory error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isCategoryNameExists(String categoryName) {
        return isCategoryNameExists(categoryName, null);
    }

    public boolean isCategoryNameExists(String categoryName, Integer excludeCategoryId) {
        String sql = "SELECT COUNT(*) FROM category WHERE category_name = ?";
        if (excludeCategoryId != null) {
            sql += " AND category_id <> ?";
        }
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, categoryName);
            if (excludeCategoryId != null) {
                stm.setInt(2, excludeCategoryId);
            }
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("CategoryDAO isCategoryNameExists error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int countProductsByCategoryId(int categoryId) {
        String sql = "SELECT COUNT(*) FROM product WHERE category_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, categoryId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("CategoryDAO countProductsByCategoryId error: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    private Category mapCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        return category;
    }
}

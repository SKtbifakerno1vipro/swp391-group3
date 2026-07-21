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
        String sql = "SELECT c.category_id, c.category_name, c.status, "
                   + "(SELECT COUNT(*) FROM product p WHERE p.category_id = c.category_id) AS total_product "
                   + "FROM category c WHERE c.status = 1 ORDER BY c.category_id";
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

    public List<Category> searchCategoriesWithPaging(String searchName, int pageIndex, int pageSize) {
        return searchCategoriesWithPaging(searchName, 1, pageIndex, pageSize);
    }

    public List<Category> searchCategoriesWithPaging(String searchName, Integer statusFilter, int pageIndex, int pageSize) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.category_id, c.category_name, c.status, "
                   + "(SELECT COUNT(*) FROM product p WHERE p.category_id = c.category_id) AS total_product "
                   + "FROM category c WHERE 1=1";

        if (statusFilter != null && statusFilter != -1) {
            sql += " AND c.status = ?";
        }
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " AND c.category_name LIKE ?";
        }
        sql += " ORDER BY c.category_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            if (statusFilter != null && statusFilter != -1) {
                stm.setInt(index++, statusFilter);
            }
            if (searchName != null && !searchName.trim().isEmpty()) {
                stm.setString(index++, "%" + searchName.trim() + "%");
            }
            stm.setInt(index++, (pageIndex - 1) * pageSize);
            stm.setInt(index++, pageSize);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO searchCategoriesWithPaging error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCategoriesCount(String searchName) {
        return getTotalCategoriesCount(searchName, 1);
    }

    public int getTotalCategoriesCount(String searchName, Integer statusFilter) {
        String sql = "SELECT COUNT(*) FROM category WHERE 1=1";
        if (statusFilter != null && statusFilter != -1) {
            sql += " AND status = ?";
        }
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " AND category_name LIKE ?";
        }
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            int index = 1;
            if (statusFilter != null && statusFilter != -1) {
                stm.setInt(index++, statusFilter);
            }
            if (searchName != null && !searchName.trim().isEmpty()) {
                stm.setString(index++, "%" + searchName.trim() + "%");
            }
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("CategoryDAO getTotalCategoriesCount error: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public Category getCategoryById(int categoryId) {
        String sql = "SELECT c.category_id, c.category_name, c.status, "
                   + "(SELECT COUNT(*) FROM product p WHERE p.category_id = c.category_id) AS total_product "
                   + "FROM category c WHERE c.category_id = ?";
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
        String sql = "INSERT INTO category (category_name, total_product, status) VALUES (?, 0, 1)";
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
        String sql = "UPDATE category SET status = 0 WHERE category_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, categoryId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("CategoryDAO deleteCategory (soft delete) error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean restoreCategory(int categoryId) {
        String sql = "UPDATE category SET status = 1 WHERE category_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, categoryId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("CategoryDAO restoreCategory error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean isCategoryNameExists(String categoryName) {
        return isCategoryNameExists(categoryName, null);
    }

    public boolean isCategoryNameExists(String categoryName, Integer excludeCategoryId) {
        String sql = "SELECT COUNT(*) FROM category WHERE category_name = ? AND status = 1";
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
        try {
            category.setTotalProduct(rs.getInt("total_product"));
        } catch (SQLException e) {
            category.setTotalProduct(0);
        }
        try {
            category.setStatus(rs.getInt("status"));
        } catch (SQLException e) {
            category.setStatus(1);
        }
        return category;
    }
}

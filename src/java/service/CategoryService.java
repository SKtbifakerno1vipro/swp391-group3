package service;

import dal.CategoryDAO;
import java.util.List;
import model.Category;

public class CategoryService {

    private final CategoryDAO categoryDAO = new CategoryDAO();


    public List<Category> searchCategoriesWithPaging(String searchName, Integer statusFilter, int pageIndex, int pageSize) {
        return categoryDAO.searchCategoriesWithPaging(searchName, statusFilter, pageIndex, pageSize);
    }


    public int getTotalCategoriesCount(String searchName, Integer statusFilter) {
        return categoryDAO.getTotalCategoriesCount(searchName, statusFilter);
    }

    public Category getCategoryById(int categoryId) {
        return categoryDAO.getCategoryById(categoryId);
    }

    public int createCategory(String categoryName) {
        return categoryDAO.createCategory(categoryName);
    }

    public boolean updateCategory(Category category) {
        return categoryDAO.updateCategory(category);
    }

    public boolean deleteCategory(int categoryId) {
        return categoryDAO.deleteCategory(categoryId);
    }

    public boolean restoreCategory(int categoryId) {
        return categoryDAO.restoreCategory(categoryId);
    }

    public boolean isCategoryNameExists(String categoryName) {
        return categoryDAO.isCategoryNameExists(categoryName);
    }

    public boolean isCategoryNameExists(String categoryName, Integer excludeCategoryId) {
        return categoryDAO.isCategoryNameExists(categoryName, excludeCategoryId);
    }

}

package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Category;
import service.CategoryService;

@WebServlet(name = "EditCategoryController", urlPatterns = {"/category/edit"})
public class EditCategoryController extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdRaw = request.getParameter("categoryId");

        if (categoryIdRaw == null || categoryIdRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=edit_failed");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdRaw);
            Category category = categoryService.getCategoryById(categoryId);
            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=not_found");
                return;
            }
            request.setAttribute("category", category);
            request.getRequestDispatcher("/views/category/category_edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=edit_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String categoryIdRaw = request.getParameter("categoryId");
        String categoryName = request.getParameter("categoryName");

        if (categoryIdRaw == null || categoryIdRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=edit_failed");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdRaw);
            Category category = categoryService.getCategoryById(categoryId);

            if (category == null) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=not_found");
                return;
            }

            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập tên danh mục!");
                request.setAttribute("category", category);
                request.getRequestDispatcher("/views/category/category_edit.jsp").forward(request, response);
                return;
            }

            categoryName = categoryName.trim();

            if (categoryService.isCategoryNameExists(categoryName, categoryId)) {
                request.setAttribute("error", "Tên danh mục này đã tồn tại!");
                category.setCategoryName(categoryName);
                request.setAttribute("category", category);
                request.getRequestDispatcher("/views/category/category_edit.jsp").forward(request, response);
                return;
            }

            category.setCategoryName(categoryName);
            if (categoryService.updateCategory(category)) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=edit_success");
            } else {
                request.setAttribute("error", "Lỗi khi cập nhật danh mục!");
                request.setAttribute("category", category);
                request.getRequestDispatcher("/views/category/category_edit.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=edit_failed");
        }
    }
}

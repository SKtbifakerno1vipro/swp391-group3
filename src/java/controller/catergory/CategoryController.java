package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Category;
import service.CategoryService;

@WebServlet(name = "CategoryController", urlPatterns = {"/category/create", "/category/edit"})
public class CategoryController extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/category/edit".equals(path)) {
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
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=edit_failed");
                return;
            }
        }

        // Forward to the unified category form JSP
        request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();

        if ("/category/create".equals(path)) {
            String categoryName = request.getParameter("categoryName");

            if (categoryName == null || categoryName.trim().isEmpty()) {
                request.setAttribute("error", "Please enter the category name!");
                request.setAttribute("categoryName", categoryName);
                request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
                return;
            }

            categoryName = categoryName.trim();

            if (categoryService.isCategoryNameExists(categoryName)) {
                request.setAttribute("error", "This category name already exists!");
                request.setAttribute("categoryName", categoryName);
                request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
                return;
            }

            int newCategoryId = categoryService.createCategory(categoryName);
            if (newCategoryId > 0) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=add_success");
            } else {
                request.setAttribute("error", "Failed to add category to the database!");
                request.setAttribute("categoryName", categoryName);
                request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
            }
        } else if ("/category/edit".equals(path)) {
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
                    request.setAttribute("error", "Please enter the category name!");
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
                    return;
                }

                categoryName = categoryName.trim();

                if (categoryService.isCategoryNameExists(categoryName, categoryId)) {
                    request.setAttribute("error", "This category name already exists!");
                    category.setCategoryName(categoryName);
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
                    return;
                }

                category.setCategoryName(categoryName);
                if (categoryService.updateCategory(category)) {
                    response.sendRedirect(request.getContextPath() + "/category/list?status=edit_success");
                } else {
                    request.setAttribute("error", "Failed to update category!");
                    request.setAttribute("category", category);
                    request.getRequestDispatcher("/views/category/category_form.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=edit_failed");
            }
        }
    }
}

package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.CategoryService;

@WebServlet(name = "DeleteCategoryController", urlPatterns = {"/category/delete"})
public class DeleteCategoryController extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryIdRaw = request.getParameter("categoryId");

        if (categoryIdRaw == null || categoryIdRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=delete_failed");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdRaw);

            if (categoryService.getCategoryById(categoryId) == null) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=not_found");
                return;
            }

            if (categoryService.countProductsByCategoryId(categoryId) > 0) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=delete_in_use");
                return;
            }

            if (categoryService.deleteCategory(categoryId)) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=delete_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/category/list?status=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=delete_failed");
        }
    }
}

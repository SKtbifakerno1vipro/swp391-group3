package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.*;

@WebServlet(name = "DeleteCategoryController", urlPatterns = {"/category/delete"})
public class DeleteCategoryController extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();
    private final ProductService productService = new ProductService();

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

            if (productService.countProduct(null, categoryId, null) > 0) {
                response.sendRedirect(request.getContextPath() + "/category/list?status=delete_in_use");
                return;
            }

            model.Category cat = categoryService.getCategoryById(categoryId);
            if (categoryService.deleteCategory(categoryId)) {
                model.User loggedInUser = (model.User) request.getSession().getAttribute("user");
                Integer userId = loggedInUser != null ? loggedInUser.getUserId() : null;
                String catName = cat != null ? cat.getCategoryName() : "Unknown";
                service.AuditLogService.log(userId, "DELETE", "Category", "Xóa danh mục: " + catName + " (ID: " + categoryId + ")");
                response.sendRedirect(request.getContextPath() + "/category/list?status=delete_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/category/list?status=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=delete_failed");
        }
    }
}

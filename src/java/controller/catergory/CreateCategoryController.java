package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.CategoryService;

@WebServlet(name = "CreateCategoryController", urlPatterns = {"/category/create"})
public class CreateCategoryController extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/category/category_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String categoryName = request.getParameter("categoryName");

        if (categoryName == null || categoryName.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the category name!");
            request.setAttribute("categoryName", categoryName);
            request.getRequestDispatcher("/views/category/category_create.jsp").forward(request, response);
            return;
        }

        categoryName = categoryName.trim();

        if (categoryService.isCategoryNameExists(categoryName)) {
            request.setAttribute("error", "This category name already exists!");
            request.setAttribute("categoryName", categoryName);
            request.getRequestDispatcher("/views/category/category_create.jsp").forward(request, response);
            return;
        }

        int newCategoryId = categoryService.createCategory(categoryName);
        if (newCategoryId > 0) {
            response.sendRedirect(request.getContextPath() + "/category/list?status=add_success");
        } else {
            request.setAttribute("error", "Failed to add category to the database!");
            request.setAttribute("categoryName", categoryName);
            request.getRequestDispatcher("/views/category/category_create.jsp").forward(request, response);
        }
    }
}

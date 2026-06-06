package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import service.CategoryService;

@WebServlet(name = "ListCatagory", urlPatterns = {"/category-list"})
public class ListCatagory extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categoryList", categoryService.getAllCategories());
        request.getRequestDispatcher("/views/category/list.jsp").forward(request, response);
    }
}

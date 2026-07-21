package controller.catergory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import service.CategoryService;

@WebServlet(name = "ListCategory", urlPatterns = {"/category/list"})
public class ListCategory extends HttpServlet {

    private final CategoryService categoryService = new CategoryService();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        if (searchName != null) {
            searchName = searchName.trim();
        }

        String statusFilterRaw = request.getParameter("statusFilter");
        Integer statusFilter = 1;
        if (statusFilterRaw != null && !statusFilterRaw.isBlank()) {
            try {
                statusFilter = Integer.parseInt(statusFilterRaw);
            } catch (NumberFormatException e) {
                statusFilter = 1;
            }
        }

        String pageRaw = request.getParameter("page");
        int page = 1;
        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Integer.parseInt(pageRaw);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Category> categoryList = categoryService.searchCategoriesWithPaging(searchName, statusFilter, page, PAGE_SIZE);
        int totalRecords = categoryService.getTotalCategoriesCount(searchName, statusFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        request.setAttribute("categoryList", categoryList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("searchName", searchName);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/views/category/category_list.jsp").forward(request, response);
    }
}

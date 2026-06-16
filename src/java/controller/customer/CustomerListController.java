package controller.customer;

import service.CustomerService;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dto.CustomerDTO;
import utils.*;

import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "CustomerListController", urlPatterns = {"/customer/list"})
public class CustomerListController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();
    private static final int PAGE_SIZE = 10;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        String searchSdt = request.getParameter("searchSdt");
        String searchEmail = request.getParameter("searchEmail");
        String searchMst = request.getParameter("searchMst");
        
        String typeCus = request.getParameter("type");
        String pageRaw = request.getParameter("page");
        
        int page = 1;       // Default page when accessing for the first time
        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // validate + format / max 150 characters
        String error =
                Validation.validateInputSearch(searchName, 150);

        if (error == null)
            error = Validation.validateInputSearch(searchSdt, 20);

        if (error == null)
            error = Validation.validateInputSearch(searchEmail, 150);

        if (error == null)
            error = Validation.validateInputSearch(searchMst, 20);

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/views/customer/customer_list.jsp").forward(request, response);
            return;
        }

        // format and remove extra whitespaces
        if (searchName != null) {
            searchName = searchName.trim().replaceAll("\\s+", " ");
        }

        if (searchSdt != null) {
            searchSdt = searchSdt.trim().replaceAll("\\s+", " ");
        }

        if (searchEmail != null) {
            searchEmail = searchEmail.trim().replaceAll("\\s+", " ");
        }

        if (searchMst != null) {
            searchMst = searchMst.trim().replaceAll("\\s+", " ");
        }

        // filter and paginate
        List<CustomerDTO> list = customerService.getSearchAndPaginatedCusDTOs(searchName, searchSdt, searchEmail,
                searchMst, typeCus, page, PAGE_SIZE);
        int totalPages = customerService.getTotalPages(searchName, searchSdt, searchEmail, searchMst, typeCus, PAGE_SIZE);

        request.setAttribute("customers", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.setAttribute("searchName", searchName);
        request.setAttribute("searchSdt", searchSdt);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("searchMst", searchMst);
        
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        request.setAttribute("type", typeCus);

        request.getRequestDispatcher("/views/customer/customer_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

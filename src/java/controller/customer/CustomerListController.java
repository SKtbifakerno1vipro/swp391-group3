package controller.customer;
import service.CustomerService;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dto.CustomerDTO;

import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "CustomerListController", urlPatterns = {"/customer/list"})
public class CustomerListController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int currentPage = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isBlank()) {
                currentPage = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ignored) {
            currentPage = 1;
        }

        List<CustomerDTO> allCustomers = customerService.getAllCustomerDTOs();
        int totalRecords = allCustomers == null ? 0 : allCustomers.size();
        int totalPages = (int) Math.ceil(totalRecords / (double) PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;

        if (currentPage < 1) currentPage = 1;
        if (currentPage > totalPages) currentPage = totalPages;

        int fromIndex = (currentPage - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalRecords);
        List<CustomerDTO> pageCustomers = (totalRecords == 0) ? List.of() : allCustomers.subList(fromIndex, toIndex);

        request.setAttribute("customerList", pageCustomers);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/views/customer/customer_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}







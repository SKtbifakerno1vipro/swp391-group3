package controller.quotation;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Quotation;
import service.QuotationService;

@WebServlet(name = "QuotationListController", urlPatterns = {"/quotation-list"})
public class QuotationListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String searchText = request.getParameter("search");
        if (searchText != null) {
            searchText = searchText.trim().replaceAll("\\s+", " ");
        }
               
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        model.User user = (session != null) ? (model.User) session.getAttribute("user") : null;
        Integer customerId = null;
        if (user != null && user.getRoleId() == 3) {
            Object sessionCusId = session.getAttribute("customerId");
            if (sessionCusId != null) {
                customerId = (Integer) sessionCusId;
            } else {
                service.CustomerService customerService = new service.CustomerService();
                dto.CustomerDTO customer = customerService.getCustomerDTOByUserId(user.getUserId());
                if (customer != null) {
                    customerId = customer.getCustomerId();
                    session.setAttribute("customerId", customerId);
                }
            }
        }

        QuotationService quotationService = new QuotationService();
        List<Quotation> quotationList = quotationService.searchQuotations(searchText, status, fromDate, toDate, customerId);

        // Pagination
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");

        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalQuotations = quotationList.size();
        int totalPages = (int) Math.ceil((double) totalQuotations / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page < 1) {
            page = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        int fromIndex = Math.min((page - 1) * pageSize, totalQuotations);
        int toIndex = Math.min(fromIndex + pageSize, totalQuotations);
        List<Quotation> pagedQuotationList = totalQuotations == 0 
                ? java.util.Collections.emptyList() 
                : quotationList.subList(fromIndex, toIndex);
       
        request.setAttribute("searchText", searchText);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalQuotations", totalQuotations);
        request.setAttribute("quotationList", pagedQuotationList);
        request.getRequestDispatcher("/views/quotation/list.jsp").forward(request, response);
    } 
}

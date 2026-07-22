package controller.customer;

import service.CustomerService;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dto.CustomerDTO;
import model.User;
import jakarta.servlet.http.HttpSession;
import utils.*;

import jakarta.servlet.annotation.WebServlet;

//COALESCE

@WebServlet(name = "CustomerListController", urlPatterns = {"/customer/list"})
public class CustomerListController extends HttpServlet {
    private static final int ROLE_SYSTEM_ADMIN = 1;
    private static final int ROLE_MANAGER = 2;
    private static final int ROLE_CUSTOMER = 3;
    private static final int ROLE_SALE_STAFF = 4;
    private static final int ROLE_ADMIN_OFFICER = 5;
    private static final int ROLE_WAREHOUSE_STAFF = 6;
    private static final int PAGE_SIZE = 10;

    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // authorization check 
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // one user one ability
        Integer assignedToUserId = null;

        if (user.getRoleId() == ROLE_SALE_STAFF) {
            // chi lay customer thuoc sale
            assignedToUserId = user.getUserId();
        } else{
            try {
                assignedToUserId = Integer.parseInt(request.getParameter("assignedToUserId"));
            } catch (NumberFormatException e){
                assignedToUserId = null;
            }
        }
        String searchName = request.getParameter("searchName");
        String searchSdt = request.getParameter("searchSdt");
        String searchEmail = request.getParameter("searchEmail");
        String searchMst = request.getParameter("searchMst");
        String typeCus = request.getParameter("type");
        String searchStatus = request.getParameter("searchStatus");
        if (searchStatus == null) {
            searchStatus = "ACTIVE"; // default is ACTIVE
        }
        String pageRaw = request.getParameter("page");

        int page = 1;       // Default page when accessing for the first time
        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String pageSizeRaw = request.getParameter("pageSize");
        int pageSize = 10;
        if (pageSizeRaw != null && !pageSizeRaw.isBlank()) {
            try {
                pageSize = Integer.parseInt(pageSizeRaw.trim());
                if (pageSize < 1) pageSize = 10;
            } catch (NumberFormatException e) {
                pageSize = 10;
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
                searchMst, typeCus, assignedToUserId, searchStatus, page, pageSize);
        int totalPages = customerService.getTotalPages(searchName, searchSdt, searchEmail, searchMst, typeCus, assignedToUserId, searchStatus, pageSize);

        request.setAttribute("customersDTOs", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("searchStatus", searchStatus);

        request.setAttribute("searchName", searchName);
        request.setAttribute("searchSdt", searchSdt);
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("searchMst", searchMst);
        
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        request.setAttribute("type", typeCus);

        request.setAttribute("assignedToUserId", assignedToUserId);
        request.setAttribute("listSales", customerService.getAllSalesExecutiveUsers());

        request.getRequestDispatcher("/views/customer/customer_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

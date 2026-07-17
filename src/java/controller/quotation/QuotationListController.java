package controller.quotation;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Quotation;
import model.Role;
import service.QuotationService;

@WebServlet(name = "QuotationListController", urlPatterns = { "/quotation-list" })
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

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        service.RoleService roleService = new service.RoleService();
        Role userRole = roleService.getRoleById(user.getRoleId());
        String roleName = userRole != null ? userRole.getRoleName().toLowerCase() : "";

        Integer saleId = null;
        if (roleName.contains("sale")) {
            saleId = user.getUserId();
        }

        QuotationService quotationService = new QuotationService();
        int pageSize = 10;
        int pageIndex = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isBlank()) {
            try {
                pageIndex = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        int totalQuotations = quotationService.getTotalQuotations(searchText, status, fromDate, toDate, saleId, user.getUserId(), user.getRoleId());
        int endPage = (int) Math.ceil((double) totalQuotations / pageSize);
        if (pageIndex > endPage && endPage > 0) {
            pageIndex = endPage;
        }
        if (pageIndex < 1) {
            pageIndex = 1;
        }

<<<<<<< HEAD
        int fromIndex = Math.min((page - 1) * pageSize, totalQuotations);
        int toIndex = Math.min(fromIndex + pageSize, totalQuotations);
        List<Quotation> pagedQuotationList = totalQuotations == 0
                ? java.util.Collections.emptyList()
                : quotationList.subList(fromIndex, toIndex);
=======
        List<Quotation> quotationList = quotationService.searchQuotations(searchText, status, fromDate, toDate, saleId, user.getUserId(), user.getRoleId(), pageIndex, pageSize);

        request.setAttribute("endPage", endPage);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("quotationList", quotationList);
>>>>>>> 82f89d5717e0ab74238e9d04ef7ecf73b298cabb

        request.setAttribute("searchText", searchText);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("totalQuotations", totalQuotations);
        request.getRequestDispatcher("/views/quotation/list.jsp").forward(request, response);
    }
}

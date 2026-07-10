package controller.dashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.DashboardDAO;
import model.User;
import dto.TopProductDTO;
import dto.TopCustomerDTO;
import dto.StatusStatisticDTO;
import java.io.IOException;
import java.util.Map;
import service.RevenueService;
import java.util.*;

@WebServlet(name = "RevenueController", urlPatterns = {"/revenue-report"})
public class RevenueController extends HttpServlet {
    private final RevenueService revenueService = new RevenueService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Integer filterUserId = null;
        // If Sale Staff (roleId 4), only show their own
        if (user.getRoleId() == 4) {
            filterUserId = user.getUserId();
        }

        DashboardDAO dao = new DashboardDAO();

        int totalProducts = dao.getTotalProducts();
        int totalOrders = dao.getTotalOrders(filterUserId);
        int totalQuotations = dao.getTotalQuotations(filterUserId);
        int totalContracts = dao.getTotalContracts(filterUserId);

        List<StatusStatisticDTO> orderStatusCounts = dao.countByStatus("customer_order", "order_status", filterUserId);
        List<StatusStatisticDTO> quotationStatusCounts = dao.countByStatus("quotation", "quotation_status", filterUserId);
        List<StatusStatisticDTO> contractStatusCounts = dao.countByStatus("customer_contract", "contract_status", filterUserId);
        
        List<TopCustomerDTO> topCustomers = dao.getTopCustomersByOrderCount(5, filterUserId);
        
        List<TopProductDTO> topSellingProducts = dao.getTopSellingProducts(5, filterUserId);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalQuotations", totalQuotations);
        request.setAttribute("totalContracts", totalContracts);
        
        request.setAttribute("orderStatusCounts", orderStatusCounts);
        request.setAttribute("quotationStatusCounts", quotationStatusCounts);
        request.setAttribute("contractStatusCounts", contractStatusCounts);
        
        request.setAttribute("topCustomers", topCustomers);
        request.setAttribute("topSellingProducts", topSellingProducts);
        
        request.getRequestDispatcher("/views/revenue_report.jsp").forward(request, response);
    }
}

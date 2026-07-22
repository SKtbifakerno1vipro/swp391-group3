package controller.dashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.DashboardService;
import model.User;
import dto.TopProductDTO;
import dto.TopCustomerDTO;
import dto.StatusStatisticDTO;
import dto.RecentInvoiceDTO;
import java.io.IOException;
import java.util.Map;
import service.RevenueService;
import java.util.*;

@WebServlet(name = "RevenueController", urlPatterns = {"/revenue-report", "/revenue"})
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

        String period = request.getParameter("period");
        if (period == null || period.trim().isEmpty()) {
            period = "month";
        }

        DashboardService dao = new DashboardService();

        // Revenue breakdown amounts for Today, This Week, This Month, and All Time
        double revenueToday = dao.getTotalRevenue(filterUserId, "today");
        double revenueThisWeek = dao.getTotalRevenue(filterUserId, "week");
        double revenueThisMonth = dao.getTotalRevenue(filterUserId, "month");
        double totalRevenueAllTime = dao.getTotalRevenue(filterUserId, "all");

        // Period-filtered statistics
        int totalProducts = dao.getTotalProducts();
        int totalOrders = dao.getTotalOrders(filterUserId, period);
        int totalQuotations = dao.getTotalQuotations(filterUserId, period);
        int totalContracts = dao.getTotalContracts(filterUserId, period);
        double totalRevenue = dao.getTotalRevenue(filterUserId, period);

        List<StatusStatisticDTO> orderStatusCounts = dao.countByStatus("customer_order", "order_status", filterUserId, period);
        List<StatusStatisticDTO> quotationStatusCounts = dao.countByStatus("quotation", "quotation_status", filterUserId, period);
        List<StatusStatisticDTO> contractStatusCounts = dao.countByStatus("customer_contract", "contract_status", filterUserId, period);
        
        List<TopCustomerDTO> topCustomers = dao.getTopCustomersByOrderCount(5, filterUserId, period);
        
        List<TopProductDTO> topSellingProducts = dao.getTopSellingProducts(5, filterUserId, period);

        // Fetch recent orders & invoices for the tables
        List<Map<String, Object>> recentOrders = dao.getRecentOrders(5, filterUserId, period);
        List<dto.RecentInvoiceDTO> recentInvoices = dao.getRecentInvoicesForOfficer(10, null, null, period);

        request.setAttribute("period", period);
        request.setAttribute("revenueToday", revenueToday);
        request.setAttribute("revenueThisWeek", revenueThisWeek);
        request.setAttribute("revenueThisMonth", revenueThisMonth);
        request.setAttribute("totalRevenueAllTime", totalRevenueAllTime);

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalQuotations", totalQuotations);
        request.setAttribute("totalContracts", totalContracts);
        request.setAttribute("totalRevenue", totalRevenue);
        
        request.setAttribute("orderStatusCounts", orderStatusCounts);
        request.setAttribute("quotationStatusCounts", quotationStatusCounts);
        request.setAttribute("contractStatusCounts", contractStatusCounts);
        
        request.setAttribute("topCustomers", topCustomers);
        request.setAttribute("topSellingProducts", topSellingProducts);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("recentInvoices", recentInvoices);
        
        request.getRequestDispatcher("/views/report/revenue_report.jsp").forward(request, response);
    }
}

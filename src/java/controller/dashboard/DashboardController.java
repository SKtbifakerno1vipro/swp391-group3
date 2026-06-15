package controller.dashboard;



import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import service.DashboardService;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    private DashboardService dashboardService = new DashboardService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        
        // Only allow Admin (1) and Manager (2) to see full dashboard stats
        if (user.getRoleId() == 1 || user.getRoleId() == 2) {
            request.setAttribute("totalRevenue", dashboardService.getTotalRevenue());
            request.setAttribute("totalOrders", dashboardService.getTotalOrders());
            request.setAttribute("totalCustomers", dashboardService.getTotalCustomers());
            request.setAttribute("totalProducts", dashboardService.getTotalProducts());
            request.setAttribute("revenueByMonth", dashboardService.getRevenueByMonth());
            request.setAttribute("orderStatusStats", dashboardService.getOrderStatusStats());
            request.setAttribute("topSellingProducts", dashboardService.getTopSellingProducts(5));
            request.setAttribute("staffPerformance", dashboardService.getStaffPerformance());
        }

        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}





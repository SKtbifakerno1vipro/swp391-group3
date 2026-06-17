package controller.dashboard;



import dal.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        service.DashboardService dashboardService = new service.DashboardService();
        dal.DashboardDAO dashboardDAO = new dal.DashboardDAO();

        request.setAttribute("user", user);
        request.setAttribute("totalCustomers", dashboardService.getTotalCustomers());
        request.setAttribute("totalProducts", dashboardService.getTotalProducts());
        request.setAttribute("totalQuotations", dashboardDAO.count("quotation"));
        request.setAttribute("totalContracts", dashboardDAO.count("customer_contract"));
        request.setAttribute("totalOrders", dashboardService.getTotalOrders());
        request.setAttribute("totalRevenue", dashboardService.getTotalRevenue());
        
        request.setAttribute("quotationStatusCounts", dashboardDAO.countByStatus("quotation", "quotation_status"));
        request.setAttribute("contractStatusCounts", dashboardDAO.countByStatus("customer_contract", "contract_status"));
        request.setAttribute("orderStatusCounts", dashboardService.getOrderStatusStats());
        
        request.setAttribute("recentContracts", dashboardDAO.getRecentContracts(5));
        request.setAttribute("recentOrders", dashboardDAO.getRecentOrders(5));
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}

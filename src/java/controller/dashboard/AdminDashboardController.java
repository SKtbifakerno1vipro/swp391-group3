package controller.dashboard;

import dal.DashboardDAO;
import dto.DashboardSummaryDTO;
import dto.RoleStatisticDTO;
import dto.StatusStatisticDTO;
import dto.ActivityDTO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin-dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) { // 1 is System Admin
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        DashboardDAO dashboardDAO = new DashboardDAO();

        // Section 1: Summary Cards
        int totalUsers = dashboardDAO.getTotalUsers();
        int totalCustomers = dashboardDAO.getTotalCustomers();
        int totalProducts = dashboardDAO.getTotalProducts();
        int totalContracts = dashboardDAO.getTotalContracts();
        int totalOrders = dashboardDAO.getTotalOrders();
        int totalInvoices = dashboardDAO.getTotalInvoices();

        DashboardSummaryDTO summary = new DashboardSummaryDTO(
            totalUsers, totalCustomers, totalProducts, totalContracts, totalOrders, totalInvoices
        );
        request.setAttribute("summary", summary);

        // Section 2: Charts data
        List<RoleStatisticDTO> usersByRole = dashboardDAO.getUsersByRole();
        List<StatusStatisticDTO> contractsByStatus = dashboardDAO.getContractsByStatus();
        List<StatusStatisticDTO> ordersByStatus = dashboardDAO.getOrdersByStatus();

        request.setAttribute("usersByRole", usersByRole);
        request.setAttribute("contractsByStatus", contractsByStatus);
        request.setAttribute("ordersByStatus", ordersByStatus);

        // Section 3: Recent Activities (Audit Log)
        List<ActivityDTO> recentActivities = dashboardDAO.getRecentActivities();
        request.setAttribute("recentActivities", recentActivities);

        // Section 4: Quick Info
        // Fetch Database Name
        String dbName = "Unknown";
        try {
            // Get database name from connection properties
            // DashboardDAO extends DBContext which has connection field
            java.lang.reflect.Field field = dal.DBContext.class.getDeclaredField("connection");
            field.setAccessible(true);
            Connection conn = (Connection) field.get(dashboardDAO);
            if (conn != null) {
                dbName = conn.getCatalog();
            }
        } catch (Exception e) {
            System.out.println("Failed to fetch database name: " + e.getMessage());
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String serverTime = LocalDateTime.now().format(formatter);

        request.setAttribute("serverTime", serverTime);
        request.setAttribute("adminName", user.getFullName());
        request.setAttribute("dbName", dbName);
        request.setAttribute("appVersion", "1.0.0");

        request.getRequestDispatcher("/views/dashboard/admin-dashboard.jsp").forward(request, response);
    }
}

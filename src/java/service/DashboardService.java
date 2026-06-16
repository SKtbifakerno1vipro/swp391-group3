package service;

import dal.DashboardDAO;
import java.util.List;
import java.util.Map;

public class DashboardService {
    private DashboardDAO dashboardDAO;

    public DashboardService() {
        dashboardDAO = new DashboardDAO();
    }

    public double getTotalRevenue() {
        return dashboardDAO.getTotalRevenue();
    }

    public int getTotalOrders() {
        return dashboardDAO.getTotalOrders();
    }

    public int getTotalCustomers() {
        return dashboardDAO.getTotalCustomers();
    }

    public int getTotalProducts() {
        return dashboardDAO.getTotalProducts();
    }

    public Map<String, Double> getRevenueByMonth() {
        return dashboardDAO.getRevenueByMonth();
    }

    public Map<String, Integer> getOrderStatusStats() {
        return dashboardDAO.getOrderStatusStats();
    }

    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        return dashboardDAO.getTopSellingProducts(limit);
    }

    public List<Map<String, Object>> getStaffPerformance() {
        return dashboardDAO.getStaffPerformance();
    }
}

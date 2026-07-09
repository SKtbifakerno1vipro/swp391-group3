package service;

import dal.DashboardDAO;
import dto.TopProductDTO;
import dto.StatusStatisticDTO;
import java.util.List;
import java.util.Map;

public class DashboardService {
    private DashboardDAO dashboardDAO;

    public DashboardService() {
        dashboardDAO = new DashboardDAO();
    }

    public double getTotalRevenue(Integer userId) {
        return dashboardDAO.getTotalRevenue(userId);
    }

    public int getTotalOrders(Integer userId) {
        return dashboardDAO.getTotalOrders(userId);
    }

    public int getTotalCustomers(Integer userId) {
        return dashboardDAO.getTotalCustomers(userId);
    }

    public int getTotalProducts() {
        return dashboardDAO.getTotalProducts();
    }

    public Map<String, Double> getRevenueByMonth() {
        return dashboardDAO.getRevenueByMonth();
    }

    public List<StatusStatisticDTO> getOrderStatusStats() {
        return dashboardDAO.getOrderStatusStats();
    }

    public List<TopProductDTO> getTopSellingProducts(int limit) {
        return dashboardDAO.getTopSellingProducts(limit);
    }

    public List<Map<String, Object>> getStaffPerformance() {
        return dashboardDAO.getStaffPerformance();
    }
}

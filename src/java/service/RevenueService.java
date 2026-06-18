package service;

import dal.RevenueDAO;
import java.util.Map;

public class RevenueService {
    private RevenueDAO revenueDAO;

    public RevenueService() {
        revenueDAO = new RevenueDAO();
    }

    public Map<String, Double> getRevenueByDay(String startDate, String endDate, Integer userId) {
        return revenueDAO.getRevenueByDay(startDate, endDate, userId);
    }

    public Map<String, Double> getRevenueByMonth(String startDate, String endDate, Integer userId) {
        return revenueDAO.getRevenueByMonth(startDate, endDate, userId);
    }

    public Map<String, Double> getRevenueByYear(String startDate, String endDate, Integer userId) {
        return revenueDAO.getRevenueByYear(startDate, endDate, userId);
    }
}

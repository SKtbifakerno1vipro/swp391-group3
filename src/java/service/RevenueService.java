package service;

import dal.RevenueDAO;
import java.util.Map;

public class RevenueService {
    private RevenueDAO revenueDAO;

    public RevenueService() {
        revenueDAO = new RevenueDAO();
    }

    public Map<String, Double> getRevenueByDay(String startDate, String endDate) {
        return revenueDAO.getRevenueByDay(startDate, endDate);
    }

    public Map<String, Double> getRevenueByMonth(String startDate, String endDate) {
        return revenueDAO.getRevenueByMonth(startDate, endDate);
    }

    public Map<String, Double> getRevenueByYear(String startDate, String endDate) {
        return revenueDAO.getRevenueByYear(startDate, endDate);
    }
}

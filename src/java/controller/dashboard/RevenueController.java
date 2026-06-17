package controller.dashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RevenueService;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "RevenueController", urlPatterns = {"/revenue-report"})
public class RevenueController extends HttpServlet {
    private RevenueService revenueService = new RevenueService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null) type = "month";
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Map<String, Double> revenueData;
        if ("day".equals(type)) {
            revenueData = revenueService.getRevenueByDay(startDate, endDate);
        } else if ("year".equals(type)) {
            revenueData = revenueService.getRevenueByYear(startDate, endDate);
        } else {
            type = "month";
            revenueData = revenueService.getRevenueByMonth(startDate, endDate);
        }

        request.setAttribute("revenueData", revenueData);
        request.setAttribute("type", type);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.getRequestDispatcher("/views/revenue_report.jsp").forward(request, response);
    }
}

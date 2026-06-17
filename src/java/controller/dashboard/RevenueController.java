package controller.dashboard;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RevenueService;
import model.User;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "RevenueController", urlPatterns = {"/revenue-report"})
public class RevenueController extends HttpServlet {
    private RevenueService revenueService = new RevenueService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        Integer filterUserId = null;
        // If Sale Staff (roleId 4), only show their own revenue
        if (user.getRoleId() == 4) {
            filterUserId = user.getUserId();
        }

        String type = request.getParameter("type");
        if (type == null) type = "month";
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Map<String, Double> revenueData;
        if ("day".equals(type)) {
            revenueData = revenueService.getRevenueByDay(startDate, endDate, filterUserId);
        } else if ("year".equals(type)) {
            revenueData = revenueService.getRevenueByYear(startDate, endDate, filterUserId);
        } else {
            type = "month";
            revenueData = revenueService.getRevenueByMonth(startDate, endDate, filterUserId);
        }

        request.setAttribute("revenueData", revenueData);
        request.setAttribute("type", type);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.getRequestDispatcher("/views/revenue_report.jsp").forward(request, response);
    }
}

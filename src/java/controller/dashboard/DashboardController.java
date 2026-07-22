package controller.dashboard;

import dal.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.*;
import service.*;
import dto.*;
import dto.StatusStatisticDTO; // Force recompile after DAO signature change

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
        if (user.getRoleId() == 1) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        DashboardDAO dashboardDAO = new DashboardDAO();
        QuotationService quotationService = new QuotationService();
        CustomerService customerService = new CustomerService();
        ContractService contractService = new ContractService();
        request.setAttribute("user", user);

        if (user.getRoleId() == 3) { // ROLE_CUSTOMER
            response.sendRedirect(request.getContextPath() + "/customer-dashboard");
            return;
        }
        if (user.getRoleId() == 5) { // ROLE IS ADMIN OFFICER
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.setAttribute("awaitingQuotations", dashboardDAO.countQuotationAwaitingContract());
            request.setAttribute("contractsInProgress", dashboardDAO.countContractInProgress());
            request.setAttribute("activeContracts", dashboardDAO.countActiveContracts());
            request.setAttribute("draftContracts", dashboardDAO.countDraftContracts());
            request.setAttribute("contractStatusCounts", dashboardDAO.countContractStatusForOfficer()); // circle
            request.setAttribute("contractsNeedingAction", dashboardDAO.getContractNeedingAction(5, startDate, endDate));
            request.setAttribute("quotationsNeedingAction", dashboardDAO.getQuotationsAwaitingContract(5, startDate, endDate));
            request.setAttribute("recentInvoices", dashboardDAO.getRecentInvoicesForOfficer(10, startDate, endDate));
            request.setAttribute("invoiceSummary", dashboardDAO.getInvoiceSummaryForOfficer());
            request.getRequestDispatcher("/views/dashboard/admin-officier-dashboard.jsp").forward(request, response);
            return;
        }

        if (user.getRoleId() == 6) { // ROLE_WAREHOUSE_STAFF
            response.sendRedirect(request.getContextPath() + "/warehouse-dashboard");
            return;
        }

        DashboardService dashboardService = new DashboardService();

        RoleService roleService = new RoleService();
        Role userRole = roleService.getRoleById(user.getRoleId());
        String roleName = userRole != null ? userRole.getRoleName().toLowerCase() : "";

        Integer saleId = null;
        if (roleName.contains("sale")) {
            saleId = user.getUserId();
        }

        request.setAttribute("user", user);
        request.setAttribute("totalCustomers", dashboardService.getTotalCustomers(saleId));
        request.setAttribute("totalProducts", dashboardService.getTotalProducts());
        request.setAttribute("totalQuotations", dashboardDAO.getTotalQuotations(saleId));
        request.setAttribute("totalContracts", dashboardDAO.getTotalContracts(saleId));
        request.setAttribute("totalOrders", dashboardService.getTotalOrders(saleId));
        request.setAttribute("totalRevenue", dashboardService.getTotalRevenue(saleId));

        request.setAttribute("quotationStatusCounts", dashboardDAO.countByStatus("quotation", "quotation_status", saleId));
        request.setAttribute("contractStatusCounts", dashboardDAO.countByStatus("customer_contract", "contract_status", saleId));
        request.setAttribute("orderStatusCounts", dashboardService.getOrderStatusStats());

        request.setAttribute("recentContracts", dashboardDAO.getRecentContracts(5, saleId));
        request.setAttribute("recentOrders", dashboardDAO.getRecentOrders(5, saleId));
        request.getRequestDispatcher("/views/dashboard/manager-dashboard.jsp").forward(request, response);
    }

}

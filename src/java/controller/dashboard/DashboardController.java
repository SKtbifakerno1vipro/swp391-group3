package controller.dashboard;

import service.DashboardService;
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
import utils.Validation;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        session.removeAttribute("errorSig");

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() == 1) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
            return;
        }
        DashboardService DashboardService = new DashboardService();
        QuotationService quotationService = new QuotationService();
        CustomerService customerService = new CustomerService();
        ContractService contractService = new ContractService();
        request.setAttribute("user", user);

        if (user.getRoleId() == 3) { // ROLE_CUSTOMER
            response.sendRedirect(request.getContextPath() + "/customer/dashboard");
            return;
        }
        if (user.getRoleId() == 5) { // ROLE IS ADMIN OFFICER
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            String error = Validation.validateFromAndToDate(startDate, endDate);

            if (error != null) {
                session.setAttribute("errorSig", error);
            }
            request.setAttribute("awaitingQuotations", DashboardService.countQuotationAwaitingContract());
            request.setAttribute("contractsInProgress", DashboardService.countContractInProgress());
            request.setAttribute("activeContracts", DashboardService.countActiveContracts());
            request.setAttribute("draftContracts", DashboardService.countDraftContracts());
            request.setAttribute("pendingImportRequests", DashboardService.getPendingImportRequestsList(5));
            request.setAttribute("contractsNeedingAction", DashboardService.getContractNeedingAction(5, startDate, endDate));
            request.setAttribute("quotationsNeedingAction", DashboardService.getQuotationsAwaitingContract(5, startDate, endDate));
            request.setAttribute("recentInvoices", DashboardService.getRecentInvoicesForOfficer(10, startDate, endDate));
            request.setAttribute("invoiceSummary", DashboardService.getInvoiceSummaryForOfficer());
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
        request.setAttribute("totalQuotations", DashboardService.getTotalQuotations(saleId));
        request.setAttribute("totalContracts", DashboardService.getTotalContracts(saleId));
        request.setAttribute("totalOrders", dashboardService.getTotalOrders(saleId));
        request.setAttribute("totalRevenue", dashboardService.getTotalRevenue(saleId));

        request.setAttribute("quotationStatusCounts", DashboardService.countByStatus("quotation", "quotation_status", saleId));
        request.setAttribute("contractStatusCounts", DashboardService.countByStatus("customer_contract", "contract_status", saleId));
        request.setAttribute("orderStatusCounts", dashboardService.getOrderStatusStats());

        request.setAttribute("recentContracts", DashboardService.getRecentContracts(5, saleId));
        request.setAttribute("recentOrders", DashboardService.getRecentOrders(5, saleId));
        request.getRequestDispatcher("/views/dashboard/manager-dashboard.jsp").forward(request, response);
    }

}

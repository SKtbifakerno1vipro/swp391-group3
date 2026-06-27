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
import dal.*;
import service.*;
import dto.*;

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
        DashboardDAO dashboardDAO = new DashboardDAO();
        QuotationService quotationService = new QuotationService();
        CustomerService customerService = new CustomerService();
        ContractService contractService = new ContractService();
        request.setAttribute("user", user);

        if (user.getRoleId() == 3) { // ROLE_CUSTOMER

            CustomerDTO customer = customerService.getCustomerDTOByUserId(user.getUserId());
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=customer_not_found");
                return;
            }
            int customerId = customer.getCustomerId();
            session.setAttribute("customerId", customerId);
            request.setAttribute("customer", customer);

            List<Quotation> quotations = quotationService.getQuotationsByCustomerId(customerId);
            request.setAttribute("totalQuotations", quotations.size());
            List<Quotation> recentQuotations = quotations;
            if (recentQuotations.size() > 5) {
                recentQuotations = recentQuotations.subList(recentQuotations.size() - 5, recentQuotations.size());
            }
            request.setAttribute("recentQuotations", recentQuotations);

            List<ContractCustomerDTO> recentContracts = contractService.searchContracts(
                    null, null, null, null, 1, 5, user.getUserId(), user.getRoleId(),
                    null, null, null, null, null
            );
            int totalContracts = contractService.getTotalContracts(
                    null, null, null, null, 1, 5, user.getUserId(), user.getRoleId(),
                    null, null, null, null, null
            );
            request.setAttribute("totalContracts", totalContracts);
            request.setAttribute("recentContracts", recentContracts);

            request.getRequestDispatcher("/views/customer-dashboard.jsp").forward(request, response);
            return;
        }
        service.DashboardService dashboardService = new service.DashboardService();

        Integer UserId = null;
        if (user.getRoleId() == 4) {
            UserId = user.getUserId();
        }

        request.setAttribute("user", user);
        request.setAttribute("totalCustomers", dashboardService.getTotalCustomers());
        request.setAttribute("totalProducts", dashboardService.getTotalProducts());
        request.setAttribute("totalQuotations", dashboardDAO.count("quotation"));
        request.setAttribute("totalContracts", dashboardDAO.count("customer_contract"));
        request.setAttribute("totalOrders", dashboardService.getTotalOrders());
        request.setAttribute("totalRevenue", dashboardService.getTotalRevenue(UserId));
        
        request.setAttribute("quotationStatusCounts", dashboardDAO.countByStatus("quotation", "quotation_status"));
        request.setAttribute("contractStatusCounts", dashboardDAO.countByStatus("customer_contract", "contract_status"));
        request.setAttribute("orderStatusCounts", dashboardService.getOrderStatusStats());
        
        request.setAttribute("recentContracts", dashboardDAO.getRecentContracts(5));
        request.setAttribute("recentOrders", dashboardDAO.getRecentOrders(5));
        request.getRequestDispatcher("/views/dashboard.jsp").forward(request, response);
    }
}

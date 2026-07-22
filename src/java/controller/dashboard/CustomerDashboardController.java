package controller.dashboard;

import dto.ContractCustomerDTO;
import dto.CustomerDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Quotation;
import model.User;
import service.ContractService;
import service.CustomerService;
import service.QuotationService;

@WebServlet(name = "CustomerDashboardController", urlPatterns = {"/customer-dashboard"})
public class CustomerDashboardController extends HttpServlet {

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
        if (user.getRoleId() != 3) { // Only ROLE_CUSTOMER
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        CustomerService customerService = new CustomerService();
        QuotationService quotationService = new QuotationService();
        ContractService contractService = new ContractService();

        CustomerDTO customer = customerService.getCustomerDTOByUserId(user.getUserId());
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=customer_not_found");
            return;
        }

        int customerId = customer.getCustomer().getCustomerId();
        session.setAttribute("customerId", customerId);

        int totalQuotations = quotationService.getTotalQuotations(
                null, null, null, null, null, user.getUserId(), user.getRoleId()
        );
        List<Quotation> recentQuotations = quotationService.searchQuotations(
                null, null, null, null, user.getUserId(), user.getRoleId(), 1, 5
        );

        List<ContractCustomerDTO> recentContracts = contractService.searchContracts(
                null, null, null, null, 1, 5, user.getUserId(), user.getRoleId(),
                null, null, null, null, null, null
        );
        int totalContracts = contractService.getTotalContracts(
                null, null, null, null, 1, 5, user.getUserId(), user.getRoleId(),
                null, null, null, null, null, null
        );

        request.setAttribute("user", user);
        request.setAttribute("customer", customer);
        request.setAttribute("totalQuotations", totalQuotations);
        request.setAttribute("recentQuotations", recentQuotations);
        request.setAttribute("totalContracts", totalContracts);
        request.setAttribute("recentContracts", recentContracts);

        request.getRequestDispatcher("/views/dashboard/customer-dashboard.jsp").forward(request, response);
    }
}

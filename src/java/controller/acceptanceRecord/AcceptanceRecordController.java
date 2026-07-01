package controller.acceptanceRecord;

import dto.CustomerOrderDTO;
import dto.CustomerDTO;
import service.CustomerOrderService;
import dal.CustomerDAO;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.InputStream;
import java.util.Properties;
import model.User;

@WebServlet(name="AcceptanceRecordController", urlPatterns={"/AcceptanceRecordController"})
public class AcceptanceRecordController extends HttpServlet {

    private CustomerOrderService customerOrderService = new CustomerOrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
         User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
            return;
        }
        // Load company configuration from properties file
        Properties config = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/resources/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        } catch (IOException e) {
            session.setAttribute("errorInvoice", "Error: Config cannot activatity");
            response.sendRedirect("/customer-order-list");
            e.printStackTrace();
        }
        request.setAttribute("company_rep_name", config.getProperty("company_rep_name"));
        request.setAttribute("companyName", config.getProperty("company_name"));
        request.setAttribute("companyTaxCode", config.getProperty("company_tax_code"));
        request.setAttribute("companyAddress", config.getProperty("company_address"));
        request.setAttribute("companyPhone", config.getProperty("company_phone"));

        try {
            int orderId = Integer.parseInt(orderIdParam);
            CustomerOrderDTO order = customerOrderService.getCustomerOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }

            List<CustomerOrderDTO> details = customerOrderService.getOrderDetails(orderId);

            double grandTotal = 0;
            if (details != null) {
                for (CustomerOrderDTO item : details) {
                    if (item.getDetail() != null) {
                        grandTotal += item.getDetail().getTotal();
                    }
                }
            }

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("grandTotal", grandTotal);

            CustomerDAO customerDAO = new CustomerDAO();
            CustomerDTO customerFull = customerDAO.getCustomerDTOById(order.getCustomer().getCustomerId());
            request.setAttribute("customerFull", customerFull);

            java.time.LocalDate now = java.time.LocalDate.now();
            request.setAttribute("day", String.format("%02d", now.getDayOfMonth()));
            request.setAttribute("month", String.format("%02d", now.getMonthValue()));
            request.setAttribute("year", now.getYear());

            request.getRequestDispatcher("/views/acceptanceRecord/acceptanceRecord.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    } 
}

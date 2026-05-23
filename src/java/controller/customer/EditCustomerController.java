package controller.customer;

import service.CustomerService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.User;

public class EditCustomerController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerIdStr = request.getParameter("id");
        if (customerIdStr == null || customerIdStr.isBlank()) {
            request.setAttribute("error", "Edit failed");
            request.getRequestDispatcher("/views/customer/edit.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            Customer customer = customerService.getCustomerByCustomerId(customerId);

            if (customer == null) {
                request.setAttribute("error", "Edit failed");
                request.setAttribute("errorDetail", "Customer not found");
            } else {
                request.setAttribute("customer", customer);
                if (customer.getUserId() != 0) {
                    User user = customerService.getUserById(customer.getUserId());
                    if (user != null) request.setAttribute("user", user);
                }
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Edit failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }

        request.getRequestDispatcher("/views/customer/edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String customerIdStr = request.getParameter("customerId");
        String userIdStr = request.getParameter("userId");

        if (customerIdStr == null || customerIdStr.isBlank() || userIdStr == null || userIdStr.isBlank()) {
            request.setAttribute("error", "Update failed: missing IDs");
            request.getRequestDispatcher("/views/customer/edit.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            int userId = Integer.parseInt(userIdStr);

            String userName = request.getParameter("username");
            String password = request.getParameter("password");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String taxCode = request.getParameter("taxCode");
            String type = request.getParameter("type");

            User u = new User();
            u.setUserId(userId);
            u.setUserName(userName);
            u.setPassword(password);
            u.setEmail(email);
            u.setFullName(fullName);
            u.setStatus(status);

            Customer c = new Customer();
            c.setCustomerId(customerId);
            c.setTaxCode(taxCode);
            c.setType(type);

            boolean userUpdated = customerService.updateUser(u);
            boolean custUpdated = customerService.updateCustomer(c);

            if (!userUpdated || !custUpdated) {
                Customer customer = customerService.getCustomerByCustomerId(customerId);
                request.setAttribute("customer", customer);
                if (customer != null && customer.getUserId() > 0) {
                    User user = customerService.getUserById(customer.getUserId());
                    if (user != null) request.setAttribute("user", user);
                }
                request.setAttribute("error", "Update failed");
                request.getRequestDispatcher("/views/customer/edit.jsp").forward(request, response);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/CustomerDetail?id=" + customerId);
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Update failed");
            request.setAttribute("errorDetail", ex.getMessage());
            request.getRequestDispatcher("/views/customer/edit.jsp").forward(request, response);
        }
    }
}

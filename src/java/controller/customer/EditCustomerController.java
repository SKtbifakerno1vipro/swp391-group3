package controller.customer;

import service.CustomerService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import model.Customer;
import model.User;

@WebServlet(name = "EditCustomerController", urlPatterns = {"/customer/edit"})
public class EditCustomerController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();

    private final service.RoleService roleService = new service.RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerIdStr = request.getParameter("id");

        if (customerIdStr == null || customerIdStr.isBlank()) {

            request.setAttribute("error", "Edit failed");
            request.getRequestDispatcher("/views/customer/customer_list.jsp").forward(request, response);

            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            Customer customer = customerService.getCustomerByCustomerId(customerId);

            if (customer == null) {
                request.setAttribute("error", "Edit failed");
                request.setAttribute("errorDetail", "Customer not found");
            } else {
                customer.setCustomerId(customerId);
                request.setAttribute("customer", customer);
                if (customer.getUserId() != null) {
                    User user = customerService.getUserById(customer.getUserId());
                    if (user != null) {
                        request.setAttribute("user", user);
                    }
                }
                java.util.List<model.Role> roles = roleService.getAllRoles();
                request.setAttribute("roles", roles);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Edit failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }

        request.getRequestDispatcher("/views/customer/customer_edit.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String customerIdStr = request.getParameter("customerId");
        String userIdStr = request.getParameter("userId");

        if (customerIdStr == null || customerIdStr.isBlank() || userIdStr == null || userIdStr.isBlank()) {
            request.setAttribute("error", "Update failed: missing IDs");
            request.getRequestDispatcher("/views/customer/customer_edit.jsp").forward(request, response);
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
            String roleIdStr = request.getParameter("roleId");
            String taxCode = request.getParameter("taxCode");
            String type = request.getParameter("type");

            User u = new User();
            u.setUserId(userId);
            u.setUserName(userName);
            if (password != null && !password.isBlank()) {
                u.setPassword(password);
            }
            u.setEmail(email);
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setStatus(status);
            if (roleIdStr != null && !roleIdStr.isBlank()) {
                u.setRoleId(Integer.parseInt(roleIdStr));
            }

            Customer c = new Customer();
            c.setCustomerId(customerId);
            c.setTaxCode(taxCode);
            c.setType(type);

            boolean userUpdated = customerService.updateUser(u);
            boolean custUpdated = customerService.updateCustomer(c);

            if (!userUpdated || !custUpdated) {
                request.setAttribute("customer", customerService.getCustomerByCustomerId(customerId));
                request.setAttribute("user", customerService.getUserById(userId));
                request.setAttribute("roles", roleService.getAllRoles());
                request.setAttribute("error", "Update failed");
                request.getRequestDispatcher("/views/customer/customer_edit.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/customer/detail?id=" + customerId);
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Update failed");
            request.setAttribute("errorDetail", ex.getMessage());
            request.getRequestDispatcher("/views/customer/customer_edit.jsp").forward(request, response);
        }
    }
}

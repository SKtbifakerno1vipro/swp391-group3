package controller.customer;

import service.CustomerService;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import model.User;

@WebServlet(name = "CreateCustomerController", urlPatterns = {"/customer/create"})
public class CreateCustomerController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = customerService.getAllUsers();
        Integer customerRoleId = customerService.getRoleIdByName("Customer");
        request.setAttribute("users", users);
        request.setAttribute("customerRoleId", customerRoleId);
        request.getRequestDispatcher("/views/customer/customer_create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String taxCode = request.getParameter("taxCode");
        String companyName = request.getParameter("companyName");
        String customerType = request.getParameter("customerType");
        String assignedToUserIdValue = request.getParameter("assignedToUserId");
        String roleIdValue = request.getParameter("roleId");

        List<User> users = customerService.getAllUsers();
        request.setAttribute("users", users);
        Integer customerRoleId = customerService.getRoleIdByName("Customer");
        request.setAttribute("customerRoleId", customerRoleId);

        if (userName == null || userName.isBlank()
                || password == null || password.isBlank()
                || email == null || email.isBlank()
                || taxCode == null || taxCode.isBlank()
                || companyName == null || companyName.isBlank()
                || customerType == null || customerType.isBlank()) {
            request.setAttribute("error", "Create failed");
            request.getRequestDispatcher("/views/customer/customer_create.jsp").forward(request, response);
            return;
        }

        try {
            Integer roleId = null;
            if (roleIdValue != null && !roleIdValue.isBlank()) {
                roleId = Integer.parseInt(roleIdValue);
            }

            model.User u = new model.User();
            u.setUserName(userName);
            u.setPassword(password);
            u.setEmail(email);
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setStatus(status);
            u.setRoleId(roleId);

            model.Customer c = new model.Customer();
            c.setTaxCode(taxCode);
            c.setCompanyName(companyName);
            c.setCustomerType(customerType);
            if (assignedToUserIdValue != null && !assignedToUserIdValue.isBlank()) {
                c.setAssignedToUserId(Integer.parseInt(assignedToUserIdValue));
            }

            model.Customer createdCustomer = customerService.createUserAndCustomer(u, c);

            if (createdCustomer != null && createdCustomer.getUserId() != null && createdCustomer.getUserId() > 0) {
                request.setAttribute("success", true);
            } else {
                request.setAttribute("error", "Create failed. " + (customerService.getLastError() != null ? customerService.getLastError() : "Unknown error"));
            }
            request.getRequestDispatcher("/views/customer/customer_create.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Create failed");
            request.setAttribute("errorDetail", ex.getMessage());
            request.getRequestDispatcher("/views/customer/customer_create.jsp").forward(request, response);
        }
    }
}

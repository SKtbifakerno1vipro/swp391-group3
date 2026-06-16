package controller.customer;

import service.CustomerService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.util.Arrays;
import java.util.Map;
import model.*;
import service.*;
import utils.*;

@WebServlet(name = "CreateCustomerController", urlPatterns = {"/customer/create"})
public class CreateCustomerController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("customerRoleId", roleService.getRoleIdByName("Customer"));
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        request.setAttribute("users", customerService.getAllSalesExecutiveUsers());
        request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String userName = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String taxCode = request.getParameter("taxCode");
        String companyName = request.getParameter("companyName");
        String customerType = request.getParameter("customerType");
        String assignedToUserIdValue = request.getParameter("assignedToUserId");
        String roleIdValue = request.getParameter("roleId");

        request.setAttribute("users", customerService.getAllSalesExecutiveUsers());
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        request.setAttribute("customerRoleId", roleService.getRoleIdByName("Customer"));

        String errorMsg = null;

        if ((errorMsg = Validation.validateUsername(userName)) != null) {

        } else if ((errorMsg = Validation.validateEmail(email)) != null) {

        } else if ((errorMsg = Validation.validateFullName(fullName)) != null) {
            
        } else if ((errorMsg = Validation.validatePhone(phone)) != null) {
            
        } else if ((errorMsg = Validation.validateTaxCode(taxCode)) != null) {
            
        } else if ((errorMsg = Validation.validateCompanyName(companyName)) != null) {
            
        } else if (customerType == null || customerType.trim().isEmpty()) {
            errorMsg = "Please select customer type.";
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);    
            request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
            return;
        }

        try {
            Integer roleId = null;
            if (roleIdValue != null && !roleIdValue.isBlank()) {
                roleId = Integer.parseInt(roleIdValue);
            }

            User u = new model.User();
            u.setUserName(userName);
            u.setEmail(email);
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setStatus(status);
            u.setRoleId(roleId);
            Customer c = new Customer();
            c.setTaxCode(taxCode);
            c.setCompanyName(companyName);
            c.setCustomerType(customerType);
            if (assignedToUserIdValue != null && !assignedToUserIdValue.isBlank()) {
                c.setAssignedToUserId(Integer.parseInt(assignedToUserIdValue));
            }

            String msg = customerService.createCustomerDTO(u, c);

            if (msg == null || msg.trim().isEmpty()) {
                request.setAttribute("success", true);
            } else {
                request.setAttribute("error", "Create failed."+ msg + (customerService.getLastError() != null ? customerService.getLastError() : "Unknown error"));
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Create failed");
        }
        request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
    }
}

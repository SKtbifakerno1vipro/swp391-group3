package controller.customer;

import service.CustomerService;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import model.*;
import dto.*;
import service.*;

@WebServlet(name = "EditCustomerController", urlPatterns = {"/customer/edit"})
public class EditCustomerController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();
    private final RoleService roleService = new service.RoleService();
    private final UserService userService = new UserService();

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
            CustomerDTO cusDTO = customerService.getCustomerDTOByCusId(customerId);
            request.setAttribute("users", customerService.getAllSalesExecutiveUsers());
            request.setAttribute("roles", roleService.getAllRoles());
            request.setAttribute("listTypeCus", customerService.getCusTypeList());
            
            if (cusDTO == null) {
                request.setAttribute("error", "Edit failed");
                request.setAttribute("errorDetail", "Customer not found");
            } else {
                request.setAttribute("cusDTO", cusDTO);
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
        
        request.setAttribute("users", customerService.getAllSalesExecutiveUsers());
        request.setAttribute("roles", roleService.getAllRoles());
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        
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
            String companyName = request.getParameter("companyName");
            String customerType = request.getParameter("customerType");
            String assignedToUserIdValue = request.getParameter("assignedToUserId");

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
            c.setUserId(userId);
            c.setCustomerId(customerId);
            c.setTaxCode(taxCode);
            c.setCompanyName(companyName);
            c.setCustomerType(customerType);
            if (assignedToUserIdValue != null && !assignedToUserIdValue.isBlank()) {
                c.setAssignedToUserId(Integer.parseInt(assignedToUserIdValue));
            } else {
                c.setAssignedToUserId(null);
            }
            boolean cusDTOUpdated = customerService.updateCustomerDTO(u,c);
            
            if (!cusDTOUpdated) {
                request.setAttribute("error", "Update failed");
            }else{
                CustomerDTO cusDTO = customerService.getCustomerDTOByCusId(customerId);
                request.setAttribute("cusDTO", cusDTO);
                request.setAttribute("success", "Updated");
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Update failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }
        request.getRequestDispatcher("/views/customer/customer_edit.jsp").forward(request, response);
    }
}

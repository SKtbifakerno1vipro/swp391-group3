package controller.customer;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;
import model.*;
import dto.*;
import service.*;
import utils.*;

@WebServlet(name = "EditCustomerController", urlPatterns = {"/customer/edit"})
public class EditCustomerController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();
    private final RoleService roleService = new RoleService();
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String customerIdStr = request.getParameter("id");

        if (customerIdStr == null || customerIdStr.isBlank()) {
            request.setAttribute("error", "Edit failed");
            request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            
            // Security check: Customer can only edit their own profile
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            if (user != null && user.getRoleId() == 3) {
                CustomerDTO currentCustomer = customerService.getCustomerDTOByUserId(user.getUserId());
                if (currentCustomer == null || currentCustomer.getCustomer().getCustomerId() != customerId) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                    return;
                }
            }

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
        request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String customerIdStr = request.getParameter("customerId");
        String userIdStr = request.getParameter("userId");

        if (customerIdStr == null || customerIdStr.isBlank() || userIdStr == null || userIdStr.isBlank()) {
            request.setAttribute("error", "Update failed: missing IDs");
            request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
            return;
        }
        
        request.setAttribute("users", customerService.getAllSalesExecutiveUsers());
        request.setAttribute("roles", roleService.getAllRoles());
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        
        try {
            int customerId = Integer.parseInt(customerIdStr);
            int userId = Integer.parseInt(userIdStr);

            // Security check: Customer can only update their own profile
            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            if (user != null && user.getRoleId() == 3) {
                CustomerDTO currentCustomer = customerService.getCustomerDTOByUserId(user.getUserId());
                if (currentCustomer == null || currentCustomer.getCustomer().getCustomerId() != customerId || currentCustomer.getUser().getUserId() != userId) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                    return;
                }
            }

            String userName = request.getParameter("username");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String roleIdStr = request.getParameter("roleId");
            String taxCode = request.getParameter("taxCode");
            String companyName = request.getParameter("companyName");
            String customerType = request.getParameter("customerType");
            String assignedToUserIdValue = request.getParameter("assignedToUserId");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");
            String dateBirthStr = request.getParameter("dateBirth");

            String errorMsg = null;
            if ((errorMsg = Validation.validateGender(gender)) != null
                    || (errorMsg = Validation.validateAddress(address)) != null
                    || (errorMsg = Validation.validateDateBirth(dateBirthStr)) != null) {
                request.setAttribute("error", errorMsg);
                CustomerDTO cusDTO = customerService.getCustomerDTOByCusId(customerId);
                request.setAttribute("cusDTO", cusDTO);
                request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
                return;
            }

            User u = new User();
            u.setUserId(userId);
            u.setUserName(userName);
            u.setEmail(email);
            u.setFullName(fullName);
            u.setPhone(phone);
            u.setStatus(status);
            if (roleIdStr != null && !roleIdStr.isBlank()) {
                u.setRoleId(Integer.parseInt(roleIdStr));
            }
            if (gender != null && !gender.isBlank()) {
                u.setGender(gender.trim());
            }
            if (address != null && !address.isBlank()) {
                u.setAddress(address.trim());
            }
            if (dateBirthStr != null && !dateBirthStr.isBlank()) {
                try {
                    u.setDateBirth(Date.valueOf(dateBirthStr.trim()));
                } catch (Exception e) {
                    System.out.println("Error parsing dateBirth: " + e.getMessage());
                    e.printStackTrace();
                }
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
        request.getRequestDispatcher("/views/customer/customer_form.jsp").forward(request, response);
    }
}

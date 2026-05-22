/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.customer;

import dal.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.User;

/**
 *
 * @author ADMIN
 */
public class CreateCustomerController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CreateCustomerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateCustomerController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        CustomerDAO dao = new CustomerDAO();
        List<User> users = dao.getAllUsers();
        Integer customerRoleId = dao.getRoleIdByName("Customer");
        request.setAttribute("users", users);
        request.setAttribute("customerRoleId", customerRoleId);
        request.getRequestDispatcher("views/customer/create.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        String type = request.getParameter("type");
        String createByValue = request.getParameter("createBy");
        String roleIdValue = request.getParameter("roleId");

        CustomerDAO dao = new CustomerDAO();
        List<User> users = dao.getAllUsers();
        request.setAttribute("users", users);
        Integer customerRoleId = dao.getRoleIdByName("Customer");
        request.setAttribute("customerRoleId", customerRoleId);

        if (userName == null || userName.isBlank() || password == null || password.isBlank() || email == null || email.isBlank() || createByValue == null || createByValue.isBlank() || taxCode == null || taxCode.isBlank() || type == null || type.isBlank()) {
            request.setAttribute("error", "Create failed");
            request.getRequestDispatcher("views/customer/create.jsp").forward(request, response);
            return;
        }

        try {
            int createBy = Integer.parseInt(createByValue);
            Integer roleId = customerRoleId != null ? customerRoleId : Integer.parseInt(roleIdValue);

            User user = new User();
            user.setUserName(userName);
            user.setPassword(password);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setStatus(status != null && !status.isBlank() ? status : "Active");
            user.setRoleId(roleId);

            Customer customer = new Customer();
            customer.setTaxCode(taxCode);
            customer.setType(type);
            customer.setCreateBy(createBy);

            Customer createdCustomer = dao.createUserAndCustomer(user, customer);
            if (createdCustomer == null || createdCustomer.getCustomerId() <= 0) {
                request.setAttribute("error", "Create failed");
                String detail = dao.getLastError();
                if (detail != null) {
                    request.setAttribute("errorDetail", detail);
                }
            } else {
                request.setAttribute("success", "Create successful");
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Create failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }

        request.getRequestDispatcher("views/customer/create.jsp").forward(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

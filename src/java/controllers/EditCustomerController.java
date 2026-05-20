/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers;

import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Customer;

/**
 *
 * @author ADMIN
 */
public class EditCustomerController extends HttpServlet {
   
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
            out.println("<title>Servlet EditCustomerController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditCustomerController at " + request.getContextPath () + "</h1>");
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
        String customerIdStr = request.getParameter("id");
        if (customerIdStr == null || customerIdStr.isBlank()) {
            request.setAttribute("error", "Edit failed");
            request.getRequestDispatcher("views/EditCustomer.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            CustomerDAO dao = new CustomerDAO();
            Customer customer = dao.getCustomerByCustomerId(customerId);
            
            if (customer == null) {
                request.setAttribute("error", "Edit failed");
                request.setAttribute("errorDetail", "Customer not found");
            } else {
                request.setAttribute("customer", customer);
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Edit failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }

        request.getRequestDispatcher("views/EditCustomer.jsp").forward(request, response);
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
        String customerIdStr = request.getParameter("customerId");
        String taxCode = request.getParameter("taxCode");
        String type = request.getParameter("type");

        if (customerIdStr == null || customerIdStr.isBlank() || taxCode == null || taxCode.isBlank() || type == null || type.isBlank()) {
            request.setAttribute("error", "Edit failed");
            request.getRequestDispatcher("views/EditCustomer.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            CustomerDAO dao = new CustomerDAO();
            Customer customer = dao.getCustomerByCustomerId(customerId);
            
            if (customer == null) {
                request.setAttribute("error", "Edit failed");
                request.setAttribute("errorDetail", "Customer not found");
            } else {
                customer.setTaxCode(taxCode);
                customer.setType(type);
                boolean success = dao.updateCustomer(customer);
                
                if (success) {
                    request.setAttribute("success", "Edit successful");
                    request.setAttribute("customer", customer);
                } else {
                    request.setAttribute("error", "Edit failed");
                    String detail = dao.getLastError();
                    if (detail != null) {
                        request.setAttribute("errorDetail", detail);
                    }
                    request.setAttribute("customer", customer);
                }
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Edit failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }

        request.getRequestDispatcher("views/EditCustomer.jsp").forward(request, response);
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

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controllers;
import dal.AccountDAO;
import dal.RoleDAO;
import jakarta.servlet.RequestDispatcher;
import models.Account;
import java.util.List;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Role;
import viewmodels.AccountDetail;

/**
 *
 * @author ADMIN
 */
public class AccountListController extends HttpServlet {
   
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
            out.println("<title>Servlet AccountListController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AccountListController at " + request.getContextPath () + "</h1>");
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
        HttpSession session = request.getSession();
        Account user = (Account)session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("Login");
        } else {
            AccountDAO dao = new AccountDAO();
            List<AccountDetail> accounts = dao.GetAccounts();
            RoleDAO rdao = new RoleDAO();
            List<Role> roles = rdao.GetRoles();
            roles.add(new Role(0, "ALL"));

            RequestDispatcher rd = request.getRequestDispatcher("views/AccountList.jsp");
            request.setAttribute("accounts", accounts);
            request.setAttribute("roles", roles);
            rd.forward(request, response);
        }
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
        String searchText = request.getParameter("searchText");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        
        AccountDAO dao = new AccountDAO();
        List<AccountDetail> accounts = dao.SearchAccount(searchText, roleId);
        RoleDAO rdao = new RoleDAO();
        List<Role> roles = rdao.GetRoles();
        roles.add(new Role(0, "ALL"));
        
        RequestDispatcher rd = request.getRequestDispatcher("views/AccountList.jsp");
        request.setAttribute("accounts", accounts);
        request.setAttribute("roles", roles);
        rd.forward(request, response);
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

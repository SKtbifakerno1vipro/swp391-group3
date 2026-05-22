/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.HouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Account;
import model.House;

public class HouseController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet HouseController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HouseController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HouseDAO dao = new HouseDAO();
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String id = request.getParameter("id");
            if (dao.hasActiveRoom(id)) {
                request.getSession().setAttribute("error", "Cannot delete house. It has occupied rooms.");
            } else {
                dao.delete(id);
            }
            response.sendRedirect(request.getContextPath() + "/House");
            return;
        }
        List<House> list = dao.getAll();
        request.setAttribute("houses", list);
        request.getRequestDispatcher("/view/admin/HouseList.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HouseDAO dao = new HouseDAO();
        if ("update".equals(action)) {
            String id = request.getParameter("id");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            int roomNum = Integer.parseInt(request.getParameter("roomNum"));

            House h = new House(id, name, address, roomNum, null);
            dao.update(h);

            response.sendRedirect(request.getContextPath() + "/House");
            return;
        }

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        int roomNum = Integer.parseInt(request.getParameter("roomNum"));
        Account acc = (Account) request.getSession().getAttribute("user");
        String acoountId = acc.getAccountId();
        House h = new House(id, name, address, roomNum, acoountId);
        dao.insert(h);

        response.sendRedirect(request.getContextPath() + "/House");

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

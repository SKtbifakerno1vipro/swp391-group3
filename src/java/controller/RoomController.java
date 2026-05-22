/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Room;

public class RoomController extends HttpServlet {

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
            out.println("<title>Servlet RoomController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RoomController at " + request.getContextPath() + "</h1>");
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
        RoomDAO dao = new RoomDAO();
        String action = request.getParameter("action");
        String houseId = request.getParameter("houseId");
        //delete
        if ("delete".equals(action)) {
            String roomId = request.getParameter("id");
            //if that room exist with another contract
            if (dao.hasContract(roomId)) {
                request.getSession().setAttribute("error",
                        "Cannot delete room, it has contract. ");
            } else {
                dao.delete(roomId);
            }
            response.sendRedirect(request.getContentType() + "Room?houseId=?" + houseId);
            return;
        }

        //Change status
        if ("toggle".equals(action)) {
            String roomId = request.getParameter("id");
            String status = request.getParameter("status");
            String newStatus = status.equals("A") ? "O" : "A";
            dao.updateStatus(roomId, newStatus);

            response.sendRedirect(request.getContentType() + "Room?houseId=?" + houseId);
            return;
        }

        //view list
        List<Room> list = dao.getByHouse(houseId);
        request.setAttribute("rooms", list);
        request.setAttribute("houseId", houseId);
        request.getRequestDispatcher("/view/admin/RoomList.jsp")
                .forward(request, response);

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
        RoomDAO dao = new RoomDAO();
        String roomId = request.getParameter("id");
        String houseId = request.getParameter("houseId");

        Room r = new Room(roomId, "A", houseId);
        dao.insert(r);
        response.sendRedirect(request.getContentType() + "Room?houseId=?" + houseId);

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

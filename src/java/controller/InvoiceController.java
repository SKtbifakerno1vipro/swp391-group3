/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.InvoiceDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Invoice;

public class InvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        InvoiceDAO dao = new InvoiceDAO();
        String action = request.getParameter("action");

        if ("pay".equals(action)) {
            String id = request.getParameter("id");
            dao.updateStatus(id, "P");
            response.sendRedirect(request.getContextPath() + "/Invoice");
            return;
        }

        List<Invoice> list = dao.getAll();
        request.setAttribute("invoices", list);
        request.getRequestDispatcher("/view/admin/InvoiceList.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        InvoiceDAO dao = new InvoiceDAO();

        String id = request.getParameter("id");
        String contractId = request.getParameter("contractId");
        int electric = Integer.parseInt(request.getParameter("electric"));
        int water = Integer.parseInt(request.getParameter("water"));
        int roomPrice = Integer.parseInt(request.getParameter("roomPrice"));
        int other = Integer.parseInt(request.getParameter("other"));

        Invoice i = new Invoice(id, electric, water,
                roomPrice, other, "U", contractId);

        dao.insert(i);

        response.sendRedirect(request.getContextPath() + "/Invoice");
    }
}

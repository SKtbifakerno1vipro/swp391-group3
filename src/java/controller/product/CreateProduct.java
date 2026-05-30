/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.product;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Category;
import model.Product;
import service.ProductService;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "CreateProduct", urlPatterns = {"/create-product"})
public class CreateProduct extends HttpServlet {

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
            out.println("<title>Servlet CreateProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateProduct at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        ProductService pService = new ProductService();
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();

        request.setAttribute("units", units);
        request.setAttribute("statusList", statusList);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/product/create.jsp").forward(request, response);
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

        ProductService pService = new ProductService();
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();
        String name = request.getParameter("name");
        String costRaw = request.getParameter("cost");
        String sellRaw = request.getParameter("sell");
        String des = request.getParameter("description");
        String unit = request.getParameter("unit");
        String status = request.getParameter("status");
        String qRaw = request.getParameter("quantity");
        String cRaw = request.getParameter("categoryId");
        String uRaw = request.getParameter("upby");
        request.setAttribute("units", units);
        request.setAttribute("categories", categories);
        request.setAttribute("statusList", statusList);
        request.setAttribute("name", name);
        request.setAttribute("cost", costRaw);
        request.setAttribute("sell", sellRaw);
        request.setAttribute("description", des);
        request.setAttribute("unit", unit);
        request.setAttribute("status", status);
        request.setAttribute("quantity", qRaw);
        request.setAttribute("categoryId", cRaw);
        request.setAttribute("upby", uRaw);
        String error = null;
        Product p = new Product();
        if (name == null || name.trim().isEmpty()
                || des == null || des.trim().isEmpty()) {
            error = "Please fill data all";
        }
        if (error == null) {
            try {
                double cost = Double.parseDouble(costRaw);
                double sell = Double.parseDouble(sellRaw);
                int q = Integer.parseInt(qRaw);
                int categoryId = Integer.parseInt(cRaw);
                int upby = Integer.parseInt(uRaw);
                p.setCostPrice(cost);
                p.setSellingPrice(sell);
                p.setQuantityAvailable(q);
                p.setUpdatedBy(upby);
                p.setCategoryId(categoryId);
                p.setProductName(name);
                p.setDescription(des);
                p.setUnit(unit);
                p.setProductStatus(status);
                boolean create = pService.createProduct(p);
                if (create) {
                    response.sendRedirect(request.getContextPath() + "/product-list");
                    return;
                } else {
                    error = "Create Product Failed";

                }
            } catch (NumberFormatException e) {
                error = "Please check number format";
            }

        }
        request.setAttribute("error", error);
        request.getRequestDispatcher("/views/product/create.jsp").forward(request, response);

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

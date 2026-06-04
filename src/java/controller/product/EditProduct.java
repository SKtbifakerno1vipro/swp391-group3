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
import model.User;
import service.ProductService;
import utils.Validation;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "EditProduct", urlPatterns = {"/edit-product"})
public class EditProduct extends HttpServlet {

    private final ProductService pService = new ProductService();

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
            out.println("<title>Servlet EditProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProduct at " + request.getContextPath() + "</h1>");
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
        User u = (User) session.getAttribute("user");

        String productId = request.getParameter("id");
        int id = Integer.parseInt(productId);
        String action = request.getParameter("action");
        Product p = pService.getProductById(Integer.parseInt(productId));
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        String updateBy = pService.getUpdateByWithProductId(id);
        List<String> statusList = pService.getProductStatus();
        request.setAttribute("units", units);
        request.setAttribute("categories", categories);
        request.setAttribute("statusList", statusList);
        request.setAttribute("update_by", updateBy);
        request.setAttribute("action", action);
        request.setAttribute("product", p);
        request.getRequestDispatcher("/views/product/detail.jsp").forward(request, response);
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
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String productId = request.getParameter("id");
        int id = Integer.parseInt(productId);

        Product p = pService.getProductById(Integer.parseInt(productId));
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();
        String updateBy = pService.getUpdateByWithProductId(id);
        String name = request.getParameter("name");
        String costRaw = request.getParameter("cost");
        String sellRaw = request.getParameter("sell");
        String des = request.getParameter("description");
        String unit = request.getParameter("unit");
        String status = request.getParameter("status");
        String qRaw = request.getParameter("quantity");
        String cRaw = request.getParameter("categoryId");
        User u = (User) session.getAttribute("user");

        String error = null;
        Product p1 = new Product();
        if (error == null) {
            error = Validation.validateCompanyName(name);
        }
        if (error == null) {
            error = Validation.validatePrice(costRaw);
        }
        if (error == null) {
            error = Validation.validatePrice(sellRaw);
        }
        if (error == null) {
            error = Validation.validateQuantity(qRaw);
        }
        if (error == null) {
            p1.setCostPrice(Double.parseDouble(costRaw));
            p1.setSellingPrice(Double.parseDouble(sellRaw));
            p1.setQuantityAvailable(Integer.parseInt(qRaw));
            p1.setUpdatedBy(u.getUserId());
            p1.setCategoryId(Integer.parseInt(cRaw));
            p1.setProductName(name);
            p1.setDescription(des);
            p1.setUnit(unit);
            p1.setProductStatus(status);
            p1.setProductId(id);
            boolean update = pService.updateProduct(p1);
            if (update) {
                response.sendRedirect(request.getContextPath() + "/product-detail?id=" + id);
            } else {
                error = "Update Product Failed";
            }
        } else {
            request.setAttribute("units", units);
            request.setAttribute("error", error);
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
            request.setAttribute("update_by", updateBy);
            request.setAttribute("product", p);
            request.getRequestDispatcher("/views/product/detail.jsp").forward(request, response);
        }
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

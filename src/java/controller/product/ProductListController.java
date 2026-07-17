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
import model.User;
import service.ProductService;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "ProductListController", urlPatterns = {"/product-list"})
public class ProductListController extends HttpServlet {

    private ProductService pService = new ProductService();
    private final int PAGE_SIZE = 10;

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
            out.println("<title>Servlet ProductList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductList at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        List<Category> categories = pService.getAllCategory();
        String sort = request.getParameter("sort");
        String searchText = request.getParameter("searchText");
        String pageRaw = request.getParameter("page");
        String totalPageRaw = request.getParameter("totalPage");
        Category c = new Category();
        c.setCategoryId(0);
        c.setCategoryName("All Category");
        categories.add(0, c);
        int categoryId = (request.getParameter("categoryId") == null || request.getParameter("categoryId").isEmpty()) ? 0 : Integer.parseInt(request.getParameter("categoryId"));
        int page = (pageRaw == null || pageRaw.isEmpty()) ? 1 : Integer.parseInt(pageRaw);
        int totalPage = (totalPageRaw == null || totalPageRaw.isEmpty()) ? 1 : Integer.parseInt(totalPageRaw);
        int totalRow = pService.countProduct(searchText, categoryId, "ACTIVE");
        totalPage = pService.calculateTotalPage(totalRow, PAGE_SIZE);
        page = pService.nomalizePage(page, totalPage);
        if (searchText != null) {
            searchText = searchText.trim();
        }
        String error = (String) session.getAttribute("errorProduct");
        session.removeAttribute("errorProduct");
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("searchText", searchText);
        request.setAttribute("errorProduct", error);
        request.setAttribute("sort", sort);
        request.setAttribute("products", pService.searchProduct(searchText, categoryId, sort, "ACTIVE", totalRow, page, totalPage, PAGE_SIZE));
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("page", page);
        request.setAttribute("totalRow", totalRow);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/product/list.jsp").forward(request, response);
        
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
         String id = request.getParameter("id");
         pService.deleteProduct(Integer.parseInt(id));
         response.sendRedirect(request.getContextPath() + "/product-list");
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

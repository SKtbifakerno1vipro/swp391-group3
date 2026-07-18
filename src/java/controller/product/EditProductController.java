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
import service.ProductReviewService;
import model.ProductReview;
import dto.CustomerDTO;
import service.CustomerService;
import service.UserService;
import utils.Validation;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "EditProductController", urlPatterns = {"/edit-product"})
public class EditProductController extends HttpServlet {

    private final ProductService pService = new ProductService();
    private final ProductReviewService reviewService = new ProductReviewService();
    private final CustomerService customerService = new CustomerService();
    private final UserService userService = new UserService();
    
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();

        if ("create".equals(action)) {
            if (user.getRoleId() == 3) {
                session.setAttribute("errorProduct", "Quý khách không có tính năng này.");
                response.sendRedirect(request.getContextPath() + "/product-list");
                return;
            }
            request.setAttribute("units", units);
            request.setAttribute("action", action);
            request.setAttribute("categories", categories);
            request.setAttribute("statusList", statusList);
            request.getRequestDispatcher("/views/product/create.jsp").forward(request, response);
        } else if ("edit".equals(action) || "detail".equals(action)) {
            if ("edit".equals(action) && user.getRoleId() == 3) {
                session.setAttribute("errorProduct", "Quý khách không có tính năng này.");
                response.sendRedirect(request.getContextPath() + "/product-list");
                return;
            }
            String productId = request.getParameter("id");
            if (productId == null || productId.isEmpty()) {
                session.setAttribute("errorProduct", "Không tìm thấy sản phẩm.");
                response.sendRedirect(request.getContextPath() + "/product-list");
                return;
            }
            try {
                int id = Integer.parseInt(productId);
                Product p = pService.getProductById(id);
                if (p == null) {
                    session.setAttribute("errorProduct", "Sản phẩm không tồn tại.");
                    response.sendRedirect(request.getContextPath() + "/product-list");
                    return;
                }

                List<ProductReview> reviews = reviewService.getReviewsByProductId(id);
                double avgRating = reviewService.getAverageRating(id);

                boolean canReview = false;
                if (user.getRoleId() == 3) {

                    CustomerDTO customerDTO = customerService.getCustomerDTOByUserId(user.getUserId());
                    if (customerDTO != null && customerDTO.getCustomer() != null) {
                        canReview = reviewService.hasPurchasedProduct(customerDTO.getCustomer().getCustomerId(), id);
                    }
                }

                request.setAttribute("reviews", reviews);
                request.setAttribute("avgRating", avgRating);
                request.setAttribute("canReview", canReview);

                request.setAttribute("product", p);
                request.setAttribute("units", units);
                request.setAttribute("categories", categories);
                request.setAttribute("statusList", statusList);
                request.setAttribute("update_at", p.getUpdatedAt());
                request.setAttribute("update_by", userService.getUserById(p.getUpdatedBy()).getFullName());
                request.setAttribute("action", action);
                request.getRequestDispatcher("/views/product/detail.jsp").forward(request,
                        response);
            } catch (NumberFormatException e) {
                session.setAttribute("errorProduct", "ID sản phẩm lỗi");
                response.sendRedirect(request.getContextPath() + "/product-list");
            }
        } else {
            session.setAttribute("errorProduct", "Không tìm thấy hành động hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/product-list");
        }
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
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String productId = request.getParameter("id");
        if (user.getRoleId() == 3) {
                session.setAttribute("errorProduct", "Quý khách không có tính năng này.");
                response.sendRedirect(request.getContextPath() + "/product-list");
                return;
            }
        int id = 0;
        if ("edit".equals(action)) {
            try {
                id = Integer.parseInt(productId);
            } catch (NumberFormatException e) {
                session.setAttribute("errorProduct", "ID sản phẩm không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/product-list");
                return;
            }
        }

        String name = request.getParameter("name");
        String costRaw = request.getParameter("cost");
        String sellRaw = request.getParameter("sell");
        String des = request.getParameter("description");
        String unit = request.getParameter("unit");
        String status = request.getParameter("status");
        String qRaw = request.getParameter("quantity");
        String cRaw = request.getParameter("categoryId");

        String error = null;
        if (error == null) {
            error = Validation.validateProductName(name);
        }
        if (error == null) {
            error = Validation.validateProductUnit(unit);
        }
        if (error == null) {
            error = Validation.validateCostAndSellingPrice(costRaw, sellRaw);
        }
        if (error == null) {
            error = Validation.validateQuantity(qRaw);
        }

        if (error == null) {
            Integer idObj = null;
            if ("edit".equals(action)) {
                idObj = id;
            }
            if (pService.isProductNameExists(name, idObj)) {
                error = "Tên sản phẩm này đã tồn tại trong hệ thống!";
            }
        }

        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("categories", categories);
            request.setAttribute("units", units);
            request.setAttribute("statusList", statusList);

            if ("create".equals(action)) {
                request.setAttribute("action", "create");
                request.setAttribute("name", name);
                request.setAttribute("cost", costRaw);
                request.setAttribute("sell", sellRaw);
                request.setAttribute("description", des);
                request.setAttribute("unit", unit);
                request.setAttribute("status", status);
                request.setAttribute("quantity", qRaw);
                request.setAttribute("categoryId", cRaw);
                request.getRequestDispatcher("/views/product/create.jsp").forward(request, response);
            } else if ("edit".equals(action)) {
                Product errorProduct = new Product();
                errorProduct.setProductId(id);
                errorProduct.setProductName(name);
                errorProduct.setDescription(des);
                errorProduct.setUnit(unit);
                errorProduct.setProductStatus(status);

                try { errorProduct.setCostPrice(Double.parseDouble(costRaw)); } catch (Exception e) { errorProduct.setCostPrice(0.0); }
                try { errorProduct.setSellingPrice(Double.parseDouble(sellRaw)); } catch (Exception e) { errorProduct.setSellingPrice(0.0); }
                try { errorProduct.setQuantityAvailable(Integer.parseInt(qRaw)); } catch (Exception e) { errorProduct.setQuantityAvailable(0); }
                try { errorProduct.setCategoryId(Integer.parseInt(cRaw)); } catch (Exception e) { errorProduct.setCategoryId(0); }

                request.setAttribute("cost", costRaw);
                request.setAttribute("sell", sellRaw);
                request.setAttribute("quantity", qRaw);
                request.setAttribute("categoryId", cRaw);

                request.setAttribute("action", "edit");
                request.setAttribute("product", errorProduct);
                request.getRequestDispatcher("/views/product/detail.jsp").forward(request, response);
            }
            return;
        }

        try {
            Product product = new Product();
            product.setProductName(name);
            product.setCostPrice(Double.parseDouble(costRaw));
            product.setSellingPrice(Double.parseDouble(sellRaw));
            product.setQuantityAvailable(Integer.parseInt(qRaw));
            product.setCategoryId(Integer.parseInt(cRaw));
            product.setDescription(des);
            product.setUnit(unit);
            product.setProductStatus(status);
            product.setUpdatedBy(user.getUserId());

            if ("create".equals(action)) {
                boolean isCreated = pService.createProduct(product);
                if (isCreated) {
                    service.AuditLogService.log(user.getUserId(), "CREATE", "Product", "Tạo sản phẩm: " + name);
                    response.sendRedirect(request.getContextPath() + "/product-list");
                } else {
                    session.setAttribute("errorProduct", "Tạo sản phẩm thất bại.");
                    response.sendRedirect(request.getContextPath() + "/product-list");
                }
            } else if ("edit".equals(action)) {
                product.setProductId(id);

                boolean isUpdated = pService.updateProduct(product);
                if (isUpdated) {
                    service.AuditLogService.log(user.getUserId(), "UPDATE", "Product", "Chỉnh sửa sản phẩm ID: " + id);
                    response.sendRedirect(request.getContextPath() + "/edit-product?id=" + id + "&action=detail");
                } else {
                    session.setAttribute("errorProduct", "Cập nhật sản phẩm thất bại.");
                    response.sendRedirect(request.getContextPath() + "/product-list");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("errorProduct", "Lỗi định dạng số liệu sản phẩm!");
            response.sendRedirect(request.getContextPath() + "/product-list");
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

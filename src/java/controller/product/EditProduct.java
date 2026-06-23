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
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();

        if ("create".equals(action)) {
            request.setAttribute("units", units);
            request.setAttribute("action", action);
            request.setAttribute("categories", categories);
            request.setAttribute("statusList", statusList);
            request.getRequestDispatcher("/views/product/create.jsp").forward(request, response);
        } else if ("edit".equals(action) || "detail".equals(action)) {
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
                request.setAttribute("product", p);
                request.setAttribute("units", units);
                request.setAttribute("categories", categories);
                request.setAttribute("statusList", statusList);
                request.setAttribute("update_at", p.getUpdatedAt());
                request.setAttribute("update_by", p.getUpdatedBy());
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
        User u = (User) session.getAttribute("user");
        if (u == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // BƯỚC 1: Đọc tất cả các tham số từ form gửi lên
        String action = request.getParameter("action");
        String productId = request.getParameter("id");

        String name = request.getParameter("name");
        String costRaw = request.getParameter("cost");
        String sellRaw = request.getParameter("sell");
        String des = request.getParameter("description");
        String unit = request.getParameter("unit");
        String status = request.getParameter("status");
        String qRaw = request.getParameter("quantity");
        String cRaw = request.getParameter("categoryId");

        // BƯỚC 2: Kiểm tra tính hợp lệ của dữ liệu (Validation)
        String error = null;
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

        // Lấy lại danh sách Category & Unit dự phòng trường hợp xảy ra lỗi cần load lại trang
        List<Category> categories = pService.getAllCategory();
        List<String> units = pService.getProductUnit();
        List<String> statusList = pService.getProductStatus();

        // BƯỚC 3: Nếu DỮ LIỆU NHẬP BỊ LỖI -> Trả về form cũ kèm thông báo lỗi
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
                // Đóng gói các giá trị bị lỗi vào đối tượng Product tạm thời để hiển thị lại trên Form detail.jsp
                Product errorProduct = new Product();
                errorProduct.setProductId(Integer.parseInt(productId));
                errorProduct.setProductName(name);
                errorProduct.setDescription(des);
                errorProduct.setUnit(unit);
                errorProduct.setProductStatus(status);
                // Tránh lỗi ném ra Exception khi chuyển đổi giá trị số bị nhập sai định dạng
                try {
                    errorProduct.setCostPrice(Double.parseDouble(costRaw));
                } catch (Exception e) {
                }
                try {
                    errorProduct.setSellingPrice(Double.parseDouble(sellRaw));
                } catch (Exception e) {
                }
                try {
                    errorProduct.setQuantityAvailable(Integer.parseInt(qRaw));
                } catch (Exception e) {
                }
                try {
                    errorProduct.setCategoryId(Integer.parseInt(cRaw));
                } catch (Exception e) {
                }

                request.setAttribute("action", "edit");
                request.setAttribute("product", errorProduct);
                request.getRequestDispatcher("/views/product/detail.jsp").forward(request, response);
            }
            return;
        }

        // BƯỚC 4: Dữ liệu HỢP LỆ -> Khởi tạo Product mới với dữ liệu đã nhập
        Product product = new Product();
        product.setProductName(name);
        product.setCostPrice(Double.parseDouble(costRaw));
        product.setSellingPrice(Double.parseDouble(sellRaw));
        product.setQuantityAvailable(Integer.parseInt(qRaw));
        product.setCategoryId(Integer.parseInt(cRaw));
        product.setDescription(des);
        product.setUnit(unit);
        product.setProductStatus(status);
        product.setUpdatedBy(u.getUserId());

        // BƯỚC 5: Thực hiện Insert (Create) hoặc Update (Edit) tương ứng
        if ("create".equals(action)) {
            boolean isCreated = pService.createProduct(product);
            if (isCreated) {
                service.AuditLogService.log(u.getUserId(), "CREATE", "Product", "Tạo sản phẩm: " + name);
                response.sendRedirect(request.getContextPath() + "/product-list");
            } else {
                session.setAttribute("errorProduct", "Tạo sản phẩm thất bại.");
                response.sendRedirect(request.getContextPath() + "/product-list");
            }
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(productId);
            product.setProductId(id);

            boolean isUpdated = pService.updateProduct(product);
            if (isUpdated) {
                service.AuditLogService.log(u.getUserId(), "UPDATE", "Product", "Chỉnh sửa sản phẩm ID: " + id);
                response.sendRedirect(request.getContextPath() + "/edit-product?id=" + id + "&action=detail");
            } else {
                session.setAttribute("errorProduct", "Cập nhật sản phẩm thất bại.");
                response.sendRedirect(request.getContextPath() + "/product-list");
            }
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

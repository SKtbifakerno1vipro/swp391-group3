package controller.importrequest;

import dal.ImportRequestDAO;
import model.ImportRequest;
import model.Product;
import model.User;
import service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ImportRequestCreateController", urlPatterns = {"/import-request-create"})
public class ImportRequestCreateController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra phân quyền: Chỉ cho phép System Admin (1), Manager (2), Warehouse (6) và Sales Staff (4) 
        if (user.getRoleId() != 1 && user.getRoleId() != 2 && user.getRoleId() != 4 && user.getRoleId() != 6) {
            response.sendRedirect(request.getContextPath() + "/import-request-list?message=permissionDenied");
            return;
        }

        // Lấy danh sách sản phẩm đang ACTIVE để hiển thị trên dropdown
        List<Product> products = productService.searchProduct(null, null, null, "ACTIVE", null, null, 0, 0, 0, 0);

        request.setAttribute("products", products);
        request.getRequestDispatcher("/views/importrequest/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra phân quyền: Chỉ cho phép System Admin (1), Manager (2), Warehouse (6) và Sales Staff (4) 
        if (user.getRoleId() != 1 && user.getRoleId() != 2 && user.getRoleId() != 4 && user.getRoleId() != 6) {
            response.sendRedirect(request.getContextPath() + "/import-request-list?message=permissionDenied");
            return;
        }

        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String note = request.getParameter("note");

        // --- BUSINESS VALIDATION ---
        int productId = 0;
        int quantity = 0;

        try {
            productId = Integer.parseInt(productIdStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "Dữ liệu nhập vào không đúng định dạng số.");
            return;
        }

        // 1. Kiểm tra số lượng nhập phải lớn hơn 0
        if (quantity <= 0) {
            redirectWithError(request, response, "Số lượng nhập kho phải lớn hơn 0.");
            return;
        }

        // 2. Kiểm tra sản phẩm phải tồn tại và đang ACTIVE
        Product product = productService.getProductById(productId);
        if (product == null) {
            redirectWithError(request, response, "Sản phẩm chọn không tồn tại.");
            return;
        }
        if ("INACTIVE".equals(product.getProductStatus())) {
            redirectWithError(request, response, "Sản phẩm hiện đang không hoạt động (Inactive).");
            return;
        }

        // Lưu thông tin yêu cầu
        ImportRequest ir = new ImportRequest();
        ir.setProductId(productId);
        ir.setQuantity(quantity);
        ir.setCreatedBy(user.getUserId());
        ir.setNote(note);

        ImportRequestDAO importRequestDAO = new ImportRequestDAO();
        boolean success;
        if (user.getRoleId() == 6) { // Warehouse Staff (nhập trực tiếp)
            ir.setStatus(2); // Imported
            ir.setImportedBy(user.getUserId());
            success = importRequestDAO.createAndPerformImport(ir);
        } else {
            success = importRequestDAO.createImportRequest(ir);
        }

        if (success) {
            if (user.getRoleId() == 6) {
                response.sendRedirect(request.getContextPath() + "/import-request-list?message=importSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/import-request-list?message=addSuccess");
            }
        } else {
            redirectWithError(request, response, "Không thể tạo yêu cầu nhập kho. Lỗi cơ sở dữ liệu.");
        }
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg)
            throws ServletException, IOException {
        List<Product> products = productService.searchProduct(null, null, null, "ACTIVE", null, null, 0, 0, 0, 0);
        request.setAttribute("products", products);
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/views/importrequest/create.jsp").forward(request, response);
    }
}

package controller.importrequest;

import dal.ImportRequestDAO;
import model.ImportRequest;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ImportRequestDetailController", urlPatterns = {"/import-request-detail"})
public class ImportRequestDetailController extends HttpServlet {

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

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/import-request-list");
            return;
        }

        int id = 0;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/import-request-list");
            return;
        }

        ImportRequestDAO importRequestDAO = new ImportRequestDAO();
        ImportRequest ir = importRequestDAO.getImportRequestById(id);
        if (ir == null) {
            response.sendRedirect(request.getContextPath() + "/import-request-list");
            return;
        }

        request.setAttribute("ir", ir);
        request.setAttribute("message", request.getParameter("message"));
        request.getRequestDispatcher("/views/importrequest/detail.jsp").forward(request, response);
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

        String importIdStr = request.getParameter("importId");
        String action = request.getParameter("action");

        if (importIdStr == null || importIdStr.trim().isEmpty() || action == null) {
            response.sendRedirect(request.getContextPath() + "/import-request-list");
            return;
        }

        int importId = 0;
        try {
            importId = Integer.parseInt(importIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/import-request-list");
            return;
        }

        ImportRequestDAO importRequestDAO = new ImportRequestDAO();
        ImportRequest ir = importRequestDAO.getImportRequestById(importId);
        if (ir == null) {
            response.sendRedirect(request.getContextPath() + "/import-request-list");
            return;
        }

        // --- XỬ LÝ HÀNH ĐỘNG HỦY YÊU CẦU (CANCEL) ---
        if ("cancel".equals(action)) {
            // Kiểm tra phân quyền: Chỉ cho phép System Admin (1), Manager (2) và Sales Staff (4)
            if (user.getRoleId() != 1 && user.getRoleId() != 2 && user.getRoleId() != 4) {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=permissionDenied");
                return;
            }

            // --- BUSINESS VALIDATION ---
            // Chỉ được hủy khi đang ở trạng thái Pending (1)
            if (ir.getStatus() != 1) {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=invalidStatus");
                return;
            }

            boolean success = importRequestDAO.cancelImportRequest(importId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=cancelSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=dbError");
            }
            return;
        }

        // --- XỬ LÝ HÀNH ĐỘNG NHẬP KHO (IMPORT) ---
        if ("import".equals(action)) {
            // Kiểm tra phân quyền: Cho phép System Admin (1), Manager (2), Sales Staff (4) và Warehouse Staff (6)
            if (user.getRoleId() != 1 && user.getRoleId() != 2 && user.getRoleId() != 4 && user.getRoleId() != 6) {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=permissionDenied");
                return;
            }

            // --- BUSINESS VALIDATION ---
            // Chỉ được nhập kho khi đang ở trạng thái Pending (1)
            if (ir.getStatus() != 1) {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=invalidStatus");
                return;
            }

            // Thực hiện nghiệp vụ nhập kho thông qua Database Transaction (gồm cập nhật status và số lượng sản phẩm)
            boolean success = importRequestDAO.performImport(importId, ir.getProductId(), ir.getQuantity(), user.getUserId());
            if (success) {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=importSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/import-request-detail?id=" + importId + "&message=dbError");
            }
            return;
        }

        // Nếu hành động không khớp, quay lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/import-request-list");
    }
}

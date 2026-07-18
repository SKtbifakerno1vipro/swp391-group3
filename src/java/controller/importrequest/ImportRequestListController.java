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
import java.util.Collections;
import java.util.List;

@WebServlet(name = "ImportRequestListController", urlPatterns = {"/import-request-list"})
public class ImportRequestListController extends HttpServlet {

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

        // Chức năng tìm kiếm
        String searchText = request.getParameter("search");
        System.out.println("[DEBUG] ImportRequestListController: received search param = '" + searchText + "'");
        if (searchText != null) {
            searchText = searchText.trim().replaceAll("\\s+", " ");
        }

        ImportRequestDAO importRequestDAO = new ImportRequestDAO();
        List<ImportRequest> allRequests;

        // Nếu có nhập từ khoá tìm kiếm thì gọi hàm tìm kiếm (bảo vệ khỏi chữ "null" do JSTL render)
        if (searchText != null && !searchText.trim().isEmpty() && !searchText.equalsIgnoreCase("null")) {
            allRequests = importRequestDAO.searchImportRequests(searchText);
        } else {
            allRequests = importRequestDAO.getAllImportRequests();
        }

        // Chức năng phân trang
        int page = 1;
        int pageSize = 5; // Hiển thị 5 dòng trên 1 trang giống Role List
        String pageParam = request.getParameter("page");

        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalRequests = allRequests.size();
        int totalPages = (int) Math.ceil((double) totalRequests / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }

        if (page < 1) {
            page = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }

        // Tính vị trí cắt danh sách cho trang hiện tại
        int fromIndex = Math.min((page - 1) * pageSize, totalRequests);
        int toIndex = Math.min(fromIndex + pageSize, totalRequests);
        List<ImportRequest> paginatedList;

        if (totalRequests == 0) {
            paginatedList = Collections.emptyList();
        } else {
            paginatedList = allRequests.subList(fromIndex, toIndex);
        }

        // Thiết lập các thuộc tính trả về JSP
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("searchText", searchText);
        request.setAttribute("list", paginatedList);
        request.setAttribute("message", request.getParameter("message"));

        request.getRequestDispatcher("/views/importrequest/list.jsp").forward(request, response);
    }
}

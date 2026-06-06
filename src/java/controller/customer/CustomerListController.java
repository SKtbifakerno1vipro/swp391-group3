package controller.customer;

import service.CustomerService;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dto.CustomerDTO;

import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "CustomerListController", urlPatterns = {"/customer/list"})
public class CustomerListController extends HttpServlet {

    private final CustomerService customerService = new CustomerService();


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchName = request.getParameter("searchName");
        String type = request.getParameter("type");
        String pageRaw = request.getParameter("page");

        int page = 1;       // Trang mặc định nếu người dùng mới vào lần đầu
        int pageSize = 2;  // Hiển thị cố định 10 dòng trên 1 trang

        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 2. Gọi Service xử lý gộp Lọc + Phân trang
        List<CustomerDTO> list = customerService.getSearchAndPaginatedCusDTOs(searchName, type, page, pageSize);
        int totalPages = customerService.getTotalPages(searchName, type, pageSize);

        // 3. Đẩy dữ liệu ra trang JSP hiển thị
        request.setAttribute("customers", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Bắt buộc giữ lại các từ khóa tìm kiếm để đẩy ngược lại các ô input/select ngoài giao diện JSP
        request.setAttribute("searchName", searchName);
        request.setAttribute("listTypeCus", customerService.getCusTypeList());
        request.setAttribute("type", type);

        request.getRequestDispatcher("/views/customer/customer_list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

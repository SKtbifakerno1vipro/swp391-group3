package controller.customerorder;

import dto.CustomerOrderDTO;
import service.CustomerOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerOrderListController", urlPatterns = {"/customer-order-list"})
public class CustomerOrderListController extends HttpServlet {

    private final CustomerOrderService customerOrderService = new CustomerOrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("search");
        String keyword = request.getParameter("keyword");
        String pageRaw = request.getParameter("page");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");

        // Defaults
        if (sortBy == null || sortBy.isEmpty()) sortBy = "orderId";
        if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "desc";

        int pageIndex = (pageRaw != null && !pageRaw.isEmpty()) ? Integer.parseInt(pageRaw) : 1;
        int pageSize = 10;
        List<CustomerOrderDTO> listOrder;
        int totalRecords;

        if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();           
            listOrder = customerOrderService.searchOrdersByPage(keyword, pageIndex, pageSize, sortBy, sortOrder);
            totalRecords = customerOrderService.getTotalSearchCount(keyword);
        } else {
            listOrder = customerOrderService.getOrdersByPage(pageIndex, pageSize, sortBy, sortOrder);
            totalRecords = customerOrderService.getTotalOrderCount();
        }

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        request.setAttribute("orders", listOrder);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("action", action);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);

        request.getRequestDispatcher("/views/customer-order/list.jsp").forward(request, response);
    }
}

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
        List<CustomerOrderDTO> listOrder = handleListRequest(request);
        request.setAttribute("orders", listOrder);
        request.getRequestDispatcher("/views/customer-order/list.jsp").forward(request, response);
    }

    private List<CustomerOrderDTO> handleListRequest(HttpServletRequest request) {
        String action = request.getParameter("search");
        if (action == null) {
            action = "default";
        }

        List<CustomerOrderDTO> listCustomerOrderDTOs;
        switch (action) {
            case "search":
                String keyword = request.getParameter("keyword");
                if (keyword == null) {
                    keyword = "";
                }
                listCustomerOrderDTOs = customerOrderService.findbyNameOrTaxcode(keyword.trim());
                break;
            default:
                listCustomerOrderDTOs = customerOrderService.getAllCustomerOrders();
        }
        return listCustomerOrderDTOs;
    }
}

package controller.customerorder;

import dto.CustomerOrderDTO;
import service.CustomerOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerOrderDetailController", urlPatterns = {"/customer-order-detail"})
public class CustomerOrderDetailController extends HttpServlet {

    private final CustomerOrderService customerOrderService = new CustomerOrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
            return;
        }

        try {
            int orderId = Integer.parseInt(idParam);
            CustomerOrderDTO order = customerOrderService.getCustomerOrderById(orderId);
            
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }

            List<CustomerOrderDTO> details = customerOrderService.getOrderDetails(orderId);

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/views/customer-order/detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        
        if (orderIdStr == null || orderIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdStr);
        
        if ("update_status".equals(action)) {
            String status = request.getParameter("status");
            customerOrderService.updateOrderStatus(orderId, status);
            
        } else if ("update_quantity".equals(action)) {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity > 0) {
                customerOrderService.updateOrderDetailQuantity(detailId, quantity);
            }
        } else if ("delete_item".equals(action)) {
            int detailId = Integer.parseInt(request.getParameter("detailId"));
            customerOrderService.deleteOrderDetail(detailId);
        }
        
        response.sendRedirect(request.getContextPath() + "/customer-order-detail?id=" + orderId);
    }
}

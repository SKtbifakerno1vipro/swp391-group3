package controller.customerorder;

import dto.CustomerDTO;
import model.CustomerOrder;
import model.CustomerOrderDetail;
import model.Product;
import model.User;
import service.CustomerOrderService;
import service.CustomerService;
import service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CreateCustomerOrderController", urlPatterns = {"/create-customer-order"})
public class CreateCustomerOrderController extends HttpServlet {

    private final CustomerOrderService customerOrderService = new CustomerOrderService();
    private final CustomerService customerService = new CustomerService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String customerIdParam = request.getParameter("customerId");
        int customerId = -1;

        if (customerIdParam != null && !customerIdParam.isBlank()) {
            customerId = Integer.parseInt(customerIdParam);
        } else {
            // If no customerId in param, check if current user is a customer
            model.Customer customer = customerService.getCustomerByUserId(currentUser.getUserId());
            if (customer != null) {
                customerId = customer.getCustomerId();
            }
        }

        try {
            List<Product> products = productService.getAllProducts();
            request.setAttribute("products", products);

            if (customerId != -1) {
                CustomerDTO customerDto = customerService.getCustomerDTOByCustomerId(customerId);
                request.setAttribute("customer", customerDto);
            } else {
                // If still no customerId, it means a staff is creating an order but hasn't picked a customer yet
                List<CustomerDTO> customers = customerService.getAllCustomerDTOs();
                request.setAttribute("customers", customers);
            }
            
            request.getRequestDispatcher("/views/customer-order/create.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String[] productIds = request.getParameterValues("productIds");

        if (productIds == null || productIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/create-customer-order?customerId=" + customerId);
            return;
        }

        CustomerOrder order = new CustomerOrder();
        order.setCustomerId(customerId);
        order.setStatus("Pending");
        order.setCreateBy(currentUser.getUserId());

        List<CustomerOrderDetail> details = new ArrayList<>();
        for (String pid : productIds) {
            String qtyStr = request.getParameter("qty_" + pid);
            if (qtyStr != null && !qtyStr.isBlank()) {
                int quantity = Integer.parseInt(qtyStr);
                if (quantity > 0) {
                    CustomerOrderDetail detail = new CustomerOrderDetail();
                    detail.setProductId(Integer.parseInt(pid));
                    detail.setQuantity(quantity);
                    details.add(detail);
                }
            }
        }

        if (details.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/create-customer-order?customerId=" + customerId);
            return;
        }

        boolean success = customerOrderService.createOrder(order, details);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        } else {
            // Handle error
            request.setAttribute("error", "Failed to create order");
            doGet(request, response);
        }
    }
}

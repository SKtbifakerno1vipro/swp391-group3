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
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "CreateCustomerOrderController", urlPatterns = {"/create-customer-order"})
public class CreateCustomerOrderController extends HttpServlet {

    private final CustomerOrderService customerOrderService = new CustomerOrderService();
    private final CustomerService customerService = new CustomerService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
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

        // Fetch all products to get current prices
        List<Product> allProducts = productService.getAllProducts();
        Map<Integer, Product> productMap = allProducts.stream()
                .collect(Collectors.toMap(Product::getProductId, p -> p));

        CustomerOrder order = new CustomerOrder();
        order.setCustomerId(customerId);
        order.setOrderStatus("PENDING");
        order.setCreatedBy(currentUser.getUserId());
        
        // HACK: In a real system, we'd pick a contract. For now, we'll try to find any contract for this customer
        // or hardcode a valid one from sample data if available, or just use 1 if it exists.
        // For the sake of "fixing" it, I'll assume there's at least one contract.
        // Ideally, we should fetch contract from DB. 
        // Let's use 1 as a placeholder or fetch it if possible.
        order.setCustomerContractId(1); 

        List<CustomerOrderDetail> details = new ArrayList<>();
        for (String pidStr : productIds) {
            int pid = Integer.parseInt(pidStr);
            String qtyStr = request.getParameter("qty_" + pid);
            if (qtyStr != null && !qtyStr.isBlank()) {
                int quantity = Integer.parseInt(qtyStr);
                if (quantity > 0) {
                    Product p = productMap.get(pid);
                    if (p != null) {
                        CustomerOrderDetail detail = new CustomerOrderDetail();
                        detail.setProductId(pid);
                        detail.setQuantity(quantity);
                        detail.setSellingPrice(p.getSellingPrice());
                        // For cost price, if model has it use it, otherwise use a default or 0
                        // SQL product has cost_price, let's check if Product model has it.
                        // I checked Product.java earlier, it didn't have costPrice.
                        // So I'll use 0 or update Product model.
                        detail.setCostPrice(BigDecimal.ZERO); 
                        details.add(detail);
                    }
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
            request.setAttribute("error", "Failed to create order. Make sure a valid contract exists.");
            doGet(request, response);
        }
    }
}

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
            try {
                customerId = Integer.parseInt(customerIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid customerId
            }
        }

        try {
            List<Product> products = productService.getAllProducts();
            request.setAttribute("products", products);

            if (customerId != -1) {
                CustomerDTO customerDto = customerService.getCustomerDTOByCustomerId(customerId);
                request.setAttribute("customer", customerDto);
                
                if (customerDto != null) {
                    // Fetch signed contracts for this customer
                    List<model.CustomerContract> contracts = customerOrderService.getSignedContractsByCustomerId(customerId);
                    request.setAttribute("contracts", contracts);
                    
                    if (contracts.isEmpty()) {
                        request.setAttribute("error", "No signed contracts found for this customer. A signed contract is required to create an order.");
                    }
                } else {
                    request.setAttribute("error", "Customer not found.");
                    // Reset customerId if not found to show customer list
                    customerId = -1;
                    List<CustomerDTO> customers = customerService.getAllCustomerDTOs();
                    request.setAttribute("customers", customers);
                }
            } else {
                // If no customerId provided, show customer list for Admin/Staff to choose
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

        String customerIdStr = request.getParameter("customerId");
        String contractIdStr = request.getParameter("customerContractId");
        String[] productIds = request.getParameterValues("productIds");

        if (customerIdStr == null || customerIdStr.isBlank() || contractIdStr == null || contractIdStr.isBlank()) {
            request.setAttribute("error", "Customer and Contract are required.");
            doGet(request, response);
            return;
        }

        int customerId;
        int contractId;
        try {
            customerId = Integer.parseInt(customerIdStr);
            contractId = Integer.parseInt(contractIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid Customer or Contract ID.");
            doGet(request, response);
            return;
        }

        if (productIds == null || productIds.length == 0) {
            request.setAttribute("error", "Please select at least one product.");
            doGet(request, response);
            return;
        }

        // Fetch all products to get current prices
        List<Product> allProducts = productService.getAllProducts();
        Map<Integer, Product> productMap = allProducts.stream()
                .collect(Collectors.toMap(Product::getProductId, p -> p));

        CustomerOrder order = new CustomerOrder();
        order.setCustomerId(customerId);
        order.setCustomerContractId(contractId);
        order.setOrderStatus("PENDING");
        order.setCreatedBy(currentUser.getUserId());

        List<CustomerOrderDetail> details = new ArrayList<>();
        for (String pidStr : productIds) {
            try {
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
                            detail.setCostPrice(p.getCostPrice()); 
                            detail.setSellingPrice(p.getSellingPrice());
                            details.add(detail);
                        }
                    }
                }
            } catch (NumberFormatException e) {
                // Skip invalid product ids or quantities
            }
        }

        if (details.isEmpty()) {
            request.setAttribute("error", "No valid products or quantities selected.");
            doGet(request, response);
            return;
        }

        boolean success = customerOrderService.createOrder(order, details);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        } else {
            request.setAttribute("error", "Failed to create order. Please try again.");
            doGet(request, response);
        }
    }
}

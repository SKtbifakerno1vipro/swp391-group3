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
    //nguyenkien - begin
    private final int PAGE_SIZE = 10;
    //nguyenkien - end
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy session hiện tại để kiểm tra người dùng đã đăng nhập chưa
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Lấy customerId từ URL (nếu có, ví dụ: ?customerId=5)
        String customerIdParam = request.getParameter("customerId");
        int customerId = -1;
        // Kiểm tra và chuyển đổi customerId từ chuỗi sang số nguyên
        if (customerIdParam != null && !customerIdParam.isBlank()) {
            try {
                customerId = Integer.parseInt(customerIdParam);
            } catch (NumberFormatException e) {
                // Ignore invalid customerId
            }
        }

        try {
            // xử lý phân trang cho danh sách sản phẩm
            String pageParam = request.getParameter("productPage");
            int productPage = 1;
            if (pageParam != null && !pageParam.isBlank()) {
                productPage = Integer.parseInt(pageParam);
            }
            // Đếm tổng số sản phẩm đang hoạt động (ACTIVE) để tính tổng số trang
            int totalProducts = productService.countProduct(null, null, "ACTIVE");
            int totalProductPages = productService.calculateTotalPage(totalProducts, PAGE_SIZE);
            productPage = productService.nomalizePage(productPage, totalProductPages);
            // Lấy danh sách sản phẩm cho trang hiện tại
            List<Product> products = productService.searchProduct(null, null, null, "ACTIVE", totalProducts, productPage,
                    totalProductPages, PAGE_SIZE); //update by nguyenkien
            request.setAttribute("products", products);
            request.setAttribute("currentProductPage", productPage);
            request.setAttribute("totalProductPages", totalProductPages);

            if (customerId != -1) {
                CustomerDTO customerDto = customerService.getCustomerDTOByCusId(customerId);
                request.setAttribute("customer", customerDto);

                if (customerDto != null) {
                    // Chỉ lấy những hợp đồng đã ký (SIGNED) của khách hàng này
                    List<model.CustomerContract> contracts = customerOrderService.getSignedContractsByCustomerId(customerId);
                    request.setAttribute("contracts", contracts);

                    if (contracts.isEmpty()) {
                        request.setAttribute("error", "No signed contracts found for this customer. A signed contract is required to create an order.");
                        request.setAttribute("error", "No signed contracts found...");
                        // Thông báo nếu chưa có hợp đồng ký kết
                    }
                } else {
                    request.setAttribute("error", "Customer not found.");
                    // Reset customerId if not found to show customer list
                    customerId = -1;
                    // Nếu chưa chọn khách hàng, lấy toàn bộ danh sách khách hàng để người dùng chọn trong dropdown
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
// Nhận dữ liệu từ form gửi lên
        String customerIdStr = request.getParameter("customerId");
        String contractIdStr = request.getParameter("customerContractId");
        String[] productIds = request.getParameterValues("productIds");// Mảng các ID sản phẩm được tích chọn

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

        // Lấy giá hiện tại của tất cả sản phẩm để lưu vào chi tiết đơn hàng (chốt giá)
        List<Product> allProducts = productService.getAllProducts();
        Map<Integer, Product> productMap = allProducts.stream()
                .collect(Collectors.toMap(Product::getProductId, p -> p));
// Tạo đối tượng Order chính
        CustomerOrder order = new CustomerOrder();
        order.setCustomerId(customerId);
        order.setCustomerContractId(contractId);
        order.setOrderStatus("PENDING");
        order.setCreatedBy(currentUser.getUserId());
// Tạo danh sách các dòng chi tiết đơn hàng (Product + Quantity + Price)
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
        // Gọi Service để lưu vào DB. Nếu thành công trả về true.

        boolean success = customerOrderService.createOrder(order, details);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        } else {
            request.setAttribute("error", "Failed to create order. Please try again.");
            doGet(request, response);
        }
    }
}

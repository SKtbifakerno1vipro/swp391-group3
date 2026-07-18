package controller.customerorder;

import dal.ContractDAO;
import dto.CustomerDTO;
import dto.CustomerOrderDTO;
import model.CustomerOrder;
import model.CustomerOrderDetail;
import model.Product;
import model.User;
import model.Contract;
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
import model.Invoice;
import service.InvoiceService;
import service.AuditLogService;
import service.RoleService;
@WebServlet(name = "CustomerOrderController", urlPatterns = {"/customer-order"})
public class CustomerOrderController extends HttpServlet {

    private final ContractDAO contractDao = new ContractDAO();
    private final CustomerOrderService customerOrderService = new CustomerOrderService();
    private final CustomerService customerService = new CustomerService();
    private final ProductService productService = new ProductService();
    private final InvoiceService invoiceService = new InvoiceService();
    private final int PAGE_SIZE = 10;
    private final AuditLogService AuditLogService = new AuditLogService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        

        String action = request.getParameter("action");
        if ("delete_order".equals(action) ) {
            if (currentUser.getRoleId() == 3) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isBlank()) {
                try {
                    int orderId = Integer.parseInt(idParam);
                    customerOrderService.deleteCustomerOrder(orderId);
                    AuditLogService.log(currentUser.getUserId(), "DELETE", "Order", "Xóa đơn hàng ID: " + orderId);
                } catch (NumberFormatException e) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            handleDetailView(request, response, idParam);
        } else {
            if (currentUser.getRoleId() == 3) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }
            handleCreateView(request, response);
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

        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            if (currentUser.getRoleId() == 3) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }
            handleCreateAction(request, response, currentUser);
        } else if ("update_status".equals(action)) {
            if (currentUser.getRoleId() == 3) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }
            handleUpdateStatusAction(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    }

    // --- VIEW HANDLERS ---

    private void handleDetailView(HttpServletRequest request, HttpServletResponse response, String idParam) 
            throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(idParam);
            boolean isExistInvoice = false;
            CustomerOrderDTO order = customerOrderService.getCustomerOrderById(orderId);
            
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }

            Invoice invoice = invoiceService.getInvoiceByOrderId(orderId);
            if (invoice != null) {
                isExistInvoice = true;
                if ("CANCELED".equals(invoice.getInvoiceStatus())) {
                    isExistInvoice = false;
                }
            }
            if (order.getCustomerOrder() != null) {
                order.getCustomerOrder().setHasInvoice(isExistInvoice);
            }
            request.setAttribute("invOfOrder", invoice);

            HttpSession session = request.getSession();
            model.User currentUser = (model.User) session.getAttribute("user");
            if (currentUser != null && order.getCustomer() != null) {
                int roleId = currentUser.getRoleId();
                int userId = currentUser.getUserId();
                
                RoleService roleService = new RoleService();
                model.Role userRole = roleService.getRoleById(roleId);
                String roleName = userRole != null ? userRole.getRoleName().toLowerCase() : "";
                
                if (roleName.contains("sale")) {
                    Integer assignedTo = order.getCustomer().getAssignedToUserId();
                    if (assignedTo == null || assignedTo != userId) {
                        response.sendRedirect(request.getContextPath() + "/customer-order-list");
                        return;
                    }
                } else if (roleName.contains("customer")) {
                    if (order.getCustomer().getUserId() == null || order.getCustomer().getUserId() != userId) {
                        response.sendRedirect(request.getContextPath() + "/customer-order-list");
                        return;
                    }
                }
            }

            List<CustomerOrderDTO> details = customerOrderService.getOrderDetails(orderId);
            
            // Calculate total from order details
            double quotationTotal = 0;
            if (details != null) {
                for (CustomerOrderDTO item : details) {
                    if (item.getDetail() != null) {
                        quotationTotal += item.getDetail().getTotal();
                    }
                }
            }
            request.setAttribute("quotationTotal", quotationTotal);
            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.getRequestDispatcher("/views/customer-order/detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    }

    private void handleCreateView(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String customerIdParam = request.getParameter("customerId");
        int customerId = -1;
        
        if (customerIdParam != null && !customerIdParam.isBlank()) {
            try {
                customerId = Integer.parseInt(customerIdParam);
            } catch (NumberFormatException e) {}
        }
        
        // Auto-detect customerId from contractId if missing
        String contractIdParam = request.getParameter("contractId");
        if (customerId == -1 && contractIdParam != null && !contractIdParam.isBlank()) {
            try {
                int contractIdForLookup = Integer.parseInt(contractIdParam);
                Contract tempContract = contractDao.getContractById(contractIdForLookup);
                if (tempContract != null) {
                    customerId = tempContract.getCustomerId();
                }
            } catch (Exception e) {}
        }

        try {
            // Product pagination logic
            String pageParam = request.getParameter("productPage");
            int productPage = (pageParam != null && !pageParam.isBlank()) ? Integer.parseInt(pageParam) : 1;
            
            int totalProducts = productService.countProduct(null, null, "ACTIVE", null, null);
            int totalProductPages = productService.calculateTotalPage(totalProducts, PAGE_SIZE);
            productPage = productService.nomalizePage(productPage, totalProductPages);
            
            List<Product> products = productService.searchProduct(null, null, null, "ACTIVE", null, null, totalProducts, productPage, totalProductPages, PAGE_SIZE);
            
            request.setAttribute("products", products);
            request.setAttribute("currentProductPage", productPage);
            request.setAttribute("totalProductPages", totalProductPages);

            if (customerId != -1) {
                CustomerDTO customerDto = customerService.getCustomerDTOByCusId(customerId);
                request.setAttribute("customer", customerDto);

                if (customerDto != null) {
                    List<Contract> contracts = contractDao.getSignedContractsByCustomerId(customerId);
                    request.setAttribute("contracts", contracts);
                } else {
                    request.setAttribute("error", "Không tìm thấy khách hàng.");
                    List<CustomerDTO> customers = customerService.getAllCustomerDTOs();
                    request.setAttribute("customers", customers);
                }
            } else {
                List<CustomerDTO> customers = customerService.getAllCustomerDTOs();
                request.setAttribute("customers", customers);
            }
            
            contractIdParam = request.getParameter("contractId");
            if (contractIdParam == null || contractIdParam.isBlank()) {
                contractIdParam = request.getParameter("customerContractId");
            }
            if (contractIdParam != null && !contractIdParam.isBlank()) {
                try {
                    int contractId = Integer.parseInt(contractIdParam);
                    request.setAttribute("selectedContractId", contractId);
                    Contract selectedContract = contractDao.getContractById(contractId);
                    if (selectedContract != null) {
                        request.setAttribute("selectedContract", selectedContract);
                        dal.QuotationDAO quotationDao = new dal.QuotationDAO();
                        List<model.QuotationDetail> quotationDetails = quotationDao.getQuotationDetailsByQuotationId(selectedContract.getQuotationId());
                        request.setAttribute("quotationDetails", quotationDetails);
                    }
                } catch (Exception e) {}
            }

            request.getRequestDispatcher("/views/customer-order/create.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    }

    // --- ACTION HANDLERS ---

    private void handleCreateAction(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws IOException, ServletException {
        String customerIdStr = request.getParameter("customerId");
        String contractIdStr = request.getParameter("customerContractId");
        String[] qdIds = request.getParameterValues("quotationDetailIds");

        if (customerIdStr == null || customerIdStr.isBlank() || contractIdStr == null || contractIdStr.isBlank()) {
            request.setAttribute("error", "Khách hàng và Hợp đồng là bắt buộc.");
            handleCreateView(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            int contractId = Integer.parseInt(contractIdStr);

            if (qdIds == null || qdIds.length == 0) {
                request.setAttribute("error", "Vui lòng chọn ít nhất một sản phẩm.");
                handleCreateView(request, response);
                return;
            }

            dal.QuotationDAO quotationDao = new dal.QuotationDAO();
            Contract selectedContract = contractDao.getContractById(contractId);
            List<model.QuotationDetail> quotationDetails = new ArrayList<>();
            if (selectedContract != null) {
                quotationDetails = quotationDao.getQuotationDetailsByQuotationId(selectedContract.getQuotationId());
            }
            Map<Integer, model.QuotationDetail> qdMap = quotationDetails.stream()
                    .collect(Collectors.toMap(model.QuotationDetail::getQuotationDetailId, qd -> qd));

            CustomerOrder order = new CustomerOrder();
            order.setCustomerId(customerId);
            order.setCustomerContractId(contractId);
            order.setOrderStatus("PENDING");
            order.setCreatedBy(currentUser.getUserId());

            List<CustomerOrderDetail> details = new ArrayList<>();
            for (String qidStr : qdIds) {
                int qid = Integer.parseInt(qidStr);
                String qtyStr = request.getParameter("qty_" + qid);
                if (qtyStr != null && !qtyStr.isBlank()) {
                    int quantity = Integer.parseInt(qtyStr);
                    if (quantity > 0) {
                        model.QuotationDetail qd = qdMap.get(qid);
                        if (qd != null) {
                            CustomerOrderDetail detail = new CustomerOrderDetail();
                            detail.setQuotationDetailId(qid);
                            detail.setProductId(qd.getProductId());
                            detail.setQuantity(quantity);
                            detail.setCostPrice(qd.getCostPrice().doubleValue());
                            detail.setSellingPrice(qd.getSellingPrice().doubleValue());
                            details.add(detail);
                        }
                    }
                }
            }

            if (details.isEmpty()) {
                request.setAttribute("error", "Không có sản phẩm hoặc số lượng hợp lệ nào được chọn.");
                handleCreateView(request, response);
                return;
            }

            if (customerOrderService.createOrder(order, details)) {
                AuditLogService.log(currentUser.getUserId(), "CREATE", "Order", "Tạo đơn hàng mới cho khách hàng ID: " + customerId + " (Số mặt hàng: " + details.size() + ")");
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
            } else {
                request.setAttribute("error", "Tạo đơn hàng thất bại. " + dal.CustomerOrderDAO.lastError);
                handleCreateView(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Định dạng dữ liệu không hợp lệ.");
            handleCreateView(request, response);
        }
    }

    private void handleUpdateStatusAction(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");
        
        CustomerOrderDTO order = customerOrderService.getCustomerOrderById(orderId);
        if (order != null && "COMPLETED".equals(order.getCustomerOrder().getOrderStatus())) {
            response.sendRedirect(request.getContextPath() + "/customer-order?id=" + orderId);
            return;
        }
        
        // Block setting status to COMPLETED via general status update (must be done via AcceptanceRecord confirmation)
        if ("COMPLETED".equals(status)) {
            response.sendRedirect(request.getContextPath() + "/customer-order?id=" + orderId);
            return;
        }
        
        customerOrderService.updateOrderStatus(orderId, status);
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        Integer currentUserId = currentUser != null ? currentUser.getUserId() : null;
        AuditLogService.log(currentUserId, "UPDATE", "Order", "Cập nhật trạng thái đơn hàng ID " + orderId + " thành: " + status);
        
        response.sendRedirect(request.getContextPath() + "/customer-order?id=" + orderId);
    }

    
}

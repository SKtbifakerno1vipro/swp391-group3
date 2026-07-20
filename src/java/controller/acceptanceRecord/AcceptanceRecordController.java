package controller.acceptanceRecord;

import dto.CustomerOrderDTO;
import dto.CustomerDTO;
import service.CustomerOrderService;
import dal.CustomerDAO;
import dal.AcceptanceRecordDAO;
import model.AcceptanceRecord;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Properties;
import model.User;
import service.AuditLogService;

@WebServlet(name="AcceptanceRecordController", urlPatterns={"/AcceptanceRecordController"})
public class AcceptanceRecordController extends HttpServlet {

    private CustomerOrderService customerOrderService = new CustomerOrderService();
    private AuditLogService AuditLogService = new AuditLogService();
    private AcceptanceRecordDAO acceptanceRecordDAO = new AcceptanceRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        boolean isCustomer = currentUser.getRoleId() == 3;
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
            return;
        }

        // Load company configuration from properties file
        Properties config = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/resources/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        } catch (IOException e) {
            session.setAttribute("errorInvoice", "Error: Config cannot activatity");
            response.sendRedirect("/customer-order-list");
            e.printStackTrace();
        }

        request.setAttribute("company_rep_name", config.getProperty("company_rep_name"));
        request.setAttribute("companyName", config.getProperty("company_name"));
        request.setAttribute("companyTaxCode", config.getProperty("company_tax_code"));
        request.setAttribute("companyAddress", config.getProperty("company_address"));
        request.setAttribute("companyPhone", config.getProperty("company_phone"));

        try {
            int orderId = Integer.parseInt(orderIdParam);
            CustomerOrderDTO order = customerOrderService.getCustomerOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }

            List<CustomerOrderDTO> details = customerOrderService.getOrderDetails(orderId);

            double grandTotal = customerOrderService.getTotalPriceFromQuotationByOrderId(orderId);
            if (grandTotal <= 0 && details != null) {
                for (CustomerOrderDTO item : details) {
                    if (item.getDetail() != null) {
                        grandTotal += item.getDetail().getTotal();
                    }
                }
            }

            request.setAttribute("order", order);
            request.setAttribute("details", details);
            request.setAttribute("grandTotal", grandTotal);

            CustomerDAO customerDAO = new CustomerDAO();
            CustomerDTO customerFull = customerDAO.getCustomerDTOById(order.getCustomer().getCustomerId());
            request.setAttribute("customerFull", customerFull);

            if (isCustomer && currentUser.getUserId() != customerFull.getUser().getUserId()) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }

            // Load or create AcceptanceRecord in DB
            AcceptanceRecord record = acceptanceRecordDAO.getAcceptanceRecordByOrderId(orderId);
            String currentOrderStatus = order.getCustomerOrder() != null ? order.getCustomerOrder().getOrderStatus() : null;

            if (record == null) {
                record = new AcceptanceRecord();
                record.setCustomerContractId(order.getCustomerOrder().getCustomerContractId());
                record.setCustomerOrderId(orderId);
                record.setAcceptanceDate(LocalDateTime.now());
                record.setAcceptanceStatus(currentOrderStatus != null ? currentOrderStatus : "PENDING");
                
                record.setProviderName(config.getProperty("company_name"));
                record.setProviderRepName(config.getProperty("company_rep_name"));
                record.setProviderTaxCode(config.getProperty("company_tax_code"));
                record.setProviderAddress(config.getProperty("company_address"));
                record.setProviderPhone(config.getProperty("company_phone"));
                
                if (customerFull != null) {
                    record.setCustomerName(customerFull.getCustomer() != null && customerFull.getCustomer().getCompanyName() != null ? customerFull.getCustomer().getCompanyName() : (customerFull.getUser() != null ? customerFull.getUser().getFullName() : ""));
                    record.setCustomerRepName(customerFull.getUser() != null ? customerFull.getUser().getFullName() : "");
                    record.setCustomerTaxCode(customerFull.getCustomer() != null ? customerFull.getCustomer().getTaxCode() : "");
                    record.setCustomerAddress(customerFull.getUser() != null ? customerFull.getUser().getAddress() : "");
                    record.setCustomerPhone(customerFull.getUser() != null ? customerFull.getUser().getPhone() : "");
                }
                record.setTotalAmount(grandTotal);
                record.setCreatedBy(currentUser.getUserId());
                acceptanceRecordDAO.insertAcceptanceRecord(record);
            } else if (currentOrderStatus != null && !currentOrderStatus.equalsIgnoreCase(record.getAcceptanceStatus())) {
                record.setAcceptanceStatus(currentOrderStatus);
                acceptanceRecordDAO.updateAcceptanceStatus(orderId, currentOrderStatus);
            }
            request.setAttribute("acceptanceRecord", record);

            LocalDate now = (record.getAcceptanceDate() != null) ? record.getAcceptanceDate().toLocalDate() : LocalDate.now();
            request.setAttribute("day", String.format("%02d", now.getDayOfMonth()));
            request.setAttribute("month", String.format("%02d", now.getMonthValue()));
            request.setAttribute("year", now.getYear());
            
            AuditLogService.log(currentUser.getUserId(), "VIEW", "AcceptanceRecord", "Xem Biên bản nghiệm thu đơn hàng ID: " + orderId);
            request.getRequestDispatcher("/views/acceptanceRecord/acceptanceRecord.jsp").forward(request, response);
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
            response.sendRedirect("login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            CustomerOrderDTO order = customerOrderService.getCustomerOrderById(orderId);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/customer-order-list");
                return;
            }

            // Only Customer (roleId == 3) associated with this order should confirm it.
            if (currentUser.getRoleId() == 3) {
                if (order.getCustomer() == null || order.getCustomer().getUserId() == null || order.getCustomer().getUserId().intValue() != currentUser.getUserId()) {
                    response.sendRedirect(request.getContextPath() + "/customer-order-list");
                    return;
                }
            } else {
                session.setAttribute("error", "Chỉ khách hàng mới có quyền xác nhận nhận hàng.");
                response.sendRedirect(request.getContextPath() + "/customer-order?id=" + orderId);
                return;
            }

            boolean updated = customerOrderService.updateOrderStatus(orderId, "COMPLETED");
            if (updated) {
                LocalDateTime now = LocalDateTime.now();
                AcceptanceRecord record = acceptanceRecordDAO.getAcceptanceRecordByOrderId(orderId);
                if (record == null) {
                    record = new AcceptanceRecord();
                    record.setCustomerContractId(order.getCustomerOrder().getCustomerContractId());
                    record.setCustomerOrderId(orderId);
                    record.setAcceptanceDate(now);
                    record.setAcceptanceStatus("COMPLETED");
                    record.setCreatedBy(currentUser.getUserId());
                    acceptanceRecordDAO.insertAcceptanceRecord(record);
                } else {
                    acceptanceRecordDAO.updateAcceptanceStatus(orderId, "COMPLETED");
                }

                AuditLogService.log(currentUser.getUserId(), "CONFIRM", "AcceptanceRecord", "Khách hàng " + currentUser.getFullName() + " xác nhận Biên bản nghiệm thu đơn hàng ID: " + orderId);
                session.setAttribute("successMessage", "Xác nhận giao hàng thành công.");
            } else {
                session.setAttribute("errorMessage", "Không thể cập nhật trạng thái đơn hàng.");
            }

            response.sendRedirect(request.getContextPath() + "/AcceptanceRecordController?orderId=" + orderId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer-order-list");
        }
    }
}

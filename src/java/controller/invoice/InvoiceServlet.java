package controller.invoice;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Properties;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dal.CustomerOrderDAO;
import dal.CustomerDAO;
import dal.UserDAO;
import dto.CustomerOrderDTO;
import dto.CustomerDTO;
import dto.InvoiceItemDTO;
import model.Invoice;
import model.User;
import service.InvoiceService;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoice"})
public class InvoiceServlet extends HttpServlet {

    private final InvoiceService iService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String orderIdRaw = request.getParameter("orderId");
        String invoiceIdRaw = request.getParameter("invoiceId");

        // Load company configuration from properties file
        Properties config = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/resources/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        } catch (IOException e) {
            session.setAttribute("errorInvoice", "Error: Config cannot activatity");
            response.sendRedirect("/invoice-list");
            e.printStackTrace();
        }
        request.setAttribute("companyName", config.getProperty("company_name"));
        request.setAttribute("companyTaxCode", config.getProperty("company_tax_code"));
        request.setAttribute("companyAddress", config.getProperty("company_address"));
        request.setAttribute("companyPhone", config.getProperty("company_phone"));

        Invoice invoice = null;

        if (invoiceIdRaw != null && !invoiceIdRaw.trim().isEmpty()) {
            try {
                int invoiceId = Integer.parseInt(invoiceIdRaw);
                invoice = iService.getInvoiceById(invoiceId);
                if (invoice != null) {
                    request.setAttribute("invoice", invoice);
                    loadInvoiceCreationData(request, invoice.getCustomerOrderId());
                } else {
                    request.setAttribute("error", "Không tìm thấy hóa đơn này.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi tải thông tin hóa đơn: " + e.getMessage());
            }
        } else if (orderIdRaw != null && !orderIdRaw.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdRaw);
                loadInvoiceCreationData(request, orderId);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi tải thông tin đơn hàng: " + e.getMessage());
            }
        }

        Integer createdBy = null;
        if (invoice != null) {
            createdBy = invoice.getCreatedBy();
        }
        if (createdBy == null) {
            createdBy = user.getUserId();
        }

        if (createdBy != null) {
            UserDAO userDAO = new UserDAO();
            User creator = userDAO.getUserById(createdBy);
            if (creator != null) {
                request.setAttribute("creatorName", creator.getFullName());
            }
        }

        request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        Invoice invoice = null;
        int orderId = 0;
        String buyerPhone = null;

        try {
            String invoiceIdRaw = request.getParameter("invoiceId");
            int invoiceId = (invoiceIdRaw != null && !invoiceIdRaw.trim().isEmpty()) ? Integer.parseInt(invoiceIdRaw) : 0;
            int contractId = Integer.parseInt(request.getParameter("customerContractId"));
            orderId = Integer.parseInt(request.getParameter("customerOrderId"));

            String invoiceStatus = request.getParameter("invoiceStatus");
            String invoiceType = request.getParameter("invoiceType");
            String invoiceSymbol = request.getParameter("invoiceSymbol");

            String sellerName = request.getParameter("sellerName");
            String sellerTaxCode = request.getParameter("sellerTaxCode");
            String sellerAddress = request.getParameter("sellerAddress");
            String sellerPhone = request.getParameter("sellerPhone");

            String buyerName = request.getParameter("buyerName");
            String buyerTaxCode = request.getParameter("buyerTaxCode");
            String buyerAddress = request.getParameter("buyerAddress");
            buyerPhone = request.getParameter("buyerPhone");

            String subTotalRaw = request.getParameter("subTotal");
            String taxAmountRaw = request.getParameter("taxAmount");
            String totalAmountRaw = request.getParameter("totalAmount");

            double subTotal = (subTotalRaw != null && !subTotalRaw.isEmpty()) ? Double.parseDouble(subTotalRaw) : 0.0;
            double taxAmount = (taxAmountRaw != null && !taxAmountRaw.isEmpty()) ? Double.parseDouble(taxAmountRaw) : 0.0;
            double totalAmount = (totalAmountRaw != null && !totalAmountRaw.isEmpty()) ? Double.parseDouble(totalAmountRaw) : 0.0;

            String customerNote = request.getParameter("invoiceNotes");
            String internalNote = request.getParameter("internalNotes");

            Integer createdBy = user.getUserId();

            invoice = new Invoice();
            invoice.setInvoiceId(invoiceId);
            invoice.setCustomerContractId(contractId);
            invoice.setCustomerOrderId(orderId);
            invoice.setInvoiceType(invoiceType);
            invoice.setInvoiceSymbol(invoiceSymbol);

            if (invoiceId > 0) {
                Invoice existingInvoice = iService.getInvoiceById(invoiceId);
                if ("RELEASED".equals(invoiceStatus)) {
                    invoice.setInvoiceStatus("RELEASED");
                    invoice.setIssueDate(LocalDateTime.now());
                    int year = LocalDateTime.now().getYear();
                    invoice.setInvoiceNo(iService.getNextInvoiceNo(year));
                } else {
                    invoice.setInvoiceStatus("UNRELEASED");
                    invoice.setIssueDate(null);
                    invoice.setInvoiceNo(existingInvoice != null ? existingInvoice.getInvoiceNo() : ("DFT-" + orderId + "-" + System.currentTimeMillis()));
                }
            } else {
                invoice.setInvoiceStatus("UNRELEASED");
                invoice.setInvoiceNo("DFT-" + orderId + "-" + System.currentTimeMillis());
                invoice.setIssueDate(null);
            }

            invoice.setSellerName(sellerName);
            invoice.setSellerTaxCode(sellerTaxCode);
            invoice.setSellerAddress(sellerAddress);
            invoice.setSellerPhone(sellerPhone);

            invoice.setBuyerName(buyerName);
            invoice.setBuyerTaxCode(buyerTaxCode);
            invoice.setBuyerAddress(buyerAddress);

            invoice.setSubTotal(subTotal);
            invoice.setTaxAmount(taxAmount);
            invoice.setTotalAmount(totalAmount);

            invoice.setCustomerNote(customerNote);
            invoice.setInternalNote(internalNote);
            invoice.setCreatedBy(createdBy);

            String errorMsg = iService.validateInvoice(invoice, buyerPhone);
            if (errorMsg != null) {
                request.setAttribute("error", errorMsg);
                request.setAttribute("invoice", invoice);
                request.setAttribute("buyerPhone", buyerPhone);

                Integer invoiceCreatorId = invoice.getCreatedBy();
                if (invoiceCreatorId == null && user != null) {
                    invoiceCreatorId = user.getUserId();
                }
                if (invoiceCreatorId != null) {
                    UserDAO userDAO = new UserDAO();
                    User creator = userDAO.getUserById(invoiceCreatorId);
                    if (creator != null) {
                        request.setAttribute("creatorName", creator.getFullName());
                    }
                }

                loadInvoiceCreationData(request, orderId);
                request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
                return;
            }

            // Save to Database
            boolean success;
            if (invoiceId > 0) {
                success = iService.updateInvoice(invoice);
            } else {
                success = iService.insertInvoice(invoice);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/invoice-list");
            } else {
                request.setAttribute("error", "Không thể lưu hóa đơn. Đã có lỗi xảy ra trong quá trình lưu trữ.");
                request.setAttribute("invoice", invoice);
                request.setAttribute("buyerPhone", buyerPhone);

                Integer invoiceCreatorId = invoice.getCreatedBy();
                if (invoiceCreatorId == null && user != null) {
                    invoiceCreatorId = user.getUserId();
                }
                if (invoiceCreatorId != null) {
                    UserDAO userDAO = new UserDAO();
                    User creator = userDAO.getUserById(invoiceCreatorId);
                    if (creator != null) {
                        request.setAttribute("creatorName", creator.getFullName());
                    }
                }

                loadInvoiceCreationData(request, orderId);
                request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý dữ liệu: " + e.getMessage());
            request.setAttribute("invoice", invoice);
            request.setAttribute("buyerPhone", buyerPhone);

            Integer invoiceCreatorId = (invoice != null) ? invoice.getCreatedBy() : null;
            if (invoiceCreatorId == null) {
                invoiceCreatorId = user.getUserId();
            }
            if (invoiceCreatorId != null) {
                UserDAO userDAO = new UserDAO();
                User creator = userDAO.getUserById(invoiceCreatorId);
                if (creator != null) {
                    request.setAttribute("creatorName", creator.getFullName());
                }
            }

            if (orderId > 0) {
                try {
                    loadInvoiceCreationData(request, orderId);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
            request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
        }
    }

    private void loadInvoiceCreationData(HttpServletRequest request, int orderId) throws Exception {
        CustomerOrderDAO orderDAO = new CustomerOrderDAO();
        CustomerOrderDTO orderDto = orderDAO.getCustomerOrderDTOById(orderId);
        if (orderDto != null) {
            List<InvoiceItemDTO> orderItems = iService.getInvoiceItemsByOrderId(orderId);
            double subTotal = iService.calculateGoodsAmount(orderItems);
            double taxTotal = iService.calculateTaxAmount(orderItems);
            double discountTotal = iService.calculateDiscountAmount(orderItems);
            double totalAmount = Double.parseDouble(String.format("%.2f", subTotal - discountTotal + taxTotal));
            CustomerDAO customerDAO = new CustomerDAO();
            CustomerDTO customerDto = customerDAO.getCustomerDTOById(orderDto.getCustomerOrder().getCustomerId());

            

            request.setAttribute("order", orderDto.getCustomerOrder());
            request.setAttribute("orderDetails", orderItems);
            request.setAttribute("subTotal", subTotal);
            request.setAttribute("discountTotal", discountTotal);
            request.setAttribute("taxAmount", taxTotal);
            request.setAttribute("totalAmount", totalAmount);

            if (customerDto != null) {
                request.setAttribute("customer", customerDto.getCustomer());
                request.setAttribute("customerUser", customerDto.getUser());
            }
        }
    }
}

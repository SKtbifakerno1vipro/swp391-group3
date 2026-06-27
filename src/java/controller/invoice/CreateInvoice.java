package controller.invoice;

import java.io.IOException;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dal.CustomerOrderDAO;
import dal.CustomerDAO;
import dal.ContractDAO;
import dal.InvoiceDAO;
import dto.CustomerOrderDTO;
import dto.CustomerDTO;
import model.Contract;
import model.Invoice;
import model.User;

@WebServlet(name = "CreateInvoice", urlPatterns = {"/invoice"})
public class CreateInvoice extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdRaw = request.getParameter("orderId");
        if (orderIdRaw != null && !orderIdRaw.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdRaw);
                loadInvoiceCreationData(request, orderId);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi tải thông tin đơn hàng: " + e.getMessage());
            }
        }
        request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form inputs
            int contractId = Integer.parseInt(request.getParameter("customerContractId"));
            int orderId = Integer.parseInt(request.getParameter("customerOrderId"));
            String invoiceNo = request.getParameter("invoiceNo");
            String issueDateStr = request.getParameter("issueDate"); // datetime-local format: yyyy-MM-dd'T'HH:mm
            String invoiceStatus = request.getParameter("invoiceStatus");
            String invoiceType = request.getParameter("invoiceType");
            String invoiceSymbol = request.getParameter("invoiceSymbol");
            
            String sellerName = request.getParameter("sellerName");
            String sellerTaxCode = request.getParameter("sellerTaxCode");
            String sellerAddress = request.getParameter("sellerAddress");
            
            String buyerName = request.getParameter("buyerName");
            String buyerTaxCode = request.getParameter("buyerTaxCode");
            String buyerAddress = request.getParameter("buyerAddress");
            String buyerPhone = request.getParameter("buyerPhone");
            
            BigDecimal subTotal = new BigDecimal(request.getParameter("subTotal"));
            BigDecimal taxAmount = new BigDecimal(request.getParameter("taxAmount"));
            BigDecimal totalAmount = new BigDecimal(request.getParameter("totalAmount"));
            
            String customerNote = request.getParameter("invoiceNotes");
            String internalNote = request.getParameter("internalNotes");
            
            // Get current logged-in user from session
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            Integer createdBy = (user != null) ? user.getUserId() : null;
            
            // Build Invoice object
            Invoice invoice = new Invoice();
            invoice.setCustomerContractId(contractId);
            invoice.setCustomerOrderId(orderId);
            invoice.setInvoiceNo(invoiceNo);
            
            if (issueDateStr != null && !issueDateStr.trim().isEmpty()) {
                invoice.setIssueDate(LocalDateTime.parse(issueDateStr));
            } else {
                invoice.setIssueDate(LocalDateTime.now());
            }
            
            invoice.setInvoiceStatus(invoiceStatus);
            invoice.setInvoiceType(invoiceType);
            invoice.setInvoiceSymbol(invoiceSymbol);
            
            invoice.setSellerName(sellerName);
            invoice.setSellerTaxCode(sellerTaxCode);
            invoice.setSellerAddress(sellerAddress);
            
            invoice.setBuyerName(buyerName);
            invoice.setBuyerTaxCode(buyerTaxCode);
            invoice.setBuyerAddress(buyerAddress);
            
            invoice.setSubTotal(subTotal);
            invoice.setTaxAmount(taxAmount);
            invoice.setTotalAmount(totalAmount);
            
            invoice.setCustomerNote(customerNote);
            invoice.setInternalNote(internalNote);
            invoice.setCreatedBy(createdBy);
            
            // Validate first
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            String errorMsg = invoiceDAO.validateInvoice(invoice, buyerPhone);
            if (errorMsg != null) {
                request.setAttribute("error", errorMsg);
                loadInvoiceCreationData(request, orderId);
                request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
                return;
            }
            
            // Insert Invoice into DB
            int generatedId = invoiceDAO.insertInvoice(invoice);
            if (generatedId > 0) {
                response.sendRedirect(request.getContextPath() + "/invoice-list");
            } else {
                request.setAttribute("error", "Không thể xuất hóa đơn. Đã có lỗi xảy ra trong quá trình lưu trữ.");
                loadInvoiceCreationData(request, orderId);
                request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi xử lý dữ liệu: " + e.getMessage());
            String orderIdRaw = request.getParameter("customerOrderId");
            if (orderIdRaw != null) {
                try {
                    loadInvoiceCreationData(request, Integer.parseInt(orderIdRaw));
                } catch (Exception ex) {}
            }
            request.getRequestDispatcher("/views/invoice/create.jsp").forward(request, response);
        }
    }

    private void loadInvoiceCreationData(HttpServletRequest request, int orderId) throws Exception {
        CustomerOrderDAO orderDAO = new CustomerOrderDAO();
        CustomerOrderDTO orderDto = orderDAO.getCustomerOrderDTOById(orderId);
        if (orderDto != null) {
            List<CustomerOrderDTO> orderDetails = orderDAO.getDetailsByOrderId(orderId);
            
            CustomerDAO customerDAO = new CustomerDAO();
            CustomerDTO customerDto = customerDAO.getCustomerDTOById(orderDto.getCustomerOrder().getCustomerId());
            
            ContractDAO contractDAO = new ContractDAO();
            Contract contract = contractDAO.getContractById(orderDto.getCustomerOrder().getCustomerContractId());
            
            request.setAttribute("order", orderDto.getCustomerOrder());
            request.setAttribute("orderDetails", orderDetails);
            if (customerDto != null) {
                request.setAttribute("customer", customerDto.getCustomer());
                request.setAttribute("customerUser", customerDto.getUser());
            }
            request.setAttribute("contract", contract);
        }
    }
}

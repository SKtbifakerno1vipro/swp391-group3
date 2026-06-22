package controller.contract;

import dto.CustomerDTO;
import model.*;
import service.*;
import service.ContractService;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Properties;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/contract-save"})
public class ContractSaveController extends HttpServlet {

    private final ContractService contractService = new ContractService();
    private final QuotationService quotationService = new QuotationService();
    private final CustomerService customerService = new CustomerService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String contractIdRaw = request.getParameter("id");
        String quotationId = request.getParameter("quotationId");

        //check  contract exist by id?
        if (contractIdRaw != null && !contractIdRaw.isEmpty()) {
            int contractId = Integer.parseInt(contractIdRaw);
            Contract contract = contractService.getContractById(contractId);

            if (contract == null) {
                response.sendRedirect("contract-list");
                return;
            }

            String status = contract.getContractStatus();

            // If contract status is customer_approve so can not edit
            if ("APPROVED".equals(status)) {
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            // Chuyển trạng thái hiển thị cho JSP
            boolean editable = "DRAFT".equals(status) || "PENDING_REVIEW".equals(status);
            request.setAttribute("editable", editable);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);

            // --- Tạo mới hợp đồng từ quotation ---
        } else if (quotationId != null && !quotationId.isEmpty()) {
            int qId = Integer.parseInt(quotationId);
            Quotation quotation = quotationService.getQuotationById(qId);
            if (quotation != null) {
                String templateHtml = generateContractHtml(quotation);
                request.setAttribute("templateContent", templateHtml);
                request.setAttribute("quotationId", qId);
                request.setAttribute("customerId", quotation.getCustomerId());
                request.setAttribute("editable", true);
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            } else {
                response.sendRedirect("quotation-list");
            }
        } else {
            response.sendRedirect(  "contract-list");
        }
    }

    private String generateContractHtml(Quotation quotation) throws IOException {
        CustomerDTO customer = customerService.getCustomerDTOById(quotation.getCustomerId());
        List<QuotationDetail> details = quotationService.getQuotationDetailsByQuotationId(quotation.getQuotationId());

        Properties config = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        }

        String templatePath = getServletContext().getRealPath("/views/contract/template.jsp");
        String template = new String(Files.readAllBytes(Paths.get(templatePath)), StandardCharsets.UTF_8);
        
        return contractService.fillTemplate(quotation, customer, details, template, config);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String contractIdStr = request.getParameter("contractId");
        String quotationIdStr = request.getParameter("quotationId");
        String contractContent = request.getParameter("contractContent");
        String action = request.getParameter("action");
        
        if (contractContent == null || contractContent.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Contract content cannot be empty!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            return;
        }

        // --- UPDATE ---
        if (contractIdStr != null && !contractIdStr.isEmpty()) {
            int contractId = Integer.parseInt(contractIdStr);
            Contract c = contractService.getContractById(contractId);
            if (c == null) {
                response.sendRedirect("contract-list");
                return;
            }

            c.setContractContent(contractContent);
            c.setUpdatedBy(user.getUserId());
            boolean ok = contractService.update(c);

            if (ok) {
                if ("submit_for_review".equals(action)) {
                    // BR: only DRAFT can submit_for_review
                    if ("DRAFT".equals(c.getContractStatus())) {
                        contractService.updateStatus(contractId, "PENDING_REVIEW");
                        insertHistory(c, "PENDING_REVIEW", "User submitted contract for manager review.", user.getUserId());
                    } else {
                        // Status not DRAFT, cannot submit
                    }
                } else {
                    insertHistory(c, c.getContractStatus(), "User saved contract content.", user.getUserId());
                }
                response.sendRedirect("contract-detail?id=" + contractId);
            } else {
                request.setAttribute("errorMsg", "Update failed!");
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            }
            return;
        }

        // --- CREATE ---
        int quotationId = Integer.parseInt(quotationIdStr);
        int customerId = Integer.parseInt(request.getParameter("customerId"));

        if (contractService.getContractByQuotationId(quotationId) != null) {
            request.setAttribute("errorMsg", "A contract for this quotation already exists!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            return;
        }

        // Tạo mã hợp đồng ngay tại đây để gán vào object trước khi insert
        String year = LocalDate.now()
                .format(DateTimeFormatter.ofPattern("yyyy"));
        String newContractNumber = String.format("%03d", quotationId) + "/" + year + "-HĐ";

        Contract c = new Contract();
        c.setCustomerId(customerId);
        c.setQuotationId(quotationId);
        c.setContractNumber(newContractNumber); // Đã có mã ngay khi tạo
        c.setContractStatus("DRAFT");
        c.setStorageType("TEXT");
        c.setContractContent(contractContent);
        c.setCreatedBy(user.getUserId());

        int newId = contractService.insert(c);
        if (newId > 0) {
            c.setContractId(newId);
            insertHistory(c, "DRAFT", "Contract created in DRAFT status.", user.getUserId());

            if ("submit_for_review".equals(action)) {
                // Guard: only DRAFT can submit_for_review
                if ("DRAFT".equals(c.getContractStatus())) {
                    contractService.updateStatus(newId, "PENDING_REVIEW");
                    insertHistory(c, "PENDING_REVIEW", "User submitted contract for manager review.", user.getUserId());
                }
            }
            response.sendRedirect("contract-detail?id=" + newId);
        } else {
            request.setAttribute("errorMsg", "Creation failed!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
        }
    }

    /**
     * Helper that records a status change / activity in ContractHistory.
     */
    private void insertHistory(Contract contract, String toStatus, String note, int changedBy) {
        ContractHistory h = new ContractHistory();
        h.setContractId(contract.getContractId());
        h.setFromStatus(contract.getContractStatus());   // previous status
        h.setToStatus(toStatus);
        h.setNote(note);
        h.setChangedBy(changedBy);
        contractService.insertHistory(h);
    }
}

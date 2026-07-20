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
import java.util.UUID;

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
        String quotationIdStr = request.getParameter("quotationId");

        //check  contract exist by id?
        if (contractIdRaw != null && !contractIdRaw.isEmpty()) {
            int contractId = Integer.parseInt(contractIdRaw);
            Contract contract = contractService.getContractById(contractId);

            //if contract not exist with id raw
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

            //define status to edit contract
            boolean editable = "DRAFT".equals(status) || "PENDING_REVIEW".equals(status);
            request.setAttribute("editable", editable);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);

            // create new contract with quotation
        } else if (quotationIdStr != null && !quotationIdStr.isEmpty()) {
            int qId = Integer.parseInt(quotationIdStr);
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
            response.sendRedirect("contract-list");
        }
    }

    private String generateContractHtml(Quotation quotation) throws IOException {
        CustomerDTO customer = customerService.getCustomerDTOById(quotation.getCustomerId());
        List<QuotationDetail> details = quotationService.getQuotationDetailsByQuotationId(quotation.getQuotationId());

        Properties config = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/resources/config.properties")) {
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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        } else if (user.getRoleId() != 5 && user.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: You do not have permission to view this profile.");
            return;
        }

        String contractIdStr = request.getParameter("contractId");
        String quotationIdStr = request.getParameter("quotationId");
        String contractContent = request.getParameter("contractContent");
        String action = request.getParameter("action");

        if (contractContent == null || contractContent.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Nội dung hợp đồng không được để trống!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            return;
        }

        //  UPDATE
        if (contractIdStr != null && !contractIdStr.isEmpty()) {
            int contractId = Integer.parseInt(contractIdStr);
            Contract c = contractService.getContractById(contractId);
            if (c == null) {
                response.sendRedirect("contract-list");
                return;
            }

            String currentStatus = c.getContractStatus();
            if (!"DRAFT".equals(currentStatus) && !"PENDING_REVIEW".equals(currentStatus)) {
                request.setAttribute("errorMsg", "Hợp đồng đã chốt, không được phép chỉnh sửa nội dung!");
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
                return;
            }

            c.setContractContent(contractContent);
            c.setUpdatedBy(user.getUserId());
            boolean updateContractSucessful = contractService.update(c);

            if (updateContractSucessful) {
                if ("submit_for_review".equals(action)) {
                    // only DRAFT or PENDING_REVIEW can submit for manager review (officier -> manager)
                    if ("DRAFT".equals(c.getContractStatus()) || "PENDING_REVIEW".equals(c.getContractStatus())) {
                        contractService.updateStatus(contractId, "PENDING_REVIEW");
                        insertHistoryForOfficier(c, "PENDING_REVIEW", "Admin officer vừa cập nhật lại hợp đồng và đã gửi cho manager kiểm tra.", user.getUserId());
                        service.AuditLogService.log(user.getUserId(), "UPDATE", "Contract", "Gửi duyệt hợp đồng số: " + c.getContractNumber() + " (ID: " + contractId + ")");
                    } else {
                        System.out.println("Status not DRAFT or PENDING_REVIEW, cannot submit");
                    }
                } else {
                    insertHistoryForOfficier(c, c.getContractStatus(), "Officer vừa lưu lại hợp đồng.", user.getUserId());
                    service.AuditLogService.log(user.getUserId(), "UPDATE", "Contract", "Lưu nội dung hợp đồng số: " + c.getContractNumber() + " (ID: " + contractId + ")");
                }
                response.sendRedirect("contract-detail?id=" + contractId);
            } else {
                request.setAttribute("errorMsg", "Cập nhật thất bại!");
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            }
            return;
        }

        // --- CREATE ---
        int quotationId = Integer.parseInt(quotationIdStr);
        int customerId = Integer.parseInt(request.getParameter("customerId"));

        //if existed one contract with quotation
        if (contractService.getContractByQuotationId(quotationId) != null) {
            request.setAttribute("errorMsg", "Báo giá này đã có hợp đồng!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            return;
        }

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
        String secureToken = UUID.randomUUID().toString();
        c.setToken(secureToken);
        int newId = contractService.insert(c);

        if (newId > 0) {
            c.setContractId(newId);
            insertHistoryForOfficier(c, "DRAFT", "Hợp đồng vừa mới được tạo mới.", user.getUserId());
            service.AuditLogService.log(user.getUserId(), "CREATE", "Contract", "Tạo dự thảo hợp đồng mới: " + newContractNumber + " (ID: " + newId + ")");// from giang

            if ("submit_for_review".equals(action)) {
                // only DRAFT or PENDING_REVIEW can submit for manager review (officier -> manager)
                if ("DRAFT".equals(c.getContractStatus()) || "PENDING_REVIEW".equals(c.getContractStatus())) {
                    contractService.updateStatus(newId, "PENDING_REVIEW");
                    insertHistoryForOfficier(c, "PENDING_REVIEW", "Admin officer vừa cập nhật lại hợp đồng và đã gửi cho manager kiểm tra.", user.getUserId());
                    service.AuditLogService.log(user.getUserId(), "UPDATE", "Contract", "Gửi duyệt hợp đồng số: " + newContractNumber + " (ID: " + newId + ")");//from giang
                }
            }
            response.sendRedirect("contract-detail?id=" + newId);
        } else {
            request.setAttribute("errorMsg", "Tạo hợp đồng thất bại!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
        }
    }

    /**
     * Helper that records a status change / activity in ContractHistory.
     */
    private void insertHistoryForOfficier(Contract contract, String toStatus, String note, int changedBy) {
        ContractHistory h = new ContractHistory();
        h.setContractId(contract.getContractId());
        h.setFromStatus(contract.getContractStatus());   // previous status
        h.setToStatus(toStatus);
        h.setNote(note);
        h.setChangedBy(changedBy);
        contractService.insertHistory(h);
    }
}

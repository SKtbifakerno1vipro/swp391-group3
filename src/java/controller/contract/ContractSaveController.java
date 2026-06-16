package controller.contract;

import dal.*;
import model.*;
import dto.*;
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

@WebServlet(urlPatterns = {"/contract-save"})
public class ContractSaveController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final QuotationDAO quotationDAO = new QuotationDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String quotationId = request.getParameter("quotationId");

        if (id != null && !id.isEmpty()) {
            int contractId = Integer.parseInt(id);
            Contract contract = contractDAO.getContractById(contractId);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
        } else if (quotationId != null && !quotationId.isEmpty()) {
            int qId = Integer.parseInt(quotationId);
            Quotation quotation = quotationDAO.getQuotationById(qId);
            if (quotation != null) {
                String templateHtml = generateContractHtml(qId);
                request.setAttribute("templateContent", templateHtml);
                request.setAttribute("quotationId", qId);
                request.setAttribute("customerId", quotation.getCustomerId());
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            } else {
                response.sendRedirect("quotation-list");
            }
        } else {
            response.sendRedirect("contract-list");
        }
    }

    private String generateContractHtml(int quotationId) throws IOException {
        Quotation quotation = quotationDAO.getQuotationById(quotationId);
        CustomerDTO customer = customerDAO.getCustomerDTOById(quotation.getCustomerId());
        List<QuotationDetail> details = quotationDAO.getQuotationDetailsByQuotationId(quotationId);

        Properties config = new Properties();
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        }

        String templatePath = getServletContext().getRealPath("/views/contract/template.jsp");
        String template = new String(Files.readAllBytes(Paths.get(templatePath)), java.nio.charset.StandardCharsets.UTF_8);

        return contractService.fillTemplate(quotation, customer, details, template, config);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

        if (contractContent == null || contractContent.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Contract content cannot be empty!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            return;
        }

        if (contractIdStr != null && !contractIdStr.isEmpty()) {
            // --- UPDATE ---
            int contractId = Integer.parseInt(contractIdStr);
            Contract c = contractDAO.getContractById(contractId);
            if (c != null) {
                c.setContractContent(contractContent);
                c.setUpdatedBy(user.getUserId());
                // Explicitly keep the status as it was in the database
                c.setContractStatus(c.getContractStatus());

                boolean success = contractDAO.update(c);
                if (success) {
                    response.sendRedirect("contract-detail?id=" + contractId);
                } else {
                    request.setAttribute("errorMsg", "Update failed!");
                    request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect("contract-list");
            }
            
        } else {
            // --- CREATE ---
            int quotationId = 0;
            try {
                quotationId = Integer.parseInt(quotationIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "Invalid Quotation ID format!");
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
                return;
            }

            String customerIdStr = request.getParameter("customerId");
            int customerId = 0;
            try {
                customerId = Integer.parseInt(customerIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMsg", "Invalid Customer ID format! customerId=" + customerIdStr);
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
                return;
            }

            Contract existingContract = contractDAO.getContractByQuotationId(quotationId);
            if (existingContract != null) {
                request.setAttribute("errorMsg", "A contract for this quotation already exists!");
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
                return;
            }

        Contract c = new Contract();
            c.setCustomerId(customerId);
            c.setQuotationId(quotationId);
            // Tạm thời để trống hoặc một chuỗi tạm
            c.setContractNumber("TEMP"); 
            c.setContractStatus("DRAFT");
            c.setStorageType("TEXT");
            c.setContractContent(contractContent);
            c.setCreatedBy(user.getUserId());

            int newId = contractDAO.insert(c);
            if (newId > 0) {
                // Sinh mã chuẩn dựa trên ID vừa tạo
                String yearMonth = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMM"));
                String newContractNumber = "HD" + yearMonth + "-" + String.format("%04d", newId);
                
                // Cập nhật mã chuẩn vào DB
                c.setContractId(newId);
                c.setContractNumber(newContractNumber);
                contractDAO.updateContractNumber(c); // Gọi phương thức mới trong DAO
                
                response.sendRedirect("contract-detail?id=" + newId);
            } else {
                request.setAttribute("errorMsg", "Creation failed!");
                request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
            }
        }
    }
}

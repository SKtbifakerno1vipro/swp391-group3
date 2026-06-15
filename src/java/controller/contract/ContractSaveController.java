package controller.contract;

import dal.*;
import model.*;
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String quotationId = request.getParameter("quotationId");

        if (id != null && !id.isEmpty()) {
            int contractId = Integer.parseInt(id);
            Contract contract = contractDAO.getContractById(contractId);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("views/contract/form.jsp")
                    .forward(request, response);
        } else if (quotationId != null && !quotationId.isEmpty()) {
            int qId = Integer.parseInt(quotationId);
            String templateHtml = generateContractHtml(qId);
            request.setAttribute("templateContent", templateHtml);
            request.setAttribute("quotationId", qId);
            request.getRequestDispatcher("views/contract/form.jsp")
                    .forward(request, response);
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
        String template = new String(Files.readAllBytes(Paths.get(templatePath)), "UTF-8");

        return contractService.fillTemplate(quotation, customer, details, template, config);
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    HttpSession session = request.getSession();
    
    // cleaned comment
    User user = (User) session.getAttribute("user"); // cleaned comment
    if (user == null) {
        response.sendRedirect("login"); // cleaned comment
        return;
    }

    // cleaned comment
    String contractIdStr = request.getParameter("contractId");
    String quotationIdStr = request.getParameter("quotationId");
    String contractContent = request.getParameter("contractContent");

    // cleaned comment
    if (contractContent == null || contractContent.trim().isEmpty()) {
        request.setAttribute("errorMsg", "Ni dung hp ng khng c  trng!");
        request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
        return;
    }

    // cleaned comment
    if (contractIdStr != null && !contractIdStr.isEmpty()) {
        // --- UPDATE ---
        int contractId = Integer.parseInt(contractIdStr);
        Contract c = contractDAO.getContractById(contractId);
        c.setContractContent(contractContent);
        c.setUpdatedBy(user.getUserId());
        
        boolean success = contractDAO.update(c);
        if (success) {
            response.sendRedirect("contract-detail?id=" + contractId);
        } else {
            request.setAttribute("errorMsg", "Cp nht tht bi!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
        }
    } else {
        // cleaned comment
        int quotationId = Integer.parseInt(quotationIdStr);
        Contract c = new Contract();
        c.setCustomerId(Integer.parseInt(request.getParameter("customerId"))); // cleaned comment
        c.setQuotationId(quotationId);
        c.setContractNumber("HD-" + System.currentTimeMillis()); // cleaned comment
        c.setContractStatus("DRAFT");
        c.setContractContent(contractContent);
        c.setCreatedBy(user.getUserId());

        int newId = contractDAO.insert(c);
        if (newId > 0) {
            response.sendRedirect("contract-detail?id=" + newId);
        } else {
            request.setAttribute("errorMsg", "To mi tht bi!");
            request.getRequestDispatcher("views/contract/form.jsp").forward(request, response);
        }
    }
}
}

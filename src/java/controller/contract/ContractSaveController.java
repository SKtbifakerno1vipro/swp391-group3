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

@WebServlet(urlPatterns = {"/contract-save"})   
public class ContractSaveController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final QuotationDAO quotationDAO = new QuotationDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Khi nguoi dung muon “sua” hop đong đa ton tai → chuyen toi form edit
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            int contractId = Integer.parseInt(id);
            Contract contract = contractDAO.getContractById(contractId);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("views/contract/form.jsp")
                   .forward(request, response);
        } else {
            // khong co id → chuyen ve danh sach
            response.sendRedirect("contract-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        /*
         *  Đau vao:  quotationId (đuoc truyen tu form “Tao hop đong”)
         *  Quy trinh:
         *  1. Lay Quotation, Customer va chi tiet san pham.
         *  2. Đoc file config.properties (cac thong tin Ben A).
         *  3. Đoc template HTML.
         *  4. Gan du lieu → html cuoi cung.
         *  5. Luu vao bang customer_contract.
         *  6. Chuyen ve chi tiet hoac danh sach.
         */

        request.setCharacterEncoding("UTF-8");
        String quotationIdStr = request.getParameter("quotationId");
        if (quotationIdStr == null || quotationIdStr.isEmpty()) {
            response.getWriter().println("Thiếu quotationId");
            return;
        }
        int quotationId = Integer.parseInt(quotationIdStr);

        // 1. Lay du lieu lien quan
        Quotation quotation = quotationDAO.getQuotationById(quotationId);
        Customer customer = customerDAO.getCustomerByCusId(quotation.getCustomerId());
        List<QuotationDetail> details = null;

        // 2. Đoc file config.properties (đat trong WEB-INF)
        Properties config = new Properties();
        try (InputStream is = getServletContext()
                .getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        }

        // 3. Đoc template HTML
        String templatePath = getServletContext()
                .getRealPath("/WEB-INF/views/contract/ContractTemplate.html");
        String template = new String(Files.readAllBytes(Paths.get(templatePath)), "UTF-8");

        // 4. Tao noi dung hop đong
        String contractHtml = contractService.fillTemplate(
                quotation, customer, details, template, config);

        // 5. Tao đoi tuong Contract va luu vao DB
        Contract contract = new Contract();
        contract.setCustomerId(customer.getCustomerId());
        contract.setQuotationId(quotationId);
        contract.setContractNumber("HĐ-" + System.currentTimeMillis()); // demo tự sinh
        contract.setContractStatus("DRAFT");
        contract.setStorageType("TEXT");
        contract.setContractContent(contractHtml);
        contract.setCreatedBy( /* ID người hiện tại, ví dụ lấy từ session */ 1 );
        // cac truong ngay, version … neu can co the set o đay

        int contractId = contractDAO.insert(contract); // trả về PK mới tạo

        // 6. Chuyen huong toi chi tiet hop đong (hoac danh sach)
        if (contractId > 0) {
            response.sendRedirect("contract-detail?id=" + contractId);
        } else {
            request.setAttribute("errorMsg", "Lưu hợp đồng thất bại");
            request.getRequestDispatcher("views/contract/form.jsp")
                   .forward(request, response);
        }
    }
}
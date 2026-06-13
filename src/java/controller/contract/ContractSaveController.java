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

@WebServlet(urlPatterns = {"/contract-save"})   // URL sẽ gọi tới servlet này
public class ContractSaveController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final QuotationDAO quotationDAO = new QuotationDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Khi người dùng muốn “sửa” hợp đồng đã tồn tại → chuyển tới form edit
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            int contractId = Integer.parseInt(id);
            Contract contract = contractDAO.getContractById(contractId);
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("views/contract/form.jsp")
                   .forward(request, response);
        } else {
            // không có id → chuyển về danh sách
            response.sendRedirect("contract-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        /*
         *  Đầu vào:  quotationId (được truyền từ form “Tạo hợp đồng”)
         *  Quy trình:
         *  1. Lấy Quotation, Customer và chi tiết sản phẩm.
         *  2. Đọc file config.properties (các thông tin Bên A).
         *  3. Đọc template HTML.
         *  4. Gán dữ liệu → html cuối cùng.
         *  5. Lưu vào bảng customer_contract.
         *  6. Chuyển về chi tiết hoặc danh sách.
         */

        request.setCharacterEncoding("UTF-8");
        String quotationIdStr = request.getParameter("quotationId");
        if (quotationIdStr == null || quotationIdStr.isEmpty()) {
            response.getWriter().println("Thiếu quotationId");
            return;
        }
        int quotationId = Integer.parseInt(quotationIdStr);

        // 1. Lấy dữ liệu liên quan
        Quotation quotation = quotationDAO.getQuotationById(quotationId);
        Customer customer = customerDAO.getCustomerByCusId(quotation.getCustomerId());
        List<QuotationDetail> details = null;

        // 2. Đọc file config.properties (đặt trong WEB-INF)
        Properties config = new Properties();
        try (InputStream is = getServletContext()
                .getResourceAsStream("/WEB-INF/config.properties")) {
            if (is != null) {
                config.load(is);
            }
        }

        // 3. Đọc template HTML
        String templatePath = getServletContext()
                .getRealPath("/WEB-INF/views/contract/ContractTemplate.html");
        String template = new String(Files.readAllBytes(Paths.get(templatePath)), "UTF-8");

        // 4. Tạo nội dung hợp đồng
        String contractHtml = contractService.fillTemplate(
                quotation, customer, details, template, config);

        // 5. Tạo đối tượng Contract và lưu vào DB
        Contract contract = new Contract();
        contract.setCustomerId(customer.getCustomerId());
        contract.setQuotationId(quotationId);
        contract.setContractNumber("HĐ-" + System.currentTimeMillis()); // demo tự sinh
        contract.setContractStatus("DRAFT");
        contract.setStorageType("TEXT");
        contract.setContractContent(contractHtml);
        contract.setCreatedBy( /* ID người hiện tại, ví dụ lấy từ session */ 1 );
        // các trường ngày, version … nếu cần có thể set ở đây

        int contractId = contractDAO.insert(contract); // trả về PK mới tạo

        // 6. Chuyển hướng tới chi tiết hợp đồng (hoặc danh sách)
        if (contractId > 0) {
            response.sendRedirect("contract-detail?id=" + contractId);
        } else {
            request.setAttribute("errorMsg", "Lưu hợp đồng thất bại");
            request.getRequestDispatcher("views/contract/form.jsp")
                   .forward(request, response);
        }
    }
}
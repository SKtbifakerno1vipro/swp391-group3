package tool;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Properties;

import model.*;
import dto.*;

@WebServlet(name = "AutoGenerateServlet", urlPatterns = {"/tool/auto-generate"})
public class AutoGenerateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (ToolDAO toolDAO = new ToolDAO()) {
            List<CustomerDTO> customers = toolDAO.getAllCustomers();
            List<Product> products = toolDAO.getAllActiveProducts();
            List<UserRoleDTO> managers = toolDAO.getAllActiveManagers();

            request.setAttribute("customers", customers);
            request.setAttribute("products", products);
            request.setAttribute("managers", managers);

            request.getRequestDispatcher("/tool/auto-generate.jsp").forward(request, response);
        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try (ToolDAO toolDAO = new ToolDAO()) {
            String customerIdRaw = request.getParameter("customerId");
            String managerIdRaw = request.getParameter("managerId");
            String[] selectedProductIds = request.getParameterValues("productIds");

            if (customerIdRaw == null || managerIdRaw == null || selectedProductIds == null || selectedProductIds.length == 0) {
                session.setAttribute("tool_error", "Vui lòng điền đầy đủ thông tin và chọn ít nhất 1 sản phẩm!");
                response.sendRedirect("auto-generate");
                return;
            }

            int customerId = Integer.parseInt(customerIdRaw);
            int managerId = Integer.parseInt(managerIdRaw);

            CustomerDTO customerDTO = toolDAO.getCustomerById(customerId);
            User managerUser = toolDAO.getManagerById(managerId);

            if (customerDTO == null) {
                session.setAttribute("tool_error", "Không tìm thấy thông tin khách hàng với ID: " + customerId);
                response.sendRedirect("auto-generate");
                return;
            }
            if (managerUser == null) {
                session.setAttribute("tool_error", "Không tìm thấy thông tin quản lý với ID: " + managerId);
                response.sendRedirect("auto-generate");
                return;
            }

            List<QuotationDetail> details = new ArrayList<>();
            for (String pidStr : selectedProductIds) {
                int pid = Integer.parseInt(pidStr);
                String qtyStr = request.getParameter("qty_" + pid);
                int qty = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 50;

                Product prod = toolDAO.getProductById(pid);
                if (prod != null) {
                    QuotationDetail detail = new QuotationDetail();
                    detail.setProductId(pid);
                    detail.setProductName(prod.getProductName());
                    detail.setUnit(prod.getUnit());
                    detail.setCostPrice(BigDecimal.valueOf(prod.getCostPrice()));
                    detail.setSellingPrice(BigDecimal.valueOf(prod.getSellingPrice()));
                    detail.setQuantity(qty);
                    detail.setDiscountPercent(BigDecimal.ZERO);
                    detail.setTaxPercent(BigDecimal.valueOf(10));
                    details.add(detail);
                } else {
                    session.setAttribute("tool_error", "Không tìm thấy sản phẩm với ID: " + pid);
                    response.sendRedirect("auto-generate");
                    return;
                }
            }

            if (details.isEmpty()) {
                session.setAttribute("tool_error", "Danh sách sản phẩm chi tiết rỗng!");
                response.sendRedirect("auto-generate");
                return;
            }

            // Read template configuration and raw file
            Properties config = new Properties();
            try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/config.properties")) {
                if (is != null) {
                    config.load(is);
                }
            }

            String templatePath = getServletContext().getRealPath("/views/contract/template.jsp");
            String template = new String(Files.readAllBytes(Paths.get(templatePath)), StandardCharsets.UTF_8);

            // Execute database transaction and templating pipeline
            ToolDAO.PipelineResult result = toolDAO.runCreationPipeline(
                customerId, managerId, customerDTO, managerUser, details, template, config
            );

            // Write transparent PNG signature file to disk
            byte[] dummyPngBytes = Base64.getDecoder().decode(
                    "iVBORw0KGgoAAAANSUhEUgAAAFAAAAAyCAYAAADLLWDDAAAABmJLR0QA/wD/AP+gvaeTAAAAIklEQVRoge3BMQEAAADCoPVPbQwfoAAAAAAAAAAAAAAAAAAAAHgQIAAB44Wj0wAAAABJRU5ErkJggg=="
            );

            String uploadBuild = getServletContext().getRealPath("/uploads");
            File buildDir = new File(uploadBuild);
            if (!buildDir.exists()) {
                buildDir.mkdirs();
            }
            try (FileOutputStream fos = new FileOutputStream(new File(buildDir, result.sigFileName))) {
                fos.write(dummyPngBytes);
            }

            try {
                File webFile = new File(new File(getServletContext().getRealPath("/")).getParentFile().getParentFile(), "web");
                File sourceUploads = new File(webFile, "uploads");
                if (!sourceUploads.exists()) {
                    sourceUploads.mkdirs();
                }
                try (FileOutputStream fos = new FileOutputStream(new File(sourceUploads, result.sigFileName))) {
                    fos.write(dummyPngBytes);
                }
            } catch (Exception e) {
                System.err.println("Note: Could not copy signature image to source directory: " + e.getMessage());
            }

            session.setAttribute("tool_success", "Chúc mừng! Đã tạo tự động thành công Báo giá (ACCEPTED) và Hợp đồng (APPROVED) cho khách hàng <strong>" + customerDTO.getCustomer().getCompanyName() + "</strong>. Trạng thái hiện tại: Manager đã ký sẵn, chờ khách hàng ký duyệt.");
            session.setAttribute("created_quotation_id", result.quotationId);
            session.setAttribute("created_contract_id", result.contractId);

        } catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            session.setAttribute("tool_error", "Đã xảy ra lỗi: " + e.getMessage() + "<br><pre style='text-align:left; font-size:12px; max-height:200px; overflow-y:auto;'>" + sw.toString() + "</pre>");
        }

        response.sendRedirect("auto-generate");
    }
}

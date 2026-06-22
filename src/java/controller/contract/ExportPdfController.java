package controller.contract;

import com.openhtmltopdf.pdfboxout.PdfRendererBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contract;
import dal.ContractDAO;
import java.io.File;
import java.io.IOException;
import service.SignatureService;
import service.RoleService;
import service.UserService;
import model.Signature;
import java.util.List;
import java.io.OutputStream;

@WebServlet(name = "ExportPdfController", urlPatterns = {"/export-pdf"})
public class ExportPdfController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final SignatureService sService = new SignatureService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Ép UTF-8 cho Request & Response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.getWriter().write("Missing id parameter");
            return;
        }

        int contractId = 0;
        try {
            contractId = Integer.parseInt(idParam);
        } catch (Exception e) {
            response.getWriter().write("Invalid id");
            return;
        }

        Contract contract = contractDAO.getContractById(contractId);
        if (contract == null) {
            response.getWriter().write("Contract not found");
            return;
        }

        String rawContent = contract.getContractContent() != null ? contract.getContractContent() : "";

        // 2. Convert custom image src to real URL for signature images
        String uploadDir = getServletContext().getRealPath("/uploads/");
        // Ensure path ends with separator
        if (!uploadDir.endsWith(File.separator)) {
            uploadDir += File.separator;
        }
        String uploadsUrl = "file:///" + uploadDir.replace("\\", "/");
        String html = rawContent.replaceAll("(src=[\\\"']?)File\\?name=([^\\\"'>]+)([\\\"']?)",
                "$1" + uploadsUrl + "$2$3");
        // Also replace any already‑converted /uploads/ URLs to file URIs for PDF rendering
        html = html.replaceAll("(src=[\\\"']?)(?:.*/)?uploads/([^\\\"'>]+)([\\\"']?)",
                "$1" + uploadsUrl + "$2$3");

        // --------------------------------------------------------
        // 2.3 Insert signature images into the HTML (same logic as the web view)
        // --------------------------------------------------------
        // Services needed
        RoleService rService = new RoleService();
        UserService uService = new UserService();
        List<Signature> sigList = sService.getSignaturesByContractId(contractId);
        for (Signature sig : sigList) {
            if (sig == null || sig.getFileName() == null) {
                continue;
            }
            // Determine if signer is Customer or Manager to choose placeholder
            boolean isCustomerSigner = rService.getRoleIdByName("Customer")
                    == uService.getUserById(sig.getSignerUserId()).getRoleId();
            String imgTag = "<img src='" + uploadsUrl + sig.getFileName() + "'"
                    + " style='width:auto;height:80px;max-width:100%;object-fit:contain;'/> <br>";
            if (isCustomerSigner) {
                html = html.replace("<div style=\"height: 100px;\" id=\"buyer\"></div>", imgTag);
            } else {
                html = html.replace("<div style=\"height: 100px;\" id=\"seller\"></div>", imgTag);
            }
        }
        // --------------------------------------------------------
        // 3. Chuẩn hóa XHTML cho openhtmltopdf
        String xhtml = html.replaceAll("<(br|hr|img|input|meta|link)([^>]*?)(?<!/)>", "<$1$2/>");


        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();

        try {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            // --- FIX FONT: Dùng font Times New Roman (hỗ trợ tiếng Việt) ---
            try {
                String[] fontPaths = {
                    "assets/fonts/times.ttf", // Relative to web root (runtime)
                    "d:/Desktop/swp_project/SWP_Group3/web/assets/fonts/times.ttf" // Absolute (IDE)
                };
                for (String path : fontPaths) {
                    File fontFile = new File(path);
                    if (fontFile.exists()) {
                        builder.useFont(fontFile, "Times New Roman");
                        break;
                    }
                }
            } catch (Exception fontEx) {
                // ignore, will use default font
            }
            // Fix base URI to be a proper HTTP URL for openhtmltopdf
            String baseUri = "http://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
            System.out.println("Base URI for PDF: " + baseUri);
            builder.withHtmlContent(xhtml, baseUri);

            builder.toStream(baos);
            System.out.println("Starting builder.run()...");
            builder.run();
            System.out.println("builder.run() completed successfully.");
        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("LỖI KHI TẠO PDF:\n\n");
            e.printStackTrace(response.getWriter());
            return;
        }

        // 5. Trả PDF về trình duyệt
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"Contract_" + contract.getContractNumber() + ".pdf\"");
        response.setContentLength(baos.size());

        try (OutputStream os = response.getOutputStream()) {
            baos.writeTo(os);
            os.flush();
        }
    }
}

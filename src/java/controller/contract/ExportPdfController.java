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
import java.io.ByteArrayOutputStream;

@WebServlet(name = "ExportPdfController", urlPatterns = {"/export-pdf"})
public class ExportPdfController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final SignatureService sService = new SignatureService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null) {
            System.out.println("Missing id parameter");
            return;
        }

        int contractId = 0;
        try {
            contractId = Integer.parseInt(idParam);
        } catch (Exception e) {
            System.out.println("Invalid id");
            return;
        }

        Contract contract = contractDAO.getContractById(contractId);
        if (contract == null) {
            System.out.println("Contract not found");
            return;
        }

        String rawContent = contract.getContractContent() != null ? contract.getContractContent() : "";

        // 2. Convert custom image src to real URL for signature images
        String uploadDir = getServletContext().getRealPath("/uploads/");
        // Ensure path ends with separator
        if (!uploadDir.endsWith(File.separator)) {
            uploadDir += File.separator;
        }
        String uploadsUrl = new File(uploadDir).toURI().toString();
        String html = rawContent.replaceAll("(src=[\"']?)(?:File\\?name=|(?:.*/)?uploads/)([^\"'>]+)([\"']?)", "$1" + uploadsUrl + "$2$3");

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

        String xhtml = html.replaceAll("<(br|hr|img|input|meta|link)([^>]*?)(?<!/)>", "<$1$2/>");
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfRendererBuilder builder = new PdfRendererBuilder();

            File fontFile = new File(getServletContext().getRealPath("/assets/fonts/times.ttf"));
//            System.out.println("check path"+getServletContext().getRealPath("/assets/fonts/times.ttf"));
            if (fontFile.exists()) {
                builder.useFont(fontFile, "Times New Roman");
            }

            String baseUri = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

            builder.withHtmlContent(xhtml, baseUri)
                    .toStream(baos)
                    .run();

        } catch (Exception e) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("LỖI KHI TẠO PDF:\n");
            e.printStackTrace(response.getWriter());
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

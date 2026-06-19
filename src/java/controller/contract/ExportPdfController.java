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
import java.io.OutputStream;

@WebServlet(name = "ExportPdfController", urlPatterns = {"/export-pdf"})
public class ExportPdfController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

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
        } catch(Exception e) {
            response.getWriter().write("Invalid id");
            return;
        }
        
        Contract contract = contractDAO.getContractById(contractId);
        if(contract == null) {
            response.getWriter().write("Contract not found");
            return;
        }

        // Dữ liệu từ DB hoàn toàn chuẩn!
        String rawContent = contract.getContractContent() != null ? contract.getContractContent() : "";

        // 2. Build HTML với CSS ép Times New Roman bằng !important
        String html = "<html><head><meta charset=\"UTF-8\"/>"
                + "<style>* { font-family: 'Times New Roman', Times, serif !important; } body { line-height: 1.6; }</style>"
                + "</head><body>"
                + "<div>" + rawContent + "</div>"
                + "</body></html>";
        
        // 3. Chuẩn hóa XHTML cho openhtmltopdf
        String xhtml = html.replaceAll("<(br|hr|img|input|meta|link)([^>]*?)(?<!/)>", "<$1$2/>");

        java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();

        try {
            PdfRendererBuilder builder = new PdfRendererBuilder();
            // --- FIX FONT: Dùng font Times New Roman (hỗ trợ tiếng Việt) ---
            try {
                String[] fontPaths = {
                    "assets/fonts/times.ttf",  // Relative to web root (runtime)
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
            builder.withHtmlContent(xhtml, "/");
            
            builder.toStream(baos);
            builder.run();
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

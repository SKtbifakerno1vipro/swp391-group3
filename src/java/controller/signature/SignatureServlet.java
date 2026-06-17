package controller.signature;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import service.SignatureService;
import dal.SignatureDAO;
import dto.CustomerDTO;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Base64;
import java.util.List;
import model.Signature;
import service.CustomerService;
import service.SignatureService;

/**
 *
 * @author ADMIN
 */
@WebServlet(urlPatterns = {"/Signature"})
public class SignatureServlet extends HttpServlet {

    SignatureService sService = new SignatureService();
    CustomerService cService = new CustomerService();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Signature</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Signature at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Signature> list = sService.getAllSignature();

        String contractIdRaw = request.getParameter("contractId");
        String customerIdRaw = request.getParameter("customerId");

        try {
            if (contractIdRaw == null || customerIdRaw == null
                    || contractIdRaw.trim().isEmpty() || customerIdRaw.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu thông tin hợp đồng hoặc người ký.");
            }

            int contractId = Integer.parseInt(contractIdRaw.trim());
            int customerId = Integer.parseInt(customerIdRaw.trim());

            if (contractId <= 0 || customerId <= 0) {
                throw new IllegalArgumentException("ID phải là số nguyên dương.");
            }

            request.setAttribute("signatures", list);
            request.setAttribute("contractId", contractId);
            request.setAttribute("customer", cService.getCustomerDTOByCusId(customerId));
            request.setAttribute("customerId", customerId);
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Sai định dạng ID.");
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String signatureData = request.getParameter("signatureData");
        File projectPath = new File(getServletContext().getRealPath("/")).getParentFile().getParentFile();
        String contractIdRaw = request.getParameter("contractId");
        String customerIdRaw = request.getParameter("customerId");
        File uploadFile = new File(projectPath, "uploads");
        if (!uploadFile.exists()) {
            uploadFile.mkdir();
        }

        if (signatureData != null && !signatureData.isEmpty()) {
            try {
                int contractId = Integer.parseInt(contractIdRaw.trim());
                int customerId = Integer.parseInt(customerIdRaw.trim());

                CustomerDTO c = cService.getCustomerDTOByCusId(customerId);

                String fileName = sService.editFileName(c.getCustomer().getCompanyName());

                fileName = fileName + System.currentTimeMillis() + ".png";
                Signature s = new Signature();
                s.setCustomerContractId(contractId);
                s.setFileName(fileName);
                s.setFileUrl(fileName);
                s.setSignerUserId(c.getUser().getUserId());
                s.setSignerName(c.getCompanyName());
                s.setUploadedBy(c.getUser().getUserId());
                sService.storeSignature(signatureData, uploadFile, fileName);
                sService.insertSignature(s);
                response.sendRedirect("contract-detail?id=" + contractId);
            } catch (NumberFormatException ne) {
                request.setAttribute("error", "Sai định dạng ID");
            }
        } else {
            request.setAttribute("error", "Vui lòng ký");
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
        }

        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

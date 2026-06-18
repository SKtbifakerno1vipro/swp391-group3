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
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Base64;
import java.util.List;
import model.Signature;
import model.User;
import service.CustomerService;
import service.RoleService;
import service.SignatureService;

/**
 *
 * @author ADMIN
 */
@WebServlet(urlPatterns = {"/Signature"})
public class SignatureServlet extends HttpServlet {
    
    private final SignatureService sService = new SignatureService();
    private final CustomerService cService = new CustomerService();
    private final RoleService rService = new RoleService();
    
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
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }
        String signerName = "";
        String contractIdRaw = request.getParameter("contractId");
        String signerIdRaw = request.getParameter("signerId");
        String error = null;
        try {
            if (contractIdRaw == null || signerIdRaw == null
                    || contractIdRaw.trim().isEmpty() || signerIdRaw.trim().isEmpty()) {
                throw new IllegalArgumentException("Thiếu thông tin hợp đồng hoặc người ký.");
            }
            
            int contractId = Integer.parseInt(contractIdRaw.trim());
            int signerId = Integer.parseInt(signerIdRaw.trim());
            
            if (contractId <= 0 || signerId <= 0) {
                throw new IllegalArgumentException("ID phải là số nguyên dương.");
            }
            boolean isCustomer = (user.getRoleId() == rService.getRoleIdByName("Customer"));
            boolean isManager = (user.getRoleId() == rService.getRoleIdByName("Manager"));
            if (isCustomer) {
                signerName = cService.getCustomerDTOByUserId(signerId).getCustomer().getCompanyName();
            } else if (isManager) {
                signerName = user.getFullName();
            }
            
            
        } catch (NumberFormatException e) {
            error = "Sai định dạng ID";
        } catch (IllegalArgumentException e) {
            error = e.getMessage();
        }
        if(error == null){
            request.setAttribute("contractId", contractIdRaw);
            request.setAttribute("signerId", signerIdRaw);
            request.setAttribute("signerName", signerName);
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
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
        String signerIdRaw = request.getParameter("signerId");
        File uploadFile = new File(projectPath, "uploads");
        if (!uploadFile.exists()) {
            uploadFile.mkdir();
        }
        
        if (signatureData != null && !signatureData.isEmpty()) {
            try {
                int contractId = Integer.parseInt(contractIdRaw.trim());
                int sigerId = Integer.parseInt(signerIdRaw.trim());
                
                CustomerDTO c = cService.getCustomerDTOByUserId(sigerId);
                
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

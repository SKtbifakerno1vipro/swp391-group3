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
import model.Contract;
import model.Signature;
import model.User;
import service.ContractService;
import service.CustomerService;
import service.RoleService;
import service.SignatureService;
import service.UserService;

/**
 *
 * @author ADMIN
 */
@WebServlet(urlPatterns = {"/Signature"})
public class SignatureServlet extends HttpServlet {

    private final SignatureService sService = new SignatureService();
    private final CustomerService cService = new CustomerService();
    private final RoleService rService = new RoleService();
    private final ContractService ctrService = new ContractService();
    private final UserService uService = new UserService();

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
            response.sendRedirect("login");
            return;
        }

        String contractIdRaw = request.getParameter("contractId");
        String signerIdRaw = request.getParameter("signerId");

        try {
            if (contractIdRaw == null || signerIdRaw == null
                    || contractIdRaw.trim().isEmpty() || signerIdRaw.trim().isEmpty()) {
                throw new IllegalArgumentException();
            }

            int contractId = Integer.parseInt(contractIdRaw.trim());
            int signerId = Integer.parseInt(signerIdRaw.trim());

            if (contractId <= 0 || signerId <= 0) {
                throw new IllegalArgumentException();
            }

            String signerName = "";
            boolean isCustomer = (user.getRoleId() == rService.getRoleIdByName("Customer"));
            boolean isManager = (user.getRoleId() == rService.getRoleIdByName("Manager"));

            if (isManager) {
                signerName = user.getFullName();
            } else if (isCustomer) {
                CustomerDTO c = cService.getCustomerDTOByUserId(signerId);
                if (c != null) {
                    signerName = c.getCustomer().getCompanyName();
                }
            }

            if (signerName.isEmpty()) {
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            
            request.setAttribute("contractId", contractId);
            request.setAttribute("signerId", signerId);
            request.setAttribute("signerName", signerName);
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Mọi lỗi đều redirect về detail không kèm thông báo
            response.sendRedirect("contract-detail?id=" + contractIdRaw);
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        boolean customerSigned = false;
        boolean managerSigned = false;
        String signatureData = request.getParameter("signatureData");
        String contractIdRaw = request.getParameter("contractId");
        String signerIdRaw = request.getParameter("signerId");
        
        if (signatureData == null || signatureData.isEmpty()) {
            request.setAttribute("error", "Vui lòng ký tên trước khi xác nhận.");
            request.setAttribute("contractId", contractIdRaw);
            request.setAttribute("signerId", signerIdRaw);
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
            return;
        }
        try {
            int contractId = Integer.parseInt(contractIdRaw.trim());
            int signerId = Integer.parseInt(signerIdRaw.trim());

            if (contractId <= 0 || signerId <= 0) {
                throw new IllegalArgumentException("ID phải là số nguyên dương.");
            }
            Contract ctr = ctrService.getContractById(contractId);
            if (ctr == null) {
                response.sendRedirect("contract-list");
                return;
            }
            
            File projectPath = new File(getServletContext().getRealPath("/")).getParentFile().getParentFile();
            File uploadFile = new File(projectPath, "uploads");
            if (!uploadFile.exists()) {
                uploadFile.mkdir();
            }

            Signature s = new Signature();
            s.setCustomerContractId(contractId);
            s.setUploadedBy(user.getUserId());

            String fileName = "";
            boolean isCustomer = (user.getRoleId() == rService.getRoleIdByName("Customer"));
            boolean isManager = (user.getRoleId() == rService.getRoleIdByName("Manager"));

            if (isCustomer) {
                CustomerDTO c = cService.getCustomerDTOByUserId(signerId);
                if (c == null || user.getUserId() != c.getUser().getUserId()) {
                    throw new IllegalArgumentException("Bạn không có quyền ký thay khách hàng này.");
                }
                fileName = c.getCustomer().getCompanyName() + "_" + ctr.getContractNumber();
                s.setSignerUserId(c.getUser().getUserId());
                s.setSignerName(c.getCustomer().getCompanyName());

            } else if (isManager) {
                fileName = "Manager_" + user.getFullName() + "_" + ctr.getContractNumber();
                s.setSignerUserId(user.getUserId());
                s.setSignerName(user.getFullName());
            } else {
                throw new IllegalArgumentException("Bạn không có quyền thực hiện ký tên.");
            }

            fileName = sService.standardFileName(fileName) + "_" + System.currentTimeMillis() + ".png";

            s.setFileName(fileName);
            s.setFileUrl(fileName);

            sService.storeSignature(signatureData, uploadFile, fileName);
            sService.insertSignature(s);
            List<Signature> sigList = sService.getSignaturesByContractId(contractId);
            for (Signature signature : sigList) {
                if (signature.getSignerUserId() != null) {
                    User signer = uService.getUserById(signature.getSignerUserId());
                    if (signer.getRoleId() == rService.getRoleIdByName("Manager")) {
                        managerSigned = true;
                    } else if (signer.getRoleId() == rService.getRoleIdByName("Customer")) {
                        customerSigned = true;
                    }
                }
            }
            if (managerSigned && customerSigned) {
                ctrService.updateStatus(contractId, "SIGNED");
            }
            response.sendRedirect("contract-detail?id=" + contractId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Sai định dạng ID.");
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình xử lý.");
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

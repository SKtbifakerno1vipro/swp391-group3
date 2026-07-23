package controller.signature;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import dto.CustomerDTO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.util.List;
import model.Contract;
import model.ContractHistory;
import model.Signature;
import model.User;
import service.PaymentService;
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
    private final PaymentService paymentService = new PaymentService();

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
        int contractId = -1;

        try {
            if (contractIdRaw == null || signerIdRaw == null
                    || contractIdRaw.trim().isEmpty() || signerIdRaw.trim().isEmpty()) {
                session.setAttribute("errorSig", "Không tìm thấy Contract ID hoặc Signer ID");
                response.sendRedirect("contract-list");
                return;
            }

            contractId = Integer.parseInt(contractIdRaw.trim());
            int signerId = Integer.parseInt(signerIdRaw.trim());

            if (contractId <= 0 || signerId <= 0) {
                session.setAttribute("errorSig", "ID phải khác 0");
                response.sendRedirect("contract-list");
                return;
            }
            Contract ctr = ctrService.getContractById(contractId);
            if (ctr == null || uService.getUserById(signerId) == null) {
                session.setAttribute("errorSig", "Không tìm thấy Contract hoặc Signer");
                response.sendRedirect("contract-list");
                return;
            }

            if ("SIGNED".equalsIgnoreCase(ctr.getContractStatus()) || "CANCELLED".equalsIgnoreCase(ctr.getContractStatus())) {
                session.setAttribute("errorSig", "Hợp đồng đã hoàn tất ký hoặc bị hủy, không thể thực hiện ký.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            Signature sigUser = sService.getSignatureByContractIdAndSignerId(contractId, user.getUserId());
            if (sigUser != null) {
                session.setAttribute("errorSig", "Bạn đã ký hợp đồng này rồi, vui lòng không ký lại.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            int managerRoleId = rService.getRoleIdByName("Manager");
            int customerRoleId = rService.getRoleIdByName("Customer");
            List<Signature> existingSigs = sService.getSignaturesByContractId(contractId);
            boolean managerSignedBefore = false;
            boolean customerSignedBefore = false;

            if (existingSigs != null) {
                for (Signature sig : existingSigs) {
                    if (sig != null && sig.getSignerUserId() != null) {
                        User signer = uService.getUserById(sig.getSignerUserId());
                        if (signer != null) {
                            if (signer.getRoleId() == managerRoleId) {
                                managerSignedBefore = true;
                            } else if (signer.getRoleId() == customerRoleId) {
                                customerSignedBefore = true;
                            }
                        }
                    }
                }
            }

            if (user.getRoleId() == managerRoleId && managerSignedBefore) {
                session.setAttribute("errorSig", "Hợp đồng này đã được Quản lý ký trước đó rồi.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            if (user.getRoleId() == customerRoleId && customerSignedBefore) {
                session.setAttribute("errorSig", "Hợp đồng này đã được Khách hàng ký trước đó rồi.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            String signerName = "";
            boolean isCustomer = (user.getRoleId() == customerRoleId);
            boolean isManager = (user.getRoleId() == managerRoleId);

            if (isManager) {
                signerName = user.getFullName();
            } else if (isCustomer) {
                CustomerDTO c = cService.getCustomerDTOByUserId(signerId);
                if (c == null || user.getUserId() != c.getUser().getUserId() || ctr.getCustomerId() != c.getCustomer().getCustomerId()) {
                    session.setAttribute("errorSig", "Bạn không có quyền ký thay khách hàng này.");
                    response.sendRedirect("contract-list");
                    return;
                }
                signerName = c.getCustomer().getCompanyName();
            } else {
                session.setAttribute("errorSig", "Bạn không được thao tác với hợp đồng này");
                response.sendRedirect("contract-list");
                return;
            }

            request.setAttribute("contractId", contractId);
            request.setAttribute("signerId", signerId);
            request.setAttribute("signerName", signerName);
            request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorSig", "Sai định dạng ID");
            response.sendRedirect("contract-list");
        } catch (Exception e) {
            session.setAttribute("errorSig", "Có lỗi xảy ra trong quá trình xử lý.");
            if (contractId > 0) {
                response.sendRedirect("contract-detail?id=" + contractId);
            } else {
                response.sendRedirect("contract-list");
            }
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
        String errorSig = null;
        if (signatureData == null || signatureData.isEmpty()) {
            errorSig = "Chữ ký không hợp lệ.";
        }

        int contractId = -1;
        int signerId = -1;
        String signerName = "";

        try {
            if (contractIdRaw == null || signerIdRaw == null
                    || contractIdRaw.trim().isEmpty() || signerIdRaw.trim().isEmpty()) {
                throw new IllegalArgumentException("Không tìm thấy Contract ID hoặc Signer ID");
            }

            contractId = Integer.parseInt(contractIdRaw.trim());
            signerId = Integer.parseInt(signerIdRaw.trim());
            
            if (contractId <= 0 || signerId <= 0) {
                throw new IllegalArgumentException("ID phải là số nguyên dương.");
            }
            Contract ctr = ctrService.getContractById(contractId);
            if (ctr == null) {
                response.sendRedirect("contract-list");
                return;
            }

            int managerRoleId = rService.getRoleIdByName("Manager");
            int customerRoleId = rService.getRoleIdByName("Customer");
            boolean isCustomer = (user.getRoleId() == customerRoleId);
            boolean isManager = (user.getRoleId() == managerRoleId);

            if (isManager) {
                signerName = user.getFullName();
            } else if (isCustomer) {
                CustomerDTO c = cService.getCustomerDTOByUserId(signerId);
                if (c != null) {
                    signerName = c.getCustomer().getCompanyName();
                }
            }

            if (errorSig != null) {
                session.setAttribute("errorSig", errorSig);
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            if ("SIGNED".equalsIgnoreCase(ctr.getContractStatus()) || "CANCELLED".equalsIgnoreCase(ctr.getContractStatus())) {
                session.setAttribute("errorSig", "Hợp đồng đã hoàn tất ký hoặc bị hủy, không thể ký thêm.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            Signature sigUser = sService.getSignatureByContractIdAndSignerId(contractId, user.getUserId());
            if (sigUser != null) {
                session.setAttribute("errorSig", "Bạn đã ký hợp đồng này rồi, vui lòng không ký lại.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            List<Signature> checkSigList = sService.getSignaturesByContractId(contractId);
            if (checkSigList != null) {
                for (Signature sig : checkSigList) {
                    if (sig != null && sig.getSignerUserId() != null) {
                        User signer = uService.getUserById(sig.getSignerUserId());
                        if (signer != null) {
                            if (user.getRoleId() == managerRoleId && signer.getRoleId() == managerRoleId) {
                                session.setAttribute("errorSig", "Hợp đồng này đã được Quản lý (Manager) ký rồi, không thể ký thêm.");
                                response.sendRedirect("contract-detail?id=" + contractId);
                                return;
                            }
                            if (user.getRoleId() == customerRoleId && signer.getRoleId() == customerRoleId) {
                                session.setAttribute("errorSig", "Hợp đồng này đã được Khách hàng ký rồi, không thể ký thêm.");
                                response.sendRedirect("contract-detail?id=" + contractId);
                                return;
                            }
                        }
                    }
                }
            }

            String uploadBuild = getServletContext().getRealPath("/uploads");
            File uploadBuildFile = new File(uploadBuild);
            if (!uploadBuildFile.exists()) {
                uploadBuildFile.mkdirs();
            }

            File webFile = new File(new File(getServletContext().getRealPath("/")).getParentFile().getParentFile(), "web");

            File uploadWebFile = new File(webFile, "uploads");
            if (!uploadWebFile.exists()) {
                uploadWebFile.mkdirs();
            }

            Signature s = new Signature();
            s.setCustomerContractId(contractId);
            s.setUploadedBy(user.getUserId());

            String fileName = "";

            if (isCustomer) {
                CustomerDTO c = cService.getCustomerDTOByUserId(signerId);
                if (c == null || user.getUserId() != c.getUser().getUserId() || ctr.getCustomerId() != c.getCustomer().getCustomerId()) {
                    throw new IllegalArgumentException("Bạn không có quyền ký thay khách hàng này.");
                }
                fileName = c.getCustomer().getCompanyName() + "_" + ctr.getContractNumber();
                s.setSignerUserId(c.getUser().getUserId());
                s.setSignerName(c.getCustomer().getCompanyName());

            } else if (isManager) {
                fileName = "Manager_" + user.getFullName() + "_" + ctr.getContractNumber();
                s.setSignerUserId(user.getUserId());
                s.setSignerName(user.getFullName());
            }

            fileName = sService.standardFileName(fileName) + "_" + System.currentTimeMillis() + ".png";

            String resWeb = sService.storeSignature(signatureData, uploadWebFile, fileName);
            if (!"SUCCESS".equals(resWeb)) {
                throw new IllegalArgumentException(resWeb);
            }
            String resBuild = sService.storeSignature(signatureData, uploadBuildFile, fileName);
            if (!"SUCCESS".equals(resBuild)) {
                throw new IllegalArgumentException(resBuild);
            }
            s.setFileName(fileName);
            s.setFileUrl(fileName);

            if (!sService.insertSignature(s)) {
                throw new IllegalArgumentException("Không thể lưu thông tin chữ ký vào cơ sở dữ liệu. Vui lòng thử lại.");
            }

            List<Signature> sigList = sService.getSignaturesByContractId(contractId);
            for (Signature signature : sigList) {
                if (signature != null && signature.getSignerUserId() != null) {
                    User signer = uService.getUserById(signature.getSignerUserId());
                    if (signer != null) {
                        if (signer.getRoleId() == managerRoleId) {
                            managerSigned = true;
                        } else if (signer.getRoleId() == customerRoleId) {
                            customerSigned = true;
                        }
                    }
                }
            }
            if (managerSigned && customerSigned) {
                ctrService.updateStatus(contractId, "SIGNED");

                //when customer and manager signed then insert to history, for notification
                ContractHistory history = new ContractHistory();
                history.setContractId(contractId);
                history.setFromStatus("APPROVED");
                history.setToStatus("SIGNED");
                history.setNote("Cả 2 bên đã ký hoàn tất");
                User currentUser = (User) request.getSession().getAttribute("user");
                history.setChangedBy(currentUser != null ? currentUser.getUserId() : 0);

                ctrService.insertHistory(history);
            }
            response.sendRedirect("contract-detail?id=" + contractId);

        } catch (NumberFormatException e) {
            if (contractId > 0 && signerId > 0) {
                request.setAttribute("errorSig", "Sai định dạng ID.");
                request.setAttribute("contractId", contractId);
                request.setAttribute("signerId", signerId);
                request.setAttribute("signerName", signerName);
                request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
            } else {
                session.setAttribute("errorSig", "Sai định dạng ID.");
                response.sendRedirect("contract-list");
            }
        } catch (IllegalArgumentException e) {
            if (contractId > 0 && signerId > 0) {
                request.setAttribute("errorSig", e.getMessage());
                request.setAttribute("contractId", contractId);
                request.setAttribute("signerId", signerId);
                request.setAttribute("signerName", signerName);
                request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
            } else {
                session.setAttribute("errorSig", e.getMessage());
                response.sendRedirect("contract-list");
            }
        } catch (Exception e) {
            if (contractId > 0 && signerId > 0) {
                request.setAttribute("errorSig", "Có lỗi xảy ra trong quá trình xử lý.");
                request.setAttribute("contractId", contractId);
                request.setAttribute("signerId", signerId);
                request.setAttribute("signerName", signerName);
                request.getRequestDispatcher("/views/signature/signature.jsp").forward(request, response);
            } else {
                session.setAttribute("errorSig", "Có lỗi xảy ra trong quá trình xử lý.");
                response.sendRedirect("contract-list");
            }
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

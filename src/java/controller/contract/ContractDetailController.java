package controller.contract;

import model.*;
import model.ContractHistory;
import model.ContractRevisionItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import service.ContractService;
import service.RoleService;
import service.SignatureService;
import service.UserService;

@WebServlet("/contract-detail")
public class ContractDetailController extends HttpServlet {
    
    private ContractService contractService = new ContractService();
    private SignatureService sService = new SignatureService();
    private UserService uService = new UserService();
    private RoleService rService = new RoleService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String token = request.getParameter("token");
        String contractIdRaw = request.getParameter("id");
        
        boolean isGuest = false;
        
        if (user == null) {
            // if user is guest and click to the link url send from email
            if (token != null && contractIdRaw != null) {
                try {
                    int contractid = Integer.parseInt(contractIdRaw);
                    if (contractService.validateToken(contractid, token)) {
                        isGuest = true;
                    } else {
                        response.sendRedirect("login");
                        return;
                    }
                } catch (Exception e) {
                    response.sendRedirect("login");
                    return;
                }
            } else { // if not link from email
                response.sendRedirect("login");
                return;
            }
        }
        request.setAttribute("isGuest", isGuest);
        
        if ((String) session.getAttribute("errorSig") != null) {
            request.setAttribute("errorSig", (String) session.getAttribute("errorSig"));
            session.removeAttribute("errorSig");
        }
        
        String idStr = request.getParameter("id");
        String quotationIdStr = request.getParameter("quotationId"); //quotation take from quotatuion detail
        boolean existSignature = false;
        
        if ((idStr != null && !idStr.isEmpty()) || (quotationIdStr != null && !quotationIdStr.isEmpty())) {
            try {
                
                Contract contract = quotationIdStr != null
                        ? contractService.getContractByQuotationId(Integer.parseInt(quotationIdStr))
                        : contractService.getContractById(Integer.parseInt(idStr));

                //check contract exist?
                if (contract != null) {
                    int contractId = contract.getContractId();
                    int userId = (user != null) ? user.getUserId() : 0;
                    int roleId = (user != null) ? user.getRoleId() : 0;
                    List<ContractHistory> historyList = contractService.getHistoriesByContractId(contractId, userId, roleId);

                    //nguyenkien - begin
                    String finalHtml = (contract.getContractContent() != null) ? contract.getContractContent() : "Not have any contract";
                    String status = contract.getContractStatus();
                    boolean isApproved = "APPROVED".equals(status);
                    boolean isSigned = "SIGNED".equals(status);
                    if (isApproved || isSigned) {
                        // Replace custom image src with web-accessible URL
                        String uploadsUrl = request.getContextPath() + "/uploads/";
                        finalHtml = finalHtml.replaceAll("(src=[\\\"']?)File\\?name=([^\\\"'>]+)([\\\"']?)",
                                "$1" + uploadsUrl + "$2$3");
                        Signature existSign = null;
                        if (user != null) {
                            existSign = sService.getSignatureByContractIdAndSignerId(contractId, user.getUserId());
                        }
                        existSignature = (existSign != null);
                        request.setAttribute("signed", existSignature);
                        List<Signature> sigList = sService.getSignaturesByContractId(contractId);
                        for (Signature sig : sigList) {
                            if (sig == null || sig.getSignerUserId() == null) {
                                continue;
                            }
                            boolean isCustomerSigner = rService.getRoleIdByName("Customer")
                                    == uService.getUserById(sig.getSignerUserId()).getRoleId();
                            
                            String imgTag = "<div style=\"height: 100px;\">"
                                    + "<img src='" + uploadsUrl + sig.getFileName() + "' style='width: auto; height:80px; max-width: 100%; object-fit: contain;'/>"
                                    + "</div>";
                            
                            if (isCustomerSigner) {
                                finalHtml = finalHtml.replace("<div style=\"height: 100px;\" id=\"buyer\"></div>", imgTag);
                            } else {
                                finalHtml = finalHtml.replace("<div style=\"height: 100px;\" id=\"seller\"></div>", imgTag);
                            }
                        }
                    }
                    
                    contract.setContractContent(finalHtml);
                    //nguyen kien - end

                    request.setAttribute("contract", contract);
                    request.setAttribute("historyList", historyList);

                    // Set status manager or customer can request edit
                    boolean isInternalProcessing = "DRAFT".equals(status)
                            || "PENDING_REVIEW".equals(status);
                    boolean canCustomerCheck = "CUSTOMER_CHECK".equals(status);
                    request.setAttribute("isInternalProcessing", isInternalProcessing);
                    request.setAttribute("canCustomerCheck", canCustomerCheck);
                    request.setAttribute("isApproved", isApproved);
                    
                    request.getRequestDispatcher("views/contract/detail.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect("contract-list");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("contract-list");
            }
        } else {
            response.sendRedirect("contract-list");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        //user not login then return to login page
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        int contractId = Integer.parseInt(request.getParameter("contractId"));

        // take contract with the id
        Contract contract = contractService.getContractById(contractId);
        if (contract == null) {
            response.sendRedirect("contract-list");
            return;
        }

        //solve all of action request edit
        if ("request_edit".equals(action)) {// when manager and customer request edit 
            // BR : only PENDING_REVIEW or CUSTOMER_CHECK status  can request edit
            String currentStatus = contract.getContractStatus();
            if (!"PENDING_REVIEW".equals(currentStatus) && !"CUSTOMER_CHECK".equals(currentStatus)) {
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            
            String note = request.getParameter("revision_note");

            // save work history  for customer or manager request edit
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(currentStatus);
            h.setToStatus("PENDING_REVIEW");
            h.setNote("Customer/Manager yêu cầu officer sửa đổi lại hợp đồng.");
            h.setChangedBy(user.getUserId());
            int historyId = contractService.insertHistory(h);

            //if manager or customer request edit then must insert revision item
            if (note != null && !note.trim().isEmpty() && historyId > 0) {
                ContractRevisionItem item = new ContractRevisionItem();
                item.setHistoryId(historyId);
                item.setContractId(contractId);
                item.setRevisionType("");
                item.setRevisionDetail(note);
                contractService.insertRevisionItem(item);
            }

            // update status of contract
            contractService.updateStatus(contractId, "PENDING_REVIEW");
            response.sendRedirect("contract-detail?id=" + contractId);
            
        } else if ("approve".equals(action)) { //when manager approve that contract
            // only PENDING_REVIEW status  can approve by Manager
            if (!"PENDING_REVIEW".equals(contract.getContractStatus())) {
                session.setAttribute("errorSig", "Cần được officer kiểm tra và sửa đổi trước.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            // Manager Approve then will give to customer check
            contractService.updateStatus(contractId, "CUSTOMER_CHECK");
            contractService.refreshContractToken(contractId); // Gen new token + 30m expire
            contractService.noticeCustomerCheckContract(contractId);

            // Save history work for manager approve contract
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("CUSTOMER_CHECK");
            h.setNote("Manager vừa phê duyệt hợp đồng. Đang chờ customer kiểm tra hợp đồng.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);
            
            response.sendRedirect("contract-detail?id=" + contractId);
            
        } else if ("customer_approve".equals(action)) { // if customer approve contract
            // only CUSTOMER_CHECK can be approve by Customer
            if (!"CUSTOMER_CHECK".equals(contract.getContractStatus())) {
                session.setAttribute("errorSig", "Hợp đồng phải ở trạng thái Chờ khách hàng duyệt trước khi Khách hàng có thể chốt.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            // When customer approve, contract status will change to APPROVED
            contractService.updateStatus(contractId, "APPROVED");

            // Save history work for customer approve contract
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("APPROVED");
            h.setNote("Customer approved the contract.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);
            
            response.sendRedirect("contract-detail?id=" + contractId);
            
        } else if ("send_to_manager".equals(action)) { //if officier send to manager
            // BR: only DRAFT or PENDING_REVIEW can be sent to Manager
            String curStatus = contract.getContractStatus();
            if (!"DRAFT".equals(curStatus) && !"PENDING_REVIEW".equals(curStatus)) {
                session.setAttribute("errorSig",
                        "Hợp đồng phải ở trạng thái Nháp hoặc Chờ duyệt trước khi gửi cho Quản lý.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            
            contractService.updateStatus(contractId, "PENDING_REVIEW");

            // save work history for officer want manager check contract
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_REVIEW");
            h.setNote("Nhân viên hành chính vừa chỉnh sửa hợp đồng. Quản lý cần kiểm tra hợp đồng.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);
            
            response.sendRedirect("contract-detail?id=" + contractId);
            
        } else if ("send_final_contract".equals(action)) {// send customer final contract for storage their contract
            if (!"SIGNED".equals(contract.getContractStatus())) {
                session.setAttribute("errorSig", "Hợp đồng chưa được ký hoàn tất.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            String token = contractService.refreshContractToken(contractId); // refresh token when send to customer
            contractService.noticeSendFinalContractPdf(contractId, token);
            
            response.sendRedirect("contract-detail?id=" + contractId);
            
        } else {
            // Action not defined
            response.sendRedirect("contract-detail?id=" + contractId);
        }
    }
}

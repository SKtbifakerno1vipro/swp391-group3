package controller.contract;

import dal.ContractDAO;
import dto.CustomerDTO;
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
import service.CustomerService;
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
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        if ((String) session.getAttribute("errorSig") != null) {
            request.setAttribute("errorSig", (String) session.getAttribute("errorSig"));
            session.removeAttribute("errorSig");
        }

        String idStr = request.getParameter("id");
        boolean existSignature = false;
        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Contract contract = contractService.getContractById(id);

                //check contract exist?
                if (contract != null) {
                    List<ContractHistory> historyList = contractService.getHistoriesByContractId(id);

//nguyenkien - begin
                    String finalHtml = contract.getContractContent();
                    String status = contract.getContractStatus();
                    boolean isApproved = "APPROVED".equals(status);
                    boolean isSigned = "SIGNED".equals(status);
                    if (isApproved || isSigned) {
                        // Replace custom image src with web-accessible URL
                        String uploadsUrl = request.getContextPath() + "/uploads/";
                        finalHtml = finalHtml.replaceAll("(src=[\\\"']?)File\\?name=([^\\\"'>]+)([\\\"']?)",
                                "$1" + uploadsUrl + "$2$3");
                        Signature existSign = sService.getSignatureByContractIdAndSignerId(id, user.getUserId());
                        existSignature = (existSign != null);
                        request.setAttribute("signed", existSignature);
                        List<Signature> sigList = sService.getSignaturesByContractId(id);
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

                    // Set the status of contract 
                    boolean canRequestEdit = "DRAFT".equals(status)
                            || "PENDING_REVIEW".equals(status);
                    boolean canCustomerCheck = "CUSTOMER_CHECK".equals(status);
                    request.setAttribute("canRequestEdit", canRequestEdit);
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

            // create history  with PENDING_REVIEW
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(currentStatus);
            h.setToStatus("PENDING_REVIEW");
            h.setChangedBy(user.getUserId());
            int historyId = contractService.insertHistory(h);

            //if have the content request edit then create revision history
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
            // BR: only PENDING_REVIEW status + approved by Manager
            if (!"PENDING_REVIEW".equals(contract.getContractStatus())) {
                session.setAttribute("errorSig", "Manager could be Admin officier check first");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            // Manager Approve then will give to customer check
            contractService.updateStatus(contractId, "CUSTOMER_CHECK");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("CUSTOMER_CHECK");
            h.setNote("Manager đã phê duyệt hợp đồng. Chờ khách hàng kiểm tra.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);

            response.sendRedirect("contract-detail?id=" + contractId);

        } else if ("customer_approve".equals(action)) {
            // BR: only CUSTOMER_CHECK can be approved by Customer
            if (!"CUSTOMER_CHECK".equals(contract.getContractStatus())) {
                session.setAttribute("errorSig", "Contract must be in CUSTOMER_CHECK status before Customer can approve.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }
            // Khách hàng đồng ý: Chuyển trạng thái sang APPROVED
            contractService.updateStatus(contractId, "APPROVED");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("APPROVED");
            h.setNote("Khách hàng đã đồng ý với các điều khoản hợp đồng.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);

            response.sendRedirect("contract-detail?id=" + contractId);

        } else if ("send_to_manager".equals(action)) {
            // BR: only DRAFT or PENDING_REVIEW can be sent to Manager
            String curStatus = contract.getContractStatus();
            if (!"DRAFT".equals(curStatus) && !"PENDING_REVIEW".equals(curStatus)) {
                session.setAttribute("errorSig",
                        "Contract must be in DRAFT or PENDING_REVIEW status before sending to Manager.");
                response.sendRedirect("contract-detail?id=" + contractId);
                return;
            }

            // Cập nhật status
            contractService.updateStatus(contractId, "PENDING_REVIEW");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_REVIEW");
            h.setNote("Admin Officer đã chỉnh sửa và gửi lại cho Manager.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);

            response.sendRedirect("contract-detail?id=" + contractId);

        } else {
            // Action không xác định
            response.sendRedirect("contract-detail?id=" + contractId);
        }
    }
}

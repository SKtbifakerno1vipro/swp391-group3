

package utils;

public class NewClass {
//// ... trong doPost, ngay **trước** khối else cuối cùng
//} else if ("reject".equals(action)) {
//    // ① Kiểm tra trạng thái hiện tại và vai trò
//    String curStatus = contract.getContractStatus();               // PENDING_REVIEW hoặc CUSTOMER_CHECK
//    boolean managerCan   = "PENDING_REVIEW".equals(curStatus) && user.getRoleId() == 2; // Manager
//    boolean customerCan = "CUSTOMER_CHECK".equals(curStatus) && user.getRoleId() == 3; // Customer
//
//    if (!managerCan && !customerCan) {
//        // Người dùng không được phép reject ở trạng thái này
//        session.setAttribute("errorSig",
//                "Bạn không thể từ chối hợp đồng ở trạng thái hiện tại.");
//        response.sendRedirect("contract-detail?id=" + contractId);
//        return;
//    }
//
//    // ② Lấy lý do reject (có thể rỗng)
//    String rejectNote = request.getParameter("reject_note");
//
//    // ③ Đưa hợp đồng trở lại DRAFT (hoặc nếu có trạng thái REJECTED thì đổi thành REJECTED)
//    contractService.updateStatus(contractId, "DRAFT");
//
//    // ④ Ghi lịch sử
//    ContractHistory h = new ContractHistory();
//    h.setContractId(contractId);
//    h.setFromStatus(curStatus);
//    h.setToStatus("DRAFT");
//    h.setNote(rejectNote != null && !rejectNote.trim().isEmpty()
//            ? rejectNote
//            : "Rejected by " + (managerCan ? "Manager" : "Customer"));
//    h.setChangedBy(user.getUserId());
//    int historyId = contractService.insertHistory(h);   // trả về id của history
//
//    // ⑤ Nếu có note thì lưu vào bảng revision_item (giống request_edit)
//    if (rejectNote != null && !rejectNote.trim().isEmpty() && historyId > 0) {
//        ContractRevisionItem rev = new ContractRevisionItem();
//        rev.setHistoryId(historyId);
//        rev.setContractId(contractId);
//        rev.setRevisionType("REJECT");
//        rev.setRevisionDetail(rejectNote);
//        contractService.insertRevisionItem(rev);
//    }
//
//    // ⑥ Kết thúc → quay lại trang chi tiết
//    response.sendRedirect("contract-detail?id=" + contractId);
//    return;
//}
//
//
//
//<!-- Ở sidebar, trong phần canRequestEdit (Manager) -->
//<c:if test="${sessionScope.user.roleId == 2 && contract.contractStatus == 'PENDING_REVIEW'}">
//    <!-- Manager Approve (đã có) -->
//    <form method="POST" action="contract-detail" style="margin:0;">
//        <input type="hidden" name="action" value="approve"/>
//        <input type="hidden" name="contractId" value="${contract.contractId}"/>
//        <button type="submit" class="btn btn-green">Approve</button>
//    </form>
//
//    <!-- **Manager Reject** -->
//    <form method="POST" action="contract-detail" style="margin-top:10px;">
//        <input type="hidden" name="action" value="reject"/>
//        <input type="hidden" name="contractId" value="${contract.contractId}"/>
//        <textarea name="reject_note" class="note-textarea"
//                  placeholder="Lý do từ chối…" style="margin-top:5px;"></textarea>
//        <button type="submit" class="btn btn-red">Reject</button>
//    </form>
//</c:if>
//
//<!-- Ở sidebar, trong phần canCustomerCheck (Customer) -->
//<c:if test="${sessionScope.user.roleId == 3 && contract.contractStatus == 'CUSTOMER_CHECK'}">
//    <form method="POST" action="contract-detail" style="margin:0;">
//        <input type="hidden" name="action" value="customer_approve"/>
//        <input type="hidden" name="contractId" value="${contract.contractId}"/>
//        <button type="submit" class="btn btn-green">Approve</button>
//    </form>
//
//    <!-- **Customer Reject** -->
//    <form method="POST" action="contract-detail" style="margin-top:10px;">
//        <input type="hidden" name="action" value="reject"/>
//        <input type="hidden" name="contractId" value="${contract.contractId}"/>
//        <textarea name="reject_note" class="note-textarea"
//                  placeholder="Lý do từ chối…" style="margin-top:5px;"></textarea>
//        <button type="submit" class="btn btn-red">Reject</button>
//    </form>
//</c:if>

}

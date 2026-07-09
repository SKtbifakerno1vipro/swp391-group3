<%@page contentType="text/html" pageEncoding="UTF-8" import="java.time.LocalDate"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
    String defaultSymbol = "1C" + String.format("%02d", LocalDate.now().getYear() % 100) + "TYY";
    pageContext.setAttribute("defaultSymbol", defaultSymbol);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết hóa đơn</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            /* Status section */
            .status-section {
                text-align: right;
                font-size: 13px;
                margin-bottom: 20px;
                color: var(--muted);
            }
            .status-label {
                font-weight: 800;
                color: var(--primary);
            }

            /* Title */
            .invoice-title {
                text-align: center;
                font-size: 22px;
                font-family: 'Literata', Georgia, serif;
                font-weight: 800;
                margin-bottom: 30px;
                text-transform: uppercase;
                color: var(--text);
                letter-spacing: 0.5px;
            }

            /* Buyer & invoice info block */
            .buyer-info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px 30px;
                background: var(--surface-soft);
                border: 1px solid var(--line);
                padding: 20px;
                border-radius: 18px;
                margin-bottom: 25px;
            }

            .buyer-group {
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .buyer-group label {
                width: 120px;
                font-size: 13px;
                font-weight: 700;
                color: var(--muted);
                text-align: right;
                white-space: nowrap;
            }
            .buyer-group .input-wrapper {
                flex-grow: 1;
                display: flex;
                gap: 5px;
            }
            .buyer-group input, .buyer-group select {
                flex-grow: 1;
                height: 38px;
                box-sizing: border-box;
            }
            .buyer-group input[readonly] {
                background: var(--surface-strong);
                color: var(--muted);
                cursor: not-allowed;
            }

            /* Table control panel */
            .table-controls {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 12px;
                font-size: 14px;
            }

            /* Table styling customization built on top of app-layout.css */
            .product-table-wrapper {
                border-radius: 18px;
                overflow: hidden;
                border: 1px solid var(--line);
                margin-bottom: 25px;
                box-shadow: var(--shadow);
            }
            .product-table {
                width: 100%;
                min-width: 950px;
                border-collapse: collapse;
                background: var(--surface);
            }
            .product-table th {
                background: var(--surface-soft);
                color: var(--muted);
                font-weight: 900;
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                padding: 14px 10px;
                border-bottom: 1px solid var(--line);
            }
            .product-table td {
                padding: 10px;
                border-bottom: 1px solid var(--line);
                color: var(--text);
            }
            .product-table input {
                width: 100%;
                border: none;
                background: transparent;
                font-size: 13px;
                color: var(--text);
                text-align: inherit;
                padding: 4px;
            }
            .product-table input[readonly] {
                pointer-events: none;
            }

            .text-right {
                text-align: right !important;
            }
            .text-center {
                text-align: center !important;
            }

            /* Summary layout */
            .summary-layout {
                display: grid;
                grid-template-columns: 1.5fr 1fr;
                gap: 40px;
                margin-bottom: 30px;
            }
            .summary-notes {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }
            .summary-notes-group {
                display: flex;
                align-items: flex-start;
                gap: 12px;
            }
            .summary-notes-group label {
                width: 120px;
                font-size: 13px;
                font-weight: 700;
                color: var(--muted);
                text-align: right;
                margin-top: 8px;
            }
            .summary-notes-group textarea {
                flex-grow: 1;
                border-radius: 12px;
                border: 1px solid var(--line);
                padding: 10px;
                font-size: 13px;
                background: #ffffff;
                color: var(--text);
                font-family: inherit;
                resize: vertical;
            }
            .money-in-words {
                font-size: 13px;
                font-weight: 700;
                color: var(--primary);
                margin-top: 15px;
                border-top: 1px dashed var(--line);
                padding-top: 15px;
            }

            .summary-values {
                display: flex;
                flex-direction: column;
                gap: 12px;
            }
            .summary-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 14px;
                gap: 10px;
            }
            .summary-row label {
                font-weight: 700;
                color: var(--muted);
            }
            .summary-row .value-box {
                width: 200px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .summary-row input {
                width: 100%;
                min-width: 0;
                flex-grow: 1;
                height: 38px;
                box-sizing: border-box;
                background: var(--surface-soft);
                border: 1px solid var(--line);
                border-radius: 12px;
                text-align: right;
                font-weight: 700;
                padding: 0 12px;
            }
            .summary-row-total {
                background: var(--primary-soft);
                padding: 12px 15px;
                border-radius: 16px;
                border: 1px solid var(--line);
            }
            .summary-row-total label {
                color: var(--primary);
                font-size: 15px;
                font-weight: 900;
            }
            .summary-row-total input {
                background: #ffffff;
                color: var(--primary) !important;
                border-color: var(--line);
                font-size: 16px;
                font-weight: 900;
            }

            /* Action buttons bar */
            .actions-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-top: 1px solid var(--line);
                padding-top: 20px;
                margin-top: 30px;
                gap: 15px;
            }
            .actions-left, .actions-right {
                display: flex;
                gap: 12px;
            }
            .btn-action {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 10px 20px;
                border-radius: 999px;
                font-size: 13px;
                font-weight: 800;
                cursor: pointer;
                border: 1px solid var(--line);
                background: var(--surface);
                color: var(--text);
                text-decoration: none;
                transition: all 0.2s ease;
            }
            .btn-action:hover {
                background: var(--surface-soft);
                transform: translateY(-1px);
            }
            .btn-action.primary {
                background: var(--primary);
                color: #ffffff;
                border-color: var(--primary);
            }
            .btn-action.primary:hover {
                background: #3d684a;
            }
            .btn-action.success {
                background: var(--primary);
                color: #ffffff;
                border-color: var(--primary);
            }
            .btn-action.success:hover {
                background: #3d684a;
            }

            .full-width-field {
                grid-column: span 2;
            }

            /* Responsive design */
            @media (max-width: 900px) {
                .buyer-info-grid {
                    grid-template-columns: 1fr;
                }
                .full-width-field {
                    grid-column: span 1;
                }
                .summary-layout {
                    grid-template-columns: 1fr;
                    gap: 25px;
                }
                .actions-bar {
                    flex-direction: column;
                    align-items: stretch;
                }
                .actions-left, .actions-right {
                    flex-direction: column;
                }
                .btn-action {
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="invoices"/>
            </jsp:include>

            <main class="main legacy-page">
                <form id="invoiceForm" action="${pageContext.request.contextPath}/invoice" method="post">

                    <div class="status-section">
                        Trạng thái: <span class="status-label">
                            <c:choose>
                                <c:when test="${(not empty invoice ? invoice.invoiceStatus : 'UNRELEASED') == 'RELEASED'}">Đã phát hành</c:when>
                                <c:when test="${(not empty invoice ? invoice.invoiceStatus : 'UNRELEASED') == 'UNRELEASED'}">Chưa phát hành</c:when>
                                <c:when test="${(not empty invoice ? invoice.invoiceStatus : 'UNRELEASED') == 'CANCELED'}">Đã hủy</c:when>
                                <c:when test="${(not empty invoice ? invoice.invoiceStatus : 'UNRELEASED') == 'WAIT_FOR_RELEASE'}">Chờ phát hành</c:when>
                                <c:otherwise>${not empty invoice ? invoice.invoiceStatus : 'UNRELEASED'}</c:otherwise>
                            </c:choose>
                        </span> 
                        | Người tạo: <span style="font-weight: bold; color: var(--primary);">${not empty creatorName ? creatorName : 'N/A'}</span>
                    </div>

                    <div class="invoice-title" id="dynamicTitle">
                        ${(not empty invoice ? invoice.invoiceType : (empty invoiceType ? 'VAT' : invoiceType)) == 'VAT' ? 'HÓA ĐƠN GIÁ TRỊ GIA TĂNG' : 'HÓA ĐƠN BÁN HÀNG'}
                    </div>

                    <c:if test="${error != null}">
                        <div style="color: var(--danger); background: var(--danger-soft); border: 1px solid var(--line); padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 13px; font-weight: 700;">
                            ${error}
                        </div>
                    </c:if>

                    <c:set var="isReadOnly" value="${not empty invoice && invoice.invoiceStatus != 'UNRELEASED'}"/>
                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                    <input type="hidden" name="customerContractId" id="customerContractId" value="${not empty invoice ? invoice.customerContractId : order.customerContractId}">
                    <input type="hidden" name="customerOrderId" id="customerOrderId" value="${not empty invoice ? invoice.customerOrderId : order.customerOrderId}">
                    <input type="hidden" name="sellerName" value="${not empty invoice ? invoice.sellerName : companyName}">
                    <input type="hidden" name="sellerTaxCode" value="${not empty invoice ? invoice.sellerTaxCode : companyTaxCode}">
                    <input type="hidden" name="sellerAddress" value="${not empty invoice ? invoice.sellerAddress : companyAddress}">
                    <input type="hidden" name="sellerPhone" id="sellerPhone" value="${not empty invoice ? invoice.sellerPhone : companyPhone}">
                    <input type="hidden" name="invoiceStatus" id="invoiceStatus" value="${not empty invoice ? invoice.invoiceStatus : 'UNRELEASED'}">

                    <div class="buyer-info-grid">
                        <div>
                            <div class="buyer-group form-group">
                                <label>Mã khách hàng</label>
                                <div class="input-wrapper">
                                    <input type="text" id="buyerCode" value="KH-${not empty customer ? customer.customerId : order.customerId}" readonly>
                                </div>
                            </div>
                            <div class="buyer-group form-group" style="margin-top: 15px;">
                                <label>Mã số thuế</label>
                                <div class="input-wrapper">
                                    <input type="text" name="buyerTaxCode" id="buyerTaxCode" value="${not empty invoice ? invoice.buyerTaxCode : customer.taxCode}" ${isReadOnly ? 'readonly' : ''}>
                                </div>
                            </div>
                            <div class="buyer-group form-group" style="margin-top: 15px;">
                                <label>Tên người mua</label>
                                <div class="input-wrapper">
                                    <input type="text" name="buyerName" id="buyerName" value="${not empty invoice ? invoice.buyerName : customer.companyName}" ${isReadOnly ? 'readonly' : ''}>
                                </div>
                            </div>
                            <div class="buyer-group form-group" style="margin-top: 15px;">
                                <label>Số điện thoại</label>
                                <div class="input-wrapper">
                                    <input type="text" name="buyerPhone" id="buyerPhone" value="${not empty buyerPhone ? buyerPhone : customerUser.phone}" ${isReadOnly ? 'readonly' : ''}>
                                </div>
                            </div>
                        </div>
                        <div>
                            <div class="buyer-group form-group">
                                <label for="invoiceType">* Mẫu hóa đơn</label>
                                <div class="input-wrapper">
                                    <select name="invoiceType" id="invoiceType" onchange="onInvoiceTypeChange()" ${isReadOnly ? 'disabled' : ''}>
                                        <option value="VAT" ${(not empty invoice ? invoice.invoiceType : (empty invoiceType ? 'VAT' : invoiceType)) == 'VAT' ? 'selected' : ''}>1 - Hóa đơn GTGT</option>
                                        <option value="SALES" ${(not empty invoice ? invoice.invoiceType : (empty invoiceType ? 'VAT' : invoiceType)) == 'SALES' ? 'selected' : ''}>2 - Hóa đơn bán hàng</option>
                                    </select>
                                    <c:if test="${isReadOnly}">
                                        <input type="hidden" name="invoiceType" value="${not empty invoice ? invoice.invoiceType : 'VAT'}">
                                    </c:if>
                                </div>
                            </div>
                            <div class="buyer-group form-group" style="margin-top: 15px;">
                                <label>Ký hiệu hóa đơn</label>
                                <div class="input-wrapper">
                                    <input type="text" name="invoiceSymbol" id="invoiceSymbol" value="${not empty invoice ? invoice.invoiceSymbol : (empty invoiceSymbol ? defaultSymbol : invoiceSymbol)}" required maxlength="10" ${isReadOnly ? 'readonly' : ''}>
                                </div>
                            </div>
                            <div class="buyer-group form-group" style="margin-top: 15px;">
                                <label>Số hóa đơn</label>
                                <div class="input-wrapper">
                                    <input type="text" id="invoiceNoDisplay" value="${(not empty invoice && invoice.invoiceStatus != 'UNRELEASED') ? invoice.invoiceNo : 'Chưa cấp (Tự động tạo)'}" readonly style="color: #dc2626; font-weight: bold; background: #f8fafc;">
                                    <input type="hidden" name="invoiceNo" id="invoiceNo" value="${not empty invoice ? invoice.invoiceNo : '0'}">
                                </div>
                            </div>
                            <div class="buyer-group form-group" style="margin-top: 15px;">
                                <label>Ngày phát hành</label>
                                <div class="input-wrapper">
                                    <input type="text" id="issueDateDisplay" value="${(not empty invoice && invoice.issueDate != null) ? invoice.issueDate : 'Tự động lấy khi phát hành'}" readonly style="background: #f8fafc; color: #64748b;">
                                    <input type="hidden" name="issueDate" id="issueDate" value="${(not empty invoice && invoice.issueDate != null) ? invoice.issueDate : ''}">
                                </div>
                            </div>
                        </div>

                        <div class="buyer-group form-group full-width-field" style="margin-top: 10px;">
                            <label style="width: 110px;">Địa chỉ</label>
                            <div class="input-wrapper">
                                <input type="text" name="buyerAddress" id="buyerAddress" value="${not empty invoice ? invoice.buyerAddress : customerUser.address}" ${isReadOnly ? 'readonly' : ''}>
                            </div>
                        </div>
                    </div>

                    <div class="table-controls">
                        <div class="table-controls-left">
                            <span style="font-weight: bold; color: var(--primary);">Danh sách hàng hóa & dịch vụ từ đơn hàng</span>
                        </div>
                        <div class="table-controls-right">
                            <label><input type="checkbox" checked disabled> Đơn giá và số lượng đã khóa</label>
                            <span class="material-symbols-outlined" style="color: #cbd5e1;">settings</span>
                        </div>
                    </div>

                    <div class="product-table-wrapper">
                        <table class="product-table" id="productTable">
                            <thead>
                                <tr>
                                    <th style="width: 10%;" class="text-center">Mã sản phẩm</th>
                                    <th style="width: 25%;">Tên hàng hóa, dịch vụ</th>
                                    <th style="width: 8%;">Đơn vị</th>
                                    <th style="width: 7%;" class="text-right">Số lượng</th>
                                    <th style="width: 10%;" class="text-right">Đơn giá</th>
                                    <th style="width: 10%;" class="text-right">Thành tiền</th>
                                    <th style="width: 10%;" class="text-center">% Chiết khấu</th>
                                    <th style="width: 10%;" class="text-center">% Thuế VAT</th>
                                    <th style="width: 10%;" class="text-right">Thuế VAT</th>
                                </tr>
                            </thead>
                            <tbody id="productTableBody">
                                <c:if var="hasNoItems" test="${empty orderDetails}">
                                    <tr id="emptyRowPlaceholder">
                                        <td colspan="9" class="text-center" style="color: var(--muted); padding: 15px;">
                                            Không có dữ liệu mặt hàng.
                                        </td>
                                    </tr>
                                </c:if>
                                <c:forEach var="item" items="${orderDetails}">
                                    <tr class="product-row">
                                        <td class="text-center">
                                            <input type="text" name="productId" value="${item.productId}" style="text-align: center;" readonly>
                                        </td>
                                        <td>
                                            <input type="text" name="productName" value="${item.productName}" readonly>
                                        </td>
                                        <td>
                                            <input type="text" name="unit" value="${item.unit}" style="text-align: center;" readonly>
                                        </td>
                                        <td>
                                            <input type="number" name="quantity" class="row-qty text-right" value="${item.quantity}" readonly>
                                        </td>
                                        <td>
                                            <input type="number" name="sellingPrice" class="row-price text-right" value="${item.sellingPrice}" readonly>
                                        </td>
                                        <td>
                                            <input type="hidden" name="lineAmount" value="${item.lineAmount}">
                                            <input type="text" class="row-amount text-right" value="<fmt:formatNumber value="${item.lineAmount}" pattern="#,##0"/>" readonly style="font-weight: 600;">
                                        </td>
                                        <td class="text-center">
                                            <input type="text" name="discountPercent" class="row-discount-rate text-center" value="${empty item.discountPercent ? 0 : item.discountPercent}" readonly style="width: 40px; text-align: center; border: none; background: transparent; pointer-events: none;">%
                                        </td>
                                        <td class="text-center">
                                            <input type="text" name="taxPercent" class="row-tax-rate text-center" value="${empty item.taxPercent ? 0 : item.taxPercent}" readonly style="width: 40px; text-align: center; border: none; background: transparent; pointer-events: none;">%
                                        </td>
                                        <td>
                                            <input type="hidden" name="lineTax" value="${item.lineTax}">
                                            <input type="text" class="row-tax-val text-right" value="<fmt:formatNumber value="${item.lineTax}" pattern="#,##0"/>" readonly style="font-weight: 600;">
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="summary-layout">
                        <!-- Left notes & words -->
                        <div class="summary-notes">
                            
                            <div class="summary-notes-group">
                                <label for="invoiceNotes">Ghi chú khách hàng</label>
                                <textarea id="invoiceNotes" name="invoiceNotes" rows="2" placeholder="Ghi chú in trên hóa đơn cho khách hàng..." ${isReadOnly ? 'readonly' : ''}>${not empty invoice ? invoice.customerNote : ''}</textarea>
                            </div>
                                <c:if test="${sessionScope.user.roleId != 3}">
                               <div class="summary-notes-group">
                                <label for="internalNotes">Ghi chú nội bộ</label>
                                <textarea id="internalNotes" name="internalNotes" rows="2" placeholder="Ghi chú nội bộ cho nhân viên..." ${isReadOnly ? 'readonly' : ''}>${not empty invoice ? invoice.internalNote : ''}</textarea>
                            </div> 
                            </c:if>
                            <div class="money-in-words" id="moneyInWords">
                                Số tiền viết bằng chữ: <em>Không đồng</em>
                            </div>
                        </div>

                        <div class="summary-values">
                            <div class="summary-row">
                                <label>Cộng tiền hàng</label>
                                <div class="value-box">
                                    <input type="hidden" name="subTotal" value="${subTotal}">
                                    <input type="text" id="subTotal" value="<fmt:formatNumber value="${subTotal}" pattern="#,##0"/>" readonly>
                                    <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                </div>
                            </div>
                            <div class="summary-row">
                                <label>Tiền chiết khấu</label>
                                <div class="value-box">
                                    <input type="hidden" name="discountTotal" value="${discountTotal}">
                                    <input type="text" id="discountTotal" value="<fmt:formatNumber value="${discountTotal}" pattern="#,##0"/>" style="text-align: right;" readonly>
                                    <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                </div>
                            </div>
                            <div class="summary-row">
                                <label>Tổng tiền thuế VAT</label>
                                <div class="value-box">
                                    <input type="hidden" name="taxAmount" value="${taxAmount}">
                                    <input type="text" id="taxAmount" value="<fmt:formatNumber value="${taxAmount}" pattern="#,##0"/>" readonly>
                                    <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                </div>
                            </div>

                            <div class="summary-row summary-row-total">
                                <label style="color: #dc2626; font-weight: 800; font-size: 14px;">Tổng cộng thanh toán</label>
                                <div class="value-box">
                                    <input type="hidden" name="totalAmount" value="${totalAmount}">
                                    <input type="text" id="totalAmount" value="<fmt:formatNumber value="${totalAmount}" pattern="#,##0"/>" readonly>
                                    <span style="font-size: 11px; font-weight: bold; color: #dc2626;">VND</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="actions-bar">
                        <div class="actions-left">
                            <button type="submit" formaction="${pageContext.request.contextPath}/preview" formtarget="_blank" class="btn-action"><span class="material-symbols-outlined" style="font-size: 16px;">print</span> Xem trước hóa đơn</button>
                        </div>

                        <div class="actions-right">
                            <c:choose>
                                <c:when test="${empty invoice}">
                                    <button type="button" class="btn-action" onclick="submitDraft()"><span class="material-symbols-outlined" style="font-size: 16px;">save</span> Lưu nháp</button>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${invoice.invoiceStatus == 'UNRELEASED'}">
                                        <button type="button" class="btn-action success" onclick="submitPublish()"><span class="material-symbols-outlined" style="font-size: 16px;">send</span> Phát hành hóa đơn</button>
                                        <button type="button" class="btn-action" onclick="submitDraft()"><span class="material-symbols-outlined" style="font-size: 16px;">save</span> Cập nhật bản nháp</button>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/invoice-list" class="btn-action"><span class="material-symbols-outlined" style="font-size: 16px;">close</span> Đóng</a>
                        </div>
                </form>
            </main>
        </div>


        <script>
            window.onload = function () {
                onInvoiceTypeChange();
                updateMoneyInWords();
            };

            function submitPublish() {
                document.getElementById('invoiceStatus').value = 'RELEASED';
                document.getElementById('invoiceForm').submit();
            }

            function submitDraft() {
                document.getElementById('invoiceStatus').value = 'UNRELEASED';
                document.getElementById('invoiceForm').submit();
            }

            function onInvoiceTypeChange() {
                var type = document.getElementById('invoiceType').value;
                var titleDiv = document.getElementById('dynamicTitle');
                var symbolInput = document.getElementById('invoiceSymbol');

                var currentSymbol = symbolInput.value || '';
                var remainingSymbol = currentSymbol.length > 1 ? currentSymbol.substring(1) : '';

                if (type === 'VAT') {
                    titleDiv.innerHTML = "HÓA ĐƠN GIÁ TRỊ GIA TĂNG";
                    symbolInput.value = '1' + remainingSymbol;
                } else {
                    titleDiv.innerHTML = "HÓA ĐƠN BÁN HÀNG";
                    symbolInput.value = '2' + remainingSymbol;
                }
            }

            function updateMoneyInWords() {
                var totalAmountVal = document.getElementById('totalAmount').value || '0';
                var cleanAmount = totalAmountVal.replace(/[,.]/g, '');
                var totalAmount = parseFloat(cleanAmount) || 0;
                document.getElementById('moneyInWords').innerHTML = "Số tiền viết bằng chữ: <em>" + numberToWords(Math.round(totalAmount)) + "</em>";
            }

            function numberToWords(number) {
                if (number === 0)
                    return "Không đồng";

                let prefix = "";
                if (number < 0) {
                    prefix = "âm ";
                    number = -number;
                }
                const units = ["không", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"];
                const places = ["", "nghìn", "triệu", "tỷ", "nghìn", "triệu", "tỷ", "nghìn", "triệu", "tỷ"];

                let numStr = Math.round(number).toString();
                let groups = [];
                while (numStr.length > 0) {
                    groups.push(parseInt(numStr.slice(-3), 10));
                    numStr = numStr.slice(0, -3);
                }

                let words = [];
                for (let i = groups.length - 1; i >= 0; i--) {
                    let n = groups[i];

                    if (n === 0 && i % 3 !== 0) {
                        continue;
                    }

                    let showZeroHundred = (i < groups.length - 1);
                    let hundred = Math.floor(n / 100);
                    let ten = Math.floor((n % 100) / 10);
                    let unit = n % 10;

                    let groupText = "";

                    if (hundred > 0) {
                        groupText += units[hundred] + " trăm ";
                    } else if (showZeroHundred && (ten > 0 || unit > 0)) {
                        groupText += "không trăm ";
                    }

                    if (ten > 1) {
                        groupText += units[ten] + " mươi ";
                    } else if (ten === 1) {
                        groupText += "mười ";
                    } else if (ten === 0 && unit > 0 && (hundred > 0 || showZeroHundred)) {
                        groupText += "lẻ ";
                    }

                    if (unit === 5 && ten > 0) {
                        groupText += "lăm";
                    } else if (unit === 1 && ten > 1) {
                        groupText += "mốt";
                    } else if (unit > 0) {
                        groupText += units[unit];
                    }

                    let groupStr = groupText.trim();
                    if (groupStr !== "") {
                        let text = groupStr;
                        if (places[i]) {
                            text += " " + places[i];
                        }
                        words.push(text);
                    } else if (i > 0 && i % 3 === 0) {
                        words.push(places[i]);
                    }
                }

                let rawWords = prefix + words.join(" ");
                let result = rawWords.replace(/\s+/g, " ").trim();
                if (result === "")
                    return "Không đồng";

                return result.charAt(0).toUpperCase() + result.slice(1) + " đồng";
            }
        </script>
    </body>
</html>

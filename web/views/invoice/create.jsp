<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Invoice Creation Form</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .invoice-container {
                background: #ffffff;
                color: #333333;
                padding: 20px;
                border-radius: 8px;
                font-family: 'Nunito Sans', sans-serif;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }
            
            /* Status section */
            .status-section {
                text-align: right;
                font-size: 13px;
                margin-bottom: 15px;
            }
            .status-label {
                font-weight: bold;
                color: #007bff;
            }

            /* Title */
            .invoice-title {
                text-align: center;
                font-size: 18px;
                font-weight: 800;
                margin-bottom: 25px;
                text-transform: uppercase;
                color: #111111;
                letter-spacing: 0.5px;
            }

            /* Buyer & invoice info block */
            .buyer-info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr;
                gap: 15px 25px;
                background: #fdfdfd;
                border: 1px solid #e2e8f0;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .buyer-group {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .buyer-group label {
                width: 110px;
                font-size: 13px;
                font-weight: 600;
                color: #555555;
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
                padding: 6px 10px;
                border: 1px solid #cbd5e1;
                border-radius: 4px;
                font-size: 13px;
                background: #ffffff;
                color: #333333;
                height: 32px;
                box-sizing: border-box;
            }
            .buyer-group input[readonly] {
                background: #f8fafc;
                color: #64748b;
                border-color: #e2e8f0;
            }
            .buyer-group input:focus, .buyer-group select:focus {
                border-color: #3b82f6;
                outline: none;
            }
            
            .btn-icon {
                display: grid;
                place-items: center;
                width: 32px;
                height: 32px;
                background: #f1f5f9;
                border: 1px solid #cbd5e1;
                border-radius: 4px;
                cursor: pointer;
                color: #475569;
            }
            .btn-icon.btn-add {
                background: #e2fcd4;
                border-color: #a3e635;
                color: #166534;
            }
            .btn-info-get {
                padding: 0 10px;
                height: 32px;
                background: #f1f5f9;
                border: 1px solid #cbd5e1;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                white-space: nowrap;
            }

            /* Table control panel */
            .table-controls {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                font-size: 13px;
            }
            .table-controls-left {
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .table-controls-right {
                display: flex;
                gap: 15px;
                align-items: center;
            }
            
            .search-product-input {
                padding: 6px 10px;
                border: 1px solid #cbd5e1;
                border-radius: 4px;
                font-size: 13px;
                width: 220px;
            }
            .btn-add-row {
                background: #e2f0fd;
                border: 1px solid #bfdbfe;
                color: #1d4ed8;
                padding: 6px 12px;
                border-radius: 4px;
                font-size: 13px;
                cursor: pointer;
                font-weight: 600;
            }

            /* Editable Product Table */
            .product-table-wrapper {
                border: 1px solid #cbd5e1;
                border-radius: 8px;
                overflow-x: auto;
                margin-bottom: 20px;
                width: 100%;
            }
            .product-table {
                width: 100%;
                min-width: 950px;
                border-collapse: collapse;
                font-size: 13px;
                text-align: left;
            }
            .product-table th {
                background: #e0f2fe;
                color: #0369a1;
                font-weight: 700;
                padding: 10px;
                border-bottom: 1.5px solid #bae6fd;
                border-right: 1px solid #e0f2fe;
            }
            .product-table td {
                padding: 6px 10px;
                border-bottom: 1px solid #cbd5e1;
                border-right: 1px solid #cbd5e1;
                background: #ffffff;
            }
            .product-table td:last-child, .product-table th:last-child {
                border-right: none;
            }
            
            .product-table input, .product-table select {
                width: 100%;
                box-sizing: border-box;
                padding: 6px;
                border: 1px solid transparent;
                background: transparent;
                font-size: 13px;
                color: #333333;
                text-align: inherit;
            }
            .product-table input[readonly] {
                color: #64748b;
            }
            .product-table input:not([readonly]):hover, .product-table select:hover {
                border-color: #cbd5e1;
                background: #fafafa;
                border-radius: 4px;
            }
            .product-table input:not([readonly]):focus, .product-table select:focus {
                border-color: #3b82f6;
                background: #ffffff;
                outline: none;
                border-radius: 4px;
            }
            
            .text-right {
                text-align: right !important;
            }
            .text-center {
                text-align: center !important;
            }
            
            /* Summary fields */
            .summary-layout {
                display: grid;
                grid-template-columns: 1.5fr 1fr;
                gap: 30px;
                margin-bottom: 25px;
            }
            .summary-notes {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }
            .summary-notes-group {
                display: flex;
                align-items: flex-start;
                gap: 10px;
            }
            .summary-notes-group label {
                width: 130px;
                font-size: 13px;
                font-weight: 600;
                color: #555555;
                text-align: right;
                margin-top: 6px;
            }
            .summary-notes-group textarea {
                flex-grow: 1;
                padding: 8px;
                border: 1px solid #cbd5e1;
                border-radius: 4px;
                font-size: 13px;
                background: #ffffff;
                color: #333333;
                font-family: inherit;
                resize: vertical;
            }
            .money-in-words {
                font-size: 13px;
                font-weight: 700;
                color: #333333;
                margin-top: 15px;
                border-top: 1px dashed #cbd5e1;
                padding-top: 15px;
            }

            .summary-values {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .summary-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 13px;
                flex-wrap: wrap;
                gap: 10px;
            }
            .summary-row label {
                font-weight: 600;
                color: #555555;
            }
            .summary-row .value-box {
                width: 180px;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .summary-row input {
                width: 100%;
                min-width: 0;
                flex-grow: 1;
                padding: 6px 10px;
                border: 1px solid #cbd5e1;
                border-radius: 4px;
                font-size: 13px;
                text-align: right;
                font-weight: 600;
                height: 32px;
                box-sizing: border-box;
                background: #f8fafc;
            }
            .summary-row-total {
                background: #f1f5f9;
                padding: 8px 10px;
                border-radius: 6px;
            }
            .summary-row-total input {
                background: #ffffff;
                color: #dc2626 !important;
                font-size: 15px;
                font-weight: 800;
            }

            /* Action buttons bar */
            .actions-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-top: 1px solid #cbd5e1;
                padding-top: 15px;
                margin-top: 20px;
                flex-wrap: wrap;
                gap: 15px;
            }
            .actions-left, .actions-right {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
            .btn-action {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 8px 16px;
                border-radius: 4px;
                font-size: 13px;
                font-weight: 700;
                cursor: pointer;
                border: 1px solid #cbd5e1;
                background: #ffffff;
                color: #333333;
                text-decoration: none;
            }
            .btn-action.primary {
                background: #1e3a8a;
                color: #ffffff;
                border-color: #1e3a8a;
            }
            .btn-action.success {
                background: #15803d;
                color: #ffffff;
                border-color: #15803d;
            }

            .full-width-field {
                grid-column: span 3;
            }

            /* Responsive design */
            @media (max-width: 1200px) {
                .buyer-info-grid {
                    grid-template-columns: 1fr 1fr;
                }
                .full-width-field {
                    grid-column: span 2;
                }
            }

            @media (max-width: 768px) {
                .buyer-info-grid {
                    grid-template-columns: 1fr;
                }
                .full-width-field {
                    grid-column: span 1;
                }
                .buyer-group {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 5px;
                }
                .buyer-group label {
                    text-align: left;
                    width: 100%;
                }
                .summary-layout {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }
                .summary-notes-group {
                    flex-direction: column;
                    align-items: stretch;
                }
                .summary-notes-group label {
                    width: 100%;
                    text-align: left;
                    margin-bottom: 5px;
                }
                .summary-row .value-box {
                    width: 150px;
                }
            }

            @media (max-width: 480px) {
                .invoice-container {
                    padding: 10px;
                }
                .actions-bar {
                    flex-direction: column;
                    align-items: stretch;
                }
                .actions-left, .actions-right {
                    flex-direction: column;
                    align-items: stretch;
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
                <div class="invoice-container">
                    
                    <!-- STATUS LABELS -->
                    <div class="status-section">
                        Trạng thái: <span class="status-label">Chờ xuất</span> 
                        | Phân loại: <span style="font-weight: bold; color: #15803d;">Hóa đơn gốc</span>
                    </div>

                    <!-- DYNAMIC INVOICE TITLE -->
                    <div class="invoice-title" id="dynamicTitle">
                        HÓA ĐƠN GIÁ TRỊ GIA TĂNG (CÓ MÃ KHỞI TẠO TỪ MÁY TÍNH TIỀN)
                    </div>
                    
                    <c:if test="${error != null}">
                        <div style="color: #dc3545; background: #fee2e2; border: 1px solid #fca5a5; padding: 10px; border-radius: 6px; margin-bottom: 20px; font-size: 13px;">
                            ${error}
                        </div>
                    </c:if>

                    <form id="invoiceForm" action="${pageContext.request.contextPath}/invoice" method="post">
                        
                        <!-- HIDDEN DATA TO SUBMIT TO DATABASE -->
                        <input type="hidden" name="customerContractId" id="customerContractId" value="${contract.contractId}">
                        <input type="hidden" name="customerOrderId" id="customerOrderId" value="${order.customerOrderId}">
                        <input type="hidden" name="sellerName" value="Công ty TNHH Bánh Ngọt Po Bread">
                        <input type="hidden" name="sellerTaxCode" value="0101234567">
                        <input type="hidden" name="sellerAddress" value="1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội">
                        <input type="hidden" name="invoiceStatus" value="UNPAID">

                        <!-- BUYER & INVOICE DETAILS BLOCK -->
                        <div class="buyer-info-grid">
                            <!-- Column 1 (Thông tin khách hàng) -->
                            <div>
                                <div class="buyer-group form-group">
                                    <label>Mã khách hàng</label>
                                    <div class="input-wrapper">
                                        <input type="text" id="buyerCode" value="KH-${customer.customerId}" readonly>
                                        <button type="button" class="btn-icon" style="opacity: 0.6; pointer-events: none;"><span class="material-symbols-outlined" style="font-size: 18px;">search</span></button>
                                        <button type="button" class="btn-icon btn-add" style="opacity: 0.6; pointer-events: none;"><span class="material-symbols-outlined" style="font-size: 18px;">add</span></button>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Mã số thuế</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="buyerTaxCode" id="buyerTaxCode" value="${customer.taxCode}" readonly>
                                        <button type="button" class="btn-info-get" style="opacity: 0.6; pointer-events: none;">Lấy thông tin</button>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Tên người mua</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="buyerName" id="buyerName" value="${customer.companyName}" readonly>
                                    </div>
                                </div>
                            </div>

                            <!-- Column 2 (Thông tin đơn hàng & Ngày hóa đơn) -->
                            <div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Điện thoại</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="buyerPhone" id="buyerPhone" value="${customerUser.phone}" readonly>
                                    </div>
                                </div>
                            </div>

                            <!-- Column 3 (Thông tin mẫu hóa đơn) -->
                            <div>
                                <div class="buyer-group form-group">
                                    <label for="invoiceType">* Mẫu số HĐ</label>
                                    <div class="input-wrapper">
                                        <select name="invoiceType" id="invoiceType" onchange="onInvoiceTypeChange()">
                                            <option value="VAT" ${invoiceType == 'VAT' ? 'selected' : ''}>1 - Hóa đơn GTGT</option>
                                            <option value="SALES" ${invoiceType == 'SALES' ? 'selected' : ''}>2 - Hóa đơn Bán hàng</option>
                                        </select>
                                        <input type="hidden" name="templateCode" id="templateCode" value="1">
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Ký hiệu hóa đơn</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="invoiceSymbol" id="invoiceSymbol" value="${empty invoiceSymbol ? '1C26TYY' : invoiceSymbol}" required maxlength="10">
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Số hóa đơn</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="invoiceNo" id="invoiceNo" value="${empty invoiceNo ? '0' : invoiceNo}" required readonly style="color: #dc2626; font-weight: bold; background: #f8fafc;">
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>* Ngày hóa đơn</label>
                                    <div class="input-wrapper">
                                        <input type="datetime-local" name="issueDate" id="issueDate" value="${issueDate}" required>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Address Input spanning full width -->
                            <div class="buyer-group form-group full-width-field" style="margin-top: 10px;">
                                <label style="width: 110px;">Địa chỉ bên mua</label>
                                <div class="input-wrapper">
                                    <input type="text" name="buyerAddress" id="buyerAddress" value="${customerUser.address}" readonly>
                                </div>
                            </div>
                        </div>

                        <!-- TABLE CONTROL PANEL (READ-ONLY DISPLAY CONTEXT) -->
                        <div class="table-controls">
                            <div class="table-controls-left">
                                <span style="font-weight: bold; color: var(--primary);">Danh sách hàng hóa & dịch vụ từ đơn hàng</span>
                            </div>
                            <div class="table-controls-right">
                                <label><input type="checkbox" checked disabled> Đơn giá, số lượng đã khóa</label>
                                <span class="material-symbols-outlined" style="color: #cbd5e1;">settings</span>
                            </div>
                        </div>

                        <!-- PRODUCT DETAILS TABLE -->
                        <div class="product-table-wrapper">
                            <table class="product-table" id="productTable">
                                <thead>
                                    <tr>
                                        <th style="width: 10%;" class="text-center">Mã hàng</th>
                                        <th style="width: 30%;">Tên hàng hóa & dịch vụ</th>
                                        <th style="width: 10%;">Đơn vị tính</th>
                                        <th style="width: 8%;" class="text-right">Số lượng</th>
                                        <th style="width: 10%;" class="text-right">Đơn giá</th>
                                        <th style="width: 10%;" class="text-right">Thành tiền</th>
                                        <th style="width: 10%;" class="text-center">(%) VAT</th>
                                        <th style="width: 10%;" class="text-right">Thuế VAT</th>
                                    </tr>
                                </thead>
                                <tbody id="productTableBody">
                                    <c:if var="hasNoItems" test="${empty orderDetails}">
                                        <tr id="emptyRowPlaceholder">
                                            <td colspan="9" class="text-center" style="color: var(--muted); padding: 15px;">
                                                Không có dữ liệu mặt hàng nào.
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="item" items="${orderDetails}">
                                        <tr class="product-row">
                                            <td class="text-center">
                                                <input type="text" value="${item.product.productId}" style="text-align: center;" readonly>
                                            </td>
                                            <td>
                                                <input type="text" value="${item.product.productName}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" value="${item.product.unit}" style="text-align: center;" readonly>
                                            </td>
                                            <td>
                                                <input type="number" class="row-qty text-right" value="${item.detail.quantity}" readonly>
                                            </td>
                                            <td>
                                                <input type="number" class="row-price text-right" value="${item.detail.sellingPrice}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" class="row-amount text-right" value="${item.detail.quantity * item.detail.sellingPrice}" readonly style="font-weight: 600;">
                                            </td>
                                            <td>
                                                <select class="row-tax-rate text-center" onchange="onRowValueChange(this)">
                                                    <option value="10" ${item.detail.taxPercent == 10 || empty item.detail.taxPercent ? 'selected' : ''}>10%</option>
                                                    <option value="8" ${item.detail.taxPercent == 8 ? 'selected' : ''}>8%</option>
                                                    <option value="5" ${item.detail.taxPercent == 5 ? 'selected' : ''}>5%</option>
                                                    <option value="0" ${item.detail.taxPercent == 0 ? 'selected' : ''}>0%</option>
                                                </select>
                                            </td>
                                            <td>
                                                <input type="text" class="row-tax-val text-right" value="0" readonly style="font-weight: 600;">
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- SUMMARY & NOTES LAYOUT -->
                        <div class="summary-layout">
                            <!-- Left notes & words -->
                            <div class="summary-notes">
                                <div class="summary-notes-group">
                                    <label for="invoiceNotes">Ghi chú trên hóa đơn</label>
                                    <textarea id="invoiceNotes" name="invoiceNotes" rows="2" placeholder="Ghi chú in ra hóa đơn gửi khách hàng..."></textarea>
                                </div>
                                <div class="summary-notes-group">
                                    <label for="internalNotes">Ghi chú nội bộ</label>
                                    <textarea id="internalNotes" name="internalNotes" rows="2" placeholder="Ghi chú nội bộ dành cho nhân viên..."></textarea>
                                </div>
                                <div class="money-in-words" id="moneyInWords">
                                    Số tiền bằng chữ: <em>Không đồng</em>
                                </div>
                            </div>
                            
                            <!-- Right financial counts -->
                            <div class="summary-values">
                                <div class="summary-row">
                                    <label>Cộng tiền hàng</label>
                                    <div class="value-box">
                                        <input type="text" name="subTotal" id="subTotal" value="0" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>
                                <div class="summary-row">
                                    <label>Chiết khấu (%)</label>
                                    <div class="value-box">
                                        <input type="number" id="discountPercent" value="0" min="0" max="100" style="text-align: right;" oninput="recalculateAll()">
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">%</span>
                                    </div>
                                </div>
                                <div class="summary-row">
                                    <label>Tổng thuế VAT (5%)</label>
                                    <div class="value-box">
                                        <input type="text" id="tax5" value="0" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>
                                <div class="summary-row">
                                    <label>Tổng thuế VAT (8%)</label>
                                    <div class="value-box">
                                        <input type="text" id="tax8" value="0" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>
                                <div class="summary-row">
                                    <label>Tổng thuế VAT (10%)</label>
                                    <div class="value-box">
                                        <input type="text" id="tax10" value="0" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>
                                <!-- Hidden input for database taxAmount -->
                                <input type="hidden" name="taxAmount" id="taxAmount" value="0">
                                
                                <div class="summary-row summary-row-total">
                                    <label style="color: #dc2626; font-weight: 800; font-size: 14px;">Tổng thanh toán</label>
                                    <div class="value-box">
                                        <input type="text" name="totalAmount" id="totalAmount" value="0" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: #dc2626;">VND</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ACTIONS BUTTONS BAR -->
                        <div class="actions-bar">
                            <div class="actions-left">
                                <button type="button" class="btn-action" style="opacity: 0.6; pointer-events: none;"><span class="material-symbols-outlined" style="font-size: 16px;">build</span> Tiện ích <span style="font-size: 10px;">▼</span></button>
                                <button type="button" class="btn-action"><span class="material-symbols-outlined" style="font-size: 16px;">print</span> Xem hóa đơn</button>
                            </div>
                            
                            <div class="actions-right">
                                <button type="submit" class="btn-action success"><span class="material-symbols-outlined" style="font-size: 16px;">send</span> Xuất hóa đơn</button>
                                <button type="button" class="btn-action" onclick="submitDraftForm()"><span class="material-symbols-outlined" style="font-size: 16px;">save</span> Ghi</button>
                                <a href="${pageContext.request.contextPath}/invoice-list" class="btn-action"><span class="material-symbols-outlined" style="font-size: 16px;">close</span> Đóng</a>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <script>
            // Execute recalculations and setup on load
            window.onload = function() {
                var issueDateInput = document.getElementById('issueDate');
                if (!issueDateInput.value) {
                    var now = new Date();
                    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
                    issueDateInput.value = now.toISOString().slice(0, 16);
                }
                
                var invoiceNoInput = document.getElementById('invoiceNo');
                if (invoiceNoInput.value === '' || invoiceNoInput.value === '0') {
                    invoiceNoInput.value = 'INV-' + Math.floor(100000 + Math.random() * 900000);
                }
                
                onInvoiceTypeChange();
                recalculateAll();
            };

            // Dynamic header title and symbols mapping based on invoice type
            function onInvoiceTypeChange() {
                var type = document.getElementById('invoiceType').value;
                var titleDiv = document.getElementById('dynamicTitle');
                var templateInput = document.getElementById('templateCode');
                var symbolInput = document.getElementById('invoiceSymbol');

                var currentSymbol = symbolInput.value || '';
                var remainingSymbol = currentSymbol.length > 1 ? currentSymbol.substring(1) : 'C26TYY';

                if (type === 'VAT') {
                    titleDiv.innerHTML = "HÓA ĐƠN GIÁ TRỊ GIA TẰNG (CÓ MÃ KHỞI TẠO TỪ MÁY TÍNH TIỀN)";
                    templateInput.value = '1';
                    symbolInput.value = '1' + remainingSymbol;
                } else {
                    titleDiv.innerHTML = "HÓA ĐƠN BÁN HÀNG (CÓ MÃ KHỞI TẠO TỪ MÁY TÍNH TIỀN)";
                    templateInput.value = '2';
                    symbolInput.value = '2' + remainingSymbol;
                }
            }

            // Handle tax rate change on a row
            function onRowValueChange(element) {
                recalculateAll();
            }

            // Recalculate totals and words conversion
            function recalculateAll() {
                var rows = document.querySelectorAll('.product-row');
                var subTotal = 0;
                var totalTax = 0;
                var tax5 = 0;
                var tax8 = 0;
                var tax10 = 0;

                rows.forEach(row => {
                    var qty = parseFloat(row.querySelector('.row-qty').value) || 0;
                    var price = parseFloat(row.querySelector('.row-price').value) || 0;
                    var taxRate = parseFloat(row.querySelector('.row-tax-rate').value) || 0;

                    var amount = qty * price;
                    var taxVal = amount * (taxRate / 100);

                    // Update row amount and row tax values dynamically
                    row.querySelector('.row-amount').value = amount.toFixed(2);
                    row.querySelector('.row-tax-val').value = taxVal.toFixed(2);

                    subTotal += amount;
                    totalTax += taxVal;

                    if (taxRate === 5) tax5 += taxVal;
                    else if (taxRate === 8) tax8 += taxVal;
                    else if (taxRate === 10) tax10 += taxVal;
                });

                var discountPercent = parseFloat(document.getElementById('discountPercent').value) || 0;
                var discountAmt = subTotal * (discountPercent / 100);
                var totalAmount = subTotal + totalTax - discountAmt;

                // Set summary fields
                document.getElementById('subTotal').value = subTotal.toFixed(2);
                document.getElementById('tax5').value = tax5.toFixed(2);
                document.getElementById('tax8').value = tax8.toFixed(2);
                document.getElementById('tax10').value = tax10.toFixed(2);
                document.getElementById('taxAmount').value = totalTax.toFixed(2);
                document.getElementById('totalAmount').value = totalAmount.toFixed(2);

                // Convert to Vietnamese words
                document.getElementById('moneyInWords').innerHTML = "Số tiền bằng chữ: <em>" + numberToWords(Math.round(totalAmount)) + " đồng</em>";
            }

            // Convert number to Vietnamese words
            function numberToWords(number) {
                if (number === 0) return "Không";
                var units = ["", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"];
                var places = ["", "nghìn", "triệu", "tỷ", "nghìn tỷ", "triệu tỷ"];
                
                var str = "";
                var groupCount = 0;
                
                while (number > 0) {
                    var group = number % 1000;
                    number = Math.floor(number / 1000);
                    
                    if (group > 0) {
                        var groupStr = convertGroup(group);
                        str = groupStr + " " + places[groupCount] + " " + str;
                    }
                    groupCount++;
                }
                
                str = str.trim();
                return str.charAt(0).toUpperCase() + str.slice(1);

                function convertGroup(num) {
                    var h = Math.floor(num / 100);
                    var t = Math.floor((num % 100) / 10);
                    var u = num % 10;
                    
                    var out = "";
                    if (h > 0) {
                        out += units[h] + " trăm ";
                    } else if (str !== "") {
                        out += "không trăm ";
                    }
                    
                    if (t > 1) {
                        out += units[t] + " mươi ";
                    } else if (t === 1) {
                        out += "mười ";
                    } else if (u > 0 && str !== "") {
                        out += "lẻ ";
                    }
                    
                    if (u === 5 && t > 0) {
                        out += "lăm";
                    } else if (u === 1 && t > 1) {
                        out += "mốt";
                    } else if (u > 0) {
                        out += units[u];
                    }
                    
                    return out.trim();
                }
            }

            function submitDraftForm() {
                var form = document.getElementById('invoiceForm');
                form.submit();
            }
        </script>
    </body>
</html>

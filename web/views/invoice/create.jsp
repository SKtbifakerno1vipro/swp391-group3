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
                grid-template-columns: 1fr 1fr;
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

            /* MODAL PREVIEW INVOICE */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(15, 23, 42, 0.6);
                backdrop-filter: blur(4px);
                z-index: 1000;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            .modal-content {
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                width: 100%;
                max-width: 850px;
                max-height: 90%;
                display: flex;
                flex-direction: column;
                animation: slideUp 0.3s ease-out;
            }
            @keyframes slideUp {
                from {
                    transform: translateY(20px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .modal-header {
                padding: 16px 24px;
                border-bottom: 1px solid #e2e8f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .close-modal-btn {
                font-size: 24px;
                font-weight: bold;
                color: #64748b;
                cursor: pointer;
                transition: color 0.2s;
            }
            .close-modal-btn:hover {
                color: #0f172a;
            }
            .modal-body {
                padding: 24px;
                overflow-y: auto;
                background: #f8fafc;
            }
            .modal-footer {
                padding: 16px 24px;
                border-top: 1px solid #e2e8f0;
                display: flex;
                justify-content: flex-end;
                gap: 12px;
            }

            /* E-Invoice Layout Styling */
            .e-invoice-wrapper {
                background: #ffffff;
                border: 1px solid #cbd5e1;
                padding: 30px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                font-family: 'Times New Roman', Times, serif;
                color: #0f172a;
            }
            .e-invoice-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
            }
            .preview-products-table th, .preview-products-table td {
                border: 1px solid #cbd5e1;
                padding: 8px 6px;
            }
            .preview-products-table td {
                vertical-align: middle;
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
                        Status: <span class="status-label">${not empty invoice ? invoice.invoiceStatus : 'UNRELEASED'}</span> 
                        | Created By: <span style="font-weight: bold; color: #15803d;">${not empty creatorName ? creatorName : 'N/A'}</span>
                    </div>

                    <!-- DYNAMIC INVOICE TITLE -->
                    <div class="invoice-title" id="dynamicTitle">
                        ${(not empty invoice ? invoice.invoiceType : (empty invoiceType ? 'VAT' : invoiceType)) == 'VAT' ? 'VALUE ADDED TAX INVOICE' : 'SALES INVOICE'}
                    </div>

                    <c:if test="${error != null}">
                        <div style="color: #dc3545; background: #fee2e2; border: 1px solid #fca5a5; padding: 10px; border-radius: 6px; margin-bottom: 20px; font-size: 13px;">
                            ${error}
                        </div>
                    </c:if>

                    <form id="invoiceForm" action="${pageContext.request.contextPath}/invoice" method="post">

                        <!-- HIDDEN DATA TO SUBMIT TO DATABASE -->
                        <c:set var="isReadOnly" value="${not empty invoice && invoice.invoiceStatus != 'UNRELEASED'}"/>
                        <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                        <input type="hidden" name="customerContractId" id="customerContractId" value="${not empty invoice ? invoice.customerContractId : contract.contractId}">
                        <input type="hidden" name="customerOrderId" id="customerOrderId" value="${not empty invoice ? invoice.customerOrderId : order.customerOrderId}">
                        <input type="hidden" name="sellerName" value="${not empty invoice ? invoice.sellerName : companyName}">
                        <input type="hidden" name="sellerTaxCode" value="${not empty invoice ? invoice.sellerTaxCode : companyTaxCode}">
                        <input type="hidden" name="sellerAddress" value="${not empty invoice ? invoice.sellerAddress : companyAddress}">
                        <input type="hidden" name="sellerPhone" id="sellerPhone" value="${not empty invoice ? invoice.sellerPhone : companyPhone}">
                        <input type="hidden" name="invoiceStatus" id="invoiceStatus" value="${not empty invoice ? invoice.invoiceStatus : 'UNRELEASED'}">

                        <!-- BUYER & INVOICE DETAILS BLOCK -->
                        <div class="buyer-info-grid">
                            <!-- Column 1 (Customer Information) -->
                            <div>
                                <div class="buyer-group form-group">
                                    <label>Customer Code</label>
                                    <div class="input-wrapper">
                                        <input type="text" id="buyerCode" value="KH-${not empty customer ? customer.customerId : order.customerId}" readonly>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Tax Code</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="buyerTaxCode" id="buyerTaxCode" value="${not empty invoice ? invoice.buyerTaxCode : customer.taxCode}" ${isReadOnly ? 'readonly' : ''}>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Buyer Company</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="buyerName" id="buyerName" value="${not empty invoice ? invoice.buyerName : customer.companyName}" ${isReadOnly ? 'readonly' : ''}>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Phone Number</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="buyerPhone" id="buyerPhone" value="${not empty buyerPhone ? buyerPhone : customerUser.phone}" ${isReadOnly ? 'readonly' : ''}>
                                    </div>
                                </div>
                            </div>
                            <!-- Column 2 (Invoice Template Info) -->
                            <div>
                                <div class="buyer-group form-group">
                                    <label for="invoiceType">* Invoice Template</label>
                                    <div class="input-wrapper">
                                        <select name="invoiceType" id="invoiceType" onchange="onInvoiceTypeChange()" ${isReadOnly ? 'disabled' : ''}>
                                            <option value="VAT" ${(not empty invoice ? invoice.invoiceType : (empty invoiceType ? 'VAT' : invoiceType)) == 'VAT' ? 'selected' : ''}>1 - VAT Invoice</option>
                                            <option value="SALES" ${(not empty invoice ? invoice.invoiceType : (empty invoiceType ? 'VAT' : invoiceType)) == 'SALES' ? 'selected' : ''}>2 - Sales Invoice</option>
                                        </select>
                                        <c:if test="${isReadOnly}">
                                            <input type="hidden" name="invoiceType" value="${not empty invoice ? invoice.invoiceType : 'VAT'}">
                                        </c:if>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Invoice Symbol</label>
                                    <div class="input-wrapper">
                                        <input type="text" name="invoiceSymbol" id="invoiceSymbol" value="${not empty invoice ? invoice.invoiceSymbol : (empty invoiceSymbol ? defaultSymbol : invoiceSymbol)}" required maxlength="10" ${isReadOnly ? 'readonly' : ''}>
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Invoice Number</label>
                                    <div class="input-wrapper">
                                        <input type="text" id="invoiceNoDisplay" value="${(not empty invoice && invoice.invoiceStatus != 'UNRELEASED') ? invoice.invoiceNo : 'Not assigned (Auto-generated)'}" readonly style="color: #dc2626; font-weight: bold; background: #f8fafc;">
                                        <input type="hidden" name="invoiceNo" id="invoiceNo" value="${not empty invoice ? invoice.invoiceNo : '0'}">
                                    </div>
                                </div>
                                <div class="buyer-group form-group" style="margin-top: 15px;">
                                    <label>Invoice Date</label>
                                    <div class="input-wrapper">
                                        <input type="text" id="issueDateDisplay" value="${(not empty invoice && invoice.issueDate != null) ? invoice.issueDate : 'Auto-retrieved upon release'}" readonly style="background: #f8fafc; color: #64748b;">
                                        <input type="hidden" name="issueDate" id="issueDate" value="${(not empty invoice && invoice.issueDate != null) ? invoice.issueDate : ''}">
                                    </div>
                                </div>
                            </div>

                            <!-- Address Input spanning full width -->
                            <div class="buyer-group form-group full-width-field" style="margin-top: 10px;">
                                <label style="width: 110px;">Buyer Address</label>
                                <div class="input-wrapper">
                                    <input type="text" name="buyerAddress" id="buyerAddress" value="${not empty invoice ? invoice.buyerAddress : customerUser.address}" ${isReadOnly ? 'readonly' : ''}>
                                </div>
                            </div>
                        </div>

                        <!-- TABLE CONTROL PANEL (READ-ONLY DISPLAY CONTEXT) -->
                        <div class="table-controls">
                            <div class="table-controls-left">
                                <span style="font-weight: bold; color: var(--primary);">List of Goods & Services from Order</span>
                            </div>
                            <div class="table-controls-right">
                                <label><input type="checkbox" checked disabled> Unit price, quantity locked</label>
                                <span class="material-symbols-outlined" style="color: #cbd5e1;">settings</span>
                            </div>
                        </div>

                        <!-- PRODUCT DETAILS TABLE -->
                        <div class="product-table-wrapper">
                            <table class="product-table" id="productTable">
                                <thead>
                                    <tr>
                                        <th style="width: 10%;" class="text-center">Item Code</th>
                                        <th style="width: 25%;">Goods & Services Name</th>
                                        <th style="width: 8%;">Unit</th>
                                        <th style="width: 7%;" class="text-right">Quantity</th>
                                        <th style="width: 10%;" class="text-right">Unit Price</th>
                                        <th style="width: 10%;" class="text-right">Line Amount</th>
                                        <th style="width: 10%;" class="text-center">(%) Discount</th>
                                        <th style="width: 10%;" class="text-center">(%) VAT</th>
                                        <th style="width: 10%;" class="text-right">VAT Amount</th>
                                    </tr>
                                </thead>
                                <tbody id="productTableBody">
                                    <c:if var="hasNoItems" test="${empty orderDetails}">
                                        <tr id="emptyRowPlaceholder">
                                            <td colspan="9" class="text-center" style="color: var(--muted); padding: 15px;">
                                                No item data available.
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="item" items="${orderDetails}">
                                        <tr class="product-row">
                                            <td class="text-center">
                                                <input type="text" value="${item.productId}" style="text-align: center;" readonly>
                                            </td>
                                            <td>
                                                <input type="text" value="${item.productName}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" value="${item.unit}" style="text-align: center;" readonly>
                                            </td>
                                            <td>
                                                <input type="number" class="row-qty text-right" value="${item.quantity}" readonly>
                                            </td>
                                            <td>
                                                <input type="number" class="row-price text-right" value="${item.sellingPrice}" readonly>
                                            </td>
                                            <td>
                                                <input type="text" class="row-amount text-right" value="${item.lineAmount}" readonly style="font-weight: 600;">
                                            </td>
                                            <td class="text-center">
                                                <input type="text" class="row-discount-rate text-center" value="${item.discountPercent}" readonly style="width: 40px; text-align: center; border: none; background: transparent; pointer-events: none;">%
                                            </td>
                                            <td class="text-center">
                                                <input type="text" class="row-tax-rate text-center" value="${empty item.taxPercent ? 0 : item.taxPercent}" readonly style="width: 40px; text-align: center; border: none; background: transparent; pointer-events: none;">%
                                            </td>
                                            <td>
                                                <input type="text" class="row-tax-val text-right" value="${item.lineTax}" readonly style="font-weight: 600;">
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
                                    <label for="invoiceNotes">Customer Notes</label>
                                    <textarea id="invoiceNotes" name="invoiceNotes" rows="2" placeholder="Notes printed on invoice for customer..." ${isReadOnly ? 'readonly' : ''}>${not empty invoice ? invoice.customerNote : ''}</textarea>
                                </div>
                                <div class="summary-notes-group">
                                    <label for="internalNotes">Internal Notes</label>
                                    <textarea id="internalNotes" name="internalNotes" rows="2" placeholder="Internal notes for staff..." ${isReadOnly ? 'readonly' : ''}>${not empty invoice ? invoice.internalNote : ''}</textarea>
                                </div>
                                <div class="money-in-words" id="moneyInWords">
                                    Amount in words: <em>Zero dong</em>
                                </div>
                            </div>

                            <!-- Right financial counts -->
                            <div class="summary-values">
                                <div class="summary-row">
                                    <label>Sub-Total</label>
                                    <div class="value-box">
                                        <input type="text" name="subTotal" id="subTotal" value="${subTotal}" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>
                                <div class="summary-row">
                                    <label>Total Discount</label>
                                    <div class="value-box">
                                        <input type="text" name="discountTotal" id="discountTotal" value="${discountTotal}" style="text-align: right;" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>
                                <div class="summary-row">
                                    <label>Total VAT</label>
                                    <div class="value-box">
                                        <input type="text" name="taxAmount" id="taxAmount" value="${taxAmount}" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: var(--muted);">VND</span>
                                    </div>
                                </div>

                                <div class="summary-row summary-row-total">
                                    <label style="color: #dc2626; font-weight: 800; font-size: 14px;">Total Amount</label>
                                    <div class="value-box">
                                        <input type="text" name="totalAmount" id="totalAmount" value="${totalAmount}" readonly>
                                        <span style="font-size: 11px; font-weight: bold; color: #dc2626;">VND</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ACTIONS BUTTONS BAR -->
                        <div class="actions-bar">
                            <div class="actions-left">
                                <button type="button" class="btn-action" style="opacity: 0.6; pointer-events: none;"><span class="material-symbols-outlined" style="font-size: 16px;">build</span> Utilities <span style="font-size: 10px;">▼</span></button>
                                <button type="button" class="btn-action" onclick="showInvoicePreview()"><span class="material-symbols-outlined" style="font-size: 16px;">print</span> Preview Invoice</button>
                            </div>

                            <div class="actions-right">
                                <c:choose>
                                    <c:when test="${empty invoice}">
                                        <!-- Creation Mode: Only Save Draft -->
                                        <button type="button" class="btn-action" onclick="submitDraft()"><span class="material-symbols-outlined" style="font-size: 16px;">save</span> Save Draft</button>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Detail/Edit Mode -->
                                        <c:if test="${invoice.invoiceStatus == 'UNRELEASED'}">
                                            <button type="button" class="btn-action success" onclick="submitPublish()"><span class="material-symbols-outlined" style="font-size: 16px;">send</span> Release Invoice</button>
                                            <button type="button" class="btn-action" onclick="submitDraft()"><span class="material-symbols-outlined" style="font-size: 16px;">save</span> Update Draft</button>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/invoice-list" class="btn-action"><span class="material-symbols-outlined" style="font-size: 16px;">close</span> Close</a>
                            </div>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <!-- INVOICE PREVIEW MODAL -->
        <div id="previewModal" class="modal-overlay" style="display: none;">
            <div class="modal-content invoice-preview-card">
                <div class="modal-header">
                    <h3 style="margin: 0; color: var(--primary); font-weight: bold; display: flex; align-items: center; gap: 8px;">
                        <span class="material-symbols-outlined">visibility</span> Xem trước hóa đơn điện tử
                    </h3>
                    <span class="close-modal-btn" onclick="closePreviewModal()">&times;</span>
                </div>
                <div class="modal-body" id="printArea">
                    <!-- Rendered Vietnam E-Invoice Layout -->
                    <div class="e-invoice-wrapper">
                        <div class="e-invoice-header">
                            <div class="header-left">
                                <h2 id="previewTitle" style="color: #dc2626; margin: 0; font-weight: 800; font-size: 20px; text-transform: uppercase;">HÓA ĐƠN GIÁ TRỊ GIA TĂNG</h2>
                                <div style="margin-top: 5px; font-size: 13px; font-style: italic; color: #475569;">(Bản thể hiện của hóa đơn điện tử)</div>
                            </div>
                            <div class="header-right" style="text-align: right; font-size: 13px; line-height: 1.6;">
                                <div><strong>Ký hiệu (Symbol):</strong> <span id="previewSymbol"></span></div>
                                <div><strong>Số (No.):</strong> <span id="previewNo" style="color: #dc2626; font-weight: bold; font-size: 15px;"></span></div>
                                <div><strong>Ngày (Date):</strong> <span id="previewDate"></span></div>
                            </div>
                        </div>

                        <hr style="border: 0; border-top: 2px solid #dc2626; margin: 15px 0;">

                        <!-- Seller Info -->
                        <div class="invoice-section">
                            <table style="width: 100%; border-collapse: collapse; font-size: 13px; line-height: 1.6;">
                                <tr>
                                    <td style="width: 18%; font-weight: bold; color: #475569; vertical-align: top;">Đơn vị bán hàng:</td>
                                    <td id="previewSellerName" style="font-weight: bold; text-transform: uppercase; color: var(--primary);"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold; color: #475569;">Mã số thuế:</td>
                                    <td id="previewSellerTaxCode" style="font-weight: bold; letter-spacing: 1px;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold; color: #475569; vertical-align: top;">Địa chỉ:</td>
                                    <td id="previewSellerAddress"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold; color: #475569;">Điện thoại:</td>
                                    <td id="previewSellerPhone"></td>
                                </tr>
                            </table>
                        </div>

                        <hr style="border: 0; border-top: 1px dashed #cbd5e1; margin: 12px 0;">

                        <!-- Buyer Info -->
                        <div class="invoice-section">
                            <table style="width: 100%; border-collapse: collapse; font-size: 13px; line-height: 1.6;">
                                <tr>
                                    <td style="width: 18%; font-weight: bold; color: #475569; vertical-align: top;">Đơn vị mua hàng:</td>
                                    <td id="previewBuyerName" style="font-weight: bold;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold; color: #475569;">Mã số thuế:</td>
                                    <td id="previewBuyerTaxCode" style="font-weight: bold; letter-spacing: 1px;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold; color: #475569;">Điện thoại:</td>
                                    <td id="previewBuyerPhone"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: bold; color: #475569; vertical-align: top;">Địa chỉ:</td>
                                    <td id="previewBuyerAddress"></td>
                                </tr>
                            </table>
                        </div>

                        <!-- Products Table -->
                        <table class="preview-products-table" style="width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 12px;">
                            <thead>
                                <tr style="background-color: #f1f5f9; text-align: center; font-weight: bold; border: 1px solid #cbd5e1;">
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 4%;">STT</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 8%;">Mã hàng</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 25%; text-align: left;">Tên hàng hóa, dịch vụ</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 6%;">ĐVT</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 6%; text-align: right;">Số lượng</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 10%; text-align: right;">Đơn giá</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 11%; text-align: right;">Thành tiền</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 10%;">(%) CK</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 10%;">(%) VAT</th>
                                    <th style="padding: 8px; border: 1px solid #cbd5e1; width: 10%; text-align: right;">Thuế VAT</th>
                                </tr>
                            </thead>
                            <tbody id="previewProductsList">
                                <!-- Dynamic items will load here -->
                            </tbody>
                        </table>

                        <!-- Summary Panel -->
                        <div style="margin-top: 15px; font-size: 13px; width: 100%; display: flex; justify-content: flex-end;">
                            <table style="width: 45%; border-collapse: collapse; line-height: 1.8;">
                                <tr>
                                    <td style="font-weight: 500; color: #475569;">Cộng tiền hàng:</td>
                                    <td id="previewSubTotal" style="text-align: right; font-weight: bold;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: 500; color: #475569;">Tiền chiết khấu:</td>
                                    <td id="previewDiscountAmt" style="text-align: right; font-weight: bold;"></td>
                                </tr>
                                <tr>
                                    <td style="font-weight: 500; color: #475569;">Tổng tiền thuế VAT:</td>
                                    <td id="previewTaxAmt" style="text-align: right; font-weight: bold;"></td>
                                </tr>
                                <tr style="border-top: 1px solid #cbd5e1; font-size: 14px;">
                                    <td style="font-weight: bold; color: #dc2626; padding-top: 5px;">Tổng cộng thanh toán:</td>
                                    <td id="previewTotalAmt" style="text-align: right; font-weight: bold; color: #dc2626; padding-top: 5px;"></td>
                                </tr>
                            </table>
                        </div>

                        <!-- Money in Words -->
                        <div style="margin-top: 15px; font-size: 13px; font-style: italic; border-top: 1px solid #e2e8f0; padding-top: 8px;" id="previewWords">
                            Số tiền viết bằng chữ: ...
                        </div>

                        <!-- Signatures -->
                        <div style="margin-top: 30px; display: flex; justify-content: space-between; font-size: 13px; text-align: center;">
                            <div style="width: 45%;">
                                <strong>NGƯỜI MUA HÀNG</strong><br>
                                <span style="font-size: 11px; color: #64748b;">(Ký, ghi rõ họ tên)</span>
                                <div style="height: 60px;"></div>
                            </div>
                            <div style="width: 45%;">
                                <strong>NGƯỜI BÁN HÀNG</strong><br>
                                <span style="font-size: 11px; color: #64748b;">(Ký, đóng dấu, ghi rõ họ tên)</span>
                                <div style="height: 60px;"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-action" onclick="printInvoice()"><span class="material-symbols-outlined" style="font-size: 16px;">print</span> In hóa đơn</button>
                    <button type="button" class="btn-action" onclick="closePreviewModal()"><span class="material-symbols-outlined" style="font-size: 16px;">close</span> Đóng</button>
                </div>
            </div>
        </div>

        <script>
            // Execute setup on load
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

            // Dynamic header title and symbols mapping based on invoice type
            function onInvoiceTypeChange() {
                var type = document.getElementById('invoiceType').value;
                var titleDiv = document.getElementById('dynamicTitle');
                var symbolInput = document.getElementById('invoiceSymbol');

                var currentSymbol = symbolInput.value || '';
                var remainingSymbol = currentSymbol.length > 1 ? currentSymbol.substring(1) : '';

                if (type === 'VAT') {
                    titleDiv.innerHTML = "VALUE ADDED TAX INVOICE";
                    symbolInput.value = '1' + remainingSymbol;
                } else {
                    titleDiv.innerHTML = "SALES INVOICE";
                    symbolInput.value = '2' + remainingSymbol;
                }
            }

            // Update money in words based on total amount
            function updateMoneyInWords() {
                var totalAmount = parseFloat(document.getElementById('totalAmount').value) || 0;
                document.getElementById('moneyInWords').innerHTML = "Amount in words: <em>" + numberToWords(Math.round(totalAmount)) + " đồng</em>";
            }

            // Convert number to Vietnamese words
            function numberToWords(number) {
                if (number === 0) return "Không";

                var units = ["không", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"];
                
                var numStr = Math.round(number).toString();
                var len = numStr.length;
                var groups = [];
                
                for (var i = len; i > 0; i -= 3) {
                    groups.push(numStr.substring(Math.max(0, i - 3), i));
                }
                groups.reverse();

                var res = "";
                var totalGroups = groups.length;

                for (var i = 0; i < totalGroups; i++) {
                    var groupVal = parseInt(groups[i], 10);
                    if (groupVal === 0 && i > 0) {
                        var hasFollowing = false;
                        for (var j = i + 1; j < totalGroups; j++) {
                            if (parseInt(groups[j], 10) > 0) {
                                hasFollowing = true;
                                break;
                            }
                        }
                        if (hasFollowing) {
                            var scaleIndex = totalGroups - 1 - i;
                            if (scaleIndex > 0 && scaleIndex % 3 === 0) {
                                res += " tỷ";
                            }
                        }
                        continue;
                    }

                    var h = Math.floor(groupVal / 100);
                    var t = Math.floor((groupVal % 100) / 10);
                    var u = groupVal % 10;

                    var groupText = "";
                    
                    if (i === 0) {
                        if (h > 0) {
                            groupText += units[h] + " trăm ";
                        }
                    } else {
                        groupText += units[h] + " trăm ";
                    }

                    if (t > 1) {
                        groupText += units[t] + " mươi ";
                    } else if (t === 1) {
                        groupText += "mười ";
                    } else if (t === 0 && u > 0) {
                        if (i > 0 || h > 0) {
                            groupText += "lẻ ";
                        }
                    }

                    if (u === 5 && t > 0) {
                        groupText += "lăm";
                    } else if (u === 1 && t > 1) {
                        groupText += "mốt";
                    } else if (u > 0) {
                        groupText += units[u];
                    }

                    groupText = groupText.trim();

                    var scaleIndex = totalGroups - 1 - i;
                    var suffix = "";
                    if (scaleIndex > 0) {
                        if (scaleIndex % 3 === 0) {
                            var tỷCount = Math.floor(scaleIndex / 3);
                            suffix = Array(tỷCount + 1).join("tỷ ").trim();
                        } else if (scaleIndex % 3 === 1) {
                            suffix = "nghìn";
                            if (Math.floor(scaleIndex / 3) > 0) {
                                var tỷCount = Math.floor(scaleIndex / 3);
                                suffix += " " + Array(tỷCount + 1).join("tỷ ").trim();
                            }
                        } else if (scaleIndex % 3 === 2) {
                            suffix = "triệu";
                            if (Math.floor(scaleIndex / 3) > 0) {
                                var tỷCount = Math.floor(scaleIndex / 3);
                                suffix += " " + Array(tỷCount + 1).join("tỷ ").trim();
                            }
                        }
                    }

                    res += " " + groupText + " " + suffix;
                }

                res = res.replace(/\s+/g, " ").trim();
                if (res === "") return "Không";
                return res.charAt(0).toUpperCase() + res.slice(1);
            }

            function showInvoicePreview() {
                // Populate invoice headers
                var type = document.getElementById('invoiceType').value;
                document.getElementById('previewTitle').innerText = (type === 'VAT') ? 'HÓA ĐƠN GIÁ TRỊ GIA TĂNG' : 'HÓA ĐƠN BÁN HÀNG';
                document.getElementById('previewSymbol').innerText = document.getElementById('invoiceSymbol').value;
                document.getElementById('previewNo').innerText = document.getElementById('invoiceNoDisplay').value;
                document.getElementById('previewDate').innerText = document.getElementById('issueDateDisplay').value;

                // Populate Seller Info (hidden values)
                document.getElementById('previewSellerName').innerText = document.getElementsByName('sellerName')[0].value;
                document.getElementById('previewSellerTaxCode').innerText = document.getElementsByName('sellerTaxCode')[0].value;
                document.getElementById('previewSellerAddress').innerText = document.getElementsByName('sellerAddress')[0].value;
                document.getElementById('previewSellerPhone').innerText = document.getElementById('sellerPhone').value;

                // Populate Buyer Info (form inputs)
                document.getElementById('previewBuyerName').innerText = document.getElementById('buyerName').value;
                document.getElementById('previewBuyerTaxCode').innerText = document.getElementById('buyerTaxCode').value;
                document.getElementById('previewBuyerPhone').innerText = document.getElementById('buyerPhone').value;
                document.getElementById('previewBuyerAddress').innerText = document.getElementById('buyerAddress').value;

                // Populate Products
                var listBody = document.getElementById('previewProductsList');
                listBody.innerHTML = ''; // clear first

                var rows = document.querySelectorAll('.product-row');
                var stt = 1;
                rows.forEach(row => {
                    var prodId = row.cells[0].querySelector('input').value;
                    var prodName = row.cells[1].querySelector('input').value;
                    var unit = row.cells[2].querySelector('input').value;
                    var qty = parseFloat(row.querySelector('.row-qty').value) || 0;
                    var price = parseFloat(row.querySelector('.row-price').value) || 0;
                    var amount = parseFloat(row.querySelector('.row-amount').value) || 0;
                    var discountRate = parseFloat(row.querySelector('.row-discount-rate').value) || 0;
                    var taxRate = parseFloat(row.querySelector('.row-tax-rate').value) || 0;
                    var taxVal = parseFloat(row.querySelector('.row-tax-val').value) || 0;

                    var tr = document.createElement('tr');
                    tr.innerHTML = `
                        <td style="text-align: center; border: 1px solid #cbd5e1; padding: 8px;">\${stt++}</td>
                        <td style="text-align: center; border: 1px solid #cbd5e1; padding: 8px;">\${prodId}</td>
                        <td style="border: 1px solid #cbd5e1; padding: 8px;">\${prodName}</td>
                        <td style="text-align: center; border: 1px solid #cbd5e1; padding: 8px;">\${unit}</td>
                        <td style="text-align: right; border: 1px solid #cbd5e1; padding: 8px;">\${qty.toLocaleString('en-US')}</td>
                        <td style="text-align: right; border: 1px solid #cbd5e1; padding: 8px;">\${price.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})}</td>
                        <td style="text-align: right; border: 1px solid #cbd5e1; padding: 8px;">\${amount.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})}</td>
                        <td style="text-align: center; border: 1px solid #cbd5e1; padding: 8px;">\${discountRate}%</td>
                        <td style="text-align: center; border: 1px solid #cbd5e1; padding: 8px;">\${taxRate}%</td>
                        <td style="text-align: right; border: 1px solid #cbd5e1; padding: 8px; font-weight: bold;">\${taxVal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})}</td>
                    `;
                    listBody.appendChild(tr);
                });

                // Populate Financial Summary
                document.getElementById('previewSubTotal').innerText = parseFloat(document.getElementById('subTotal').value).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + ' VND';
                var discountAmtVal = parseFloat(document.getElementById('discountTotal').value) || 0;
                document.getElementById('previewDiscountAmt').innerText = discountAmtVal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + ' VND';

                document.getElementById('previewTaxAmt').innerText = parseFloat(document.getElementById('taxAmount').value).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + ' VND';
                document.getElementById('previewTotalAmt').innerText = parseFloat(document.getElementById('totalAmount').value).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + ' VND';

                var totalAmountVal = parseFloat(document.getElementById('totalAmount').value) || 0;
                document.getElementById('previewWords').innerHTML = "Số tiền viết bằng chữ: <em>" + numberToWords(Math.round(totalAmountVal)) + " đồng</em>";

                // Show modal
                document.getElementById('previewModal').style.display = 'flex';
            }

            function closePreviewModal() {
                document.getElementById('previewModal').style.display = 'none';
            }

            function printInvoice() {
                var printContents = document.getElementById('printArea').innerHTML;

                var printWindow = window.open('', '_blank');
                printWindow.document.write('<html><head><title>In hóa đơn điện tử</title>');
                printWindow.document.write('<style>');
                printWindow.document.write('body { font-family: "Times New Roman", serif; padding: 20px; color: #000; }');
                printWindow.document.write('.e-invoice-wrapper { border: none; padding: 0; box-shadow: none; }');
                printWindow.document.write('.e-invoice-header { display: flex; justify-content: space-between; align-items: flex-start; }');
                printWindow.document.write('table { width: 100%; border-collapse: collapse; margin-top: 15px; }');
                printWindow.document.write('th, td { border: 1px solid #000; padding: 6px; }');
                printWindow.document.write('.invoice-section table th, .invoice-section table td { border: none; }');
                printWindow.document.write('hr { border: 0; border-top: 2px solid #000; margin: 15px 0; }');
                printWindow.document.write('</style></head><body>');
                printWindow.document.write(printContents);
                printWindow.document.write('</body></html>');
                printWindow.document.close();
                printWindow.print();
            }
        </script>
    </body>
</html>

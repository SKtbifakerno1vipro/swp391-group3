<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xem trước hóa đơn điện tử</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            body {
                background: #f8fafc;
                font-family: 'Nunito Sans', sans-serif;
                margin: 0;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }
            .preview-container {
                width: 100%;
                max-width: 850px;
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
                padding: 24px;
                box-sizing: border-box;
            }
            .preview-footer {
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
                gap: 12px;
                width: 100%;
                max-width: 850px;
            }
            .btn-action {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 10px 18px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 13px;
                cursor: pointer;
                border: 1px solid #cbd5e1;
                background: #ffffff;
                color: #334155;
                transition: all 0.2s;
            }
            .btn-action:hover {
                background: #f1f5f9;
                border-color: #94a3b8;
            }
            .btn-action.primary {
                background: #2563eb;
                color: #ffffff;
                border-color: #2563eb;
            }
            .btn-action.primary:hover {
                background: #1d4ed8;
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
            .preview-products-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
                font-size: 12px;
            }
            .preview-products-table th, .preview-products-table td {
                border: 1px solid #cbd5e1;
                padding: 8px 6px;
            }
            .preview-products-table td {
                vertical-align: middle;
            }
            .preview-products-table th {
                background-color: #f1f5f9;
                text-align: center;
                font-weight: bold;
            }

            @media print {
                body {
                    background: none;
                    padding: 0;
                }
                .preview-container {
                    box-shadow: none;
                    padding: 0;
                    max-width: 100%;
                }
                .preview-footer {
                    display: none;
                }
                .e-invoice-wrapper {
                    border: none;
                    padding: 0;
                    box-shadow: none;
                }
                .preview-products-table th, .preview-products-table td {
                    border: 1px solid #000;
                }
                hr {
                    border-top: 2px solid #000 !important;
                }
            }
        </style>
    </head>
    <body>
        <div class="preview-container">
            <div class="e-invoice-wrapper" id="printArea">
                <div class="e-invoice-header">
                    <div class="header-left">
                        <h2 style="color: #dc2626; margin: 0; font-weight: 800; font-size: 20px; text-transform: uppercase;">
                            <c:choose>
                                <c:when test="${invoiceType == 'VAT'}">HÓA ĐƠN GIÁ TRỊ GIA TĂNG</c:when>
                                <c:otherwise>HÓA ĐƠN BÁN HÀNG</c:otherwise>
                            </c:choose>
                        </h2>
                        <div style="margin-top: 5px; font-size: 13px; font-style: italic; color: #475569;">(Bản thể hiện của hóa đơn điện tử)</div>
                    </div>
                    <div class="header-right" style="text-align: right; font-size: 13px; line-height: 1.6;">
                        <div><strong>Ký hiệu:</strong> <span><c:out value="${invoiceSymbol}"/></span></div>
                        <div><strong>Số:</strong> <span style="color: #dc2626; font-weight: bold; font-size: 15px;"><c:out value="${invoiceNo}"/></span></div>
                        <div><strong>Ngày:</strong> <span><c:out value="${issueDate}"/></span></div>
                    </div>
                </div>

                <hr style="border: 0; border-top: 2px solid #dc2626; margin: 15px 0;">

                <div class="invoice-section">
                    <table style="width: 100%; border-collapse: collapse; font-size: 13px; line-height: 1.6; border: none;">
                        <tr style="border: none;">
                            <td style="width: 18%; font-weight: bold; color: #475569; vertical-align: top; border: none; padding: 2px;">Đơn vị bán hàng:</td>
                            <td style="font-weight: bold; text-transform: uppercase; color: #2563eb; border: none; padding: 2px;"><c:out value="${sellerName}"/></td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: bold; color: #475569; border: none; padding: 2px;">Mã số thuế:</td>
                            <td style="font-weight: bold; letter-spacing: 1px; border: none; padding: 2px;"><c:out value="${sellerTaxCode}"/></td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: bold; color: #475569; vertical-align: top; border: none; padding: 2px;">Địa chỉ:</td>
                            <td style="border: none; padding: 2px;"><c:out value="${sellerAddress}"/></td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: bold; color: #475569; border: none; padding: 2px;">Điện thoại:</td>
                            <td style="border: none; padding: 2px;"><c:out value="${sellerPhone}"/></td>
                        </tr>
                    </table>
                </div>

                <hr style="border: 0; border-top: 1px dashed #cbd5e1; margin: 12px 0;">

                <div class="invoice-section">
                    <table style="width: 100%; border-collapse: collapse; font-size: 13px; line-height: 1.6; border: none;">
                        <tr style="border: none;">
                            <td style="width: 18%; font-weight: bold; color: #475569; vertical-align: top; border: none; padding: 2px;">Đơn vị mua hàng:</td>
                            <td style="font-weight: bold; border: none; padding: 2px;"><c:out value="${buyerName}"/></td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: bold; color: #475569; border: none; padding: 2px;">Mã số thuế:</td>
                            <td style="font-weight: bold; letter-spacing: 1px; border: none; padding: 2px;"><c:out value="${buyerTaxCode}"/></td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: bold; color: #475569; border: none; padding: 2px;">Điện thoại:</td>
                            <td style="border: none; padding: 2px;"><c:out value="${buyerPhone}"/></td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: bold; color: #475569; vertical-align: top; border: none; padding: 2px;">Địa chỉ:</td>
                            <td style="border: none; padding: 2px;"><c:out value="${buyerAddress}"/></td>
                        </tr>
                    </table>
                </div>

                <table class="preview-products-table">
                    <thead>
                        <tr>
                            <th style="width: 4%;">STT</th>
                            <th style="width: 8%;">Mã hàng</th>
                            <th style="width: 25%; text-align: left;">Tên hàng hóa, dịch vụ</th>
                            <th style="width: 6%;">ĐVT</th>
                            <th style="width: 6%; text-align: right;">Số lượng</th>
                            <th style="width: 10%; text-align: right;">Đơn giá</th>
                            <th style="width: 11%; text-align: right;">Thành tiền</th>
                            <th style="width: 10%;">(%) CK</th>
                            <th style="width: 10%;">(%) VAT</th>
                            <th style="width: 10%; text-align: right;">Thuế VAT</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderDetails}" varStatus="status">
                            <tr>
                                <td style="text-align: center;"><c:out value="${status.index + 1}"/></td>
                                <td style="text-align: center;"><c:out value="${item.productId}"/></td>
                                <td><c:out value="${item.productName}"/></td>
                                <td style="text-align: center;"><c:out value="${item.unit}"/></td>
                                <td style="text-align: right;"><fmt:formatNumber value="${item.quantity}" pattern="#,##0"/></td>
                                <td style="text-align: right;"><fmt:formatNumber value="${item.sellingPrice}" pattern="#,##0"/></td>
                                <td style="text-align: right;"><fmt:formatNumber value="${item.lineAmount}" pattern="#,##0"/></td>
                                <td style="text-align: center;"><c:out value="${item.discountPercent}"/>%</td>
                                <td style="text-align: center;"><c:out value="${item.taxPercent}"/>%</td>
                                <td style="text-align: right;"><fmt:formatNumber value="${item.lineTax}" pattern="#,##0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div style="margin-top: 15px; font-size: 13px; width: 100%; display: flex; justify-content: flex-end;">
                    <table style="width: 45%; border-collapse: collapse; line-height: 1.8; border: none;">
                        <tr style="border: none;">
                            <td style="font-weight: 500; color: #475569; border: none; padding: 2px;">Cộng tiền hàng:</td>
                            <td style="text-align: right; font-weight: bold; border: none; padding: 2px;">
                                <fmt:formatNumber value="${subTotal}" pattern="#,##0"/> VND
                            </td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: 500; color: #475569; border: none; padding: 2px;">Tiền chiết khấu:</td>
                            <td style="text-align: right; font-weight: bold; border: none; padding: 2px;">
                                <fmt:formatNumber value="${discountTotal}" pattern="#,##0"/> VND
                            </td>
                        </tr>
                        <tr style="border: none;">
                            <td style="font-weight: 500; color: #475569; border: none; padding: 2px;">Tổng tiền thuế VAT:</td>
                            <td style="text-align: right; font-weight: bold; border: none; padding: 2px;">
                                <fmt:formatNumber value="${taxAmount}" pattern="#,##0"/> VND
                            </td>
                        </tr>
                        <tr style="border-top: 1px solid #cbd5e1; font-size: 14px;">
                            <td style="font-weight: bold; color: #dc2626; padding-top: 5px; border: none;">Tổng cộng thanh toán:</td>
                            <td style="text-align: right; font-weight: bold; color: #dc2626; padding-top: 5px; border: none;">
                                <fmt:formatNumber value="${totalAmount}" pattern="#,##0"/> VND
                            </td>
                        </tr>
                    </table>
                </div>

                <div style="margin-top: 15px; font-size: 13px; font-style: italic; border-top: 1px solid #e2e8f0; padding-top: 8px;">
                    Số tiền viết bằng chữ: <em><c:out value="${amountInWords}"/></em>
                </div>

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
        
        <div class="preview-footer">
            <button class="btn-action primary" onclick="window.print()">
                <span class="material-symbols-outlined" style="font-size: 16px;">print</span> In hóa đơn
            </button>
            <button class="btn-action" onclick="window.close()">
                <span class="material-symbols-outlined" style="font-size: 16px;">close</span> Đóng trang
            </button>
        </div>
    </body>
</html>

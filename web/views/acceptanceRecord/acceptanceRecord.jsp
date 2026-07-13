<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biên Bản Nghiệm Thu</title>
    <style>
        body {
            font-family: "Times New Roman", Times, serif;
            font-size: 14pt;
            line-height: 1.5;
            margin: 40px;
            color: #000;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .header {
            text-align: center;
            font-weight: bold;
            margin-bottom: 30px;
        }
        .header .nation {
            font-size: 13pt;
            text-transform: uppercase;
        }
        .header .motto {
            font-size: 14pt;
            margin-top: 5px;
        }
        .header .separator {
            font-weight: normal;
            margin-top: 5px;
            margin-bottom: 25px;
        }
        .title {
            text-align: center;
            font-size: 16pt;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 20px;
        }
        .dots {
            border-bottom: 1px dotted #000;
            display: inline-block;
            min-width: 150px;
        }
        .section-title {
            font-weight: bold;
            margin-top: 15px;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        .info-table td {
            padding: 4px 0;
            vertical-align: bottom;
        }
        .info-table td.label {
            width: 25%;
            white-space: nowrap;
        }
        .info-table td.value {
            border-bottom: 1px dotted #000;
        }
        .content-block {
            margin-left: 20px;
            margin-bottom: 15px;
        }
        .content-line {
            margin-bottom: 10px;
        }
        .content-line .line-dots {
            border-bottom: 1px dotted #000;
            height: 20px;
            margin-top: 10px;
        }
        .footer-signatures {
            width: 100%;
            margin-top: 40px;
            text-align: center;
        }
        .footer-signatures td {
            width: 50%;
            vertical-align: top;
        }
        .signature-title {
            font-weight: bold;
            text-transform: uppercase;
        }
        .signature-note {
            font-style: italic;
            font-size: 11pt;
            color: #555;
        }
        .signature-space {
            height: 100px;
        }
        @media print {
            body { margin: 0; }
            .container { max-width: 100%; }
            .no-print { display: none !important; }
        }
    </style>
</head>
<body>
<div class="no-print" style="display: flex; justify-content: space-between; align-items: center; margin: 20px auto; max-width: 800px; padding: 15px; background-color: #f8f9fa; border-radius: 8px; border: 1px solid #dee2e6; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
    <div>
        <c:choose>
            <c:when test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                <span style="display: inline-flex; align-items: center; gap: 8px; padding: 8px 16px; background-color: #28a745; color: white; border-radius: 20px; font-weight: bold; font-size: 14px; box-shadow: 0 4px 6px rgba(40,167,69,0.15);">
                    ✓ Đơn hàng đã giao thành công
                </span>
            </c:when>
            <c:when test="${order.customerOrder.orderStatus == 'SHIPPING' && sessionScope.user.roleId == 3}">
                <form action="${pageContext.request.contextPath}/AcceptanceRecordController" method="POST" onsubmit="return confirm('Bạn có chắc chắn xác nhận đã nhận bàn giao hàng hóa thành công? Thao tác này sẽ cập nhật trạng thái đơn hàng thành hoàn thành.');" style="margin: 0; display: inline-block;">
                    <input type="hidden" name="orderId" value="${order.customerOrder.customerOrderId}">
                    <button type="submit" style="padding: 10px 20px; cursor: pointer; background: #28a745; color: white; border: none; border-radius: 20px; font-weight: bold; font-size: 14px; box-shadow: 0 4px 6px rgba(40,167,69,0.15); transition: all 0.2s ease;">
                        ✓ Xác Nhận Giao Hàng Thành Công
                    </button>
                </form>
            </c:when>
            <c:otherwise>
                <span style="color: #6c757d; font-style: italic; font-size: 14px;">
                    Trạng thái đơn hàng: <strong>${order.customerOrder.orderStatus}</strong>
                </span>
            </c:otherwise>
        </c:choose>
    </div>
    <div>
        <button onclick="window.print()" style="padding: 8px 16px; cursor: pointer; background: #007bff; color: white; border: none; border-radius: 4px; font-weight: bold;">🖨 In Biên Bản</button>
        <a href="${pageContext.request.contextPath}/customer-order?id=${order.customerOrder.customerOrderId}" style="padding: 8px 16px; cursor: pointer; margin-left: 10px; background: #6c757d; color: white; border: none; border-radius: 4px; font-weight: bold;" >Quay Lại</a>
    </div>
</div>
<div class="container">
    <div class="header">
        <div class="nation">Cộng hòa xã hội chủ nghĩa Việt Nam</div>
        <div class="motto">Độc lập - Tự do - Hạnh phúc</div>
        <div class="separator">---o0o---</div>
    </div>

    <div class="title">Biên bản nghiệm thu</div>

    <div style="margin-bottom: 20px;">
        Căn cứ hợp đồng số: <strong>${order.customerOrder.customerContractId != 0 ? order.customerOrder.customerContractId : '......................'}</strong> <br/>
        Hôm nay, ngày <strong>${day}</strong> tháng <strong>${month}</strong> năm <strong>${year}</strong>, chúng tôi gồm có:
    </div>

    <div class="section-title">Bên A: <strong>${companyName != null ? companyName : 'Lê Quản Lý'}</strong></div>
    <table class="info-table">
        <tr>
            <td class="label">Đại diện:</td>
            <td class="value"><strong>${company_rep_name != null ? company_rep_name : 'Lê Quản Lý'}</strong></td>
        </tr>
        <tr>
            <td class="label">Địa chỉ:</td>
            <td class="value" colspan="3"><strong>${companyAddress != null ? companyAddress : 'Lê Quản Lý'}</strong></td>
        </tr>
        <tr>
            <td class="label">Điện thoại:</td>
            <td class="value" colspan="3"><strong>${companyPhone != null ? companyPhone : 'Lê Quản Lý'}</strong></td>
        </tr>
        <tr>
            <td class="label">Mã số thuế:</td>
            <td class="value" colspan="3"><strong>${companyTaxCode != null ? companyTaxCode : 'Lê Quản Lý'}</strong></td>
        </tr>
    </table>

    <div class="section-title">Bên B: <strong>${customerFull.user.fullName != null ? customerFull.user.fullName : order.customer.companyName}</strong></div>
    <table class="info-table">
        <tr>
            <td class="label">Đại diện:</td>
            <td class="value"><strong>${customerFull.user.fullName}</strong></td>
        </tr>
        <tr>
            <td class="label">Địa chỉ:</td>
            <td class="value" colspan="3"><strong>${customerFull.user.address}</strong></td>
        </tr>
        <tr>
            <td class="label">Điện thoại:</td>
            <td class="value" colspan="3"><strong>${customerFull.user.phone}</strong></td>
        </tr>
        <tr>
            <td class="label">Mã số thuế:</td>
            <td class="value" colspan="3"><strong>${order.customer.taxCode}</strong></td>
        </tr>
    </table>

    <div class="section-title">Điều 1. Nội dung</div>
    <div class="content-block">
        <div class="content-line">
            - Bên A bàn giao cho bên B các sản phẩm theo đơn hàng <strong>#${order.customerOrder.customerOrderId}</strong>, bao gồm:
            <table border="1" style="width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 12pt;">
                <tr>
                    <th style="padding: 5px;">STT</th>
                   
                    <th style="padding: 5px;">Tên Hàng Hóa</th>
                    <th style="padding: 5px;">ĐVT</th>
                    <th style="padding: 5px;">Số lượng</th>
                    <th style="padding: 5px;">Đơn giá</th>
                    <th style="padding: 5px;">Giảm giá</th>
                    <th style="padding: 5px;">Thuế</th>
                    <th style="padding: 5px;">Thành tiền</th>
                </tr>
                <c:forEach var="item" items="${details}" varStatus="status">
                <tr>
                    <td style="padding: 5px; text-align: center;">${status.index + 1}</td>
                   
                    <td style="padding: 5px;">${item.product.productName}</td>
                    <td style="padding: 5px; text-align: center;">${item.product.unit}</td>
                    <td style="padding: 5px; text-align: center;">${item.detail.quantity}</td>
                    <td style="padding: 5px; text-align: right;"><fmt:formatNumber value="${item.detail.sellingPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                    <td style="padding: 5px; text-align: center;"><fmt:formatNumber value="${item.detail.discountPercent}" maxFractionDigits="2"/>%</td>
                    <td style="padding: 5px; text-align: center;"><fmt:formatNumber value="${item.detail.taxPercent}" maxFractionDigits="2"/>%</td>
                    <td style="padding: 5px; text-align: right;"><fmt:formatNumber value="${item.detail.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                </tr>
                </c:forEach>
            </table>
        </div>
        <div class="content-line">
            - Bên B thanh toán cho bên A tổng số tiền là: <strong><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong>
        </div>
        <div class="content-line">
            - Xác nhận bàn giao: Bên B đã nhận đủ số lượng và chất lượng đúng như thỏa thuận.
        </div>
    </div>

    <div class="section-title">Điều 2. Kết luận</div>
    <div class="content-block">
        <div class="content-line">2.1. Bên A đã kiểm tra, thẩm định kỹ lưỡng chất lượng sản phẩm/dịch vụ.</div>
        <div class="content-line">2.2. Kể từ khi bên A nhận đầy đủ số lượng sản phẩm/dịch vụ đã bàn giao, Bên B hoàn toàn không chịu trách nhiệm về lỗi, chất lượng sản phẩm/dịch vụ.</div>
        <div class="content-line">2.3. Bên A phải thanh toán hết cho bên B ngay sau khi biên bản nghiệm thu được ký kết, trừ trường hợp các bên có thỏa thuận khác.</div>
        <div class="content-line">2.4. Biên bản nghiệm thu này được lập thành 02 bản, mỗi bên giữ 01 bản và có giá trị pháp lý như nhau.</div>
    </div>

    <table class="footer-signatures">
        <tr>
            <td>
                <div class="signature-title">ĐẠI DIỆN BÊN BÀN GIAO</div>
                <div class="signature-note">(Ký và ghi rõ họ tên)</div>
                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; border: 2px dashed #28a745; border-radius: 4px; padding: 5px 15px; background: #f4faf6; color: #28a745; font-family: 'Courier New', Courier, monospace; transform: rotate(-2deg); font-weight: bold; width: fit-content; margin: 0 auto; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                                <span style="font-size: 11pt; letter-spacing: 1px;">ĐÃ XÁC NHẬN ONLINE</span>
                                <span style="font-size: 8pt; color: #555; font-weight: normal; margin-top: 3px; font-family: sans-serif;">
                                    Đại diện: <strong>${company_rep_name != null ? company_rep_name : 'Lê Quản Lý'}</strong>
                                </span>
                                <span style="font-size: 7pt; color: #777; font-weight: normal; font-family: sans-serif;">
                                    Ngày: ${day}/${month}/${year}
                                </span>
                            </div>
            </td>
            <td>
                <div class="signature-title">ĐẠI DIỆN BÊN NHẬN BÀN GIAO</div>
                <div class="signature-note">(Ký và ghi rõ họ tên)</div>
                <div class="signature-space" style="height: 100px; display: flex; align-items: center; justify-content: center;">
                    <c:choose>
                        <c:when test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                            <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; border: 2px dashed #28a745; border-radius: 4px; padding: 5px 15px; background: #f4faf6; color: #28a745; font-family: 'Courier New', Courier, monospace; transform: rotate(-2deg); font-weight: bold; width: fit-content; margin: 0 auto; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                                <span style="font-size: 11pt; letter-spacing: 1px;">ĐÃ XÁC NHẬN ONLINE</span>
                                <span style="font-size: 8pt; color: #555; font-weight: normal; margin-top: 3px; font-family: sans-serif;">
                                    Khách hàng: <strong>${customerFull.user.fullName}</strong>
                                </span>
                                <span style="font-size: 7pt; color: #777; font-weight: normal; font-family: sans-serif;">
                                    Ngày: ${day}/${month}/${year}
                                </span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <span style="font-style: italic; font-size: 10pt; color: #999;">(Chờ xác nhận trực tuyến)</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </td>
        </tr>
    </table>
</div>

</body>
</html>
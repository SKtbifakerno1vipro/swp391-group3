<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Biên Bản Nghiệm Thu - ${order.customerOrder.customerOrderId}</title>
    <style>
        body { font-family: 'Times New Roman', Times, serif; padding: 40px; line-height: 1.5; }
        .header { text-align: center; font-weight: bold; }
        .title { text-align: center; font-size: 24px; font-weight: bold; margin: 30px 0; }
        .section { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        table, th, td { border: 1px solid black; }
        th, td { padding: 8px; text-align: left; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .footer { display: flex; justify-content: space-around; margin-top: 50px; font-weight: bold; }
        .signature-box { text-align: center; }
        @media print {
            .no-print { display: none; }
            body { padding: 0; }
        }
    </style>
</head>
<body>
    <div class="no-print" style="margin-bottom: 20px;">
        <button onclick="window.print()" style="padding: 10px 20px; font-size: 16px; cursor: pointer; background-color: #007bff; color: white; border: none; border-radius: 4px;">🖨 In Biên Bản</button>
        <button onclick="history.back()" style="padding: 10px 20px; font-size: 16px; cursor: pointer; margin-left: 10px; background-color: #6c757d; color: white; border: none; border-radius: 4px;">Quay Lại</button>
    </div>

    <div class="header">
        <p>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</p>
        <p>Độc lập - Tự do - Hạnh phúc</p>
        <p>---o0o---</p>
    </div>

    <div class="title">BIÊN BẢN NGHIỆM THU VÀ BÀN GIAO</div>

    <div class="section">
        <p><em>Hôm nay, ngày ..... tháng ..... năm ......, tại ................................................................</em></p>
        <p>Chúng tôi gồm có:</p>
    </div>

    <div class="section">
        <strong>BÊN BÁN (BÊN A): CÔNG TY CỔ PHẦN SWP391 GROUP 3</strong>
        <p>Đại diện: ........................................ Chức vụ: ........................................</p>
        <p>Địa chỉ: ..................................................................................................</p>
    </div>

    <div class="section">
        <strong>BÊN MUA (BÊN B): ${order.customerUser.fullName != null ? order.customerUser.fullName : order.customer.companyName}</strong>
        <p>Mã số thuế: ${order.customer.taxCode}</p>
        <p>Địa chỉ: ..................................................................................................</p>
    </div>

    <div class="section">
        <p>Hai bên thống nhất nghiệm thu và bàn giao các sản phẩm thuộc Đơn hàng số <strong>#${order.customerOrder.customerOrderId}</strong> với chi tiết như sau:</p>
        
        <table>
            <thead>
                <tr>
                    <th class="text-center">STT</th>
                    <th>Mã SP</th>
                    <th>Tên Hàng Hóa</th>
                    <th class="text-center">ĐVT</th>
                    <th class="text-center">SL</th>
                    <th class="text-right">Đơn giá</th>
                    <th class="text-right">CK (%)</th>
                    <th class="text-right">Thuế (%)</th>
                    <th class="text-right">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${details}" varStatus="status">
                    <tr>
                        <td class="text-center">${status.index + 1}</td>
                        <td>${item.product.productCode}</td>
                        <td>${item.product.productName}</td>
                        <td class="text-center">${item.product.unit}</td>
                        <td class="text-center">${item.detail.quantity}</td>
                        <td class="text-right"><fmt:formatNumber value="${item.detail.sellingPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        <td class="text-right"><fmt:formatNumber value="${item.detail.discountPercent}" maxFractionDigits="2"/></td>
                        <td class="text-right"><fmt:formatNumber value="${item.detail.taxPercent}" maxFractionDigits="2"/></td>
                        <td class="text-right"><fmt:formatNumber value="${item.detail.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="8" class="text-right">Tổng cộng (Đã bao gồm thuế & CK):</th>
                    <th class="text-right"><fmt:formatNumber value="${grandTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></th>
                </tr>
            </tfoot>
        </table>
    </div>

    <div class="section" style="margin-top: 30px;">
        <p><strong>Kết luận:</strong></p>
        <p>Bên B đã nhận đủ số lượng hàng hóa/dịch vụ theo đúng chất lượng cam kết. Biên bản được lập thành 02 bản, mỗi bên giữ 01 bản có giá trị pháp lý như nhau.</p>
    </div>

    <div class="footer">
        <div class="signature-box">
            <p><strong>ĐẠI DIỆN BÊN A</strong></p>
            <p><em>(Ký, ghi rõ họ tên và đóng dấu)</em></p>
        </div>
        <div class="signature-box">
            <p><strong>ĐẠI DIỆN BÊN B</strong></p>
            <p><em>(Ký, ghi rõ họ tên và đóng dấu)</em></p>
        </div>
    </div>
</body>
</html>

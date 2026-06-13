<%-- 
    Document   : ContractTemplate
    Created on : Jun 8, 2026, 10:57:03 PM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <style>
            body {
                font-family: "Times New Roman", serif;
                font-size: 14px;
                line-height: 1.5;
                color: #000;
            }
            .container {
                width: 85%;
                margin: 0 auto;
                padding: 20px;
            }
            .text-center {
                text-align: center;
            }
            .bold {
                font-weight: bold;
            }
            .underline {
                text-decoration: underline;
            }
            .section-title {
                font-weight: bold;
                margin-top: 20px;
                margin-bottom: 10px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 10px;
            }
            .info-table td {
                padding: 5px 0;
                vertical-align: bottom;
            }
            .dotted {
                border-bottom: 1px dotted #000;
            }
            .product-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .product-table th, .product-table td {
                border: 1px solid #000;
                padding: 8px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="text-center">
                <p class="bold">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</p>
                <p class="bold underline">Độc lập - Tự do - Hạnh phúc</p>
                <h2 class="bold" style="margin-top:40px;">HỢP ĐỒNG MUA BÁN HÀNG HÓA</h2>
                <p>Số: {contract_number}</p>
            </div>

            <p>Hôm nay, ngày {sign_date}, tại {location}, chúng tôi gồm có:</p>

            <!-- THÔNG TIN BÊN A -->
            <div class="section-title">BÊN BÁN (BÊN A):</div>
            <table class="info-table">
                <tr>
                    <td style="width: 20%;">Tên doanh nghiệp:</td>
                    <td colspan="3" class="dotted">{company_name}</td>
                </tr>
                <tr>
                    <td>Địa chỉ:</td>
                    <td colspan="3" class="dotted">{company_address}</td>
                </tr>
                <tr>
                    <td>Điện thoại:</td>
                    <td style="width: 30%;" class="dotted">{company_phone}</td>
                    <td style="width: 15%; padding-left: 20px;">Mã số thuế:</td>
                    <td style="width: 35%;" class="dotted">{company_tax}</td>
                </tr>
                <tr>
                    <td>Người đại diện:</td>
                    <td class="dotted">{company_rep}</td>
                    <td style="padding-left: 20px;">Chức vụ:</td>
                    <td class="dotted">{company_position}</td>
                </tr>
            </table>

            <!-- THÔNG TIN BÊN B -->
            <div class="section-title">BÊN MUA (BÊN B):</div>
            <table class="info-table">
                <tr>
                    <td style="width: 20%;">Tên doanh nghiệp:</td>
                    <td colspan="3" class="dotted">{customer_name}</td>
                </tr>
                <tr>
                    <td>Địa chỉ:</td>
                    <td colspan="3" class="dotted">{customer_address}</td>
                </tr>
                <tr>
                    <td>Điện thoại:</td>
                    <td style="width: 30%;" class="dotted">{customer_phone}</td>
                    <td style="width: 15%; padding-left: 20px;">Mã số thuế:</td>
                    <td style="width: 35%;" class="dotted">{customer_tax}</td>
                </tr>
            </table>

            <!-- DANH SÁCH SẢN PHẨM -->
            <div class="section-title">ĐIỀU 1: DANH MỤC HÀNG HÓA</div>
            <table class="product-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên sản phẩm</th>
                        <th>Đơn vị</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    {product_list}
                </tbody>
            </table>

            <div style="text-align: right; margin-top: 10px;">
                <p>Tổng cộng: <span class="bold">{total_amount} VNĐ</span></p>
            </div>

            <div class="section-title">ĐIỀU 2: HIỆU LỰC</div>
            <p>Hợp đồng có hiệu lực từ ngày {effective_date} đến ngày {end_date}.</p>
        </div>
    </body>
</html>
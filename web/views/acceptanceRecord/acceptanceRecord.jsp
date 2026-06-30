<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <div class="nation">Cộng hòa xã hội chủ nghĩa Việt Nam</div>
        <div class="motto">Độc lập - Tự do - Hạnh phúc</div>
        <div class="separator">---o0o---</div>
    </div>

    <div class="title">Biên bản nghiệm thu</div>

    <div style="margin-bottom: 20px;">
        Căn cứ hợp đồng số: <span class="dots" style="min-width: 100px;"></span> ngày <span class="dots" style="min-width: 50px;"></span>/<span class="dots" style="min-width: 50px;"></span>/<span class="dots" style="min-width: 50px;"></span> <br/>
        Hôm nay, ngày <span class="dots" style="min-width: 50px;"></span>/<span class="dots" style="min-width: 50px;"></span>/<span class="dots" style="min-width: 50px;"></span> tại Công ty <span class="dots" style="min-width: 350px;"></span>, chúng tôi gồm có:
    </div>

    <div class="section-title">Bên A: CÔNG TY <span class="dots" style="min-width: 300px;"></span></div>
    <table class="info-table">
        <tr>
            <td class="label">Đại diện:</td>
            <td class="value"></td>
            <td class="label" style="width: 10%; padding-left: 10px;">Chức vụ:</td>
            <td class="value"></td>
        </tr>
        <tr>
            <td class="label">Địa chỉ:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Điện thoại:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Mã số thuế:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Tên tài khoản ngân hàng:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Số tài khoản:</td>
            <td class="value"></td>
            <td class="label" style="width: 10%; padding-left: 10px;">Ngân hàng:</td>
            <td class="value">Chi nhánh <span class="dots" style="min-width: 100px;"></span></td>
        </tr>
    </table>

    <div class="section-title">Bên B: CÔNG TY <span class="dots" style="min-width: 300px;"></span></div>
    <table class="info-table">
        <tr>
            <td class="label">Đại diện:</td>
            <td class="value"></td>
            <td class="label" style="width: 10%; padding-left: 10px;">Chức vụ:</td>
            <td class="value"></td>
        </tr>
        <tr>
            <td class="label">Địa chỉ:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Điện thoại:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Mã số thuế:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Tên tài khoản ngân hàng:</td>
            <td class="value" colspan="3"></td>
        </tr>
        <tr>
            <td class="label">Số tài khoản:</td>
            <td class="value"></td>
            <td class="label" style="width: 10%; padding-left: 10px;">Ngân hàng:</td>
            <td class="value">Chi nhánh <span class="dots" style="min-width: 100px;"></span></td>
        </tr>
    </table>

    <div class="section-title">Điều 1. Nội dung</div>
    <div class="content-block">
        <div class="content-line">
            - Bên B bàn giao cho bên A:
            <div class="line-dots"></div>
            <div class="line-dots"></div>
        </div>
        <div class="content-line">
            - Bên A thanh toán cho bên B:
            <div class="line-dots"></div>
            <div class="line-dots"></div>
        </div>
        <div class="content-line">
            - Xác nhận bàn giao:
            <div class="line-dots"></div>
            <div class="line-dots"></div>
        </div>
    </div>

    <div class="section-title">Điều 2. Kết luận</div>
    <div class="content-block">
        <div class="content-line">2.1. Bên A đã kiểm tra, thẩm định kỹ lưỡng chất lượng sản phẩm/dịch vụ.</div>
        <div class="content-line">2.2. Kể từ khi bên A nhận đầy đủ số lượng sản phẩm/dịch vụ <span class="dots" style="min-width: 150px;"></span> đã bàn giao, Bên B hoàn toàn không chịu trách nhiệm về lỗi, chất lượng sản phẩm/dịch vụ.</div>
        <div class="content-line">2.3. Bên A phải thanh toán hết cho bên B ngay sau khi biên bản nghiệm thu được ký kết, trừ trường hợp các bên có thỏa thuận khác.</div>
        <div class="content-line">2.4. Biên bản nghiệm thu này được lập thành 02 bản, mỗi bên giữ 01 bản và có giá trị pháp lý như nhau.</div>
    </div>

    <table class="footer-signatures">
        <tr>
            <td>
                <div class="signature-title">ĐẠI DIỆN BÊN BÀN GIAO</div>
                <div class="signature-note">(Ký và ghi rõ họ tên)</div>
                <div class="signature-space"></div>
            </td>
            <td>
                <div class="signature-title">ĐẠI DIỆN BÊN NHẬN BÀN GIAO</div>
                <div class="signature-note">(Ký và ghi rõ họ tên)</div>
                <div class="signature-space"></div>
            </td>
        </tr>
    </table>
</div>

</body>
</html>
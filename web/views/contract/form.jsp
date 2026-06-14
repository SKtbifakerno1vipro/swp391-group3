<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>${contract == null ? 'Tạo mới' : 'Chỉnh sửa'} Hợp đồng</title>
        <style>
            #contract-body {
                border: 1px solid #999;
                padding: 20px;
                min-height: 500px;
                background: #fff;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <h2>${contract == null ? 'Tạo Hợp đồng mới' : 'Chỉnh sửa Hợp đồng'}</h2>

        <!-- Gửi POST tới contract-save -->
        <form action="contract-save" method="POST" id="contractForm" onsubmit="prepareContent()">
            <!-- Dùng cho Update -->
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <!-- Dùng cho Create (khi bấm tạo từ Quotation) -->
            <input type="hidden" name="quotationId" value="${quotationId}">

            <label>Số Hợp đồng:</label>
            <input type="text" name="contractNumber" value="${contract.contractNumber}" required>

            <br><br>

            <label>Nội dung hợp đồng (Có thể chỉnh sửa trực tiếp):</label>
            <!-- Sử dụng thẻ div với contenteditable="true" để trình duyệt render HTML -->
            <div id="contract-body" 
                 style="border: 1px solid #ccc; padding: 20px; min-height: 500px; background: white; margin-top: 10px;"
                 contenteditable="true">
                ${not empty contract.contractContent ? contract.contractContent : templateContent}
            </div>

            <!-- Input ẩn quan trọng để gửi HTML về Controller -->
            <input type="hidden" name="contractContent" id="contractContentInput">

            <br>
            <!-- Nút lưu cần gọi hàm JS để lấy dữ liệu từ DIV -->
            <button type="submit" onclick="prepareContent()">Lưu Hợp đồng</button>


            <script>
                function prepareContent() {
                    // Lấy nội dung từ div đã render HTML
                    var content = document.getElementById('contract-body').innerHTML;
                    // Gán vào input ẩn
                    document.getElementById('contractContentInput').value = content;
                }
            </script>
    </body>
</html>
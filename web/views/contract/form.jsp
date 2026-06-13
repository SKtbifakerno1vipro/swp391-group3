<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>${contract == null ? 'Tạo mới' : 'Chỉnh sửa'} Hợp đồng</title>
        <style>
            #contract-body {
                border: 1px solid #ccc;
                padding: 20px;
                min-height: 300px;
                background: white;
            }
        </style>
    </head>
    <body>
        <h2>${contract == null ? 'Tạo Hợp đồng mới' : 'Chỉnh sửa Hợp đồng'}</h2>

        <form action="contract-save" method="POST" id="contractForm">
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <input type="hidden" name="quotationId" value="${quotation.quotationId}">

            <label>Số Hợp đồng:</label>
            <input type="text" name="contractNumber" value="${contract.contractNumber}" required>

            <br><br>
            <label>Nội dung hợp đồng:</label>
            <!-- Đây là khu vực chỉnh sửa trực quan -->
            <div id="contract-body" contenteditable="true">${contract.contractContent != null ? contract.contractContent : templateContent}</div>

            <!-- Input ẩn để lưu nội dung từ div vào server -->
            <input type="hidden" name="contractContent" id="contractContentInput">

            <br>
            <button type="submit" onclick="prepareContent()">Lưu Hợp đồng</button>
        </form>

        <script>
            function prepareContent() {
                // Copy nội dung từ div vào input ẩn trước khi submit
                document.getElementById('contractContentInput').value = document.getElementById('contract-body').innerHTML;
            }
        </script>
    </body>
</html>
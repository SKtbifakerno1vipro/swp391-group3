<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${contract == null ? 'Create' : 'Edit'} Contract</title>
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
        <c:if test="${not empty errorMsg}">
            <div style="color: red; border: 1px solid red; padding: 10px; margin-bottom: 15px;">
                ${errorMsg}
            </div>
        </c:if>
        <h2>${contract == null ? 'Create Contract' : 'Edit Contract'}</h2>

        <!-- Form gửi POST tới contract-save -->
        <form action="contract-save" method="POST" id="contractForm" onsubmit="prepareContent()">
            <!-- Dùng cho Update -->
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <!-- Dùng cho Create (khi bấm tạo từ Quotation) -->
            <input type="hidden" name="quotationId" value="${quotationId}">
            <input type="hidden" name="customerId" value="${customerId}">

            <!-- Hiển thị mã nếu đã có (Edit mode) -->
            <c:if test="${not empty contract.contractNumber}">
                <label><strong>Contract Number:</strong></label>
                <input type="text" value="${contract.contractNumber}" readonly style="border:none; background:transparent; font-weight:bold;">
                <br><br>
            </c:if>

            <br><br>

            <label>Contract Content (Can edit directly):</label>
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
            <button type="submit" onclick="prepareContent()">${contract == null ? 'Create' : 'Save'} Contract</button>
            <div><a href="contract-list">Back to contract list</a></div>

            <script>
                function prepareContent() {
                    var content = document.getElementById('contract-body').innerHTML;
                    document.getElementById('contractContentInput').value = content;
                }
            </script>
        </form>
    </body>
</html>
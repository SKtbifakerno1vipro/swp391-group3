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
            .btn {
                padding: 10px 20px;
                margin-right: 10px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <c:if test="${not empty errorMsg}">
            <div style="color: red; border: 1px solid red; padding: 10px; margin-bottom: 15px;">${errorMsg}</div>
        </c:if>
        <h2>${contract == null ? 'Create Contract' : 'Edit Contract'}</h2>

        <!-- Form gửi POST tới contract-save -->
        <form action="contract-save" method="POST" id="contractForm">
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <input type="hidden" name="quotationId" value="${quotationId}">
            <input type="hidden" name="customerId" value="${customerId}">
            <input type="hidden" name="action" id="actionInput">
            <input type="hidden" name="contractContent" id="contractContentInput">

            <c:if test="${not empty contract.contractNumber}">
                <p><strong>Contract Number:</strong> ${contract.contractNumber}</p>
            </c:if>

            <label>Contract Content:</label>
            <div id="contract-body" 
                 style="border: 1px solid #ccc; padding: 20px; min-height: 500px; background: white; margin-top: 10px;"
                 contenteditable="${editable ? 'true' : 'false'}">
                ${not empty contract.contractContent ? contract.contractContent : templateContent}
            </div>

            <br>
            <c:if test="${editable}">
                <button type="button" class="btn" onclick="submitForm('save')">Save Changes</button>

                <c:if test="${sessionScope.user.roleId == 2}">
                    <button type="button" class="btn" onclick="submitForm('manager_approve')" style="background:green; color:white;">Lưu & Duyệt (Approve)</button>
                </c:if>

                <c:if test="${sessionScope.user.roleId == 5}">
                    <button type="button" class="btn" onclick="submitForm('submit_for_review')" style="background:blue; color:white;">Gửi duyệt lại</button>
                </c:if>
            </c:if>

            <div style="margin-top: 20px;"><a href="contract-list">Back to contract list</a></div>

            <script>
                function submitForm(action) {
                    var content = document.getElementById('contract-body').innerHTML;
                    document.getElementById('contractContentInput').value = content;
                    document.getElementById('actionInput').value = action;
                    document.getElementById('contractForm').submit();
                }
            </script>
        </form>
    </body>
</html>
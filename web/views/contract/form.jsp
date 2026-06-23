<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${contract == null ? 'Create' : 'Edit'} Contract</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
                background-color: #f8f9fa;
            }

            #contract-body {
                border: 1px solid #ccc;
                padding: 20px;
                min-height: 500px;
                background: #fff;
                margin-top: 10px;
                border-radius: 4px;
            }

            .btn {
                padding: 10px 20px;
                margin-right: 10px;
                cursor: pointer;
                border: none;
                border-radius: 4px;
                font-weight: bold;
            }

            .btn-save {
                background: #007bff;
                color: white;
            }

            .btn-approve {
                background: #28a745;
                color: white;
            }

            .btn-review {
                background: #0056b3;
                color: white;
            }
        </style>
    </head>

    <body>
        <c:if test="${not empty errorMsg}">
            <div style="color: red; border: 1px solid red; padding: 10px; margin-bottom: 15px;">${errorMsg}</div>
        </c:if>

        <h2>${contract == null ? 'Create Contract' : 'Edit Contract'}</h2>

        <form action="contract-save" method="POST" id="contractForm">
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <input type="hidden" name="quotationId" value="${quotationId}">
            <input type="hidden" name="customerId" value="${customerId}">
            <input type="hidden" name="action" id="actionInput">
            <input type="hidden" name="contractContent" id="contractContentInput">

            <c:if test="${not empty contract.contractNumber}">
                <p><strong>Contract Number:</strong> ${contract.contractNumber}</p>
            </c:if>

            <label style="font-weight:bold;">Contract Content:</label>
            <div id="contract-body" contenteditable="${editable ? 'true' : 'false'}"
                 style="border: 1px solid #ccc; padding: 20px; min-height: 500px; background: ${editable ? 'white' : '#f9f9f9'}; margin-top: 10px;">
                ${not empty contract.contractContent ? contract.contractContent : templateContent}
            </div>

            <br>
            <c:if test="${editable}">
                <button type="button" class="btn btn-save" onclick="submitForm('save')">Save Changes</button>

                <c:if test="${contract != null}">
       
                    <!--officier-->
                    <c:if test="${sessionScope.user.roleId == 5}">
                        <button type="button" class="btn btn-review" onclick="submitForm('submit_for_review')">Send to review</button>
                    </c:if>
                </c:if>
            </c:if>

            <div style="margin-top: 20px;"><a href="contract-list">Back to contract list</a></div>

            <script>
                function submitForm(action) {
        
                    document.getElementById('contractContentInput').value = document.getElementById('contract-body').innerHTML;
                    document.getElementById('actionInput').value = action;
                    document.getElementById('contractForm').submit();
                }
            </script>
        </form>
    </body>

</html>
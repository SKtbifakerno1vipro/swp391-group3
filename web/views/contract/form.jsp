<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>${contract == null ? 'To mi' : 'Chnh sa'} Hp ng</title>
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
        <h2>${contract == null ? 'To Hp ng mi' : 'Chnh sa Hp ng'}</h2>

        <!-- Gi POST ti contract-save -->
        <form action="contract-save" method="POST" id="contractForm" onsubmit="prepareContent()">
            <!-- Dng cho Update -->
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <!-- Dng cho Create (khi bm to t Quotation) -->
            <input type="hidden" name="quotationId" value="${quotationId}">

            <label>S Hp ng:</label>
            <input type="text" name="contractNumber" value="${contract.contractNumber}" required>

            <br><br>

            <label>Ni dung hp ng (C th chnh sa trc tip):</label>
            <!-- S dng th div vi contenteditable="true"  trnh duyt render HTML -->
            <div id="contract-body" 
                 style="border: 1px solid #ccc; padding: 20px; min-height: 500px; background: white; margin-top: 10px;"
                 contenteditable="true">
                ${not empty contract.contractContent ? contract.contractContent : templateContent}
            </div>

            <!-- Input n quan trng  gi HTML v Controller -->
            <input type="hidden" name="contractContent" id="contractContentInput">

            <br>
            <!-- Nt lu cn gi hm JS  ly d liu t DIV -->
            <button type="submit" onclick="prepareContent()">Lu Hp ng</button>


            <script>
                function prepareContent() {
                    
                    var content = document.getElementById('contract-body').innerHTML;
                    
                    document.getElementById('contractContentInput').value = content;
                }
            </script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>${contract == null ? 'Táº¡o má»›i' : 'Chá»‰nh sá»­a'} Há»£p Ä‘á»“ng</title>
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
        <h2>${contract == null ? 'Táº¡o Há»£p Ä‘á»“ng má»›i' : 'Chá»‰nh sá»­a Há»£p Ä‘á»“ng'}</h2>

        <!-- Gá»­i POST tá»›i contract-save -->
        <form action="contract-save" method="POST" id="contractForm" onsubmit="prepareContent()">
            <!-- DÃ¹ng cho Update -->
            <input type="hidden" name="contractId" value="${contract.contractId}">
            <!-- DÃ¹ng cho Create (khi báº¥m táº¡o tá»« Quotation) -->
            <input type="hidden" name="quotationId" value="${quotationId}">

            <label>Sá»‘ Há»£p Ä‘á»“ng:</label>
            <input type="text" name="contractNumber" value="${contract.contractNumber}" required>

            <br><br>

            <label>Ná»™i dung há»£p Ä‘á»“ng (CÃ³ thá»ƒ chá»‰nh sá»­a trá»±c tiáº¿p):</label>
            <!-- Sá»­ dá»¥ng tháº» div vá»›i contenteditable="true" Ä‘á»ƒ trÃ¬nh duyá»‡t render HTML -->
            <div id="contract-body" 
                 style="border: 1px solid #ccc; padding: 20px; min-height: 500px; background: white; margin-top: 10px;"
                 contenteditable="true">
                ${not empty contract.contractContent ? contract.contractContent : templateContent}
            </div>

            <!-- Input áº©n quan trá»ng Ä‘á»ƒ gá»­i HTML vá» Controller -->
            <input type="hidden" name="contractContent" id="contractContentInput">

            <br>
            <!-- NÃºt lÆ°u cáº§n gá»i hÃ m JS Ä‘á»ƒ láº¥y dá»¯ liá»‡u tá»« DIV -->
            <button type="submit" onclick="prepareContent()">LÆ°u Há»£p Ä‘á»“ng</button>


            <script>
                function prepareContent() {
                    
                    var content = document.getElementById('contract-body').innerHTML;
                    
                    document.getElementById('contractContentInput').value = content;
                }
            </script>
    </body>
</html>

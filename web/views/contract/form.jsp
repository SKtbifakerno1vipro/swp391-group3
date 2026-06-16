<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${contract == null ? 'Create' : 'Edit'} Contract - Po Bread Sales</title>
        <style>
            #contract-body {
                border: 1px solid #ccc;
                padding: 20px;
                min-height: 500px;
                background: #fff;
                margin-top: 10px;
                border-radius: 16px;
            }
        </style>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="contracts"/>
            </jsp:include>
            <main class="main legacy-page">
                <c:if test="${not empty errorMsg}">
                    <div style="color: #b83230; border: 1px solid #ffdad8; background:#ffdad8; padding: 10px; margin-bottom: 15px; border-radius: 12px;">
                        ${errorMsg}
                    </div>
                </c:if>

                <h2>${contract == null ? 'Create New Contract' : 'Edit Contract'}</h2>

                <form action="contract-save" method="POST" id="contractForm" onsubmit="prepareContent()">
                    <input type="hidden" name="contractId" value="${contract.contractId}">
                    <input type="hidden" name="quotationId" value="${quotationId}">

                    <label>Contract Number:</label>
                    <input type="text" name="contractNumber" value="${contract.contractNumber}" required>

                    <br><br>

                    <label>Contract Content (editable):</label>
                    <div id="contract-body" contenteditable="true">
                        ${not empty contract.contractContent ? contract.contractContent : templateContent}
                    </div>

                    <input type="hidden" name="contractContent" id="contractContentInput">

                    <br>
                    <button type="submit" onclick="prepareContent()">Save Contract</button>
                    <a href="${pageContext.request.contextPath}/contract-list">Back to contracts</a>
                </form>

                <script>
                    function prepareContent() {
                        var content = document.getElementById('contract-body').innerHTML;
                        document.getElementById('contractContentInput').value = content;
                    }
                </script>
            </main>
        </div>
    </body>
</html>

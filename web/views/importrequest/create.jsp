<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tạo yêu cầu nhập kho</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="import-requests"/>
            </jsp:include>
            <main class="main legacy-page">
                <h1>Tạo yêu cầu nhập kho mới</h1>

                <c:if test="${not empty error}">
                    <p style="color: red; font-weight: bold;">Lỗi: ${error}</p>
                </c:if>

                <form action="${pageContext.request.contextPath}/import-request-create" method="post" style="max-width: 600px; background-color: #f9f9f9; padding: 20px; border-radius: 5px; border: 1px solid #e0e0e0;">
                    
                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-weight: bold; margin-bottom: 5px;">Sản phẩm:</label>
                        <select name="productId" required style="width: 100%; padding: 8px; box-sizing: border-box;">
                            <option value="">-- Chọn sản phẩm --</option>
                            <c:forEach items="${products}" var="p">
                                <option value="${p.productId}">${p.productName} (${p.unit}) - Hiện có: ${p.quantityAvailable}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-weight: bold; margin-bottom: 5px;">Số lượng nhập:</label>
                        <input type="number" name="quantity" min="1" required style="width: 100%; padding: 8px; box-sizing: border-box;">
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-weight: bold; margin-bottom: 5px;">Ghi chú:</label>
                        <textarea name="note" rows="4" style="width: 100%; padding: 8px; box-sizing: border-box; resize: vertical;"></textarea>
                    </div>

                    <div style="margin-top: 20px;">
                        <button type="submit" style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Gửi yêu cầu</button>
                        <a href="${pageContext.request.contextPath}/import-request-list" style="margin-left: 10px; text-decoration: none;">
                            <button type="button" style="padding: 10px 20px; background-color: #9e9e9e; color: white; border: none; cursor: pointer;">Quay lại</button>
                        </a>
                    </div>
                </form>
            </main>
        </div>
    </body>
</html>

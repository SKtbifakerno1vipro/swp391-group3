<%--
    Document   : create
    Created on : May 30, 2026, 2:42:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib  uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thêm sản phẩm</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="products"/>
            </jsp:include>
            <main class="main legacy-page">
        <div>
            <h1>Thêm sản phẩm</h1>
            <div>
                <form action="edit-product" method="post">
                    <c:if test="${error != null}">
                        <div style="color: var(--danger); background: var(--danger-soft); border: 1px solid var(--line); padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 13px; font-weight: 700;">
                            ${error}
                        </div>
                    </c:if>
                    <table>
                        <tr>
                            <td>Tên sản phẩm</td>
                            <td><input type="text" name="name" value="${name}" required></td>
                        </tr>
                        <tr>
                            <td>Giá gốc</td>
                            <td><input type="number" name="cost" value="${cost}" required min="0"></td>
                        </tr>
                        <tr>
                            <td>Giá bán</td>
                            <td><input type="number" name="sell" value="${sell}" required min="0"></td>
                        </tr>
                        <tr>
                            <td>Mô tả</td>
                            <td><textarea name="description" rows="5" cols="20" required>${description}</textarea></td>
                        </tr>
                        <tr>
                            <td>Đơn vị</td>
                            <td><input type="text" name="unit" value="${unit}" required></td>
                        </tr>
                        <tr>
                            <td>Trạng thái sản phẩm</td>
                            <td>
                                <select name="status">
                                    <option value="ACTIVE" ${status == 'ACTIVE' || status == 'Active' || empty status ? 'selected' : ''}>Hoạt động</option>
                                    <option value="OUT_OF_STOCK" ${status == 'OUT_OF_STOCK' || status == 'OUT OF STOCK' || status == 'Out of stock' ? 'selected' : ''}>Hết hàng</option>
                                    <option value="INACTIVE" ${status == 'INACTIVE' || status == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Số lượng</td>
                            <td><input type="number" name="quantity" value="${quantity}" required min="0"></td>
                        </tr>
                        <tr>
                            <td>Danh mục</td>
                            <td>
                                <select name="categoryId">
                                    <c:forEach var="c" items="${categories}">
                                        <option value="${c.categoryId}" ${c.categoryId == categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                        <input type="hidden" name="action" value="${action}">
                            <td colspan="2"><input type="submit"  value="Thêm mới">
                                <a href="${pageContext.request.contextPath}/product-list">Hủy</a></td>
                        </tr>

                    </table>
                    
                </form>
            </div>
        </div>


            </main>
        </div>
    </body>
</html>

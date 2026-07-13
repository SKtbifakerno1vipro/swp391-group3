<%--
    Document   : detail
    Created on : May 31, 2026, 12:57:11 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết sản phẩm</title>

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
                    <c:if test="${action == 'detail'}">
                        <h1>Chi tiết sản phẩm</h1>
                    </c:if>
                    <c:if test="${action != 'detail'}">
                        <h1>Chỉnh sửa sản phẩm</h1>
                    </c:if>
                    <c:if test="${error != null}" >
                        <p>${error}</p>
                    </c:if>
                    <div>
                        <form action="edit-product" method="post">
                            <table border="1">
                                <input type="hidden" name="id" value="${product.productId}">
                                <input type="hidden" name="action" value="${action}">
                                <tr>
                                    <td>Tên sản phẩm</td>
                                    <td><input type="text" name="name" value="${product.productName}" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <tr>
                                    <td>Giá gốc</td>
                                    <fmt:formatNumber var="fmtCost" value="${product.costPrice}" pattern="#"/>
                                    <td><input type="number"  name="cost" value="${fmtCost}" min="0" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <tr>
                                    <td>Giá bán</td>
                                    <fmt:formatNumber var="fmtSell" value="${product.sellingPrice}" pattern="#"/>
                                    <td><input type="number" name="sell" value="${fmtSell}" min="0" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <tr>
                                    <td>Mô tả</td>
                                    <td><textarea name="description" rows="5" cols="20" ${action != 'detail' ? ' ' : 'readonly'} required>${product.description}</textarea></td>
                                </tr>
                                <tr>
                                    <td>Đơn vị</td>
                                    <td><input type="text" name="unit" value="${product.unit}" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <tr>
                                    <td>Trạng thái sản phẩm</td>
                                    <td>
                                        <select name="status" ${action != 'detail' ? ' ' : 'disabled'}>
                                            <option value="ACTIVE" ${product.productStatus == 'ACTIVE' || product.productStatus == 'Active' ? 'selected' : ''}>Hoạt động</option>
                                            <option value="OUT_OF_STOCK" ${product.productStatus == 'OUT_OF_STOCK' || product.productStatus == 'OUT OF STOCK' || product.productStatus == 'Out of stock' ? 'selected' : ''}>Hết hàng</option>
                                            <option value="INACTIVE" ${product.productStatus == 'INACTIVE' || product.productStatus == 'Inactive' ? 'selected' : ''}>Không hoạt động</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Số lượng</td>
                                    <td><input type="number" name="quantity" value="${product.quantityAvailable}" min="0" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <tr>
                                    <td>Danh mục</td>
                                    <td>
                                        <select name="categoryId" ${action != 'detail' ? ' ' : 'disabled'}>
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c.categoryId}" ${c.categoryId == product.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <c:if test="${action == 'detail'}">
                                    <tr>
                                        <td>Ngày tạo</td>
                                        <td><fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>

                                    </tr>
                                    <tr>
                                    <input type="hidden" name="update_at" value="${product.updatedAt}">
                                    <td>Ngày cập nhật</td>
                                    <td><fmt:formatDate value="${product.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>

                                    </tr>
                                </c:if>
                                <tr>
                                    <td>Người cập nhật</td>
                                    <td><input type="text" name="update_by" value="${product.updatedBy}" readonly></td>
                                </tr>
                            </table>

                            <div>
                                <c:if test="${action == 'detail'}">
                                    <a href="pageContext.request.contextPath/edit - product?id ={product.productId}&action=edit"><button type="button">Chỉnh sửa</button></a>
                                </c:if> 
                                <c:if test="${action == 'edit'}">
                                    <input type="submit" value="Lưu">
                                </c:if>

                                <a href="${pageContext.request.contextPath}/product-list">Hủy</a></div>
                        </form>
                    </div>
                </div>

            </main>
        </div>
    </body>
</html>

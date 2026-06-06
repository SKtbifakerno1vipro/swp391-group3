<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách danh mục</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Quản lý danh mục sản phẩm</h2>

    <c:if test="${param.status == 'add_success'}">
        <div style="color: green; margin-bottom: 10px;">Thêm danh mục thành công!</div>
    </c:if>
    <c:if test="${param.status == 'edit_success'}">
        <div style="color: green; margin-bottom: 10px;">Cập nhật danh mục thành công!</div>
    </c:if>
    <c:if test="${param.status == 'delete_success'}">
        <div style="color: green; margin-bottom: 10px;">Xóa danh mục thành công!</div>
    </c:if>
    <c:if test="${param.status == 'delete_in_use'}">
        <div style="color: red; margin-bottom: 10px;">Không thể xóa danh mục đang được sử dụng bởi sản phẩm!</div>
    </c:if>
    <c:if test="${param.status == 'not_found'}">
        <div style="color: red; margin-bottom: 10px;">Không tìm thấy danh mục!</div>
    </c:if>
    <c:if test="${param.status == 'delete_failed' || param.status == 'edit_failed'}">
        <div style="color: red; margin-bottom: 10px;">Thao tác thất bại, vui lòng thử lại!</div>
    </c:if>

    <div style="margin-bottom: 15px;">
        <a href="${pageContext.request.contextPath}/category/create">Thêm danh mục</a> |
        <a href="${pageContext.request.contextPath}/product-list">Product</a> |
        <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>Category ID</th>
                <th>Category Name</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty categoryList}">
                <tr>
                    <td colspan="3">Không có danh mục nào.</td>
                </tr>
            </c:if>

            <c:forEach var="category" items="${categoryList}">
                <tr>
                    <td>${category.categoryId}</td>
                    <td>${category.categoryName}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/category/edit?categoryId=${category.categoryId}">Sửa</a>
                        <a href="${pageContext.request.contextPath}/category/delete?categoryId=${category.categoryId}"
                           onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>

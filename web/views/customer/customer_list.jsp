<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sach khach hang</title>
    </head>
    <body>

        <h2>Danh sach khach hang</h2>
        <h2>Quá quản lý danh sách khách hàng (Hệ thống thành viên)</h2>
        <a href="{pageContext.request.contextPath}"> Add Customer</a>
        <table>
            <thead>
                <tr>
                    <th>Ma customer (ID) </th>
                    <th>Ten khach hang‹</th>
                    <th>Email</th>
                    <th>So dien thoai</th>
                    <th>Ma so thue</th>
                    <th>Trang thai</th>
                    <th>Created At</th>
                    <th>Updated At</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty customerList}">
                    <tr>
                        <td colspan="7">Khong co du lieu khach hang</td>
                    </tr>
                </c:if>

                <c:forEach var="cust" items="${customerList}">
                    <tr>
                        <td>${cust.customer.customerId}</td>
                        <td><strong>${cust.user.fullName}</strong></td>
                        <td>${cust.user.email}</td>
                        <td>${cust.user.phone}</td>
                        <td>${cust.customer.taxCode}</td>
                        <td><span>${cust.user.status}</span></td>
                        <td>${customer.createAt}</td>
                        <td>${customer.updateAt}</td>
                        <td><a href="${pageContext.request.contextPath}/customer/edit?id=${cust.customer.customerId}">Edit</a></td>
                            
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
        <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

        <c:if test="${totalPages > 1}">
            <div style="margin-top: 16px;">
                <c:set var="startPage" value="${currentPage - 9}" />
                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                </c:if>

                <c:set var="endPage" value="${startPage + 19}" />
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}" />
                </c:if>

                <c:if test="${(endPage - startPage) < 19 && startPage > 1}">
                    <c:set var="startPage" value="${endPage - 19}" />
                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1" />
                    </c:if>
                </c:if>

                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/customer-list?page=${currentPage - 1}">&lt;</a>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #999;">&lt;</span>
                    </c:otherwise>
                </c:choose>

                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <strong style="margin: 0 6px;">${i}</strong>
                        </c:when>
                        <c:otherwise>
                            <a style="margin: 0 6px;" href="${pageContext.request.contextPath}/customer-list?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/customer-list?page=${currentPage + 1}">&gt;</a>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #999;">&gt;</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

    </body>
</html>


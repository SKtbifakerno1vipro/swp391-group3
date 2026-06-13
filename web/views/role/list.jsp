<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Pơ Bread - Role Management</title>
    </head>
    <body>
        <jsp:include page="/views/shared/menu.jsp" />

        <h2>Role Management</h2>
        <p><a href="${pageContext.request.contextPath}/add-role">Add Role</a></p>
        <form action="role-list" method="get">
            <input type="text" name="search" value ="${searchText}">
            <button type="submit">Search</button>
        </form>


        <table border="1" cellpadding="6" cellspacing="0">
            <thead>
                <tr>
                    <th>Role ID</th>
                    <th>Role Name</th> 
                    <th>Created At</th>
                    <th>Updated At</th>
                    <th>Actions</th>

                </tr>
            </thead>
            <tbody>

                <c:if test="${empty roleList}">
                    <tr>
                        <td colspan="6">No roles found.</td>
                    </tr>
                </c:if>

                <c:forEach var="role" items="${roleList}">
                    <tr>
                        <td>R-${role.roleId}</td>
                        <td>${role.roleName}</td>
                        <td>${role.createAt}</td>
                        <td>${role.updateAt}</td> 

                        <td>
                            <a href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}">View</a>
                            <a href="${pageContext.request.contextPath}/edit-role-permissions?roleId=${role.roleId}">Permissions</a>
                        </td>


                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <div class="pagination">

            <!-- Nút Lùi -->
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/role-list?page=${currentPage - 1}&search=${searchText}">&lt;</a>
            </c:if>

            <!-- Các nút Số trang -->
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/role-list?page=${i}&search=${searchText}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <!-- Nút Tiến -->
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/role-list?page=${currentPage + 1}&search=${searchText}">&gt;</a>
            </c:if>

        </div>

        <a href="${pageContext.request.contextPath}/dashboard">
            Back to Dash Board
        </a>
    </body>
</html>

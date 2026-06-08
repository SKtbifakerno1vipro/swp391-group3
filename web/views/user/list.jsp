<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User List</title>
    </head>
    <body>

        <div>
            <h1>User List</h1>

            <form method="get" action="${pageContext.request.contextPath}/user-list">
                <label for="roleId">Role:</label>
                <select name="roleId">
                    <option value="">All</option>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.roleId}" ${r.roleId == roleId ? 'selected' : ''}>${r.roleName}</option>
                    </c:forEach>
                </select>

                <label for="status">Status</label>
                <select id="status" name="status">
                    <option value="" ${empty status ? 'selected' : ''}>ALL</option>
                    <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                    <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                </select>

                <label for="keyword">Keyword</label>
                <input type="text" name="keyword">
                <button type="submit">Filter</button>
            </form>

            <p><a href="${pageContext.request.contextPath}/create-user">Create New User</a></p>

            <table border="1" cellpadding="6" cellspacing="0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="8">No users found.</td>

                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>${u.userId}</td>
                                    <td>${u.userName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.phone}</td>
                                    <td>${u.status}</td>
                                    <td>${u.roleName}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/user-detail?id=${u.userId}">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>


        <%-- Cấu hình hiển thị --%>
        <c:set var="windowSize" value="4" />   
        <c:set var="start" value="${currentPage - windowSize > 1 ? currentPage - windowSize : 1}" />
        <c:set var="end" value="${currentPage + windowSize < endPage ? currentPage + windowSize : endPage}" />

        <div class="d-flex justify-content-center my-3">
            <div class="btn-group border shadow-sm">

                <!-- Đầu & Trước -->
                <a href="user-list?page=1&keyword=${keyword}&roleId=${roleId}&status=${status}" 
                   class="btn btn-outline-secondary ${currentPage == 1 ? 'disabled' : ''}">&lt;&lt;</a>

                <a href="user-list?page=${currentPage - 1}&keyword=${keyword}&roleId=${roleId}&status=${status}" 
                   class="btn btn-outline-secondary ${currentPage == 1 ? 'disabled' : ''}">&lt;</a>

                <!-- Dấu ... đầu -->
                <c:if test="${start > 1}">
                    <span class="btn btn-outline-secondary disabled">...</span>
                </c:if>

                <!-- Các số trang -->
                <c:forEach begin="${start}" end="${end}" var="i">
                    <a href="user-list?page=${i}&keyword=${keyword}&roleId=${roleId}&status=${status}" 
                       class="btn ${currentPage == i ? 'btn-primary' : 'btn-outline-secondary'}">
                        ${i}
                    </a>
                </c:forEach>

                <!-- Dấu ... cuối -->
                <c:if test="${end < endPage}">
                    <span class="btn btn-outline-secondary disabled">...</span>
                </c:if>

                <!-- Sau & Cuối -->
                <a href="user-list?page=${currentPage + 1}&keyword=${keyword}&roleId=${roleId}&status=${status}" 
                   class="btn btn-outline-secondary ${currentPage == endPage ? 'disabled' : ''}">&gt;</a>

                <a href="user-list?page=${endPage}&keyword=${keyword}&roleId=${roleId}&status=${status}" 
                   class="btn btn-outline-secondary ${currentPage == endPage ? 'disabled' : ''}">&gt;&gt;</a>

            </div>
        </div>

    </body>
</html>
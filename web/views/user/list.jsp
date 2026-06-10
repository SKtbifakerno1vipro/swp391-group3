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

        <h1>User List</h1>

        <form method="get" action="${pageContext.request.contextPath}/user-list">
            <div style="margin-bottom: 10px;">
                <input type="text" name="searchName" placeholder="Search by Name..." value="${searchName}">
                <input type="text" name="searchPhone" placeholder="Search by Phone..." value="${searchPhone}">
                <input type="text" name="searchEmail" placeholder="Search by Email..." value="${searchEmail}">

                <select name="roleId">
                    <option value="0">All Roles</option>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.roleId}" ${r.roleId == roleId ? 'selected' : ''}>${r.roleName}</option>
                    </c:forEach>
                </select>

                <select name="status">
                    <option value="" ${empty status ? 'selected' : ''}>All Status</option>
                    <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                    <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                </select>

                <button type="submit">Search</button>
            </div>
        </form>

        <p><a href="${pageContext.request.contextPath}/edit-user">Create New User</a></p>

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
                    <th>Toggle</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty users}">
                        <tr><td colspan="8">No users found.</td></tr>
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
                                    <a href="${pageContext.request.contextPath}/edit-user?id=${u.userId}">Edit</a>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/user-list" method="post" style="display:inline;">
                                        <!-- Truyền ID và Status hiện tại của User -->
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <input type="hidden" name="status" value="${u.status}">

                                        <button type="submit" 
                                                onclick="return confirm('Bạn có chắc chắn muốn ${u.status == 'ACTIVE' ? 'KHÓA' : 'MỞ KHÓA'} người dùng này?')"
                                                style="background: none; border: none; color: ${u.status == 'ACTIVE' ? 'red' : 'green'}; cursor: pointer; text-decoration: underline; padding: 0;">
                                            ${u.status == 'ACTIVE' ? 'Ban' : 'Unban'}
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>


        <c:if test="${endPage >1}">
            <%-- cấu hình hiển thị --%>
            <c:set var="windowSize" value="2" />   
            <c:set var="start" value="${currentPage - windowSize > 1 ? currentPage - windowSize : 1}" />
            <c:set var="end" value="${currentPage + windowSize < endPage ? currentPage + windowSize : endPage}" />

            <div class="d-flex justify-content-center my-3">
                <div class="btn-group border shadow-sm">

                    <!-- Đầu & Trước (<<) -->
                    <a href="user-list?page=1&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}" 
                       class="btn btn-outline-secondary ${currentPage == 1 ? 'disabled' : ''}">&lt;&lt;</a>

                    <a href="user-list?page=${currentPage - 1}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}" 
                       class="btn btn-outline-secondary ${currentPage == 1 ? 'disabled' : ''}">&lt;</a>

                    <!-- Dấu ... đầu -->
                    <c:if test="${start > 1}">
                        <span class="btn btn-outline-secondary disabled">...</span>
                    </c:if>

                    <!-- Các số trang -->
                    <c:forEach begin="${start}" end="${end}" var="i">
                        <a href="user-list?page=${i}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}" 
                           class="btn ${currentPage == i ? 'btn-primary' : 'btn-outline-secondary'}">
                            ${i}
                        </a>
                    </c:forEach>

                    <!-- Dấu ... cuối -->
                    <c:if test="${end < endPage}">
                        <span class="btn btn-outline-secondary disabled">...</span>
                    </c:if>

                    <!-- Sau & Cuối (>>) -->
                    <c:if test="${currentPage <endPage}">
                        <a href="user-list?page=${currentPage + 1}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}" 
                           class="btn btn-outline-secondary ${currentPage == endPage ? 'disabled' : ''}">&gt;</a>
                    </c:if>
                    <a href="user-list?page=${endPage}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}" 
                       class="btn btn-outline-secondary ${currentPage == endPage ? 'disabled' : ''}">&gt;&gt;</a>

                </div>
            </div>
        </c:if>

    </body>
</html>
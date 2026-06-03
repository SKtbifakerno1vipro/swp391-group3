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


        <div class="d-flex align-items-center justify-content-end my-3">
            <span class="me-2">Chuyển đến trang: </span>


            <select class="form-select w-auto" onchange="window.location.href = this.value">


                <c:forEach begin="1" end="${endPage}" var="i">


                    <c:set var="pageUrl" value="user-list?page=${i}&keyword=${keyword}&roleId=${roleId}&status=${status}" />


                    <option value="${pageUrl}" ${currentPage == i ? 'selected' : ''}>
                        Page: ${i} 
                    </option>

                </c:forEach>

            </select>
        </div>

    </body>
</html>
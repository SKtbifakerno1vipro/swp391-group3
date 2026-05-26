<%-- 
    Document   : CreateCustomer
    Created on : May 21, 2026
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Customer</title>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    
    
</head>
<body>
    <main>
        <div>
            <h1>Create Customer</h1>
            <c:if test="${not empty success}">
                <div>Create successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div>Create failed</div>
                <c:if test="${not empty errorDetail}">
                    <div>${errorDetail}</div>
                </c:if>
            </c:if>
            <form action="CreateCustomer" method="post">
                <div>
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div>
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div>
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div>
                    <label for="fullname">Full Name</label>
                    <input type="text" id="fullname" name="fullname">
                </div>
                <div>
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone">
                </div>
                <div>
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
                <div>
                    <label for="role">Role</label>
                    <input type="hidden" name="roleId" value="${customerRoleId}">
                    <span>Customer</span>
                </div>
                <div>
                    <label for="taxCode">Tax Code</label>
                    <input type="text" id="taxCode" name="taxCode" required>
                </div>
                <div>
                    <label for="type">Type</label>
                    <input type="text" id="type" name="type" required>
                </div>
                <div>
                    <label for="createBy">Created By</label>
                    <select id="createBy" name="createBy" required>
                        <option value="">Choose staff</option>
                        <c:forEach var="user" items="${users}">
                            <option value="${user.userId}">${user.fullName != null && !user.fullName.isEmpty() ? user.fullName : user.userName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <button type="submit">Create</button>
                    <a href="dashboard">Cancel</a>
                </div>
            </form>
        </div>
    </main>
</body>
</html>



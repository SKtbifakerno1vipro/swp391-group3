<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Role"%>

<%
    Role role = (Role) request.getAttribute("role");

    if (role == null) {
        response.sendRedirect(request.getContextPath() + "/role-list");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Role</title>
    
</head>

<body>

<main>

    <a href="${pageContext.request.contextPath}/role-list">
        &larr; Back to Role List
    </a>

    <h1>Edit Role</h1>
    <p>Update role basic information.</p>

    <form action="${pageContext.request.contextPath}/edit-role" method="post">

        <input type="hidden" name="roleId" value="<%= role.getRoleId() %>">

        <label>Role Name</label>
        <input type="text"
               name="roleName"
               value="<%= role.getRoleName() %>"
               required>

        <div>
            <div>
                <label>Created At</label>
                <input type="text"
                       readonly
                       value="<%= role.getCreateAt() != null ? role.getCreateAt() : "-" %>">
            </div>

            <div>
                <label>Updated At</label>
                <input type="text"
                       readonly
                       value="<%= role.getUpdateAt() != null ? role.getUpdateAt() : "-" %>">
            </div>
        </div>

        <div>
            <a href="${pageContext.request.contextPath}/role-list">
                Cancel
            </a>

            <button type="submit">
                Save Changes
            </button>
        </div>

    </form>

</main>

</body>
</html>


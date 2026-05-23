<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="model.Role"%>
<%@page import="model.Permission"%>

<%
    Role role = (Role) request.getAttribute("role");
    List<Permission> permissionList = (List<Permission>) request.getAttribute("permissionList");
    Set<Integer> selectedPermissionIds = (Set<Integer>) request.getAttribute("selectedPermissionIds");

    if (role == null) {
        response.sendRedirect(request.getContextPath() + "/role-list");
        return;
    }

    if (permissionList == null) {
        permissionList = new java.util.ArrayList<>();
    }

    if (selectedPermissionIds == null) {
        selectedPermissionIds = new java.util.HashSet<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Role Permissions</title>
    
</head>

<body>

<main>

    <a href="${pageContext.request.contextPath}/role-list">
        &larr; Back to Role List
    </a>

    <h1>Edit Role Permissions</h1>
    <p>
        Manage permissions for role:
        <strong><%= role.getRoleName() %></strong>
    </p>

    <div>
        <div>
            <div>
                <p>Role ID</p>
                <p>R-<%= role.getRoleId() %></p>
            </div>

            <div>
                <p>Role Name</p>
                <p><%= role.getRoleName() %></p>
            </div>

            <div>
                <p>Created At</p>
                <p><%= role.getCreateAt() != null ? role.getCreateAt() : "-" %></p>
            </div>

            <div>
                <p>Updated At</p>
                <p><%= role.getUpdateAt() != null ? role.getUpdateAt() : "-" %></p>
            </div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/edit-role-permissions" method="post">

        <input type="hidden" name="roleId" value="<%= role.getRoleId() %>">

        <div>
            <span>
                <%= selectedPermissionIds.size() %> permissions enabled
            </span>

            <label>
                <input type="checkbox" id="selectAll">
                Select All Permissions
            </label>
        </div>

        <div>

            <div>
                System Permissions
            </div>

            <div>

                <%
                    for (Permission permission : permissionList) {
                        boolean checked = selectedPermissionIds.contains(permission.getPermissionId());
                %>

                <div>

                    <div>
                        <p><%= permission.getPermissionName() %></p>
                        <p>
                            Allow this role to access <%= permission.getPermissionName() %>.
                        </p>
                    </div>

                    <input type="checkbox"
                           name="permissionIds"
                           value="<%= permission.getPermissionId() %>"
                           <%= checked ? "checked" : "" %>>

                </div>

                <%
                    }
                %>

            </div>
        </div>

        <div>

            <a href="${pageContext.request.contextPath}/role-list">
                Cancel
            </a>

            <button type="submit">
                Save Permission Changes
            </button>

        </div>

    </form>

</main>

<script>
    const selectAll = document.getElementById("selectAll");
    const checkboxes = document.querySelectorAll(".permission-checkbox");

    selectAll.addEventListener("change", function () {
        checkboxes.forEach(cb => cb.checked = selectAll.checked);
    });
</script>

</body>
</html>


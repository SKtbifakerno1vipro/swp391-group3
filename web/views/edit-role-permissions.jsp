<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Set"%>
<%@page import="models.Role"%>
<%@page import="models.Permission"%>

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
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-[#FAF6F0] text-[#2E3230] min-h-screen">

<main class="max-w-5xl mx-auto p-10 pb-28">

    <a href="${pageContext.request.contextPath}/role-list"
       class="text-[#4A7C59] font-bold">
        ← Back to Role List
    </a>

    <h1 class="text-4xl font-bold mt-6 mb-2">Edit Role Permissions</h1>
    <p class="text-[#74796E] mb-8">
        Manage permissions for role:
        <strong><%= role.getRoleName() %></strong>
    </p>

    <div class="bg-[#F5F1EA] border border-[#E4E0D8] rounded-3xl p-8 mb-8">
        <div class="grid grid-cols-4 gap-6">
            <div>
                <p class="text-xs uppercase text-[#74796E] font-bold">Role ID</p>
                <p class="font-bold text-[#4A7C59]">R-<%= role.getRoleId() %></p>
            </div>

            <div>
                <p class="text-xs uppercase text-[#74796E] font-bold">Role Name</p>
                <p class="font-bold"><%= role.getRoleName() %></p>
            </div>

            <div>
                <p class="text-xs uppercase text-[#74796E] font-bold">Created At</p>
                <p><%= role.getCreateAt() != null ? role.getCreateAt() : "-" %></p>
            </div>

            <div>
                <p class="text-xs uppercase text-[#74796E] font-bold">Updated At</p>
                <p><%= role.getUpdateAt() != null ? role.getUpdateAt() : "-" %></p>
            </div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/edit-role-permissions" method="post">

        <input type="hidden" name="roleId" value="<%= role.getRoleId() %>">

        <div class="flex justify-between items-center mb-6">
            <span class="px-4 py-2 bg-[#D8F0DE] text-[#2A6038] rounded-full text-sm font-bold">
                <%= selectedPermissionIds.size() %> permissions enabled
            </span>

            <label class="font-bold text-sm">
                <input type="checkbox" id="selectAll" class="mr-2 accent-[#4A7C59]">
                Select All Permissions
            </label>
        </div>

        <div class="bg-white border border-[#E4E0D8] rounded-3xl overflow-hidden">

            <div class="bg-[#EAE6DE] px-6 py-4 font-bold">
                System Permissions
            </div>

            <div class="divide-y divide-[#E4E0D8]">

                <%
                    for (Permission permission : permissionList) {
                        boolean checked = selectedPermissionIds.contains(permission.getPermissionId());
                %>

                <div class="flex justify-between items-center px-6 py-5 hover:bg-[#F5F1EA]">

                    <div>
                        <p class="font-bold"><%= permission.getPermissionName() %></p>
                        <p class="text-sm text-[#74796E]">
                            Allow this role to access <%= permission.getPermissionName() %>.
                        </p>
                    </div>

                    <input type="checkbox"
                           name="permissionIds"
                           value="<%= permission.getPermissionId() %>"
                           <%= checked ? "checked" : "" %>
                           class="permission-checkbox w-5 h-5 accent-[#4A7C59]">

                </div>

                <%
                    }
                %>

            </div>
        </div>

        <div class="fixed bottom-0 left-0 right-0 bg-[#FAF6F0]/90 border-t border-[#E4E0D8] px-10 py-5 flex justify-end gap-4">

            <a href="${pageContext.request.contextPath}/role-list"
               class="px-8 py-3 bg-[#F0E8DB] rounded-xl font-bold">
                Cancel
            </a>

            <button type="submit"
                    class="px-8 py-3 bg-[#4A7C59] text-white rounded-xl font-bold">
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
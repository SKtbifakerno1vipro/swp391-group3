<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Role"%>

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
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-[#FAF6F0] text-[#2E3230] min-h-screen">

<main class="max-w-3xl mx-auto p-10">

    <a href="${pageContext.request.contextPath}/role-list"
       class="text-[#4A7C59] font-bold">
        ← Back to Role List
    </a>

    <h1 class="text-4xl font-bold mt-6 mb-2">Edit Role</h1>
    <p class="text-[#74796E] mb-8">Update role basic information.</p>

    <form action="${pageContext.request.contextPath}/edit-role" method="post"
          class="bg-[#F5F1EA] border border-[#E4E0D8] rounded-3xl p-8">

        <input type="hidden" name="roleId" value="<%= role.getRoleId() %>">

        <label class="block font-bold mb-2">Role Name</label>
        <input type="text"
               name="roleName"
               value="<%= role.getRoleName() %>"
               required
               class="w-full px-5 py-3 rounded-2xl border border-[#E4E0D8] bg-white mb-6">

        <div class="grid grid-cols-2 gap-6 mb-8">
            <div>
                <label class="block font-bold mb-2">Created At</label>
                <input type="text"
                       readonly
                       value="<%= role.getCreateAt() != null ? role.getCreateAt() : "-" %>"
                       class="w-full px-5 py-3 rounded-2xl border border-[#E4E0D8] bg-[#FAF6F0]">
            </div>

            <div>
                <label class="block font-bold mb-2">Updated At</label>
                <input type="text"
                       readonly
                       value="<%= role.getUpdateAt() != null ? role.getUpdateAt() : "-" %>"
                       class="w-full px-5 py-3 rounded-2xl border border-[#E4E0D8] bg-[#FAF6F0]">
            </div>
        </div>

        <div class="flex justify-end gap-3">
            <a href="${pageContext.request.contextPath}/role-list"
               class="px-6 py-3 rounded-2xl bg-white border border-[#E4E0D8] font-bold">
                Cancel
            </a>

            <button type="submit"
                    class="px-6 py-3 rounded-2xl bg-[#4A7C59] text-white font-bold">
                Save Changes
            </button>
        </div>

    </form>

</main>

</body>
</html>
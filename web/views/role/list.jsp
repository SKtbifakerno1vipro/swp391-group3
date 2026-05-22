<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Role"%>
<%@page import="model.User"%>

<%
    List<Role> roleList = (List<Role>) request.getAttribute("roleList");
    User currentUser = (User) session.getAttribute("user");

    if (roleList == null) {
        roleList = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><title>Pơ Bread - Role Management</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />
<link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;700&family=Nunito+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">
</head><body>
<table>
<tbody>
<% for (Role role : roleList) { %>
<tr>
<td>R-<%= role.getRoleId()%></td>
<td><%= role.getRoleName()%></td>
<td>
<div class="flex justify-end gap-2">
<a href="#" title="View Role" class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition"><span class="material-symbols-outlined">visibility</span></a>
<a href="${pageContext.request.contextPath}/edit-role?id=<%= role.getRoleId()%>" title="Edit Role" class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition"><span class="material-symbols-outlined">edit</span></a>
<a href="${pageContext.request.contextPath}/edit-role-permissions?roleId=<%= role.getRoleId()%>" title="Edit Permissions" class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition"><span class="material-symbols-outlined">admin_panel_settings</span></a>
<a href="javascript:void(0)" class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition"><span class="material-symbols-outlined">more_vert</span></a>
</div>
</td>
</tr>
<% } %>
</tbody>
</table>
</body></html>

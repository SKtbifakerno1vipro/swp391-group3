<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="models.Role"%>
<%@page import="models.User"%>

<%
    List<Role> roleList = (List<Role>) request.getAttribute("roleList");
    User currentUser = (User) session.getAttribute("user");

    if (roleList == null) {
        roleList = new java.util.ArrayList<>();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Pơ Bread - Role Management</title>

    <!-- Tailwind -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Google Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet" />

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;700&family=Nunito+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Nunito Sans', sans-serif;
        }

        h1,
        h2,
        h3 {
            font-family: 'Literata', serif;
        }

        .material-symbols-outlined {
            font-size: 20px;
        }

        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-thumb {
            background: #c4c8bc;
            border-radius: 10px;
        }
    </style>
</head>

<body class="bg-[#FAF6F0] text-[#2E3230] min-h-screen">

    <!-- SIDEBAR -->
    <aside class="fixed left-0 top-0 h-full w-64 bg-[#F5F1EA] border-r border-[#E4E0D8] flex flex-col p-5">

        <!-- Logo -->
        <div class="flex items-center gap-3 mb-10 mt-2">
            <div class="w-11 h-11 rounded-xl bg-[#4A7C59] flex items-center justify-center text-white shadow">
                <span class="material-symbols-outlined">eco</span>
            </div>

            <div>
                <h2 class="text-2xl font-bold text-[#4A7C59]">
                    Pơ Bread
                </h2>

                <p class="text-[10px] uppercase tracking-widest text-[#74796E] font-bold">
                    Enterprise Sales
                </p>
            </div>
        </div>

        <!-- Navigation -->
        <nav class="space-y-2 flex-1">

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">dashboard</span>
                <span class="font-semibold text-sm">Dashboard</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">group</span>
                <span class="font-semibold text-sm">Users</span>
            </a>

            <!-- ACTIVE -->
            <a href="${pageContext.request.contextPath}/role-list"
               class="flex items-center gap-3 px-4 py-3 rounded-xl bg-[#78A886] text-white shadow-md">
                <span class="material-symbols-outlined">security</span>
                <span class="font-bold text-sm">Roles</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">person</span>
                <span class="font-semibold text-sm">Customers</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">description</span>
                <span class="font-semibold text-sm">Contracts</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">payments</span>
                <span class="font-semibold text-sm">Payments</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">store</span>
                <span class="font-semibold text-sm">Providers</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">account_tree</span>
                <span class="font-semibold text-sm">Workflow</span>
            </a>

            <a href="#"
               class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-[#EAE6DE] transition">
                <span class="material-symbols-outlined">assessment</span>
                <span class="font-semibold text-sm">Reports</span>
            </a>

        </nav>

        <!-- Help -->
        <div class="pt-5 border-t border-[#E4E0D8]">

            <div class="bg-[#F0ECE4] rounded-2xl p-4">

                <div class="flex items-center gap-3 mb-3">
                    <div class="w-9 h-9 rounded-full bg-[#C4A66A] flex items-center justify-center text-white">
                        <span class="material-symbols-outlined text-sm">
                            support_agent
                        </span>
                    </div>

                    <span class="font-bold text-sm">
                        Help Center
                    </span>
                </div>

                <button class="w-full py-2 rounded-xl bg-white border border-[#E4E0D8] text-[#4A7C59] font-bold text-sm hover:bg-[#FAF6F0] transition">
                    Contact Support
                </button>

            </div>

        </div>

    </aside>

    <!-- TOPBAR -->
    <header class="fixed top-0 left-64 right-0 h-16 bg-[#F5F1EA] border-b border-[#E4E0D8] flex items-center justify-between px-8 z-50">

        <!-- Search -->
        <div class="relative w-[420px]">

            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-[#74796E]">
                search
            </span>

            <input type="text"
                   placeholder="Search roles, permissions, or users..."
                   class="w-full bg-[#FAF6F0] border border-[#E4E0D8] rounded-full pl-10 pr-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-[#78A886]">

        </div>

        <!-- Right -->
        <div class="flex items-center gap-5">

            <button class="flex items-center gap-2 px-3 py-1 bg-[#F8E0A8] rounded-full text-xs font-bold text-[#554020]">
                <span class="material-symbols-outlined text-sm">
                    shield_person
                </span>
                Admin
            </button>

            <span class="material-symbols-outlined text-[#74796E] cursor-pointer">
                notifications
            </span>

            <span class="material-symbols-outlined text-[#74796E] cursor-pointer">
                settings
            </span>

            <div class="flex items-center gap-3">

                <div class="text-right">
                    <p class="font-bold text-sm">
                        <%= currentUser != null ? currentUser.getFullName() : "Guest" %>
                    </p>

                    <p class="text-xs text-[#74796E]">
                        System Admin
                    </p>
                </div>

                <img src="https://i.pinimg.com/736x/88/fb/74/88fb74af7e8f5269826089892f4b1625.jpg"
                     class="w-11 h-11 rounded-full border-2 border-[#D8F0DE]">

            </div>

        </div>

    </header>

    <!-- MAIN -->
    <main class="ml-64 pt-24 p-8">

        <!-- Breadcrumb -->
        <div class="mb-8">

            <div class="flex items-center gap-2 text-xs uppercase tracking-widest text-[#74796E] font-bold mb-3">
                <span>Dashboard</span>
                <span class="material-symbols-outlined text-sm">chevron_right</span>
                <span>Admin</span>
                <span class="material-symbols-outlined text-sm">chevron_right</span>
                <span class="text-[#4A7C59]">Role Management</span>
            </div>

            <div class="flex items-end justify-between">

                <div>
                    <h1 class="text-5xl font-bold mb-2">
                        Role Management
                    </h1>

                    <p class="text-[#74796E]">
                        Manage system-wide roles and granular permissions.
                    </p>
                </div>

                <!-- Actions -->
                <div class="flex items-center gap-3">

                    <button class="px-4 py-3 rounded-2xl border border-[#E4E0D8] bg-white hover:bg-[#F5F1EA] flex items-center gap-2 text-sm font-bold">
                        <span class="material-symbols-outlined text-lg">download</span>
                        Export Excel
                    </button>

                    <button class="px-4 py-3 rounded-2xl border border-[#E4E0D8] bg-white hover:bg-[#F5F1EA] flex items-center gap-2 text-sm font-bold">
                        <span class="material-symbols-outlined text-lg">refresh</span>
                        Refresh Data
                    </button>

                    <button class="px-5 py-3 rounded-2xl bg-[#4A7C59] hover:bg-[#3F6B4D] text-white shadow-lg shadow-[#4A7C59]/20 flex items-center gap-2 text-sm font-bold transition">

                        <span class="material-symbols-outlined text-lg">
                            add_circle
                        </span>

                        Create New Role

                    </button>

                </div>

            </div>

        </div>

        <!-- STATS -->
        <div class="grid grid-cols-4 gap-6 mb-8">

            <div class="bg-[#F0ECE4] rounded-3xl p-6 border border-[#E4E0D8] relative overflow-hidden">

                <div class="flex justify-between mb-5">

                    <div class="w-12 h-12 rounded-2xl bg-[#D8F0DE] flex items-center justify-center text-[#4A7C59]">
                        <span class="material-symbols-outlined">shield</span>
                    </div>

                    <span class="text-xs font-bold bg-[#D8F0DE] text-[#2A6038] px-3 py-1 rounded-full">
                        +1 new
                    </span>

                </div>

                <h3 class="text-4xl font-bold">
                    <%= roleList.size() %>
                </h3>

                <p class="text-[#74796E] mt-2 font-semibold">
                    Total Roles
                </p>

            </div>

            <div class="bg-[#F0ECE4] rounded-3xl p-6 border border-[#E4E0D8]">

                <div class="flex justify-between mb-5">

                    <div class="w-12 h-12 rounded-2xl bg-[#F8E0A8] flex items-center justify-center text-[#705C30]">
                        <span class="material-symbols-outlined">key</span>
                    </div>

                    <span class="text-xs font-bold bg-[#F8E0A8] text-[#705C30] px-3 py-1 rounded-full">
                        System Wide
                    </span>

                </div>

                <h3 class="text-4xl font-bold">142</h3>

                <p class="text-[#74796E] mt-2 font-semibold">
                    Active Permissions
                </p>

            </div>

            <div class="bg-[#F0ECE4] rounded-3xl p-6 border border-[#E4E0D8]">

                <div class="flex justify-between mb-5">

                    <div class="w-12 h-12 rounded-2xl bg-[#EAE6DE] flex items-center justify-center text-[#6B6358]">
                        <span class="material-symbols-outlined">group</span>
                    </div>

                    <span class="text-xs font-bold bg-[#EAE6DE] text-[#6B6358] px-3 py-1 rounded-full">
                        Active users
                    </span>

                </div>

                <h3 class="text-4xl font-bold">24</h3>

                <p class="text-[#74796E] mt-2 font-semibold">
                    Users Assigned
                </p>

            </div>

            <div class="bg-[#F0ECE4] rounded-3xl p-6 border border-[#E4E0D8]">

                <div class="flex justify-between mb-5">

                    <div class="w-12 h-12 rounded-2xl bg-[#FFDAD8] flex items-center justify-center text-[#B83230]">
                        <span class="material-symbols-outlined">history</span>
                    </div>

                    <span class="text-xs font-bold bg-[#FFDAD8] text-[#B83230] px-3 py-1 rounded-full">
                        Recent
                    </span>

                </div>

                <h3 class="text-4xl font-bold">3</h3>

                <p class="text-[#74796E] mt-2 font-semibold">
                    Recently Updated
                </p>

            </div>

        </div>

        <!-- TABLE -->
        <div class="bg-[#FAF6F0] rounded-3xl border border-[#E4E0D8] overflow-hidden shadow-sm">

            <div class="overflow-x-auto">

                <table class="w-full">

                    <thead class="bg-[#F5F1EA] border-b border-[#E4E0D8]">

                        <tr class="text-left">

                            <th class="px-6 py-5 text-xs uppercase tracking-widest text-[#74796E]">
                                Role ID
                            </th>

                            <th class="px-6 py-5 text-xs uppercase tracking-widest text-[#74796E]">
                                Role Name
                            </th>

                            <th class="px-6 py-5 text-xs uppercase tracking-widest text-[#74796E]">
                                Created At
                            </th>

                            <th class="px-6 py-5 text-xs uppercase tracking-widest text-[#74796E]">
                                Updated At
                            </th>

                            <th class="px-6 py-5 text-xs uppercase tracking-widest text-[#74796E]">
                                Status
                            </th>

                            <th class="px-6 py-5 text-xs uppercase tracking-widest text-[#74796E] text-right">
                                Actions
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        <%
                            for (Role role : roleList) {
                        %>

                        <tr class="border-b border-[#E4E0D8] hover:bg-[#F0ECE4] transition">

                            <td class="px-6 py-5 font-mono text-sm text-[#74796E]">
                                R-<%= role.getRoleId()%>
                            </td>

                            <td class="px-6 py-5 font-bold text-[#4A7C59]">
                                <%= role.getRoleName()%>
                            </td>

                            <td class="px-6 py-5 text-sm text-[#74796E]">
                                <%= role.getCreateAt()%>
                            </td>

                            <td class="px-6 py-5 text-sm text-[#74796E]">
                                <%= role.getUpdateAt()%>
                            </td>

                            <td class="px-6 py-5">

                                <span class="px-3 py-1 rounded-full bg-[#D8F0DE] text-[#2A6038] text-xs font-bold">
                                    Active
                                </span>

                            </td>

                            <td class="px-6 py-5">

                                <div class="flex justify-end gap-2">

                                    <a href="#"
                                       class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition">

                                        <span class="material-symbols-outlined">
                                            visibility
                                        </span>

                                    </a>

                                    <a href="#"
                                       class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition">

                                        <span class="material-symbols-outlined">
                                            edit
                                        </span>

                                    </a>

                                    <a href="#"
                                       class="p-2 rounded-xl hover:bg-[#D8F0DE] text-[#4A7C59] transition">

                                        <span class="material-symbols-outlined">
                                            more_vert
                                        </span>

                                    </a>

                                </div>

                            </td>

                        </tr>

                        <%
                            }
                        %>

                    </tbody>

                </table>

            </div>

        </div>

    </main>

</body>

</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User List Management</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com" rel="preconnect"/>
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
        <link href="https://fonts.googleapis.com/css2?family=Literata:opsz,wght@7..72,400;7..72,600;7..72,700&family=Nunito+Sans:ital,opsz,wght@0,6..12,400;0,6..12,600;0,6..12,700;1,6..12,400&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

        <!-- Tailwind CSS Script -->
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>

        <!-- Theme Configuration -->
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "primary": "#4a7c59",
                            "on-primary": "#ffffff",
                            "primary-fixed": "#c8e8d0",
                            "surface": "#faf6f0",
                            "on-surface": "#2e3230",
                            "on-surface-variant": "#4a4e4a",
                            "outline-variant": "#c4c8bc",
                            "surface-container-low": "#f5f1ea",
                            "surface-container-highest": "#e4e0d8",
                            "error": "#b83230"
                        },
                        "fontFamily": {
                            "headline": ["Literata", "serif"],
                            "body": ["Nunito Sans", "sans-serif"],
                            "label": ["Nunito Sans", "sans-serif"]
                        }
                    }
                }
            }
        </script>
        <style>
            body {
                font-family: 'Nunito Sans', sans-serif;
                background-color: #faf6f0;
                color: #2e3230;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .table-shadow {
                box-shadow: 0 4px 20px rgba(46, 50, 48, 0.06);
            }
        </style>
    </head>
    <body class="bg-surface text-on-surface">

        <main class="p-8 max-w-[1600px] mx-auto space-y-8">

            <!-- Header & Actions -->
            <div class="flex justify-between items-end mb-6">
                <div>
                    <h2 class="font-headline font-bold text-3xl text-on-surface">User Management</h2>
                    <p class="text-sm text-on-surface-variant font-label mt-1">Manage system accounts and roles.</p>
                </div>
                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/create-user" 
                       class="px-6 py-2.5 rounded-lg bg-primary text-on-primary font-bold text-sm shadow-sm hover:bg-[#3a6347] transition-all active:scale-95 flex items-center gap-2">
                        <span class="material-symbols-outlined text-lg">add_circle</span>
                        Create New User
                    </a>
                </div>
            </div>

            <!-- Table Container -->
            <div class="bg-white rounded-xl table-shadow overflow-hidden border border-outline-variant/20">

                <!-- Filters Section -->
                <div class="p-6 border-b border-outline-variant/30 flex justify-between items-center bg-surface-container-low/50">
                    <form method="get" action="${pageContext.request.contextPath}/user-list" class="flex gap-4 w-full">

                        <!-- Keyword Filter -->
                        <div class="relative w-80">
                            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-lg">search</span>
                            <input type="text" name="keyword" value="${param.keyword}" placeholder="Search by name, email..." 
                                   class="w-full pl-10 pr-4 py-2 bg-white rounded-lg border border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary text-sm font-body"/>
                        </div>

                        <!-- Role Filter -->
                        <select name="roleId" class="bg-white border border-outline-variant rounded-lg pl-4 pr-10 py-2 text-sm font-body focus:ring-1 focus:ring-primary">
                            <option value="">All Roles</option>
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" ${r.roleId == roleId ? 'selected' : ''}>${r.roleName}</option>
                            </c:forEach>
                        </select>

                        <!-- Status Filter -->
                        <select name="status" class="bg-white border border-outline-variant rounded-lg px-4 py-2 text-sm font-body focus:ring-1 focus:ring-primary">
                            <option value="">All Status</option>
                            <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                            <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option>
                        </select>

                        <button type="submit" class="px-4 py-2 bg-surface-container-highest rounded-lg text-sm font-semibold hover:bg-outline-variant/40 transition-colors">
                            Filter
                        </button>
                    </form>
                </div>

                <!-- Data Table -->
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-surface-container-highest/30 text-xs font-bold uppercase tracking-wider text-on-surface-variant">
                                <th class="py-4 px-6">ID</th>
                                <th class="py-4 px-6">User Info</th>
                                <th class="py-4 px-6">Role</th>
                                <th class="py-4 px-6">Status</th>
                                <th class="py-4 px-6 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-outline-variant/20">
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="5" class="py-8 text-center text-on-surface-variant font-medium">No users found matching your criteria.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="u" items="${users}">
                                        <tr class="hover:bg-surface-container-low transition-colors group">
                                            <td class="py-4 px-6 font-semibold text-sm text-on-surface-variant">#${u.userId}</td>

                                            <!-- Gộp chung cột để nhìn xịn hơn giống template -->
                                            <td class="py-4 px-6">
                                                <div class="flex flex-col">
                                                    <span class="font-bold text-sm text-primary">${u.fullName}</span>
                                                    <span class="text-xs text-on-surface-variant">${u.userName} | ${u.email}</span>
                                                    <span class="text-xs text-on-surface-variant">${u.phone}</span>
                                                </div>
                                            </td>

                                            <td class="py-4 px-6">
                                                <span class="px-3 py-1 rounded-full text-xs font-bold bg-primary/10 text-primary border border-primary/20">
                                                    ${u.roleName}
                                                </span>
                                            </td>

                                            <td class="py-4 px-6">
                                                <c:if test="${u.status == 'ACTIVE'}">
                                                    <span class="flex items-center gap-1 text-xs font-bold text-[#059669]">
                                                        <span class="material-symbols-outlined text-sm">check_circle</span> Active
                                                    </span>
                                                </c:if>
                                                <c:if test="${u.status == 'INACTIVE'}">
                                                    <span class="flex items-center gap-1 text-xs font-bold text-error">
                                                        <span class="material-symbols-outlined text-sm">cancel</span> Inactive
                                                    </span>
                                                </c:if>
                                            </td>

                                            <td class="py-4 px-6 text-right space-x-2">
                                                <!-- Nút View Detail -->
                                                <a href="${pageContext.request.contextPath}/user-detail?id=${u.userId}" 
                                                   class="inline-flex items-center justify-center p-2 rounded-lg text-primary hover:bg-primary/10 transition-colors tooltip" title="View Detail">
                                                    <span class="material-symbols-outlined text-xl">visibility</span>
                                                </a>

                                                <!-- Form Ban/Unban -->
                                                <form action="user-list" method="post" style="display:inline;">
                                                    <input type="hidden" name="userId" value="${u.userId}" />
                                                    <input type="hidden" name="status" value="${u.status}" />
                                                    <input type="hidden" name="keyword" value="${param.keyword}" />
                                                    <input type="hidden" name="roleId" value="${param.roleId}" />
                                                    <input type="hidden" name="statusFilter" value="${param.status}" />

                                                    <c:if test="${u.status == 'ACTIVE'}">
                                                        <button type="submit" class="inline-flex items-center justify-center p-2 rounded-lg text-error hover:bg-error/10 transition-colors tooltip" title="Ban User">
                                                            <span class="material-symbols-outlined text-xl">block</span>
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${u.status != 'ACTIVE'}">
                                                        <button type="submit" class="inline-flex items-center justify-center p-2 rounded-lg text-[#059669] hover:bg-[#059669]/10 transition-colors tooltip" title="Unban User">
                                                            <span class="material-symbols-outlined text-xl">lock_open</span>
                                                        </button>
                                                    </c:if>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>

    </body>
</html>
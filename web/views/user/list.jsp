<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SaleFlow Enterprise - User List</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;500;700&family=Nunito+Sans:wght@400;500;700&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

        <script id="tailwind-config">tailwind.config = {darkMode: "class", theme: {extend: {colors: {"on-tertiary-fixed-variant": "#6c5421", "surface-container-low": "#f0f5ee", error: "#a83836", "border-subtle": "#E6E9EF", "primary-fixed": "#b9efc5", "on-surface": "#2c342e", "on-background": "#2c342e", tertiary: "#745c27", "warning-orange": "#FFAD00", "on-tertiary": "#fff8f1", "on-secondary": "#fff8f2", "on-primary": "#e8ffe9", "primary-container": "#b9efc5", outline: "#747d75", "on-tertiary-container": "#614b18", "tertiary-container": "#fad998", "inverse-surface": "#0b0f0c", surface: "#f7faf4", "outline-variant": "#abb4ac", primary: "#386948", background: "#f7faf4", "primary-fixed-dim": "#abe1b7", "on-primary-fixed-variant": "#346544", "surface-variant": "#dce5db", secondary: "#665e53", "on-primary-fixed": "#15482a", "secondary-fixed-dim": "#ded3c5", "surface-container": "#e9f0e8", "tertiary-fixed": "#fad998", "surface-tint": "#386948", "on-secondary-fixed-variant": "#625a50", "on-error-container": "#6e0a12", "surface-container-lowest": "#ffffff", "on-tertiary-fixed": "#4d3806", "error-red": "#E2445C", "surface-alt": "#F5F6F8", "surface-container-highest": "#dce5db", "surface-container-high": "#e3eae2", "on-surface-variant": "#59615a", "tertiary-fixed-dim": "#ebcb8b", "secondary-fixed": "#ece1d3", "on-error": "#fff7f6", "on-primary-container": "#2a5b3b", "on-secondary-container": "#585146", "surface-main": "#FFFFFF", "success-green": "#00C875", "inverse-primary": "#bef5ca", "error-dim": "#67040d", "on-secondary-fixed": "#453e34", "surface-dim": "#d3dcd3", "secondary-dim": "#595248", "error-container": "#fa746f", "tertiary-dim": "#67501c", "inverse-on-surface": "#9a9e99", "primary-dim": "#2b5d3c", "surface-bright": "#f7faf4", "secondary-container": "#ece1d3"}, borderRadius: {DEFAULT: "0.25rem", lg: "0.5rem", xl: "0.75rem", full: "9999px"}, spacing: {"stack-md": "12px", base: "8px", "stack-sm": "4px", "stack-lg": "24px", gutter: "16px", "container-margin": "24px", lg: "24px", xs: "4px", sm: "8px", xl: "48px", md: "16px"}, fontFamily: {"headline-md": ["Literata"], "headline-lg": ["Literata"], "body-md": ["Inter"], "label-sm": ["Inter"], "headline-xl": ["Inter"], "body-lg": ["Nunito Sans"], "label-md": ["Nunito Sans"]}, fontSize: {"headline-md": ["24px", {lineHeight: "32px", fontWeight: "600"}], "headline-lg": ["32px", {lineHeight: "40px", fontWeight: "700"}], "body-md": ["14px", {lineHeight: "20px", fontWeight: "400"}], "label-sm": ["12px", {lineHeight: "16px", letterSpacing: "0.02em", fontWeight: "500"}], "headline-xl": ["36px", {lineHeight: "44px", letterSpacing: "-0.02em", fontWeight: "700"}], "body-lg": ["16px", {lineHeight: "24px", fontWeight: "400"}], "label-md": ["12px", {lineHeight: "16px", letterSpacing: "0.5px", fontWeight: "600"}]}}}};</script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #fbf8ff;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
        </style>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>

    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="users"/>
            </jsp:include>
            <main class="main legacy-page">
<div class="flex-1 md:ml-[240px] flex flex-col">
            <header class="flex justify-between items-center w-full px-container-margin h-16 bg-surface-main border-b border-border-subtle sticky top-0 z-40">
                <div class="flex items-center gap-4 flex-1">
                    <p class="font-headline-md text-on-surface-variant">User Management</p>
                </div>
            </header>

            <main class="p-container-margin space-y-gutter">

                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <h1 class="font-headline-lg text-headline-lg text-on-surface">User List</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">Manage your system users effectively.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/edit-user" class="bg-primary-container text-white px-6 py-2.5 rounded-lg flex items-center gap-2 font-body-md text-body-md font-semibold hover:opacity-90 transition-all shadow-sm">
                        <span class="material-symbols-outlined">person_add</span> Create New User
                    </a>
                </div>

                <section class="bg-surface-main p-stack-lg rounded-xl border border-border-subtle shadow-[0px_4px_12px_rgba(0,0,0,0.05)]">
                    <form method="get" action="${pageContext.request.contextPath}/user-list">
                        <div class="grid grid-cols-1 md:grid-cols-6 gap-4">
                            <input type="text" name="searchName" placeholder="Search by Name..." value="${searchName}"
                                   class="px-4 py-2 bg-surface-alt border border-border-subtle rounded-lg focus:ring-2 focus:ring-primary focus:border-primary outline-none font-body-md w-full">

                            <input type="text" name="searchPhone" placeholder="Search by Phone..." value="${searchPhone}"
                                   class="px-4 py-2 bg-surface-alt border border-border-subtle rounded-lg focus:ring-2 focus:ring-primary focus:border-primary outline-none font-body-md w-full">

                            <input type="text" name="searchEmail" placeholder="Search by Email..." value="${searchEmail}"
                                   class="px-4 py-2 bg-surface-alt border border-border-subtle rounded-lg focus:ring-2 focus:ring-primary focus:border-primary outline-none font-body-md w-full">

                            <select name="roleId" class="px-4 py-2 bg-surface-alt border border-border-subtle rounded-lg focus:ring-2 focus:ring-primary outline-none font-body-md w-full appearance-none">
                                <option value="0">All Roles</option>
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.roleId}" ${r.roleId == roleId ? 'selected' : ''}>${r.roleName}</option>
                                </c:forEach>
                            </select>

                            <select name="status" class="px-4 py-2 bg-surface-alt border border-border-subtle rounded-lg focus:ring-2 focus:ring-primary outline-none font-body-md w-full appearance-none">
                                <option value="" ${empty status ? 'selected' : ''}>All Status</option>
                                <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                <option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                            </select>

                            <button type="submit" class="bg-surface-variant text-on-surface-variant border border-border-subtle px-6 py-2.5 rounded-lg font-semibold hover:bg-surface-container-high transition-all flex items-center justify-center gap-2">
                                <span class="material-symbols-outlined text-sm">search</span> Search
                            </button>
                        </div>
                    </form>
                </section>

                <section class="bg-surface-main rounded-xl border border-border-subtle shadow-[0px_4px_12px_rgba(0,0,0,0.05)] overflow-hidden">
                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead class="bg-surface-alt">
                                <tr>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">ID</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">Username</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">Email</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">Full Name</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">Phone</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">Status</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant">Role</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant text-center">Action</th>
                                    <th class="px-6 py-4 font-label-sm text-label-sm text-on-surface-variant text-center">Toggle</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border-subtle">
                                <c:choose>
                                    <c:when test="${empty users}">
                                        <tr>
                                            <td colspan="9" class="px-6 py-8 text-center text-on-surface-variant font-body-md">No users found.</td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="u" items="${users}">
                                            <tr class="hover:bg-surface-alt transition-colors">
                                                <td class="px-6 py-4 font-body-md text-on-surface">${u.userId}</td>
                                                <td class="px-6 py-4 font-body-md font-semibold text-on-surface">${u.userName}</td>
                                                <td class="px-6 py-4 font-body-md text-on-surface-variant">${u.email}</td>
                                                <td class="px-6 py-4 font-body-md text-on-surface">${u.fullName}</td>
                                                <td class="px-6 py-4 font-body-md text-on-surface-variant">${u.phone}</td>
                                                <td class="px-6 py-4">
                                                    <span class="flex items-center gap-1 font-label-sm text-label-sm ${u.status == 'ACTIVE' ? 'text-success-green' : 'text-error-red'}">
                                                        <span class="w-1.5 h-1.5 rounded-full ${u.status == 'ACTIVE' ? 'bg-success-green' : 'bg-error-red'}"></span> ${u.status}
                                                    </span>
                                                </td>
                                                <td class="px-6 py-4">
                                                    <span class="bg-surface-variant text-on-surface-variant px-3 py-1 rounded-full text-[10px] font-bold uppercase">${u.roleName}</span>
                                                </td>
                                                <td class="px-6 py-4 text-center">
                                                    <a href="${pageContext.request.contextPath}/edit-user?id=${u.userId}"
                                                       class="p-2 inline-flex hover:bg-surface-container rounded-lg text-primary transition-colors" title="Edit">
                                                        <span class="material-symbols-outlined text-lg">edit</span>
                                                    </a>
                                                </td>
                                                <td class="px-6 py-4 text-center">
                                                    <form action="${pageContext.request.contextPath}/user-list" method="post" style="display:inline;">
                                                        <input type="hidden" name="userId" value="${u.userId}">
                                                        <input type="hidden" name="status" value="${u.status}">
                                                        <button type="submit"
                                                                onclick="return confirm('Bạn có chắc chắn muốn ${u.status == 'ACTIVE' ? 'KHÓA' : 'MỞ KHÓA'} người dùng này?')"
                                                                class="font-label-sm font-semibold underline bg-transparent border-none cursor-pointer p-0 transition-opacity hover:opacity-75 ${u.status == 'ACTIVE' ? 'text-error-red' : 'text-success-green'}">
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
                    </div>

                    <c:if test="${endPage > 1}">
                        <c:set var="windowSize" value="2" />
                        <c:set var="start" value="${currentPage - windowSize > 1 ? currentPage - windowSize : 1}" />
                        <c:set var="end" value="${currentPage + windowSize < endPage ? currentPage + windowSize : endPage}" />

                        <div class="p-stack-lg border-t border-border-subtle flex flex-col sm:flex-row items-center justify-end gap-4">
                            <div class="flex items-center gap-2">
                                <a href="user-list?page=1&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}"
                                   class="w-8 h-8 rounded-lg flex items-center justify-center border border-border-subtle text-on-surface-variant hover:bg-surface-alt transition-colors ${currentPage == 1 ? 'opacity-50 pointer-events-none' : ''}">
                                    <span class="material-symbols-outlined text-sm">keyboard_double_arrow_left</span>
                                </a>
                                <a href="user-list?page=${currentPage - 1}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}"
                                   class="w-8 h-8 rounded-lg flex items-center justify-center border border-border-subtle text-on-surface-variant hover:bg-surface-alt transition-colors ${currentPage == 1 ? 'opacity-50 pointer-events-none' : ''}">
                                    <span class="material-symbols-outlined text-sm">chevron_left</span>
                                </a>

                                <c:if test="${start > 1}">
                                    <span class="w-8 h-8 rounded-lg flex items-center justify-center text-on-surface-variant">...</span>
                                </c:if>

                                <c:forEach begin="${start}" end="${end}" var="i">
                                    <a href="user-list?page=${i}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}"
                                       class="w-8 h-8 rounded-lg flex items-center justify-center font-label-sm text-label-sm transition-colors ${currentPage == i ? 'bg-primary text-white border border-primary' : 'border border-border-subtle text-on-surface-variant hover:bg-surface-alt'}">
                                        ${i}
                                    </a>
                                </c:forEach>

                                <c:if test="${end < endPage}">
                                    <span class="w-8 h-8 rounded-lg flex items-center justify-center text-on-surface-variant">...</span>
                                </c:if>

                                <c:if test="${currentPage < endPage}">
                                    <a href="user-list?page=${currentPage + 1}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}"
                                       class="w-8 h-8 rounded-lg flex items-center justify-center border border-border-subtle text-on-surface-variant hover:bg-surface-alt transition-colors ${currentPage == endPage ? 'opacity-50 pointer-events-none' : ''}">
                                        <span class="material-symbols-outlined text-sm">chevron_right</span>
                                    </a>
                                </c:if>
                                <a href="user-list?page=${endPage}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}"
                                   class="w-8 h-8 rounded-lg flex items-center justify-center border border-border-subtle text-on-surface-variant hover:bg-surface-alt transition-colors ${currentPage == endPage ? 'opacity-50 pointer-events-none' : ''}">
                                    <span class="material-symbols-outlined text-sm">keyboard_double_arrow_right</span>
                                </a>
                            </div>
                        </div>
                    </c:if>
                </section>
            </main>
        </div>

            </main>
        </div>
    </body>
</html>

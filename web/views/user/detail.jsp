<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit User - SaleFlow</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;500;700&family=Nunito+Sans:wght@400;500;700&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet" />
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "on-tertiary-fixed-variant": "#6c5421",
                        "surface-container-low": "#f0f5ee",
                        error: "#a83836",
                        "border-subtle": "#E6E9EF",
                        "primary-fixed": "#b9efc5",
                        "on-surface": "#2c342e",
                        "on-background": "#2c342e",
                        tertiary: "#745c27",
                        "warning-orange": "#FFAD00",
                        "on-tertiary": "#fff8f1",
                        "on-secondary": "#fff8f2",
                        "on-primary": "#e8ffe9",
                        "primary-container": "#b9efc5",
                        outline: "#747d75",
                        "on-tertiary-container": "#614b18",
                        "tertiary-container": "#fad998",
                        "inverse-surface": "#0b0f0c",
                        surface: "#f7faf4",
                        "outline-variant": "#abb4ac",
                        primary: "#386948",
                        background: "#f7faf4",
                        "primary-fixed-dim": "#abe1b7",
                        "on-primary-fixed-variant": "#346544",
                        "surface-variant": "#dce5db",
                        secondary: "#665e53",
                        "on-primary-fixed": "#15482a",
                        "secondary-fixed-dim": "#ded3c5",
                        "surface-container": "#e9f0e8",
                        "tertiary-fixed": "#fad998",
                        "surface-tint": "#386948",
                        "on-secondary-fixed-variant": "#625a50",
                        "on-error-container": "#6e0a12",
                        "surface-container-lowest": "#ffffff",
                        "on-tertiary-fixed": "#4d3806",
                        "error-red": "#E2445C",
                        "surface-alt": "#F5F6F8",
                        "surface-container-highest": "#dce5db",
                        "surface-container-high": "#e3eae2",
                        "on-surface-variant": "#59615a",
                        "tertiary-fixed-dim": "#ebcb8b",
                        "secondary-fixed": "#ece1d3",
                        "on-error": "#fff7f6",
                        "on-primary-container": "#2a5b3b",
                        "on-secondary-container": "#585146",
                        "surface-main": "#FFFFFF",
                        "success-green": "#00C875",
                        "inverse-primary": "#bef5ca",
                        "error-dim": "#67040d",
                        "on-secondary-fixed": "#453e34",
                        "surface-dim": "#d3dcd3",
                        "secondary-dim": "#595248",
                        "error-container": "#fa746f",
                        "tertiary-dim": "#67501c",
                        "inverse-on-surface": "#9a9e99",
                        "primary-dim": "#2b5d3c",
                        "surface-bright": "#f7faf4",
                        "secondary-container": "#ece1d3"
                    },
                    borderRadius: {
                        DEFAULT: "0.25rem",
                        lg: "0.5rem",
                        xl: "0.75rem",
                        full: "9999px"
                    },
                    spacing: {
                        "stack-md": "12px",
                        base: "8px",
                        "stack-sm": "4px",
                        "stack-lg": "24px",
                        gutter: "16px",
                        "container-margin": "24px",
                        lg: "24px",
                        xs: "4px",
                        sm: "8px",
                        xl: "48px",
                        md: "16px"
                    },
                    fontFamily: {
                        "headline-md": ["Literata"],
                        "headline-lg": ["Literata"],
                        "body-md": ["Inter"],
                        "label-sm": ["Inter"],
                        "headline-xl": ["Inter"],
                        "body-lg": ["Nunito Sans"],
                        "label-md": ["Nunito Sans"]
                    },
                    fontSize: {
                        "headline-md": ["24px", { lineHeight: "32px", fontWeight: "600" }],
                        "headline-lg": ["32px", { lineHeight: "40px", fontWeight: "700" }],
                        "body-md": ["14px", { lineHeight: "20px", fontWeight: "400" }],
                        "label-sm": ["12px", { lineHeight: "16px", letterSpacing: "0.02em", fontWeight: "500" }],
                        "headline-xl": ["36px", { lineHeight: "44px", letterSpacing: "-0.02em", fontWeight: "700" }],
                        "body-lg": ["16px", { lineHeight: "24px", fontWeight: "400" }],
                        "label-md": ["12px", { lineHeight: "16px", letterSpacing: "0.5px", fontWeight: "600" }]
                    }
                }
            }
        };
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #fbf8ff; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
    </style>
</head>
<body class="flex min-h-screen bg-background">
    <aside class="hidden md:flex flex-col h-full py-stack-lg bg-surface-alt border-r border-border-subtle fixed left-0 top-0 w-[240px] z-50">
        <div class="px-6 mb-8 flex items-center gap-3">
            <div class="w-10 h-10 bg-primary-container rounded-lg flex items-center justify-center">
                <span class="material-symbols-outlined text-white" style="font-variation-settings: 'FILL' 1;">dashboard_customize</span>
            </div>
            <div>
                <h2 class="font-headline-md text-headline-md font-extrabold text-primary">SaleFlow</h2>
                <p class="font-label-sm text-label-sm text-on-surface-variant">Enterprise Suite</p>
            </div>
        </div>
        <nav class="flex-1 px-4 space-y-2">
            <a class="flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-high transition-all font-body-md text-body-md" href="dashboard">
                <span class="material-symbols-outlined">dashboard</span>
                Dashboard
            </a>
            <a class="flex items-center gap-3 px-4 py-3 rounded-lg bg-surface-container text-primary font-semibold border-r-4 border-primary transition-all scale-95 font-body-md text-body-md" href="user-list">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">group</span>
                User Management
            </a>
        </nav>
    </aside>

    <div class="flex-1 md:ml-[240px] flex flex-col">
        <header class="flex justify-between items-center w-full px-container-margin h-16 bg-surface-main border-b border-border-subtle sticky top-0 z-40">
            <div class="flex items-center gap-4 flex-1">
                <p class="font-headline-md text-on-surface-variant">User Details & Editing</p>
            </div>
        </header>

        <main class="p-container-margin">
            <div class="max-w-4xl mx-auto bg-surface-main rounded-xl border border-border-subtle shadow-sm overflow-hidden">
                <div class="p-stack-lg border-b border-border-subtle bg-surface-alt flex justify-between items-center">
                    <div>
                        <h3 class="font-headline-md text-on-surface">Profile Information</h3>
                        <p class="font-body-md text-on-surface-variant">View and update account details for <strong>${u.userName}</strong>.</p>
                    </div>
                    <span class="px-3 py-1 rounded-full text-[12px] font-bold ${u.status == 'ACTIVE' ? 'bg-success-green/20 text-success-green' : 'bg-error-red/20 text-error-red'}">
                        ${u.status}
                    </span>
                </div>

                <form action="edit-user" method="post" class="p-stack-lg space-y-6">
                    <input type="hidden" name="id" value="${u.userId}">
                    
                    <c:if test="${not empty error}">
                        <div class="p-4 bg-error-container text-on-error-container rounded-lg flex items-center gap-3">
                            <span class="material-symbols-outlined">error</span>
                            <p class="font-body-md">${error}</p>
                        </div>
                    </c:if>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="userName">Username (Read-only)</label>
                            <input type="text" id="userName" name="userName" value="${u.userName}" readonly
                                   class="w-full px-4 py-2 rounded-lg border border-border-subtle bg-surface-container-low text-on-surface-variant cursor-not-allowed outline-none font-body-md" />
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="${u.fullName}" required minlength="4" maxlength="50"
                                   class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md" />
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="email">Email Address</label>
                            <input type="email" id="email" name="email" value="${u.email}" required
                                   class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md" />
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" value="${u.phone}" required pattern="^0[0-9]{9}$"
                                   class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md" />
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="address">Address</label>
                            <input type="text" id="address" name="address" value="${u.address}"
                                   class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md" />
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="gender">Gender</label>
                            <select id="gender" name="gender" class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md bg-white">
                                <option value="M" ${u.gender == 'M' ? 'selected' : ''}>Male</option>
                                <option value="F" ${u.gender == 'F' ? 'selected' : ''}>Female</option>
                                <option value="O" ${u.gender == 'O' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="roleId">Role</label>
                            <select id="roleId" name="roleId" class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md bg-white">
                                <c:forEach var="r" items="${roles}">
                                    <option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="space-y-2">
                            <label class="font-label-md text-on-surface-variant" for="status">Account Status</label>
                            <select id="status" name="status" class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none transition-all font-body-md bg-white">
                                <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                <option value="INACTIVE" ${u.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                            </select>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4 border-t border-border-subtle">
                        <div class="space-y-1">
                            <p class="font-label-sm text-on-surface-variant">Created By</p>
                            <p class="font-body-md text-on-surface">${userService.getUsernameById(u.createdBy)}</p>
                        </div>
                        <div class="space-y-1 text-right">
                            <p class="font-label-sm text-on-surface-variant">Last Updated By</p>
                            <p class="font-body-md text-on-surface">${userService.getUsernameById(u.updatedBy)}</p>
                        </div>
                    </div>

                    <div class="pt-6 flex items-center justify-end gap-4">
                        <a href="user-list" class="px-6 py-2 rounded-lg font-label-md text-on-surface-variant hover:bg-surface-alt transition-colors">
                            Back to List
                        </a>
                        <button type="submit" class="px-8 py-2 bg-primary text-white rounded-lg font-label-md hover:bg-primary-dim transition-all shadow-sm">
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </main>

        <footer class="mt-auto flex justify-between items-center px-container-margin py-stack-md w-full bg-surface-main border-t border-border-subtle">
            <p class="font-label-sm text-label-sm text-on-surface-variant"> 2024 SaleFlow Digitalization System.</p>
        </footer>
    </div>
</body>
</html>

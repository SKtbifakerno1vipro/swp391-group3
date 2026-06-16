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
                theme: {extend: {colors: {primary: "#386948", "primary-container": "#b9efc5", "surface-alt": "#F5F6F8", "border-subtle": "#E6E9EF", "error-container": "#fa746f", "on-error-container": "#6e0a12", "success-green": "#00C875", "error-red": "#E2445C"}}}
            };
        </script>
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
                    <span class="material-symbols-outlined">dashboard</span> Dashboard
                </a>
                <a class="flex items-center gap-3 px-4 py-3 rounded-lg bg-surface-container text-primary font-semibold border-r-4 border-primary transition-all scale-95 font-body-md text-body-md" href="user-list">
                    <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">group</span> User Management
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
                            <p class="font-body-md text-on-surface-variant">Update account details for <strong>${u.userName}</strong>.</p>
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
                            <!-- Username -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="userName">Username</label>
                                <input type="text" value="${u.userName}" readonly class="w-full px-4 py-2 rounded-lg border border-border-subtle bg-surface-container-low cursor-not-allowed font-body-md" />
                            </div>

                            <!-- Full Name -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" value="${u.fullName}" required 
                                       pattern=".{4,50}" title="Full Name must be between 4 and 50 characters"
                                       class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none font-body-md" />
                            </div>

                            <!-- Email -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="email">Email Address</label>
                                <input type="email" id="email" name="email" value="${u.email}" required 
                                       pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Please enter a valid email address (e.g., name@domain.com)"
                                       class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none font-body-md" />
                            </div>

                            <!-- Phone -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="phone">Phone Number</label>
                                <input type="text" id="phone" name="phone" value="${u.phone}" required pattern="^0[0-9]{9}$" 
                                       title="Phone must start with 0 and have exactly 10 digits"
                                       class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none font-body-md" />
                            </div>

                            <!-- Address -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="address">Address</label>
                                <input type="text" id="address" name="address" value="${u.address}" required
                                       pattern=".{5,}" title="Address must be at least 5 characters long"
                                       class="w-full px-4 py-2 rounded-lg border border-border-subtle focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none font-body-md" />
                            </div>

                            <!-- Gender -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="gender">Gender</label>
                                <select id="gender" name="gender" class="w-full px-4 py-2 rounded-lg border border-border-subtle bg-white font-body-md">
                                    <option value="M" ${u.gender == 'M' ? 'selected' : ''}>Male</option>
                                    <option value="F" ${u.gender == 'F' ? 'selected' : ''}>Female</option>
                                    <option value="O" ${u.gender == 'O' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>

                            <!-- Role -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="roleId">Role</label>
                                <select id="roleId" name="roleId" class="w-full px-4 py-2 rounded-lg border border-border-subtle bg-white font-body-md">
                                    <c:forEach var="r" items="${roles}">
                                        <option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Status -->
                            <div class="space-y-2">
                                <label class="font-label-md text-on-surface-variant" for="status">Account Status</label>
                                <select id="status" name="status" class="w-full px-4 py-2 rounded-lg border border-border-subtle bg-white font-body-md">
                                    <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                    <option value="INACTIVE" ${u.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                                </select>
                            </div>
                        </div>

                        <div class="pt-6 flex items-center justify-end gap-4">
                            <a href="user-list" class="px-6 py-2 rounded-lg font-label-md text-on-surface-variant hover:bg-surface-alt transition-colors">Back</a>
                            <button type="submit" class="px-8 py-2 bg-primary text-white rounded-lg font-label-md hover:bg-primary-dim transition-all shadow-sm">Save Changes</button>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </body>
</html>
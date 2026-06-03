<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New User</title>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Literata:opsz,wght@7..72,400;7..72,600;7..72,700&family=Nunito+Sans:ital,opsz,wght@0,6..12,400;0,6..12,600;0,6..12,700;1,6..12,400&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "primary": "#4a7c59", "on-primary": "#ffffff", "surface": "#faf6f0",
                        "on-surface": "#2e3230", "on-surface-variant": "#4a4e4a",
                        "outline-variant": "#c4c8bc", "error": "#b83230"
                    },
                    "fontFamily": { "headline": ["Literata", "serif"], "body": ["Nunito Sans", "sans-serif"], "label": ["Nunito Sans", "sans-serif"] }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Nunito Sans', sans-serif; background-color: #faf6f0; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        .card-shadow { box-shadow: 0 4px 24px rgba(46, 50, 48, 0.08); }
    </style>
</head>
<body class="bg-surface text-on-surface py-10">

<main class="max-w-4xl mx-auto">
    <!-- Header -->
    <div class="mb-6 flex items-center gap-3">
        <a href="user-list" class="p-2 rounded-full hover:bg-outline-variant/30 transition-colors text-on-surface-variant flex items-center justify-center">
            <span class="material-symbols-outlined">arrow_back</span>
        </a>
        <div>
            <h2 class="font-headline font-bold text-3xl text-on-surface">Create New User</h2>
            <p class="text-sm text-on-surface-variant font-label mt-1">Register a new account into the system.</p>
        </div>
    </div>

    <!-- Error Alert -->
    <c:if test="${not empty error}">
        <div class="mb-6 p-4 bg-error/10 border-l-4 border-error rounded-r-lg flex items-center gap-3">
            <span class="material-symbols-outlined text-error">error</span>
            <p class="text-error font-semibold text-sm">${error}</p>
        </div>
    </c:if>

    <!-- Form Card -->
    <div class="bg-white rounded-xl card-shadow border border-outline-variant/20 p-8">
        <form action="create-user" method="post">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                <!-- Username -->
                <div class="flex flex-col gap-1.5">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Username <span class="text-error">*</span></label>
                    <input type="text" name="userName" value="<c:out value='${u.userName}' />" required 
                           class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all" />
                </div>

                <!-- Password -->
                <div class="flex flex-col gap-1.5">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Password <span class="text-error">*</span></label>
                    <input type="password" name="password" required 
                           class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all" />
                </div>

                <!-- Full Name -->
                <div class="flex flex-col gap-1.5 md:col-span-2">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Full Name <span class="text-error">*</span></label>
                    <input type="text" name="fullName" value="<c:out value='${u.fullName}' />" required minlength="4" maxlength="50"
                           class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all" />
                </div>

                <!-- Email -->
                <div class="flex flex-col gap-1.5">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Email Address <span class="text-error">*</span></label>
                    <input type="email" name="email" value="<c:out value='${u.email}' />" required
                           class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all" />
                </div>

                <!-- Phone -->
                <div class="flex flex-col gap-1.5">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Phone Number <span class="text-error">*</span></label>
                    <input type="text" name="phone" value="<c:out value='${u.phone}' />" required pattern="[0-9]{10}"
                           class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all" />
                </div>

                <!-- Gender -->
                <div class="flex flex-col gap-1.5">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Gender</label>
                    <select name="gender" class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all">
                        <option value="M" ${u.gender == 'M' ? 'selected' : ''}>Male</option>
                        <option value="F" ${u.gender == 'F' ? 'selected' : ''}>Female</option>
                        <option value="O" ${u.gender == 'O' ? 'selected' : ''}>Other</option>
                    </select>
                </div>

                <!-- Role -->
                <div class="flex flex-col gap-1.5">
                    <label class="text-sm font-label font-bold text-on-surface-variant">Role</label>
                    <select name="roleId" class="w-full px-4 py-2.5 border border-outline-variant rounded-lg text-sm font-body focus:ring-2 focus:ring-primary/50 focus:border-primary outline-none transition-all">
                        <c:forEach var="r" items="${roles}">
                            <option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex items-center justify-end gap-3 pt-6 border-t border-outline-variant/30">
                <a href="user-list" class="px-6 py-2.5 rounded-lg border border-outline-variant text-on-surface font-semibold text-sm hover:bg-surface-container-low transition-colors">
                    Cancel
                </a>
                <button type="submit" class="px-6 py-2.5 rounded-lg bg-primary text-on-primary font-bold text-sm shadow-sm hover:bg-[#3a6347] transition-all flex items-center gap-2">
                    <span class="material-symbols-outlined text-sm">person_add</span> Create Account
                </button>
            </div>

        </form>
    </div>
</main>

</body>
</html>
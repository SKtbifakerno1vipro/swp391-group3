<%--
    Document   : CreateProvider
    Created on : 2026-05-21
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Provider</title>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@400;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
</head>
<body class="antialiased text-body-md min-h-screen bg-surface text-on-surface">
    <main class="p-8">
        <div class="max-w-4xl mx-auto bg-surface-container-low rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold text-primary mb-4">Create Provider</h1>
            <c:if test="${not empty success}">
                <div class="text-green-600">Create successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="text-red-600">Create failed</div>
                <c:if test="${not empty errorDetail}">
                    <div class="text-red-500">${errorDetail}</div>
                </c:if>
            </c:if>
            <form action="CreateProvider" method="post" class="space-y-4">
                <div>
                    <label for="username" class="block text-sm font-medium">Username</label>
                    <input type="text" id="username" name="username" class="w-full p-2 border rounded" required>
                </div>
                <div>
                    <label for="password" class="block text-sm font-medium">Password</label>
                    <input type="password" id="password" name="password" class="w-full p-2 border rounded" required>
                </div>
                <div>
                    <label for="email" class="block text-sm font-medium">Email</label>
                    <input type="email" id="email" name="email" class="w-full p-2 border rounded" required>
                </div>
                <div>
                    <label for="fullname" class="block text-sm font-medium">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="w-full p-2 border rounded">
                </div>
                <div>
                    <label for="phone" class="block text-sm font-medium">Phone</label>
                    <input type="text" id="phone" name="phone" class="w-full p-2 border rounded">
                </div>
                <div>
                    <label for="status" class="block text-sm font-medium">Status</label>
                    <select id="status" name="status" class="w-full p-2 border rounded">
                        <option value="Active">Active</option>
                        <option value="Inactive">Inactive</option>
                    </select>
                </div>
                <div>
                    <label for="providerName" class="block text-sm font-medium">Provider Name</label>
                    <input type="text" id="providerName" name="providerName" class="w-full p-2 border rounded" required>
                </div>
                <div>
                    <label for="taxCode" class="block text-sm font-medium">Tax Code</label>
                    <input type="text" id="taxCode" name="taxCode" class="w-full p-2 border rounded">
                </div>
                <div>
                    <label for="role" class="block text-sm font-medium">Role</label>
                    <input type="hidden" name="roleId" value="${providerRoleId}">
                    <span>Provider</span>
                </div>
                <div>
                    <button type="submit" class="bg-primary text-on-primary px-4 py-2 rounded">Create</button>
                </div>
            </form>
        </div>
    </main>
</body>
</html>

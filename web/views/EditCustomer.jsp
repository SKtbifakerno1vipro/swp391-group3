<%--
    EditCustomer.jsp — uses frontend template from frontend.txt
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Edit Customer - Terra Enterprise</title>
    <link href="https://fonts.googleapis.com" rel="preconnect"/>
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect"/>
    <link href="https://fonts.googleapis.com/css2?family=Literata:opsz,wght@7..72,400..700&amp;family=Nunito+Sans:wght@400..700&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <script id="tailwind-config">tailwind.config = {darkMode: "class", theme: {extend: {colors: {background: '#faf6f0', primary: '#4a7c59', 'on-background': '#2e3230', 'surface': '#faf6f0', 'outline-variant': '#c4c8bc', 'surface-container-low': '#f5f1ea', 'surface-container-lowest': '#ffffff'}, fontFamily: {headline: ['Literata','serif'], body: ['Nunito Sans','sans-serif']}}}};</script>
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        body { font-family: theme('fontFamily.body'); background-color: #faf6f0; color: #2e3230; }
    </style>
</head>
<body class="antialiased text-body-md min-h-screen">
    <!-- Top nav + side simplified to reuse template look -->
    <header class="fixed top-0 right-0 h-[64px] z-10 bg-white/80 backdrop-blur-md flex items-center justify-between px-6 ml-[240px] w-[calc(100%-240px)] border-b">
        <div class="flex items-center gap-4 w-1/3">
            <div class="relative w-full max-w-md">
                <input class="w-full pl-3 pr-4 py-2 bg-white rounded-full border" placeholder="Search..." type="text"/>
            </div>
        </div>
        <div class="flex items-center justify-center absolute left-1/2 -translate-x-1/2">
            <h1 class="font-headline text-lg font-bold text-primary">Terra</h1>
        </div>
        <div class="flex items-center gap-4">Admin</div>
    </header>

    <nav class="fixed left-0 top-0 h-full w-[240px] bg-white shadow-sm flex flex-col border-r z-20">
        <div class="h-[64px] flex items-center px-6 border-b"><h1 class="font-headline text-xl font-bold text-primary">Terra</h1></div>
    </nav>

    <main class="ml-[240px] pt-[80px] p-8">
        <div class="max-w-3xl mx-auto bg-white rounded-lg p-6 shadow soft-shadow border">
            <h2 class="text-2xl font-bold text-primary mb-4">Edit Customer</h2>

            <c:if test="${not empty success}">
                <div class="mb-4 p-3 bg-green-50 text-green-800 rounded">Edit successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="mb-4 p-3 bg-red-50 text-red-800 rounded">Edit failed</div>
                <c:if test="${not empty errorDetail}">
                    <div class="text-sm text-red-700 mt-2">${errorDetail}</div>
                </c:if>
            </c:if>

            <c:if test="${not empty customer}">
                <form action="EditCustomer" method="post" class="space-y-4">
                    <input type="hidden" name="customerId" value="${customer.customerId}" />
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium text-on-background/80">Customer ID</label>
                            <input class="w-full mt-1 p-2 border rounded bg-gray-50" value="${customer.customerId}" readonly />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-on-background/80">User ID</label>
                            <input class="w-full mt-1 p-2 border rounded bg-gray-50" value="${customer.userId}" readonly />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Username</label>
                            <input name="username" class="w-full mt-1 p-2 border rounded" value="${user.userName}" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Password</label>
                            <input name="password" type="password" class="w-full mt-1 p-2 border rounded" placeholder="Leave blank to keep current" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Email</label>
                            <input name="email" class="w-full mt-1 p-2 border rounded" value="${user.email}" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Full name</label>
                            <input name="fullname" class="w-full mt-1 p-2 border rounded" value="${user.fullName}" />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Status</label>
                            <select name="status" class="w-full mt-1 p-2 border rounded">
                                <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Tax Code</label>
                            <input name="taxCode" class="w-full mt-1 p-2 border rounded" value="${customer.taxCode}" required />
                        </div>
                        <div>
                            <label class="block text-sm font-medium mt-2">Type</label>
                            <input name="type" class="w-full mt-1 p-2 border rounded" value="${customer.type}" required />
                        </div>
                    </div>

                    <div class="flex items-center justify-end gap-3 mt-4">
                        <a href="CustomerDetail?id=${customer.customerId}" class="px-4 py-2 border rounded">Cancel</a>
                        <button type="submit" class="bg-primary text-white px-4 py-2 rounded">Save changes</button>
                    </div>
                </form>
            </c:if>
        </div>
    </main>
</body>
</html>

<%--
    Document   : ProviderList
    Created on : 2026-05-21
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Providers</title>
        <link href="https://fonts.googleapis.com" rel="preconnect">
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@400;700&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    </head>
    <body class="antialiased text-body-md min-h-screen bg-surface text-on-surface">
        <main class="p-8">
            <div class="max-w-5xl mx-auto bg-surface-container-low rounded-lg shadow-md p-6">
                <div class="flex items-center justify-between mb-4">
                    <h1 class="text-2xl font-bold text-primary">Providers</h1>
                    <a href="${pageContext.request.contextPath}/CreateProvider"
                       style="
                       display: inline-block;
                       padding: 10px 20px;
                       background-color: #2563eb;
                       color: white;
                       text-decoration: none;
                       border-radius: 6px;
                       font-size: 14px;
                       font-weight: 500;
                       border: none;
                       cursor: pointer;
                       ">
                        Create Provider
                    </a>
                </div>

                <c:if test="${empty providers}">
                    <p class="text-on-surface-variant">No providers found.</p>
                </c:if>

                <c:if test="${not empty providers}">
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tax Code</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">User ID</th>
                                    <th class="px-6 py-3"></th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <c:forEach var="p" items="${providers}">
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">${p.providerId}</td>
                                        <td class="px-6 py-4 whitespace-nowrap">${p.providerName}</td>
                                        <td class="px-6 py-4 whitespace-nowrap">${p.taxCode}</td>
                                        <td class="px-6 py-4 whitespace-nowrap">${p.userId}</td>
                                        <td class="px-6 py-4 whitespace-nowrap text-right space-x-2">
                                            <a href="${pageContext.request.contextPath}/ProviderDetail?id=${p.providerId}" class="inline-block px-3 py-1 bg-blue-600 text-white rounded">Detail</a>
                                            <a href="${pageContext.request.contextPath}/EditProvider?id=${p.providerId}" class="inline-block px-3 py-1 bg-yellow-500 text-white rounded">Edit</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>

        </main>
    </body>
</html>

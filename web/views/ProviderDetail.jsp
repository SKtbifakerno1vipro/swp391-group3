<%--
    Document   : ProviderDetail
    Created on : 2026-05-21
    Author     : AUTO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Provider Detail</title>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@400;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
</head>
<body class="antialiased text-body-md min-h-screen bg-surface text-on-surface">
    <main class="p-8">
        <div class="max-w-4xl mx-auto bg-surface-container-low rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold text-primary mb-4">Provider Detail</h1>
            <c:if test="${not empty error}">
                <p class="text-red-600">${error}</p>
            </c:if>
            <c:if test="${empty provider}">
                <p class="text-on-surface-variant">No provider data available.</p>
            </c:if>
            <c:if test="${not empty provider}">
                <div class="space-y-4">
                    <div>
                        <span class="font-medium">Provider ID:</span> ${provider.providerId}
                    </div>
                    <div>
                        <span class="font-medium">User ID:</span> ${provider.userId}
                    </div>
                    <div>
                        <span class="font-medium">Provider Name:</span> ${provider.providerName}
                    </div>
                    <div>
                        <span class="font-medium">Tax Code:</span> ${provider.taxCode}
                    </div>
                    <div>
                        <span class="font-medium">Created At:</span> ${provider.createAt}
                    </div>
                    <div>
                        <span class="font-medium">Updated At:</span> ${provider.updateAt}
                    </div>
                </div>
                <c:if test="${not empty provider.user}">
                    <h2 class="text-xl font-bold text-primary mt-6">Associated User</h2>
                    <div class="space-y-4">
                        <div>
                            <span class="font-medium">Full Name:</span> ${provider.user.fullName}
                        </div>
                        <div>
                            <span class="font-medium">Email:</span> ${provider.user.email}
                        </div>
                        <div>
                            <span class="font-medium">Phone:</span> ${provider.user.phone}
                        </div>
                        <c:if test="${not empty provider.userRoleName}">
                            <div>
                                <span class="font-medium">Role:</span> ${provider.userRoleName}
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </c:if>
            <div class="mt-6">
                <a href="#" class="text-primary hover:underline">Back</a>
            </div>
        </div>
    </main>
</body>
</html>

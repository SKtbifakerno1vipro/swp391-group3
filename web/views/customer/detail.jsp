<%-- 
    Document   : CustomerDetail
    Created on : May 20, 2026, 11:49:15 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Detail</title>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Nunito+Sans:wght@400;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
</head>
<body class="antialiased text-body-md min-h-screen bg-surface text-on-surface">
    <main class="p-8">
        <div class="max-w-4xl mx-auto bg-surface-container-low rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold text-primary mb-4">Customer Detail</h1>
            <c:if test="${empty customer}">
                <p class="text-on-surface-variant">No customer data available.</p>
            </c:if>
            <c:if test="${not empty customer}">
                <div class="space-y-4">
                    <div>
                        <span class="font-medium">Customer ID:</span> ${customer.customerId}
                    </div>
                    <div>
                        <span class="font-medium">User ID:</span> ${customer.userId}
                    </div>
                    <div>
                        <span class="font-medium">Tax Code:</span> ${customer.taxCode}
                    </div>
                    <div>
                        <span class="font-medium">Type:</span> ${customer.type}
                    </div>
                    <div>
                        <span class="font-medium">Created By:</span> ${customer.createBy}
                    </div>
                    <div>
                        <span class="font-medium">Created At:</span> ${customer.createAt}
                    </div>
                    <div>
                        <span class="font-medium">Updated At:</span> ${customer.updateAt}
                    </div>
                </div>
                <c:if test="${not empty customer.user}">
                    <h2 class="text-xl font-bold text-primary mt-6">Associated User</h2>
                    <div class="space-y-4">
                        <div>
                            <span class="font-medium">Full Name:</span> ${customer.user.fullName}
                        </div>
                        <div>
                            <span class="font-medium">Email:</span> ${customer.user.email}
                        </div>
                        <div>
                            <span class="font-medium">Phone:</span> ${customer.user.phone}
                        </div>
                        <c:if test="${not empty customer.userRoleName}">
                            <div>
                                <span class="font-medium">Role:</span> ${customer.userRoleName}
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </c:if>
            <div class="mt-6">
                <a href="javascript:void(0)" class="text-primary hover:underline">Back</a>
            </div>
        </div>
    </main>
</body>
</html>

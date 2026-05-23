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
    
    
</head>
<body>
    <main>
        <div>
            <h1>Provider Detail</h1>
            <c:if test="${not empty error}">
                <p>${error}</p>
            </c:if>
            <c:if test="${empty provider}">
                <p>No provider data available.</p>
            </c:if>
            <c:if test="${not empty provider}">
                <div>
                    <div>
                        <span>Provider ID:</span> ${provider.providerId}
                    </div>
                    <div>
                        <span>User ID:</span> ${provider.userId}
                    </div>
                    <div>
                        <span>Provider Name:</span> ${provider.providerName}
                    </div>
                    <div>
                        <span>Tax Code:</span> ${provider.taxCode}
                    </div>
                    <div>
                        <span>Created At:</span> ${provider.createAt}
                    </div>
                    <div>
                        <span>Updated At:</span> ${provider.updateAt}
                    </div>
                </div>
                <c:if test="${not empty provider.user}">
                    <h2>Associated User</h2>
                    <div>
                        <div>
                            <span>Full Name:</span> ${provider.user.fullName}
                        </div>
                        <div>
                            <span>Email:</span> ${provider.user.email}
                        </div>
                        <div>
                            <span>Phone:</span> ${provider.user.phone}
                        </div>
                        <c:if test="${not empty provider.userRoleName}">
                            <div>
                                <span>Role:</span> ${provider.userRoleName}
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </c:if>
            <div>
                <a href="#">Back</a>
            </div>
        </div>
    </main>
</body>
</html>



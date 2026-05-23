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
        
        
    </head>
    <body>
        <main>
            <div>
                <div>
                    <h1>Providers</h1>
                    <a href="${pageContext.request.contextPath}/CreateProvider">
                        Create Provider
                    </a>
                </div>

                <c:if test="${empty providers}">
                    <p>No providers found.</p>
                </c:if>

                <c:if test="${not empty providers}">
                    <div>
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Tax Code</th>
                                    <th>User ID</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${providers}">
                                    <tr>
                                        <td>${p.providerId}</td>
                                        <td>${p.providerName}</td>
                                        <td>${p.taxCode}</td>
                                        <td>${p.userId}</td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/ProviderDetail?id=${p.providerId}">Detail</a>
                                            <a href="#" onclick="alert('Chức năng Edit Provider chưa được code'); return false;">Edit</a>
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



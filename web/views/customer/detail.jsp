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
    
    
</head>
<body>
    <main>
        <div>
            <h1>Customer Detail</h1>
            <c:if test="${empty customerDTO}">
                <p>No customer data available.</p>
            </c:if>
            <c:if test="${not empty customerDTO}">
                <table border="1" cellpadding="5" style="border-collapse: collapse; width: 50%;">
                    <tr>
                        <td><b>Customer ID:</b></td>
                        <td>${customerDTO.customer.customerId}</td>
                    </tr>
                    <tr>
                        <td><b>User ID:</b></td>
                        <td>${customerDTO.customer.userId}</td>
                    </tr>
                    <tr>
                        <td><b>Tax Code:</b></td>
                        <td>${customerDTO.customer.taxCode}</td>
                    </tr>
                    <tr>
                        <td><b>Type:</b></td>
                        <td>${customerDTO.customer.type}</td>
                    </tr>
                    <tr>
                        <td><b>Created By:</b></td>
                        <td>${customerDTO.customer.createBy}</td>
                    </tr>
                    <tr>
                        <td><b>Created At:</b></td>
                        <td>${customerDTO.customer.createAt}</td>
                    </tr>
                    <tr>
                        <td><b>Updated At:</b></td>
                        <td>${customerDTO.customer.updateAt}</td>
                    </tr>
                </table>

                <c:if test="${not empty customerDTO.user}">
                    <h3>Associated User</h3>
                    <table border="1" cellpadding="5" style="border-collapse: collapse; width: 50%;">
                        <tr>
                            <td><b>Full Name:</b></td>
                            <td>${customerDTO.user.fullName}</td>
                        </tr>
                        <tr>
                            <td><b>Email:</b></td>
                            <td>${customerDTO.user.email}</td>
                        </tr>
                        <tr>
                            <td><b>Phone:</b></td>
                            <td>${customerDTO.user.phone}</td>
                        </tr>
                        <c:if test="${not empty customerDTO.userRoleName}">
                            <tr>
                                <td><b>Role:</b></td>
                                <td>${customerDTO.userRoleName}</td>
                            </tr>
                        </c:if>
                    </table>
                </c:if>
            </c:if>
            <br>
            <div>
                <a href="dashboard">Back</a>
            </div>
        </div>
    </main>
</body>
</html>




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
            <c:if test="${empty customer}">
                <p>No customer data available.</p>
            </c:if>
            <c:if test="${not empty customer}">
                <div>
                    <div>
                        <span>Customer ID:</span> ${customerDTO.customer.customerId}
                    </div>
                    <div>
                        <span>User ID:</span> ${customer.userId}
                    </div>
                    <div>
                        <span>Tax Code:</span> ${customerDTO.customer.taxCode}
                    </div>
                    <div>
                        <span>Type:</span> ${customerDTO.customer.type}
                    </div>
                    <div>
                        <span>Created By:</span> ${customer.createBy}
                    </div>
                    <div>
                        <span>Created At:</span> ${customer.createAt}
                    </div>
                    <div>
                        <span>Updated At:</span> ${customer.updateAt}
                    </div>
                </div>
                <c:if test="${not empty customer.user}">
                    <h2>Associated User</h2>
                    <div>
                        <div>
                            <span>Full Name:</span> ${customer.user.fullName}
                        </div>
                        <div>
                            <span>Email:</span> ${customer.user.email}
                        </div>
                        <div>
                            <span>Phone:</span> ${customer.user.phone}
                        </div>
                        <c:if test="${not empty customer.userRoleName}">
                            <div>
                                <span>Role:</span> ${customer.userRoleName}
                            </div>
                        </c:if>
                    </div>
                </c:if>
            </c:if>
            <div>
                <a href="javascript:void(0)">Back</a>
            </div>
        </div>
    </main>
</body>
</html>




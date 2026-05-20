<%-- 
    Document   : CustomerDetail
    Created on : May 20, 2026, 11:49:15 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Detail</title>
        <!-- CSS temporarily removed per request -->
    </head>
    <body>
        <div>
            <h2>Customer Detail</h2>
            <c:if test="${empty customer}">
                <p>No customer data available.</p>
            </c:if>
            <c:if test="${not empty customer}">
                <div>
                    <div>Customer ID</div>
                    <div>${customer.customerId}</div>

                    <div>User ID</div>
                    <div>${customer.userId}</div>

                    <div>Tax Code</div>
                    <div>${customer.taxCode}</div>

                    <div>Type</div>
                    <div>${customer.type}</div>

                    <div>Created By</div>
                    <div>${customer.createBy}</div>

                    <div>Created At</div>
                    <div>${customer.createAt}</div>

                    <div>Updated At</div>
                    <div>${customer.updateAt}</div>
                </div>

                <c:if test="${not empty customer.user}">
                    <h3>Associated User</h3>
                    <div>
                        <div>Full Name</div>
                        <div>${customer.user.fullName}</div>

                        <div>Email</div>
                        <div>${customer.user.email}</div>

                        <div>Phone</div>
                        <div>${customer.user.phone}</div>

                        <c:if test="${not empty customer.userRoleName}">
                            <div>Role</div>
                            <div>${customer.userRoleName}</div>
                        </c:if>
                    </div>
                </c:if>
            </c:if>

            <div>
                <a href="#">Back</a>
            </div>
        </div>
    </body>
</html>

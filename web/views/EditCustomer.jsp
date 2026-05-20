<%-- 
    Document   : EditCustomer
    Created on : May 21, 2026
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Customer</title>
    </head>
    <body>
        <div>
            <h2>Edit Customer</h2>
            <c:if test="${not empty success}">
                <div>Edit successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div>Edit failed</div>
                <c:if test="${not empty errorDetail}">
                    <div>${errorDetail}</div>
                </c:if>
            </c:if>
            <c:if test="${not empty customer}">
                <form action="EditCustomer" method="post">
                    <table>
                        <tr>
                            <td>Customer ID:</td>
                            <td>
                                <input type="text" name="customerId" value="${customer.customerId}" readonly />
                                <input type="hidden" name="customerId" value="${customer.customerId}" />
                            </td>
                        </tr>
                        <tr>
                            <td>User ID:</td>
                            <td><input type="text" value="${customer.userId}" readonly /></td>
                        </tr>
                        <tr>
                            <td>Tax Code:</td>
                            <td><input type="text" name="taxCode" value="${customer.taxCode}" required /></td>
                        </tr>
                        <tr>
                            <td>Type:</td>
                            <td><input type="text" name="type" value="${customer.type}" required /></td>
                        </tr>
                        <tr>
                            <td>Created By:</td>
                            <td><input type="text" value="${customer.createBy}" readonly /></td>
                        </tr>
                        <tr>
                            <td>Created At:</td>
                            <td><input type="text" value="${customer.createAt}" readonly /></td>
                        </tr>
                        <tr>
                            <td>Updated At:</td>
                            <td><input type="text" value="${customer.updateAt}" readonly /></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><button type="submit">Update</button></td>
                        </tr>
                    </table>
                </form>
            </c:if>
        </div>
    </body>
</html>

<%--
    EditCustomer.jsp â€” uses frontend template from frontend.txt
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
    
    
    
    
    
</head>
<body>
  

    <main>
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
                    <input type="hidden" name="customerId" value="${customer.customerId}" />
                    <input type="hidden" name="userId" value="${customer.userId}" />
                    
                    <table>
                        <tr>
                            <td>Customer ID:</td>
                            <td><input type="text" value="${customer.customerId}" readonly></td>
                        </tr>
                        <tr>
                            <td>User ID:</td>
                            <td><input type="text" value="${customer.userId}" readonly></td>
                        </tr>
                        <tr>
                            <td>Username:</td>
                            <td><input type="text" name="username" value="${user.userName}" readonly></td>
                        </tr>
                        <tr>
                            <td>Password:</td>
                            <td><input type="password" name="password" value="${user.password}"></td>
                        </tr>
                        <tr>
                            <td>Role:</td>
                            <td>
                                <c:forEach var="role" items="${roles}">
                                    <c:if test="${role.roleId == user.roleId}">
                                        <input type="text" value="${role.roleName}" readonly>
                                        <input type="hidden" name="roleId" value="${role.roleId}">
                                    </c:if>
                                </c:forEach>
                            </td>
                        </tr>
                        <tr>
                            <td>Full Name:</td>
                            <td><input type="text" name="fullname" value="${user.fullName}"></td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td><input type="text" name="email" value="${user.email}" readonly></td>
                        </tr>
                        <tr>
                            <td>Phone:</td>
                            <td><input type="text" name="phone" value="${user.phone}"></td>
                        </tr>
                        <tr>
                            <td>Status:</td>
                            <td>
                                <select name="status">
                                    <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                                    <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Tax Code:</td>
                            <td><input type="text" name="taxCode" value="${customer.taxCode}" required></td>
                        </tr>
                        <tr>
                            <td>Type:</td>
                            <td><input type="text" name="type" value="${customer.type}" required></td>
                        </tr>
                        <tr>
                            <td>Created At:</td>
                            <td><input type="text" value="${customer.createAt}" readonly></td>
                        </tr>
                        <tr>
                            <td>Updated At:</td>
                            <td><input type="text" value="${customer.updateAt}" readonly></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <br>
                                <button type="submit">Save changes</button>
                                <a href="CustomerDetail?id=${customer.customerId}">Cancel</a>
                            </td>
                        </tr>
                    </table>
                </form>
            </c:if>
        </div>
    </main>
</body>
</html>



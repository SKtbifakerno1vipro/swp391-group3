<%--
    EditCustomer.jsp
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
                    <div>${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div>${error}</div>
                    <c:if test="${not empty errorDetail}">
                        <div>${errorDetail}</div>
                    </c:if>
                </c:if>

                <form action="${pageContext.request.contextPath}/customer/edit" method="post">
                    <input type="hidden" name="customerId" value="${cusDTO.customer.customerId}" />
                    <input type="hidden" name="userId" value="${cusDTO.customer.userId}" />

                    <table>
                        <tr>
                            <td>Customer ID:</td>
                            <td>${cusDTO.customer.customerId}</td>
                        </tr>
                        <tr>
                            <td>User ID:</td>
                            <td>${cusDTO.customer.userId}</td>
                        </tr>
                        <tr>
                            <td>Username:</td>
                            <td><input type="text" name="username" value="${cusDTO.user.userName}" readonly></td>
                        </tr>
                        <tr>
                            <td>Password:</td>
                            <td><input type="password" name="password" placeholder="Leave blank to keep current"></td>
                        </tr>
                        <tr>
                            <td>Role:</td>
                            <td>
                                <c:forEach var="role" items="${roles}">
                                    <c:if test="${role.roleId == cusDTO.user.roleId}">
                                        <input type="text" value="${role.roleName}" readonly>
                                        <input type="hidden" name="roleId" value="${role.roleId}">
                                    </c:if>
                                </c:forEach>
                            </td>
                        </tr>
                        <tr>
                            <td>Full Name:</td>
                            <td><input type="text" name="fullname" value="${cusDTO.user.fullName}"></td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td><input type="text" name="email" value="${cusDTO.user.email}" readonly></td>
                        </tr>
                        <tr>
                            <td>Phone:</td>
                            <td><input type="text" name="phone" value="${cusDTO.user.phone}"></td>
                        </tr>
                        <tr>
                            <td>Status:</td>
                            <td>
                                <select name="status">
                                    <option value="Active" ${cusDTO.user.status == 'Active' ? 'selected' : ''}>Active</option>
                                    <option value="Inactive " ${cusDTO.user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>Tax Code:</td>
                            <td><input type="text" name="taxCode" value="${cusDTO.customer.taxCode}" required></td>
                        </tr>
                        <tr>
                            <td>Company Name:</td>
                            <td><input type="text" name="companyName" value="${cusDTO.customer.companyName}" required></td>
                        </tr>
                        <tr>
                            <td>Customer Type:</td>
                            <td><input type="text" name="customerType" value="${cusDTO.customer.customerType}" required></td>
                        </tr>
                        <tr>
                            <td>Assigned To:</td>
                            <td>
                                <select name="assignedToUserId">
                                    <option value="">-- None --</option>
                                    <c:forEach var="u" items="${users}">
                                        <option value="${u.userId}" ${cusDTO.customer.assignedToUserId == u.userId ? 'selected' : ''}>
                                            ${u.fullName} (${u.userName})
                                        </option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <br>
                                <button type="submit">Save changes</button>
                                <a href="${pageContext.request.contextPath}/customer/list">Cancel</a>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </main>
    </body>
</html>

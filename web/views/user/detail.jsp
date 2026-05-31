<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User Detail</title>
    </head>
    <body>
        <h1>
            <c:if test="${mode=='edit'}">Edit User</c:if>
            <c:if test="${mode!='edit'}">User Detail</c:if>
            </h1>
        <c:if test="${not empty error}">
            <p style="color: red">${error}</p>
        </c:if>

        <form action="edit-user?id=${u.userId}" method="post">
            <table border="1">
                <tr>
                    <td>User Name:</td>
                    <td><input type="text" name="userName" 
                               value="${u.userName}" readonly="" ></td>
                </tr>

                <tr>
                    <td>Full Name:</td>
                    <td><input type="text" name="fullName" 
                               value="${u.fullName}   " ${mode=='edit' ? '' : 'readonly'}></td>
                </tr>

                <tr>
                    <td>Email:</td>
                    <td><input type="text" name="email" 
                               value="${u.email} " readonly=""></td>
                </tr>

                <tr>
                    <td>Phone:</td>
                    <td><input type="text" name="phone"  required pattern="[0-9]{10}"
                               value="${u.phone}" ${mode=='edit' ? '' : 'readonly'}></td>
                </tr>

                <tr>
                    <td>Gender:</td>
                    <td>
                        <select name="gender" ${mode=='edit'? '' : 'disabled' }>
                            <option value="M" ${u.gender== 'M' ? 'selected' : ''} >Male</option>
                            <option value="F" ${u.gender== 'F' ? 'selected' : ''} >Female</option>
                            <option value="O" ${u.gender== 'O' ? 'selected' : ''} >Other</option>

                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Role:</td>
                    <td>
                        <select name="roleId" ${mode=='edit'? '' : 'disabled' }>
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" ${r.roleId == u.roleId ? 'selected': ''}>${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td>Status:</td>
                    <td>
                        <select name="status" ${mode == 'edit' ?' ': 'disabled'}>
                            <option value="ACTIVE" ${u.status =='ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE"  ${u.status =='INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        </select>
                    </td>
                </tr>
                <!-- detailing -->
                <c:if test="${mode != 'edit'}">

                    <a href="edit-user?id=${u.userId}&mode=edit"><button type="button">Edit User</button></a>
                    <a href="user-list"><button type="button">Cancel</button></a>
                </c:if>

                <!-- editing -->
                <c:if test="${mode == 'edit'}">

                    <button type="submit">Save</button>

                    <a href="user-detail?id=${u.userId}"><button type="button">Cancel</button></a>
                </c:if>
            </table>
        </form>

    </body>
</html>
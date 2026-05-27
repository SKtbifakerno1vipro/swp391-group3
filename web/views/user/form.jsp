<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${empty u ? "Create User" : "Edit User"}</title>
        
        
    </head>
    <body>
        <div>
            <c:choose>
                <c:when test="${empty u}">
                    <h1>Create User</h1>
                </c:when>
                <c:otherwise>
                    <h1>Edit User</h1>
                </c:otherwise>
            </c:choose>

            <div>
                <form action="${empty u ? 'create-user' : 'edit-user'}" method="post">
                    <input type="hidden" name="userId" value="${u.userId}" />

                    <div>
                        <label for="userName">Username</label>
                        <input id="userName" type="text" name="userName" value="${u.userName}"
                               <c:if test="${not empty u}">readonly="readonly"</c:if> required />
                    </div>

                    <div>
                        <label for="password">Password</label>
                        <input id="password" type="password" name="password" <c:if test="${empty u}">required</c:if> />
                        <c:if test="${not empty u}">
                            <div>Leave blank to keep current password</div>
                        </c:if>
                    </div>

                    <div>
                        <label for="email">Email Address</label>
                        <input id="email" type="email" name="email" value="${u.email}" required />
                    </div>

                    <div>
                        <label for="fullName">Full Name</label>
                        <input id="fullName" type="text" name="fullName" value="${u.fullName}" />
                    </div>

                    <div>
                        <label for="phone">Phone Number</label>
                        <input id="phone" type="text" name="phone" value="${u.phone}" />
                    </div>

                    <div>
                        <label for="roleId">Role ID</label>
                        <input id="roleId" type="number" name="roleId" value="${u.roleId}" required />
                    </div>

                    <div>
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="Active" <c:if test="${u.status eq 'Active'}">selected</c:if>>Active</option>
                            <option value="Inactive" <c:if test="${u.status eq 'Inactive'}">selected</c:if>>Inactive</option>
                        </select>
                    </div>

                    <div>
                        <button type="submit">Save Changes</button>
                        <a href="user-list">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>



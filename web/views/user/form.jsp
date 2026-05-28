<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${(empty u or u.userId == 0) ? "Create User" : "Edit User"}</title>


    </head>
    <body>
        <div>
            <h1>${(empty u or u.userId == 0) ? "Create User" : "Edit User"}</h1>

            <div><c:if test="${not empty error}">
                    <div>${error}</div>
                </c:if></div>
            <div>
                <form action="${ (empty u or u.userId == 0 ) ?'create-user' : 'edit-user'}" method="post">

                    <input type="hidden" name="userId" value="${u.userId}" />

                    <div>
                        <label for="userName">Username</label>
                        <input id="userName" type="text" name="userName" value="${u.userName}"
                               ${(not empty u and u.userId != 0) ? 'readonly="readonly"' : ''} required />
                    </div>

                    <div>
                        <label for="password">Password</label>
                        <input id="password" type="password" name="password" ${(empty u or u.userId == 0) ? 'required' : ''} />
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
                        <label for="roleId">Role</label>
                        <select id="roleId" name ="roleId">
                            <c:forEach items= "${roleList}" var="role">
                                <option value="${role.roleId}" ${(u.roleId == role.roleId) ? 'selected' : ''} >${role.roleName}</option>
                            </c:forEach>
                        </select>
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



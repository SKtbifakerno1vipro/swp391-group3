<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Detail</title>
        
        
    </head>
    <body>
        <div>
            <h1>User Detail</h1>
            <p>This screen show user detail for purpose of viewing complete profile information of a specific user, including their role, contact details (email, phone), status, and associated account histories.</p>

            <div>
                <c:choose>
                    <c:when test="${not empty u}">
                        <div>
                            <div>
                                <label>User ID</label>
                                <div>${u.userId}</div>
                            </div>
                            <div>
                                <label>Username</label>
                                <div>${u.userName}</div>
                            </div>
                            <div>
                                <label>Email Address</label>
                                <div>${u.email}</div>
                            </div>
                            <div>
                                <label>Full Name</label>
                                <div>${u.fullName}</div>
                            </div>
                            <div>
                                <label>Phone Number</label>
                                <div>${u.phone}</div>
                            </div>
                            <div>
                                <label>Role ID</label>
                                <div>${u.roleId}</div>
                            </div>
                            <div>
                                <label>Status</label>
                                <div>
                                    <span>${u.status}</span>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p>User information not found.</p>
                    </c:otherwise>
                </c:choose>

                <div>
                    <a href="edit-user?id=${u.userId}">Edit this user</a>
                    <a href="user-list">Back to User List</a>
                </div>
            </div>
        </div>
    </body>
</html>



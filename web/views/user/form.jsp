<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${empty u ? "Create User" : "Edit User"}</title>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&family=Nunito+Sans:wght@400;600&display=swap" rel="stylesheet">
        <style>
            * { box-sizing: border-box; }
            body {
                margin: 0;
                padding: 24px;
                background: #f7faf4;
                color: #2c342e;
                font-family: 'Nunito Sans', sans-serif;
                line-height: 24px;
            }
            .page { max-width: 600px; margin: 0 auto; }
            h1 {
                margin: 0 0 8px;
                font-family: 'Literata', serif;
                font-size: 32px;
                line-height: 40px;
                font-weight: 700;
            }
            .desc { margin: 0 0 24px; color: #59615a; }
            .card {
                background: #ffffff;
                border-radius: 16px;
                padding: 32px;
                box-shadow: 0 4px 16px rgba(44, 52, 46, 0.08);
            }
            .form-group {
                margin-bottom: 20px;
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            label {
                color: #59615a;
                font-size: 12px;
                font-weight: 600;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }
            input, select {
                width: 100%;
                padding: 12px;
                border: 1px solid #abb4ac;
                border-radius: 8px;
                background: #ffffff;
                color: #2c342e;
                font-family: 'Nunito Sans', sans-serif;
                font-size: 16px;
            }
            input:focus, select:focus {
                outline: none;
                border-color: #386948;
                box-shadow: 0 0 0 3px rgba(56, 105, 72, 0.12);
            }
            input:read-only { background: #f0f5ee; color: #59615a; cursor: not-allowed; }
            .hint { font-size: 12px; color: #59615a; margin-top: 4px; }
            .actions { display: flex; gap: 12px; margin-top: 32px; }
            .btn {
                border: 0;
                border-radius: 8px;
                padding: 12px 24px;
                cursor: pointer;
                font-family: 'Nunito Sans', sans-serif;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
                text-align: center;
                flex: 1;
            }
            .btn-primary { background: #386948; color: #e8ffe9; }
            .btn-primary:hover { background: #2b5d3c; }
            .btn-secondary { background: #e9f0e8; color: #386948; }
            .btn-secondary:hover { background: #dce5db; }
        </style>
    </head>
    <body>
        <div class="page">
            <c:choose>
                <c:when test="${empty u}">
                    <h1>Create User</h1>
                    <p class="desc">This screen show create user form for purpose of allowing administrators to add new users to the system, assign appropriate roles, and set up initial account credentials.</p>
                </c:when>
                <c:otherwise>
                    <h1>Edit User</h1>
                    <p class="desc">This screen show edit user form for purpose of updating an existing user's information, modifying contact details, changing access roles, or updating account status.</p>
                </c:otherwise>
            </c:choose>

            <div class="card">
                <form action="user" method="post">
                    <input type="hidden" name="userId" value="${u.userId}" />

                    <div class="form-group">
                        <label for="userName">Username</label>
                        <input id="userName" type="text" name="userName" value="${u.userName}"
                               <c:if test="${not empty u}">readonly="readonly"</c:if> required />
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input id="password" type="password" name="password" <c:if test="${empty u}">required</c:if> />
                        <c:if test="${not empty u}">
                            <div class="hint">Leave blank to keep current password</div>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input id="email" type="email" name="email" value="${u.email}" required />
                    </div>

                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input id="fullName" type="text" name="fullName" value="${u.fullName}" />
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input id="phone" type="text" name="phone" value="${u.phone}" />
                    </div>

                    <div class="form-group">
                        <label for="roleId">Role ID</label>
                        <input id="roleId" type="number" name="roleId" value="${u.roleId}" required />
                    </div>

                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status">
                            <option value="Active" <c:if test="${u.status eq 'Active'}">selected</c:if>>Active</option>
                            <option value="Inactive" <c:if test="${u.status eq 'Inactive'}">selected</c:if>>Inactive</option>
                        </select>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="user?action=list" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>

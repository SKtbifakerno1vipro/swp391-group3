<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Detail</title>
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
            .page { max-width: 800px; margin: 0 auto; }
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
                margin-bottom: 24px;
                box-shadow: 0 4px 16px rgba(44, 52, 46, 0.08);
            }
            .grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 24px;
            }
            .info { display: flex; flex-direction: column; gap: 4px; }
            label {
                color: #59615a;
                font-size: 12px;
                font-weight: 600;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }
            .val { font-size: 16px; font-weight: 400; color: #2c342e; }
            .chip {
                padding: 4px 10px;
                border-radius: 9999px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .chip-active { background: #b9efc5; color: #2a5b3b; }
            .chip-inactive { background: #ece1d3; color: #585146; }
            .actions { display: flex; gap: 12px; margin-top: 24px; }
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
            }
            .btn-primary { background: #386948; color: #e8ffe9; }
            .btn-primary:hover { background: #2b5d3c; }
            .btn-secondary { background: #e9f0e8; color: #386948; }
            .btn-secondary:hover { background: #dce5db; }
        </style>
    </head>
    <body>
        <div class="page">
            <h1>User Detail</h1>
            <p class="desc">This screen show user detail for purpose of viewing complete profile information of a specific user, including their role, contact details (email, phone), status, and associated account histories.</p>

            <div class="card">
                <c:choose>
                    <c:when test="${not empty u}">
                        <div class="grid">
                            <div class="info">
                                <label>User ID</label>
                                <div class="val">${u.userId}</div>
                            </div>
                            <div class="info">
                                <label>Username</label>
                                <div class="val">${u.userName}</div>
                            </div>
                            <div class="info">
                                <label>Email Address</label>
                                <div class="val">${u.email}</div>
                            </div>
                            <div class="info">
                                <label>Full Name</label>
                                <div class="val">${u.fullName}</div>
                            </div>
                            <div class="info">
                                <label>Phone Number</label>
                                <div class="val">${u.phone}</div>
                            </div>
                            <div class="info">
                                <label>Role ID</label>
                                <div class="val">${u.roleId}</div>
                            </div>
                            <div class="info">
                                <label>Status</label>
                                <div>
                                    <span class="chip ${u.status == 'Active' ? 'chip-active' : 'chip-inactive'}">${u.status}</span>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty">User information not found.</p>
                    </c:otherwise>
                </c:choose>

                <div class="actions">
                    <a href="user?action=edit&id=${u.userId}" class="btn btn-primary">Edit this user</a>
                    <a href="user?action=list" class="btn btn-secondary">Back to User List</a>
                </div>
            </div>
        </div>
    </body>
</html>

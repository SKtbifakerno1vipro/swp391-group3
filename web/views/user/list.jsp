<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User List</title>
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
            .page { max-width: 1200px; margin: 0 auto; }
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
                padding: 24px;
                margin-bottom: 24px;
                box-shadow: 0 4px 16px rgba(44, 52, 46, 0.08);
            }
            .filter-row {
                display: flex;
                flex-wrap: wrap;
                gap: 16px;
                align-items: end;
            }
            .field { display: flex; flex-direction: column; gap: 8px; }
            label {
                color: #59615a;
                font-size: 12px;
                font-weight: 600;
                line-height: 16px;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }
            input, select {
                min-width: 180px;
                padding: 10px 12px;
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
            .top-actions {
                display: flex;
                justify-content: flex-end;
                margin-bottom: 16px;
            }
            .btn {
                border: 0;
                border-radius: 8px;
                padding: 10px 18px;
                cursor: pointer;
                font-family: 'Nunito Sans', sans-serif;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary { background: #386948; color: #e8ffe9; }
            .btn-primary:hover { background: #2b5d3c; }
            .table-wrap {
                overflow-x: auto;
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 4px 16px rgba(44, 52, 46, 0.08);
            }
            table { width: 100%; border-collapse: collapse; }
            th {
                background: #e9f0e8;
                color: #59615a;
                text-align: left;
                padding: 14px 16px;
                font-size: 12px;
                font-weight: 600;
                letter-spacing: 0.5px;
                text-transform: uppercase;
            }
            td {
                padding: 14px 16px;
                border-top: 1px solid #e9f0e8;
                font-size: 14px;
            }
            tr:hover td { background: #f7faf4; }
            .chip {
                padding: 4px 10px;
                border-radius: 9999px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .chip-active { background: #b9efc5; color: #2a5b3b; }
            .chip-inactive { background: #ece1d3; color: #585146; }
            .action-link {
                color: #386948;
                font-weight: 600;
                text-decoration: none;
                margin-right: 12px;
            }
            .action-link:hover { text-decoration: underline; }
            .empty { text-align: center; color: #59615a; padding: 32px; }
        </style>
    </head>
    <body>
        <div class="page">
            <h1>User List</h1>
            <p class="desc">This screen show user list for purpose of viewing all users in the system (Admin, Manager, Sale, Provider, Customer), filtering by roles or status, and managing system access effectively.</p>

            <div class="card">
                <form method="get" action="user">
                    <input type="hidden" name="action" value="list" />
                    <div class="filter-row">
                        <div class="field">
                            <label for="roleId">Role ID</label>
                            <input id="roleId" type="text" name="roleId" value="${roleId}" placeholder="Enter role id" />
                        </div>
                        <div class="field">
                            <label for="status">Status</label>
                            <select id="status" name="status">
                                <option value="">All</option>
                                <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
                                <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Filter</button>
                    </div>
                </form>
            </div>

            <div class="top-actions">
                <a href="user?action=create" class="btn btn-primary">Create New User</a>
            </div>

            <div class="table-wrap">
                <table>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Role ID</th>
                        <th>Action</th>
                    </tr>

                    <c:forEach items="${users}" var="u">
                        <tr>
                            <td>${u.userId}</td>
                            <td>${u.userName}</td>
                            <td>${u.email}</td>
                            <td>${u.fullName}</td>
                            <td>${u.phone}</td>
                            <td>
                                <span class="chip ${u.status == 'Active' ? 'chip-active' : 'chip-inactive'}">${u.status}</span>
                            </td>
                            <td>${u.roleId}</td>
                            <td>
                                <a href="user?action=view&id=${u.userId}" class="action-link">View</a>
                                <a href="user?action=edit&id=${u.userId}" class="action-link">Edit</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="8" class="empty">No users found.</td>
                        </tr>
                    </c:if>
                </table>
            </div>
        </div>
    </body>
</html>

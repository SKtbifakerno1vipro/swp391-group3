<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create User - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .page-top{
                display:flex;
                align-items:flex-end;
                justify-content:space-between;
                gap:20px;
                margin-bottom:26px
            }
            .eyebrow{
                margin:0 0 6px;
                color:var(--primary);
                font-weight:800;
                letter-spacing:.08em;
                text-transform:uppercase;
                font-size:12px
            }
            h1{
                margin:0;
                font-family:'Literata',Georgia,serif;
                font-size:clamp(32px,4vw,46px);
                line-height:1.08
            }
            .page-top p{
                margin:8px 0 0;
                color:var(--muted)
            }
            .panel{
                background:var(--surface);
                border:1px solid rgba(221,213,201,.85);
                border-radius:28px;
                box-shadow:var(--shadow);
                overflow:hidden
            }
            .panel-head{
                padding:22px 24px;
                border-bottom:1px solid var(--line);
                background:linear-gradient(135deg,#fffaf3,#f0ece4);
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:16px
            }
            .panel-head h2{
                margin:0;
                font-family:'Literata',Georgia,serif
            }
            .panel-body{
                padding:24px
            }
            .form-grid{
                display:grid;
                grid-template-columns:repeat(2,minmax(0,1fr));
                gap:16px
            }
            .field label{
                display:block;
                margin-bottom:8px;
                color:var(--muted);
                font-weight:900;
                font-size:12px;
                text-transform:uppercase;
                letter-spacing:.04em
            }
            .field input,.field select{
                width:100%;
                padding:12px 13px;
                border:1px solid var(--line);
                border-radius:15px;
                background:#fff;
                color:var(--text);
                font:inherit;
                font-weight:700
            }
            .actions{
                display:flex;
                gap:10px;
                flex-wrap:wrap
            }
            .button{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:11px 16px;
                border:1px solid var(--line);
                border-radius:999px;
                background:var(--surface);
                color:var(--text);
                font-weight:800;
                text-decoration:none;
                cursor:pointer;
                font-family:inherit
            }
            .button.primary{
                background:var(--primary);
                border-color:var(--primary);
                color:#fff
            }
            .button.danger{
                background:var(--danger-soft);
                border-color:var(--danger-soft);
                color:var(--danger)
            }
            .alert{
                padding:14px 16px;
                border-radius:16px;
                margin-bottom:18px;
                background:var(--danger-soft);
                color:var(--danger);
                font-weight:800
            }
            @media(max-width:760px){
                .page-top,.panel-head{
                    align-items:flex-start;
                    flex-direction:column
                }
                .form-grid{
                    grid-template-columns:1fr
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp"><jsp:param name="activeMenu" value="users"/></jsp:include>
                <main class="main legacy-page">
                    <section class="page-top"><div><p class="eyebrow">Access Control</p><h1>Create User</h1><p>Create a new employee account and assign a system role.</p></div><div class="actions"><a class="button" href="${pageContext.request.contextPath}/user-list"><span class="material-symbols-outlined">arrow_back</span>Back to users</a></div></section>
                <form class="panel" action="${pageContext.request.contextPath}/edit-user" method="post">
                    <div class="panel-head"><h2>Account Information</h2><button class="button primary" type="submit"><span class="material-symbols-outlined">save</span>Create user</button></div>
                    <div class="panel-body">
                        <c:if test="${not empty error}"><div class="alert"><c:out value="${error}"/></div></c:if>
                            <div class="form-grid">
                                <div class="field"><label>Username</label><input type="text" name="userName" value="${u.userName}" required></div>
                            <div class="field"><label>Full name</label><input type="text" name="fullName" value="${u.fullName}" required></div>
                            <div class="field"><label>Email</label><input type="email" name="email" value="${u.email}" required></div>
                            <div class="field"><label>Phone</label><input type="text" name="phone" value="${u.phone}" required></div>
                            <div class="field"><label>Gender</label><select name="gender"><option value="M" ${u.gender == 'M' ? 'selected' : ''}>Male</option><option value="F" ${u.gender == 'F' ? 'selected' : ''}>Female</option><option value="O" ${u.gender == 'O' ? 'selected' : ''}>Other</option></select></div>
                            <div class="field"><label>Role</label><select name="roleId" required><c:forEach var="r" items="${roles}"><option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option></c:forEach></select></div>
                            </div>
                            <div class="actions" style="margin-top:24px"><button class="button primary" type="submit"><span class="material-symbols-outlined">save</span>Create user</button><a class="button danger" href="${pageContext.request.contextPath}/user-list"><span class="material-symbols-outlined">close</span>Cancel</a></div>
                    </div>
                </form>
            </main>
        </div>
    </body>
</html>
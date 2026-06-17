<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">

            <%-- Auto changes page title based on action --%>
                <c:set var="isEdit" value="${not empty cusDTO}" />
                <title>
                    <c:choose>
                        <c:when test="${isEdit}">Edit Customer - Terra Enterprise</c:when>
                        <c:otherwise>Create Customer</c:otherwise>
                    </c:choose>
                </title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap"
                    rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">

                <style>
                    .container {
                        max-width: 650px;
                        margin: 20px auto;
                    }

                    h1,
                    h2 {
                        font-family: 'Literata', Georgia, serif;
                        font-size: 26px;
                        font-weight: 700;
                        margin-top: 0;
                        margin-bottom: 20px;
                        color: var(--text);
                        text-align: center;
                    }

                    .nav-links {
                        margin-bottom: 25px;
                    }

                    .nav-links a {
                        color: var(--primary);
                        text-decoration: none;
                        font-weight: 800;
                        font-size: 14px;
                        margin-right: 15px;
                        transition: color 0.2s ease;
                    }

                    .nav-links a:hover {
                        text-decoration: underline;
                    }

                    .alert {
                        padding: 12px 16px;
                        margin-bottom: 20px;
                        border-radius: 12px;
                        font-size: 14px;
                    }

                    .alert-success {
                        background-color: var(--primary-soft);
                        color: var(--primary);
                        border: 1px solid rgba(74, 124, 89, 0.2);
                    }

                    .alert-danger {
                        background-color: var(--danger-soft);
                        color: var(--danger);
                        border: 1px solid rgba(184, 50, 48, 0.2);
                    }

                    .form-group {
                        margin-bottom: 18px;
                    }

                    .form-group label {
                        display: block;
                        font-weight: 800;
                        margin-bottom: 8px;
                        font-size: 13px;
                        color: var(--muted);
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                    }

                    .form-control {
                        width: 100%;
                        padding: 10px 14px;
                        font-size: 14px;
                        color: var(--text);
                        background-color: #fff;
                        border: 1px solid var(--line);
                        border-radius: 12px;
                        box-sizing: border-box;
                        outline: none;
                        transition: border-color 0.2s ease;
                    }

                    .form-control:focus {
                        border-color: var(--primary);
                    }

                    /* Specific CSS for read-only fields in Edit mode */
                    .form-control[readonly] {
                        background-color: var(--surface-soft);
                        color: var(--muted);
                        cursor: not-allowed;
                    }

                    span.role-badge {
                        display: inline-block;
                        padding: 6px 14px;
                        font-size: 13px;
                        font-weight: 800;
                        background-color: var(--surface-soft);
                        color: var(--muted);
                        border-radius: 12px;
                        border: 1px solid var(--line);
                    }

                    .btn-group {
                        margin-top: 25px;
                        display: flex;
                        gap: 12px;
                        align-items: center;
                    }

                    .btn-submit {
                        background-color: var(--primary);
                        color: white;
                        padding: 12px 24px;
                        border: none;
                        border-radius: 999px;
                        cursor: pointer;
                        font-weight: 800;
                        font-size: 15px;
                        box-shadow: var(--shadow);
                        transition: all 0.2s ease;
                    }

                    .btn-submit:hover {
                        transform: translateY(-2px);
                        filter: brightness(1.1);
                    }

                    .btn-cancel {
                        background-color: var(--surface-soft);
                        color: var(--text);
                        padding: 12px 24px;
                        border: 1px solid var(--line);
                        border-radius: 999px;
                        text-decoration: none;
                        font-weight: 800;
                        font-size: 15px;
                        transition: all 0.2s ease;
                        display: inline-block;
                        text-align: center;
                    }

                    .btn-cancel:hover {
                        background-color: var(--surface-strong);
                        transform: translateY(-2px);
                    }
                </style>
        </head>

        <body>
            <div class="dashboard-shell">
                <jsp:include page="/views/shared/sidebar.jsp">
                    <jsp:param name="activeMenu" value="customers" />
                </jsp:include>
                <main class="main legacy-page">
                    <div class="container">
                        <c:choose>
                            <c:when test="${isEdit}">
                                <h2>Edit Customer</h2>
                            </c:when>
                            <c:otherwise>
                                <h1>Create Customer</h1>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success">
                                <c:choose>
                                    <c:when test="${isEdit}">${success}</c:when>
                                    <c:otherwise>Create successful</c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <strong>Error:</strong> ${error}
                                <c:if test="${not empty errorDetail}">
                                    <br><small>${errorDetail}</small>
                                </c:if>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/customer/${isEdit ? 'edit' : 'create'}"
                            method="post">

                             <%-- Neu la EDIT thi moi sinh ra 2 the hidden ID nay --%>
                                <c:if test="${isEdit}">
                                    <input type="hidden" name="customerId" value="${cusDTO.customerId}" />
                                    <input type="hidden" name="userId" value="${cusDTO.userId}" />

                                    <%-- Hien thi Customer ID va User ID (Chi Edit moi thay) --%>
                                        <div class="form-group">
                                            <label>Customer ID</label>
                                            <input type="text" class="form-control"
                                                value="${cusDTO.customerId}" readonly>
                                        </div>

                                        <div class="form-group">
                                            <label>User ID</label>
                                            <input type="text" class="form-control" value="${cusDTO.userId}"
                                                readonly>
                                        </div>
                                </c:if>

                                <div class="form-group">
                                    <label for="username">Username</label>
                                    <input type="text" id="username" name="username" class="form-control"
                                        value="${isEdit ? cusDTO.userName : ''}" ${isEdit ? 'readonly' : '' }
                                        required>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" class="form-control"
                                        value="${isEdit ? cusDTO.email : ''}" ${isEdit ? 'readonly' : '' }
                                        required>
                                </div>

                                <%-- Full Name --%>
                                    <div class="form-group">
                                        <label for="fullname">Full Name</label>
                                        <input type="text" id="fullname" name="fullname" class="form-control"
                                            value="${isEdit ? cusDTO.fullName : ''}">
                                    </div>

                                    <%-- Phone --%>
                                        <div class="form-group">
                                            <label for="phone">Phone</label>
                                            <input type="text" id="phone" name="phone" class="form-control"
                                                value="${isEdit ? cusDTO.phone : ''}">
                                        </div>

                                        <%-- Status --%>
                                            <div class="form-group">
                                                <label for="status">Status</label>
                                                <select id="status" name="status" class="form-control">
                                                    <option value="ACTIVE" ${isEdit && cusDTO.status=='ACTIVE'
                                                        ? 'selected' : '' }>ACTIVE</option>
                                                    <option value="INACTIVE" ${isEdit && cusDTO.status=='INACTIVE'
                                                        ? 'selected' : '' }>INACTIVE</option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label>Role</label>
                                                <c:choose>
                                                    <c:when test="${isEdit}">
                                                        <c:forEach var="role" items="${roles}">
                                                            <c:if test="${role.roleId == cusDTO.roleId}">
                                                                <input type="text" class="form-control"
                                                                    value="${role.roleName}" readonly>
                                                                <input type="hidden" name="roleId"
                                                                    value="${role.roleId}">
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="hidden" name="roleId" value="${customerRoleId}">
                                                        <span class="role-badge">Customer</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <%-- Tax Code --%>
                                                <div class="form-group">
                                                    <label for="taxCode">Tax Code</label>
                                                    <input type="text" id="taxCode" name="taxCode" class="form-control"
                                                        value="${isEdit ? cusDTO.taxCode : ''}" required>
                                                </div>

                                                <%-- Company Name --%>
                                                    <div class="form-group">
                                                        <label for="companyName">Company Name</label>
                                                        <input type="text" id="companyName" name="companyName"
                                                            class="form-control"
                                                            value="${isEdit ? cusDTO.companyName : ''}"
                                                            required>
                                                    </div>

                                                    <%-- Customer Type--%>
                                                        <div class="form-group">
                                                            <label for="customerType">Customer Type</label>
                                                            <select id="customerType" name="customerType"
                                                                class="form-control" ${isEdit ? 'required' : '' }>
                                                                <option value="">-- Select Type --</option>
                                                                <c:forEach var="type" items="${listTypeCus}">
                                                                    <option value="${type}" ${isEdit &&
                                                                        cusDTO.customerType==type ? 'selected'
                                                                        : '' }>${type}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>

                                                        <%-- Assigned To--%>
                                                            <div class="form-group">
                                                                <label for="assignedToUserId">Assigned To</label>
                                                                <select id="assignedToUserId" name="assignedToUserId"
                                                                    class="form-control">
                                                                    <option value="">-- None --</option>
                                                                    <c:forEach var="u" items="${users}">
                                                                        <option value="${u.userId}" ${isEdit &&
                                                                            cusDTO.assignedToUserId==u.userId
                                                                            ? 'selected' : '' }>
                                                                            ${u.fullName} (${u.userName})
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>

                                                            <%-- --%>
                                                                <div class="btn-group">
                                                                    <button type="submit" class="btn-submit">${isEdit ?
                                                                        'Save changes' : 'Create'}</button>
                                                                    <a href="${pageContext.request.contextPath}/customer/list"
                                                                        class="btn-cancel">Cancel</a>
                                                                </div>
                        </form>
                    </div>

                </main>
            </div>
        </body>

        </html>
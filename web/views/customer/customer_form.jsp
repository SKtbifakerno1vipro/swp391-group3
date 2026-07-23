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
                        <c:when test="${isEdit}">Chỉnh sửa khách hàng - Terra Enterprise</c:when>
                        <c:otherwise>Tạo khách hàng</c:otherwise>
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
                        max-width: 850px;
                        margin: 20px auto;
                    }

                    .form-grid {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 18px 24px;
                    }

                    .full-width {
                        grid-column: span 2;
                    }

                    @media (max-width: 768px) {
                        .form-grid {
                            grid-template-columns: 1fr;
                        }

                        .full-width {
                            grid-column: span 1;
                        }
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
                    <jsp:param name="activeMenu" value="${sessionScope.user.roleId == 3 ? 'profile' : 'customers'}" />
                </jsp:include>
                <main class="main legacy-page">
                    <div class="container">
                        <c:choose>
                            <c:when test="${isEdit}">
                                <h2>Chỉnh sửa khách hàng</h2>
                            </c:when>
                            <c:otherwise>
                                <h1>Tạo khách hàng</h1>
                            </c:otherwise>
                        </c:choose>
 
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">
                                <c:choose>
                                    <c:when test="${isEdit}">${success}</c:when>
                                    <c:otherwise>Tạo thành công</c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                <strong>Lỗi:</strong> ${error}
                                <c:if test="${not empty errorDetail}">
                                    <br><small>${errorDetail}</small>
                                </c:if>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/customer/${isEdit ? 'edit' : 'create'}"
                            method="post">
                            <div class="form-grid">
                                <%-- Neu la EDIT thi moi sinh ra 2 the hidden ID nay --%>
                                <c:if test="${isEdit}">
                                    <input type="hidden" name="customerId" value="${cusDTO.customer.customerId}" />
                                    <input type="hidden" name="userId" value="${cusDTO.user.userId}" />

                                    <%-- Hien thi Customer ID va User ID (Chi Edit moi thay) --%>
                                    <div class="form-group">
                                        <label>Mã khách hàng</label>
                                        <input type="text" class="form-control" value="${cusDTO.customer.customerId}"
                                            readonly>
                                    </div>

                                    <div class="form-group">
                                        <label>Mã người dùng</label>
                                        <input type="text" class="form-control" value="${cusDTO.user.userId}" readonly>
                                    </div>
                                </c:if>

                                <div class="form-group">
                                    <label for="username">Tên đăng nhập</label>
                                    <input type="text" id="username" name="username" class="form-control"
                                        value="${isEdit ? cusDTO.user.userName : ''}" ${isEdit ? 'readonly' : '' } required>
                                </div>

                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" class="form-control"
                                        value="${isEdit ? cusDTO.user.email : ''}" ${isEdit && sessionScope.user.roleId != 3 ? 'readonly' : '' } required>
                                </div>

                                <%-- Full Name --%>
                                <div class="form-group">
                                    <label for="fullname">Họ và tên</label>
                                    <input type="text" id="fullname" name="fullname" class="form-control"
                                        value="${isEdit ? cusDTO.user.fullName : ''}">
                                </div>

                                <%-- Phone --%>
                                <div class="form-group">
                                    <label for="phone">Số điện thoại</label>
                                    <input type="text" id="phone" name="phone" class="form-control"
                                        value="${isEdit ? cusDTO.user.phone : ''}">
                                </div>

                                <%-- Gender --%>
                                <div class="form-group">
                                    <label for="gender">Giới tính</label>
                                    <select id="gender" name="gender" class="form-control">
                                        <option value="">-- Chọn giới tính --</option>
                                        <option value="M" ${isEdit && cusDTO.user.gender == 'M' ? 'selected' : ''}>Nam</option>
                                        <option value="F" ${isEdit && cusDTO.user.gender == 'F' ? 'selected' : ''}>Nữ</option>
                                        <option value="O" ${isEdit && cusDTO.user.gender == 'O' ? 'selected' : ''}>Khác</option>
                                    </select>
                                </div>

                                <%-- Date of Birth --%>
                                <div class="form-group">
                                    <label for="dateBirth">Ngày sinh</label>
                                    <input type="date" id="dateBirth" name="dateBirth" class="form-control"
                                        value="${isEdit ? cusDTO.user.dateBirth : ''}">
                                </div>

                                <%-- Status --%>
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleId == 3}">
                                        <input type="hidden" name="status" value="${cusDTO.user.status}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group">
                                            <label for="status">Trạng thái</label>
                                            <select id="status" name="status" class="form-control">
                                                <option value="ACTIVE" ${isEdit && cusDTO.user.status=='ACTIVE'
                                                    ? 'selected' : '' }>Hoạt động</option>
                                                <option value="INACTIVE" ${isEdit && cusDTO.user.status=='INACTIVE'
                                                    ? 'selected' : '' }>Ngừng hoạt động</option>
                                            </select>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <%-- Role --%>
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleId == 3}">
                                        <input type="hidden" name="roleId" value="${cusDTO.user.roleId}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group">
                                            <label>Vai trò</label>
                                            <c:choose>
                                                <c:when test="${isEdit}">
                                                    <c:forEach var="role" items="${roles}">
                                                        <c:if test="${role.roleId == cusDTO.user.roleId}">
                                                            <input type="text" class="form-control"
                                                                value="${role.roleName}" readonly>
                                                            <input type="hidden" name="roleId"
                                                                value="${role.roleId}">
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="roleId" value="${customerRoleId}">
                                                    <input type="text" class="form-control" value="Khách hàng" readonly>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <%-- Tax Code --%>
                                <div class="form-group">
                                    <label for="taxCode">Mã số thuế (10 hoặc 13 số dạng XXXXXXXXXX-XXX)</label>
                                    <input type="text" id="taxCode" name="taxCode" class="form-control"
                                        value="${isEdit ? cusDTO.customer.taxCode : ''}" ${sessionScope.user.roleId == 3 ? 'readonly' : ''} required>
                                </div>

                                <%-- Company Name --%>
                                <div class="form-group">
                                    <label for="companyName">Tên công ty</label>
                                    <input type="text" id="companyName" name="companyName"
                                        class="form-control"
                                        value="${isEdit ? cusDTO.customer.companyName : ''}" required>
                                </div>

                                <%-- Customer Type--%>
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleId == 3}">
                                        <input type="hidden" name="customerType" value="${cusDTO.customer.customerType}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group">
                                            <label for="customerType">Loại khách hàng</label>
                                            <select id="customerType" name="customerType"
                                                class="form-control" ${isEdit ? 'required' : '' }>
                                                <option value="">-- Chọn phân loại --</option>
                                                <c:forEach var="type" items="${listTypeCus}">
                                                    <option value="${type}" ${isEdit &&
                                                        cusDTO.customer.customerType==type ? 'selected' : '' }>
                                                        ${type}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <%-- Assigned To--%>
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleId == 3}">
                                        <input type="hidden" name="assignedToUserId" value="${cusDTO.customer.assignedToUserId}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="form-group">
                                            <label for="assignedToUserId">Giao cho (ID người dùng đã đăng nhập: ${sessionScope.user.userId})</label>
                                            <select id="assignedToUserId" name="assignedToUserId"
                                                class="form-control">
                                                <option value="">-- Không giao cho ai --</option>
                                                <c:forEach var="u" items="${users}">
                                                    <option value="${u.userId}" ${(isEdit &&
                                                        cusDTO.customer.assignedToUserId==u.userId) ||
                                                        (!isEdit &&
                                                        sessionScope.user.userId==u.userId)
                                                        ? 'selected' : '' }>
                                                        ${u.fullName} (${u.userName}) - ID:
                                                        ${u.userId}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <%-- Address --%>
                                <div class="form-group full-width">
                                    <label for="address">Địa chỉ</label>
                                    <input type="text" id="address" name="address" class="form-control"
                                        value="${isEdit ? cusDTO.user.address : ''}" placeholder="Nhập địa chỉ">
                                </div>

                                <div class="btn-group full-width">
                                    <button type="submit" class="btn-submit">${isEdit ?
                                        'Lưu thay đổi' : 'Tạo mới'}</button>
                                    <a href="${pageContext.request.contextPath}/${sessionScope.user.roleId == 3 ? 'customer/detail' : 'customer/list'}"
                                        class="btn-cancel">Hủy</a>
                                </div>
                            </div>
                        </form>
                    </div>

                </main>
            </div>
        </body>

        </html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <%-- Tự động đổi Tiêu đề trang tùy theo hành động --%>
        <c:set var="isEdit" value="${not empty cusDTO}" />
        <title><c:choose><c:when test="${isEdit}">Edit Customer - Terra Enterprise</c:when>
                <c:otherwise>Create Customer</c:otherwise></c:choose></title>
        
        <link href="https://fonts.googleapis.com" rel="preconnect">
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
        
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
                color: #212529;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 650px;
                margin: 20px auto;
                background: #ffffff;
                padding: 30px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border: 1px solid #dee2e6;
            }

            h1, h2 {
                font-size: 24px;
                font-weight: 700;
                margin-top: 0;
                margin-bottom: 8px;
                color: #000000;
                border-bottom: 2px solid #212529;
                padding-bottom: 10px;
            }

            .nav-links {
                margin-bottom: 25px;
            }

            .nav-links a {
                color: #0056b3;
                text-decoration: underline;
                font-size: 14px;
                margin-right: 15px;
            }

            .alert {
                padding: 12px 15px;
                margin-bottom: 20px;
                border-radius: 4px;
                font-size: 14px;
            }
            .alert-success {
                background-color: #d1e7dd;
                color: #0f5132;
                border: 1px solid #badbcc;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #842029;
                border: 1px solid #f5c2c7;
            }

            .form-group {
                margin-bottom: 18px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 6px;
                font-size: 14px;
            }

            .form-control {
                width: 100%;
                padding: 6px 10px;
                font-size: 14px;
                line-height: 1.5;
                color: #495057;
                background-color: #fff;
                border: 1px solid #ced4da;
                border-radius: 4px;
                box-sizing: border-box;
                transition: border-color .15s ease-in-out;
            }

            .form-control:focus {
                border-color: #80bdff;
                outline: 0;
            }

            /* CSS đặc trị cho các trường khóa khi ở chế độ Edit */
            .form-control[readonly] {
                background-color: #e9ecef;
                opacity: 1;
                cursor: not-allowed;
            }

            span.role-badge {
                display: inline-block;
                padding: 4px 8px;
                font-size: 13px;
                font-weight: 600;
                background-color: #e9ecef;
                color: #495057;
                border-radius: 4px;
                border: 1px solid #ced4da;
            }

            .btn-group {
                margin-top: 25px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .btn-submit {
                color: #fff;
                background-color: #007bff;
                border-color: #007bff;
                display: inline-block;
                font-weight: 400;
                text-align: center;
                vertical-align: middle;
                cursor: pointer;
                padding: 6px 16px;
                font-size: 14px;
                border: 1px solid transparent;
                border-radius: 4px;
            }

            .btn-submit:hover {
                background-color: #0069d9;
            }

            .btn-cancel {
                color: #fff;
                background-color: #6c757d;
                border-color: #6c757d;
                display: inline-block;
                font-weight: 400;
                text-align: center;
                vertical-align: middle;
                cursor: pointer;
                padding: 6px 16px;
                font-size: 14px;
                border: 1px solid transparent;
                border-radius: 4px;
                text-decoration: none;
            }

            .btn-cancel:hover {
                background-color: #5a6268;
            }
        </style>
    </head>
    <body>
        <main class="container">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/customer/list">Customer List</a>
                <a href="${pageContext.request.contextPath}/dashboard">DashBoard</a>
            </div>

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

            <form action="${pageContext.request.contextPath}/customer/${isEdit ? 'edit' : 'create'}" method="post">
                
                <%-- Nếu là EDIT thì mới sinh ra 2 thẻ hidden ID này --%>
                <c:if test="${isEdit}">
                    <input type="hidden" name="customerId" value="${cusDTO.customer.customerId}" />
                    <input type="hidden" name="userId" value="${cusDTO.customer.userId}" />

                    <%-- Hiển thị Customer ID và User ID (Chỉ Edit mới thấy) --%>
                    <div class="form-group">
                        <label>Customer ID</label>
                        <input type="text" class="form-control" value="${cusDTO.customer.customerId}" readonly>
                    </div>

                    <div class="form-group">
                        <label>User ID</label>
                        <input type="text" class="form-control" value="${cusDTO.customer.userId}" readonly>
                    </div>
                </c:if>

                <%-- Username: Edit readonly  Create thì để trống cho nhập --%>
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" 
                           value="${isEdit ? cusDTO.user.userName : ''}" ${isEdit ? 'readonly' : ''} required>
                </div>
                
                <%-- Email: Edit thì readonly và điền dữ liệu, Create thì để trống cho nhập --%>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" 
                           value="${isEdit ? cusDTO.user.email : ''}" ${isEdit ? 'readonly' : ''} required>
                </div>
                
                <%-- Full Name --%>
                <div class="form-group">
                    <label for="fullname">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="form-control" 
                           value="${isEdit ? cusDTO.user.fullName : ''}">
                </div>
                
                <%-- Phone --%>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control" 
                           value="${isEdit ? cusDTO.user.phone : ''}">
                </div>
                
                <%-- Status: Tự động Selected nếu trùng khớp trạng thái cũ khi Edit --%>
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE" ${isEdit && cusDTO.user.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${isEdit && cusDTO.user.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Role</label>
                    <c:choose>
                        <c:when test="${isEdit}">
                            <c:forEach var="role" items="${roles}">
                                <c:if test="${role.roleId == cusDTO.user.roleId}">
                                    <input type="text" class="form-control" value="${role.roleName}" readonly>
                                    <input type="hidden" name="roleId" value="${role.roleId}">
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
                           value="${isEdit ? cusDTO.customer.taxCode : ''}" required>
                </div>
                
                <%-- Company Name --%>
                <div class="form-group">
                    <label for="companyName">Company Name</label>
                    <input type="text" id="companyName" name="companyName" class="form-control" 
                           value="${isEdit ? cusDTO.customer.companyName : ''}" required>
                </div>
                
                <%-- Customer Type: Xử lý selected động dựa vào biến type --%>
                <div class="form-group">
                    <label for="customerType">Customer Type</label>
                    <select id="customerType" name="customerType" class="form-control" ${isEdit ? 'required' : ''}> 
                        <option value="">-- Select Type --</option>
                        <c:forEach var="type" items="${listTypeCus}">
                            <option value="${type}" ${isEdit && cusDTO.customer.customerType == type ? 'selected' : ''}>${type}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <%-- Assigned To: Xử lý selected động dựa vào userId --%>
                <div class="form-group">
                    <label for="assignedToUserId">Assigned To</label>
                    <select id="assignedToUserId" name="assignedToUserId" class="form-control">
                        <option value="">-- None --</option>
                        <c:forEach var="u" items="${users}">
                            <option value="${u.userId}" ${isEdit && cusDTO.customer.assignedToUserId == u.userId ? 'selected' : ''}>
                                ${u.fullName} (${u.userName})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <%-- Nút bấm thay tên chữ hiển thị linh hoạt --%>
                <div class="btn-group">
                    <button type="submit" class="btn-submit">${isEdit ? 'Save changes' : 'Create'}</button>
                    <a href="${pageContext.request.contextPath}/customer/list" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </main>
    </body>
</html>
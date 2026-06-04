<%-- 
    Document   : CreateCustomer
    Created on : May 21, 2026
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Customer</title>
        <link href="https://fonts.googleapis.com" rel="preconnect">
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
        
        <style>
            /* Nhái lại font chữ và màu nền cơ bản của trang List */
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

            h1 {
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

            /* Hộp thông báo lỗi / thành công */
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

            /* Định dạng lưới Form nhập liệu giống trang quản lý */
            .form-group {
                margin-bottom: 18px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 6px;
                font-size: 14px;
            }

            /* Sửa lại ô Input và Select giống hệt bộ lọc trang List */
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

            /* Tổ hợp nút bấm chuẩn màu sắc trang List */
            .btn-group {
                margin-top: 25px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .btn-submit {
                color: #fff;
                background-color: #007bff; /* Màu xanh nút Tìm kiếm */
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
                background-color: #6c757d; /* Màu xám nút Xóa bộ lọc */
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

            <h1>Create Customer</h1>
            
            <%-- Thông báo kết quả --%>
            <c:if test="${not empty success}">
                <div class="alert alert-success">Create successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <strong>Error:</strong> ${error}
                    <c:if test="${not empty errorDetail}">
                        <br><small>${errorDetail}</small>
                    </c:if>
                </div>
            </c:if>

            <%-- Form create nhập liệu --%>
            <form action="${pageContext.request.contextPath}/customer/create" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="fullname">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="INACTIVE">INACTIVE</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Role</label>
                    <input type="hidden" name="roleId" value="${customerRoleId}">
                    <span class="role-badge">Customer</span>
                </div>
                
                <div class="form-group">
                    <label for="taxCode">Tax Code</label>
                    <input type="text" id="taxCode" name="taxCode" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="companyName">Company Name</label>
                    <input type="text" id="companyName" name="companyName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="customerType">Customer Type</label>
                    <select id="customerType" name="customerType" class="form-control"> 
                        <option value="">-- Select Type --</option>
                        <c:forEach var="type" items="${listTypeCus}">
                            <option value="${type}">${type}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="assignedToUserId">Assigned To</label>
                    <select id="assignedToUserId" name="assignedToUserId" class="form-control">
                        <option value="">-- None --</option>
                        <c:forEach var="u" items="${users}">
                            <option value="${u.userId}">${u.fullName} (${u.userName})</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn-submit">Create</button>
                    <a href="${pageContext.request.contextPath}/customer/list" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </main>
    </body>
</html>
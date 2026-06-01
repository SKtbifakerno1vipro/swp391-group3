<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>Edit Customer - Terra Enterprise</title>
        <link href="https://fonts.googleapis.com" rel="preconnect"/>
        <link crossorigin href="https://fonts.gstatic.com" rel="preconnect"/>
        <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
        
        <style>
            /* Đồng bộ font chữ và màu nền cơ bản giống trang Create và List */
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

            h2 {
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

            /* Định dạng lưới Form nhập liệu */
            .form-group {
                margin-bottom: 18px;
            }

            .form-group label {
                display: block;
                font-weight: 600;
                margin-bottom: 6px;
                font-size: 14px;
            }

            /* Ô Input và Select bo góc viền mỏng hiện đại */
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

            .form-control[readonly] {
                background-color: #e9ecef;
                opacity: 1;
                cursor: not-allowed;
            }

            /* Tổ hợp nút bấm chuẩn màu sắc hệ thống */
            .btn-group {
                margin-top: 25px;
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .btn-submit {
                color: #fff;
                background-color: #007bff; /* Màu xanh nút Tìm kiếm / Lưu dữ liệu */
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
                background-color: #6c757d; /* Màu xám nút Hủy bỏ */
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
                <a href="#">DashBoard</a>
            </div>

            <h2>Edit Customer</h2>

            <%-- Thông báo kết quả --%>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <strong>Error:</strong> ${error}
                    <c:if test="${not empty errorDetail}">
                        <br><small>${errorDetail}</small>
                    </c:if>
                </div>
            </c:if>

            <%-- Form chỉnh sửa thông tin --%>
            <form action="${pageContext.request.contextPath}/customer/edit" method="post">
                <input type="hidden" name="customerId" value="${cusDTO.customer.customerId}" />
                <input type="hidden" name="userId" value="${cusDTO.customer.userId}" />

                <div class="form-group">
                    <label>Customer ID</label>
                    <input type="text" class="form-control" value="${cusDTO.customer.customerId}" readonly>
                </div>

                <div class="form-group">
                    <label>User ID</label>
                    <input type="text" class="form-control" value="${cusDTO.customer.userId}" readonly>
                </div>

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" value="${cusDTO.user.userName}" readonly>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Leave blank to keep current">
                </div>

                <div class="form-group">
                    <label>Role</label>
                    <c:forEach var="role" items="${roles}">
                        <c:if test="${role.roleId == cusDTO.user.roleId}">
                            <input type="text" class="form-control" value="${role.roleName}" readonly>
                            <input type="hidden" name="roleId" value="${role.roleId}">
                        </c:if>
                    </c:forEach>
                </div>

                <div class="form-group">
                    <label for="fullname">Full Name</label>
                    <input type="text" id="fullname" name="fullname" class="form-control" value="${cusDTO.user.fullName}">
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="text" id="email" name="email" class="form-control" value="${cusDTO.user.email}" readonly>
                </div>

                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control" value="${cusDTO.user.phone}">
                </div>

                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status" class="form-control">
                        <option value="ACTIVE" ${cusDTO.user.status == 'ACTIVE' || cusDTO.user.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                        <option value="INACTIVE" ${cusDTO.user.status == 'INACTIVE' || cusDTO.user.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="taxCode">Tax Code</label>
                    <input type="text" id="taxCode" name="taxCode" class="form-control" value="${cusDTO.customer.taxCode}" required>
                </div>

                <div class="form-group">
                    <label for="companyName">Company Name</label>
                    <input type="text" id="companyName" name="companyName" class="form-control" value="${cusDTO.customer.companyName}" required>
                </div>

                <div class="form-group">
                    <label for="customerType">Customer Type</label>
                    <select id="customerType" name="customerType" class="form-control" required>
                        <option value="">-- Select Type --</option>
                        <c:forEach var="type" items="${listTypeCus}">
                            <option value="${type}" ${cusDTO.customer.customerType == type ? 'selected' : ''}>${type}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="assignedToUserId">Assigned To</label>
                    <select id="assignedToUserId" name="assignedToUserId" class="form-control">
                        <option value="">-- None --</option>
                        <c:forEach var="u" items="${users}">
                            <option value="${u.userId}" ${cusDTO.customer.assignedToUserId == u.userId ? 'selected' : ''}>
                                ${u.fullName} (${u.userName})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn-submit">Save changes</button>
                    <a href="${pageContext.request.contextPath}/customer/list" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </main>
    </body>
</html>
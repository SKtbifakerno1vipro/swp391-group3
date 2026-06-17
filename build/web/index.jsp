<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Quyền - ${role.roleName}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; }
        .card { border: 1px solid #ccc; padding: 20px; border-radius: 5px; background-color: #fafafa; max-width: 600px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; background-color: white; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        .badge { background-color: #28a745; color: white; padding: 3px 8px; border-radius: 3px; font-size: 12px; }
        .btn-back { display: inline-block; margin-top: 15px; color: #007bff; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <div class="card">
        <h2>Thông tin nhóm người dùng</h2>
        <p><strong>Mã nhóm (ID):</strong> ${role.roleId}</p>
        <p><strong>Tên nhóm (Role Name):</strong> <span style="color: #d9534f;">${role.roleName}</span></p>

        <h3>Danh sách quyền được cấp:</h3>
        <table>
            <thead>
                <tr>
                    <th>Mã quyền</th>
                    <th>Tên quyền hạn</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="perm" items="${role.permissions}">
                    <tr>
                        <td>${perm.permissionId}</td>
                        <td>${perm.permissionName}</td>
                        <td><span class="badge">Đang kích hoạt</span></td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty role.permissions}">
                    <tr>
                        <td colspan="3" style="text-align: center; color: #999;">Nhóm này chưa được phân quyền nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <a href="${pageContext.request.contextPath}/role-list" class="btn-back">← Quay lại danh sách nhóm</a>
    </div>

</body>
</html>
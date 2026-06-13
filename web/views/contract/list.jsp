<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sách Hợp đồng</title>
    </head>
    <body>
        <h2>Quản lý Hợp đồng</h2>

        <!-- ---------------   Form Tìm Kiếm (4 Trường)   ---------------- -->
        <form action="contract-list" method="GET">
            <!-- 1. Số hợp đồng -->
            <input type="text" name="contractNumber" value="${contractNumber}" placeholder="Số hợp đồng">

            <!-- 2. Tên khách hàng -->
            <input type="text" name="customerName" value="${customerName}" placeholder="Tên khách hàng">

            <!-- 3. Trạng thái -->
            <select name="status">
                <option value="">-- Tất cả trạng thái --</option>
                <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>Bản nháp</option>
                <option value="SIGNED" ${status == 'SIGNED' ? 'selected' : ''}>Đã ký</option>
                <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
            </select>

            <!-- 4. Loại lưu trữ (Mới bổ sung) -->
            <select name="storageType">
                <option value="">-- Loại lưu trữ --</option>
                <option value="TEXT" ${storageType == 'TEXT' ? 'selected' : ''}>Văn bản (TEXT)</option>
                <option value="IMAGE" ${storageType == 'IMAGE' ? 'selected' : ''}>Ảnh scan (IMAGE)</option>
            </select>

            <button type="submit">Tìm kiếm</button>
            <a href="contract-list">Xóa lọc</a>
        </form>

        <br>

        <!-- ---------------   Bảng Danh Sách   ---------------- -->
        <table border="1" cellpadding="5">
            <thead>
                <tr>
                    <td>ID</td>
                    <th>Số Hợp đồng</th>
                    <th>Khách hàng</th>
                    <th>Trạng thái</th>
                    <th>Loại lưu trữ</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty list}">
                    <tr><td colspan="5" style="text-align:center;">Không tìm thấy kết quả nào.</td></tr>
                </c:if>

                <c:forEach items="${list}" var="c">
                    <tr>
                        <td>${c.contractId}</td>
                        <td>${c.contractNumber}</td>
                        <td>${c.customerName}</td>
                        <td>${c.contractStatus}</td>
                        <td>${c.storageType}</td>
                        <td>
                            <a href="contract-save?id=${c.contractId}">Sửa</a> |
                            <a href="contract-detail?id=${c.contractId}">Chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <br>

        <!-- ---------------   Phân Trang (Giữ trạng thái 4 trường)   ---------------- -->
        <c:if test="${endPage > 1}">
            <c:set var="params" value="contractNumber=${contractNumber}&customerName=${customerName}&status=${status}&storageType=${storageType}" />

            <div>
                <!-- Về trang 1 -->
                <a href="contract-list?page=1&${params}" 
                   ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&laquo;</a>

                <!-- Trang trước -->
                <a href="contract-list?page=${currentPage - 1}&${params}" 
                   ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&lsaquo;</a>

                <!-- Các số trang -->
                <c:forEach begin="${currentPage - 2 > 1 ? currentPage - 2 : 1}" 
                           end="${currentPage + 2 < endPage ? currentPage + 2 : endPage}" var="i">
                    <a href="contract-list?page=${i}&${params}" 
                       ${i == currentPage ? 'style="font-weight:bold;color:red;"' : ''}>${i}</a>
                    &nbsp;
                </c:forEach>

                <!-- Trang sau -->
                <a href="contract-list?page=${currentPage + 1}&${params}" 
                   ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&rsaquo;</a>

                <!-- Trang cuối -->
                <a href="contract-list?page=${endPage}&${params}" 
                   ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&raquo;</a>
            </div>
        </c:if>
    </body>
</html>
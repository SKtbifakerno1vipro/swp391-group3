<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách khách hàng</title>
        <style>
            table { width: 100%; border-collapse: collapse; margin-top: 15px; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
            .pagination-container a, .pagination-container span, .pagination-container strong { margin: 0 4px; padding: 5px 10px; text-decoration: none; }
            .pagination-container a { border: 1px solid #ddd; color: #007bff; }
            .pagination-container strong { border: 1px solid #007bff; background-color: #007bff; color: white; }
        </style>
    </head>
    <body>
        <h2>Quản lý danh sách khách hàng (Hệ thống thành viên)</h2>
        
        <c:if test="${not empty success}">
            <div style="color: green; margin-bottom: 10px;">Edit successful</div>
        </c:if>
        <c:if test="${not empty error}">
            <div style="color: red; margin-bottom: 10px;">
                ${error}
                <c:if test="${not empty errorDetail}">
                    <br/><small>${errorDetail}</small>
                </c:if>
            </div>
        </c:if>
        
        <div style="margin-bottom: 15px;">
            <a href="${pageContext.request.contextPath}/customer/create">Add Customer</a> | 
            <a href="${pageContext.request.contextPath}/dashboard">DashBoard</a>
        </div>
        
        <form action="${pageContext.request.contextPath}/customer/list" method="GET">
            <table style="border: none; width: auto; margin-top: 0;">
                <tr style="border: none;">
                    <td style="border: none; padding: 5px 10px;">
                        <label>Tìm kiếm:</label><br/>
                        <input type="text" name="searchName" value="${searchName}" 
                               placeholder="Nhập tên..." style="padding: 5px; width: 250px;"/>
                        <input type="text" name="searchSdt" value="${searchSdt}" 
                               placeholder="Nhập SĐT..." style="padding: 5px; width: 250px;"/>
                        <input type="text" name="searchEmail" value="${searchEmail}" 
                               placeholder="Nhập email..." style="padding: 5px; width: 250px;"/>
                        <input type="text" name="searchMst" value="${searchMst}" 
                               placeholder="Nhập mã số thuế..." style="padding: 5px; width: 250px;"/>
                    </td>

                    <td style="border: none; padding: 5px 10px; vertical-align: bottom;">
                        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Loại khách hàng: </label>
                        <select name="type" style="padding: 5px; width: 150px; box-sizing: border-box;"> 
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="typeCus" items="${listTypeCus}">
                                <option value="${typeCus}" ${type eq typeCus ? 'selected' : ''}>${typeCus}</option>
                            </c:forEach>
                        </select>
                    </td>
                    
                    <td style="border: none; padding: 5px 10px; vertical-align: bottom;">
                        <button type="submit" style="padding: 6px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer;">Tìm kiếm</button>
                        <a href="${pageContext.request.contextPath}/customer/list" style="padding: 6px 15px; background-color: #6c757d; color: white; text-decoration: none; border-radius: 4px; margin-left: 5px;">Xóa bộ lọc</a>
                    </td>
                </tr>
            </table>
        </form>
        
        <table>
            <thead>
                <tr>
                    <th>Mã customer (ID)</th>
                    <th>Tên khách hàng</th>
                    <th>Company Name</th>
                    <th>Email</th>
                    <th>Số điện thoại</th>
                    <th>Mã số thuế</th>
                    <th>Trạng thái</th>
                    <th>Tạo lúc</th>
                    <th>Cập nhật gần nhất</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty customers}">
                    <tr>
                        <td colspan="10" style="text-align: center;">Không có dữ liệu khách hàng</td>
                    </tr>
                </c:if>

                <c:forEach var="cust" items="${customers}">
                    <tr>
                        <td>${cust.customer.customerId}</td>
                        <td><strong>${cust.user.fullName}</strong></td>
                        <td>${cust.customer.companyName}</td>
                        <td>${cust.user.email}</td>
                        <td>${cust.user.phone}</td>
                        <td>${cust.customer.taxCode}</td>
                        <td><span>${cust.user.status}</span></td>
                        <td>${cust.user.formattedCreatedAt}</td>
                        <td>${cust.user.formattedUpdateAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/customer/detail?id_cus=${cust.customer.customerId}">Detail</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
        <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

        <c:if test="${totalPages > 1}">
            <div class="pagination-container" style="margin-top: 20px; text-align: center;">
                
                <%-- Tính toán khoảng hiển thị các nút số trang --%>
                <c:set var="startPage" value="${currentPage - 2}" />
                <c:if test="${startPage < 1}">
                    <c:set var="startPage" value="1" />
                </c:if>
                <c:set var="endPage" value="${startPage + 4}" />
                <c:if test="${endPage > totalPages}">
                    <c:set var="endPage" value="${totalPages}" />
                    <c:set var="startPage" value="${endPage - 4 < 1 ? 1 : endPage - 4}" />
                </c:if>

                <%-- Nút Quay lại (<): Nối kèm tham số tìm kiếm cũ --%>
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="${pageContext.request.contextPath}/customer/list?page=${currentPage - 1}&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}">&lt;</a>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&lt;</span>
                    </c:otherwise>
                </c:choose>

                <%-- Vòng lặp hiển thị các số trang: Nối kèm tham số tìm kiếm cũ --%>
                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <strong>${i}</strong>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/customer/list?page=${i}&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <%-- Nút Tiếp theo (>): Nối kèm tham số tìm kiếm cũ --%>
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="${pageContext.request.contextPath}/customer/list?page=${currentPage + 1}&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}">&gt;</a>
                    </c:when>
                    <c:otherwise>
                        <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&gt;</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>
    </body>
</html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Danh sch Hp ng</title>
    </head>
    <body>
        <h2>Qun l Hp ng</h2>

        <!-- ---------------   Form Tm Kim (4 Trng)   ---------------- -->
        <form action="contract-list" method="GET">
            <!-- 1. S hp ng -->
            <input type="text" name="contractNumber" value="${contractNumber}" placeholder="S hp ng">

            <!-- 2. Tn khch hng -->
            <input type="text" name="customerName" value="${customerName}" placeholder="Tn khch hng">

            <!-- 3. Trng thi -->
            <select name="status">
                <option value="">-- Tt c trng thi --</option>
                <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>Bn nhp</option>
                <option value="SIGNED" ${status == 'SIGNED' ? 'selected' : ''}> k</option>
                <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}> hy</option>
            </select>

            <!-- 4. Loi lu tr (Mi b sung) -->
            <select name="storageType">
                <option value="">-- Loi lu tr --</option>
                <option value="TEXT" ${storageType == 'TEXT' ? 'selected' : ''}>Vn bn (TEXT)</option>
                <option value="IMAGE" ${storageType == 'IMAGE' ? 'selected' : ''}>nh scan (IMAGE)</option>
            </select>

            <button type="submit">Tm kim</button>
            <a href="contract-list">Xa lc</a>
        </form>

        <br>

        <!-- ---------------   Bng Danh Sch   ---------------- -->
        <table border="1" cellpadding="5">
            <thead>
                <tr>
                    <td>ID</td>
                    <th>S Hp ng</th>
                    <th>Khch hng</th>
                    <th>Trng thi</th>
                    <th>Loi lu tr</th>
                    <th>Thao tc</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty list}">
                    <tr><td colspan="5" style="text-align:center;">Khng tm thy kt qu no.</td></tr>
                </c:if>

                <c:forEach items="${list}" var="c">
                    <tr>
                        <td>${c.contractId}</td>
                        <td>${c.contractNumber}</td>
                        <td>${c.customerName}</td>
                        <td>${c.contractStatus}</td>
                        <td>${c.storageType}</td>
                        <td>
                            <a href="contract-save?id=${c.contractId}">Sa</a> |
                            <a href="contract-detail?id=${c.contractId}">Chi tit</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <br>

        <!-- ---------------   Phn Trang (Gi trng thi 4 trng)   ---------------- -->
        <c:if test="${endPage > 1}">
            <c:set var="params" value="contractNumber=${contractNumber}&customerName=${customerName}&status=${status}&storageType=${storageType}" />

            <div>
                <!-- V trang 1 -->
                <a href="contract-list?page=1&${params}" 
                   ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&laquo;</a>

                <!-- Trang trc -->
                <a href="contract-list?page=${currentPage - 1}&${params}" 
                   ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&lsaquo;</a>

                <!-- Cc s trang -->
                <c:forEach begin="${currentPage - 2 > 1 ? currentPage - 2 : 1}" 
                           end="${currentPage + 2 < endPage ? currentPage + 2 : endPage}" var="i">
                    <a href="contract-list?page=${i}&${params}" 
                       ${i == currentPage ? 'style="font-weight:bold;color:red;"' : ''}>${i}</a>
                    &nbsp;
                </c:forEach>

                <!-- Trang sau -->
                <a href="contract-list?page=${currentPage + 1}&${params}" 
                   ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&rsaquo;</a>

                <!-- Trang cui -->
                <a href="contract-list?page=${endPage}&${params}" 
                   ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&raquo;</a>
            </div>
        </c:if>
    </body>
</html>
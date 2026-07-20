<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết báo giá</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="quotations"/>
            </jsp:include>
            <main class="main legacy-page">

                <h1>Chi tiết báo giá</h1>

                <%-- Hien thi thong bao sau khi thao tac. --%>
                <c:if test="${message == 'saveSuccess'}"><p style="color: green; font-weight: bold;">Lưu thành công.</p></c:if>
                <c:if test="${message == 'saveFailed'}"><p style="color: red; font-weight: bold;">Lưu thất bại. Vui lòng thử lại.</p></c:if>
                <c:if test="${message == 'addSuccess'}"><p style="color: green; font-weight: bold;">Thêm sản phẩm thành công.</p></c:if>
                <c:if test="${message == 'addFailed'}"><p style="color: red; font-weight: bold;">Thêm sản phẩm thất bại.</p></c:if>
                <c:if test="${message == 'deleteSuccess'}"><p style="color: green; font-weight: bold;">Xóa sản phẩm thành công.</p></c:if>
                <c:if test="${message == 'deleteFailed'}"><p style="color: red; font-weight: bold;">Xóa sản phẩm thất bại.</p></c:if>
                <c:if test="${message == 'invalidInput'}"><p style="color: red; font-weight: bold;">Dữ liệu đầu vào không hợp lệ.</p></c:if>
                <c:if test="${message == 'accepted'}"><p style="color: green; font-weight: bold;">Đã duyệt báo giá thành công.</p></c:if>
                <c:if test="${message == 'rejected'}"><p style="color: green; font-weight: bold;">Đã hủy/từ chối báo giá thành công.</p></c:if>
                <c:if test="${message == 'permissionDenied'}"><p style="color: red; font-weight: bold;">Bạn không có quyền thực hiện thao tác này.</p></c:if>
                <c:if test="${message == 'invalidStatus'}"><p style="color: red; font-weight: bold;">Không thể sửa đổi báo giá đã duyệt hoặc đã từ chối.</p></c:if>
                <c:if test="${message == 'stockError'}">
                    <p style="color: red; font-weight: bold;">
                        Không đủ hàng cho sản phẩm.
                    </p>
                </c:if>

                <%-- Khoi nay hien thi thong tin chung cua quotation. --%>
                <h2>Thông tin chung</h2>

                <table border="1" cellpadding="7" cellspacing="0">
                    <tr><th>Mã báo giá</th><td>${quotation.quotationId}</td></tr>
                    <tr><th>Khách hàng</th><td>${quotation.customerName}</td></tr>
                    <tr><th>Ngày báo giá</th><td>${quotation.formattedQuotationDate}</td></tr>
                    <tr><th>Trạng thái</th><td>
                        <c:choose>
                             <c:when test="${quotation.quotationStatus == 'DRAFT'}">Nháp</c:when>
                             <c:when test="${quotation.quotationStatus == 'PENDING'}">Chờ duyệt</c:when>
                             <c:when test="${quotation.quotationStatus == 'ACCEPTED'}">Đã duyệt</c:when>
                             <c:when test="${quotation.quotationStatus == 'REJECTED'}">Đã từ chối</c:when>
                             <c:otherwise>${quotation.quotationStatus}</c:otherwise>
                         </c:choose>
                    </td></tr>
                    <tr><th>Tổng giá</th><td><strong><fmt:formatNumber value="${quotation.totalPrice != null ? quotation.totalPrice : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong></td></tr>
                    <tr><th>Người tạo</th><td>${quotation.createdByName}</td></tr>
                    <tr><th>Ngày tạo</th><td>${quotation.formattedCreatedAt}</td></tr>
                </table>

                <br>

                <%-- Form them san pham moi vao quotation hien tai bang searchbar. --%>
                <c:if test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                    <h2>Thêm sản phẩm</h2>
                    <form action="${pageContext.request.contextPath}/quotation-detail" method="post">
                        <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                        <input type="hidden" name="productId" id="addProductId">

                        <label>Tìm kiếm sản phẩm:</label>
                        <input type="text" id="addProductSearch" placeholder="Nhập tên sản phẩm..." autocomplete="off" onkeyup="showProductSuggestions()">

                        <%-- Hop goi y san pham sau khi search. --%>
                        <div id="productSuggestions" style="border: 1px solid #ccc; max-width: 420px; display: none; background: white; position: absolute; z-index: 10;"></div>

                        <span id="selectedProductName" style="font-weight: bold; color: green; margin-left: 10px;"></span>

                        <br><br>

                        <div style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                            <div>
                                <label>Đơn vị:</label>
                                <input type="text" id="addUnit" readonly style="width: 75px; background-color: #f1f1f1; border: 1px solid #ccc; padding: 4px;">
                            </div>
                            <div>
                                <label>Giá bán:</label>
                                <input type="number" id="addSellingPrice" readonly style="width: 110px; background-color: #f1f1f1; border: 1px solid #ccc; padding: 4px;">
                            </div>
                            <div>
                                <label>Số lượng:</label>
                                <input type="number" name="quantity" min="1" value="1" required style="width: 70px; padding: 4px;">
                            </div>
                        </div>
                        <br>
                        <button type="submit" name="action" value="addProduct" onclick="return validateAddProductForm()">Thêm sản phẩm</button>
                    </form>
                    <br>
                </c:if>

                <%-- Khoi nay hien thi va cho sua danh sach san pham trong quotation. --%>
                <c:if test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                    <div style="margin-bottom: 15px;">
                        <form action="${pageContext.request.contextPath}/quotation-detail" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="applyAll">
                            <input type="hidden" name="quotationId" value="${quotation.quotationId}">

                            <label><strong>Chiết khấu %:</strong></label>
                            <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required>

                            <label style="margin-left: 10px;"><strong>Thuế %:</strong></label>
                            <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required>

                            <button type="submit" style="margin-left: 10px;">Áp dụng cho tất cả sản phẩm</button>
                        </form>
                    </div>
                </c:if>

                <table border="1" cellpadding="7" cellspacing="0" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Đơn vị</th>
                                <c:if test="${sessionScope.user.roleId != 3}">
                                <th>Giá vốn</th>
                                </c:if>
                            <th>Giá bán</th>
                            <th>Số lượng</th>
                            <th>Chiết khấu %</th>
                            <th>Thuế %</th>
                            <th>Thành tiền</th>
                                <c:if test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                                <th>Hành động</th>
                                </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty details}">
                            <tr><td colspan="10" style="text-align: center;">Không tìm thấy chi tiết sản phẩm nào.</td></tr>
                        </c:if>

                        <c:forEach items="${details}" var="detail">
                            <tr>
                            <form action="${pageContext.request.contextPath}/quotation-detail" method="post">
                                <td>
                                    ${detail.productName}
                                    <input type="hidden" name="productId" value="${detail.productId}">
                                    <input type="hidden" name="productName" value="${detail.productName}">
                                </td>
                                <td>${detail.unit}</td>
                                <c:if test="${sessionScope.user.roleId != 3}">
                                    <td>
                                        <fmt:formatNumber value="${detail.costPrice}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                    </td>
                                </c:if>
                                <td>
                                    <fmt:formatNumber value="${detail.sellingPrice}" type="number" minFractionDigits="2" maxFractionDigits="2" />
                                    <input type="hidden" name="sellingPrice" value="${detail.sellingPrice}">
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                                            <input type="number" name="quantity" min="1" value="${detail.quantity}" required style="width: 70px;">
                                        </c:when>
                                        <c:otherwise>
                                            ${detail.quantity}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                                            <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="${detail.discountPercent}" readonly style="width: 70px;">
                                        </c:when>
                                        <c:otherwise>
                                            ${detail.discountPercent}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                                            <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="${detail.taxPercent}" readonly style="width: 70px;">
                                        </c:when>
                                        <c:otherwise>
                                            ${detail.taxPercent}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatNumber value="${detail.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                                <c:if test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                                    <td>
                                        <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                                        <input type="hidden" name="quotationDetailId" value="${detail.quotationDetailId}">
                                        <button type="submit" name="action" value="updateDetail">Lưu</button>
                                        <button type="submit" name="action" value="deleteProduct" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi báo giá?')">Xóa</button>
                                    </td>
                                </c:if>
                            </form>
                            </tr>
                        </c:forEach>
                                   <!-- Grand Total Row -->
                        <tr style="background-color: #f9f9f9;">
                            <td colspan="${sessionScope.user.roleId != 3 ? 7 : 6}" style="text-align: right; font-weight: bold;">Tổng cộng:</td>
                            <td style="font-weight: bold; color: #2e7d32;">
                                <fmt:formatNumber value="${quotation.totalPrice != null ? quotation.totalPrice : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                            </td>
                            <c:if test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                            <td></td>
                            </c:if>
                        </tr>
                    </tbody>
                </table>

                <br>

                <%-- Khoi nay hien thi lich su negotiation cua quotation. --%>
                <h2>Lịch sử thương lượng</h2>

                <table border="1" cellpadding="7" cellspacing="0" style="width: 100%;">
                    <thead>
                        <tr><th>Thời gian</th><th>Tên người dùng</th><th>Lịch sử</th></tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty histories}">
                            <tr><td colspan="3" style="text-align: center;">Không tìm thấy lịch sử nào.</td></tr>
                        </c:if>

                        <c:forEach items="${histories}" var="history">
                            <tr>
                                <td>${history.formattedCreatedAt}</td>
                                <td><c:out value="${history.createdByName != null ? history.createdByName : 'Hệ thống'}"/></td>
                                <td>${history.editHistory}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <br>
                <div style="margin-top: 20px;">
                    <c:if test="${sessionScope.user.roleId == 4 && isAllowedToManage && (quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING')}">
                        <form action="quotation-detail" method="POST" style="display:inline;">
                            <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                            <input type="hidden" name="action" value="accept">
                            <button type="submit" style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Duyệt báo giá</button>
                        </form>
                        
                        <form action="quotation-detail" method="POST" style="display:inline; margin-left: 10px;">
                            <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" style="padding: 10px 20px; background-color: #f44336; color: white; border: none; cursor: pointer;" onclick="return confirm('Bạn có chắc chắn muốn hủy/từ chối báo giá này không?')">Hủy báo giá</button>
                        </form>
                    </c:if>

                    <c:if test="${sessionScope.user.roleId == 5 && quotation.quotationStatus == 'ACCEPTED'}">
                        <a href="contract-save?quotationId=${quotation.quotationId}">
                            <button style="padding: 10px 20px; background-color: #008CBA; color: white; border: none; cursor: pointer;">Tạo hợp đồng nháp</button>
                        </a>
                    </c:if>
                </div>

                <br>
                <a href="${pageContext.request.contextPath}/quotation-list">Quay lại danh sách</a>

                <script>
                    // Luu danh sach product tu server sang JavaScript de search goi y.
                    const products = [
                    <c:forEach items="${products}" var="product" varStatus="status">
                    {
                    id: '${product.productId}',
                            name: '${product.productName}',
                            price: '${product.sellingPrice}',
                            costPrice: '${sessionScope.user.roleId != 3 ? product.costPrice : 0}',
                            unit: '${product.unit}'
                    }${status.last ? '' : ','}
                    </c:forEach>
                    ];

                    // Hien thi danh sach goi y theo keyword user dang go.
                    function showProductSuggestions() {
                        const keyword = document.getElementById('addProductSearch').value.toLowerCase().trim().replace(/\s+/g, ' ');
                        const box = document.getElementById('productSuggestions');

                        document.getElementById('addProductId').value = '';
                        document.getElementById('selectedProductName').textContent = '';
                        document.getElementById('addUnit').value = '';
                        const addCostPriceElem = document.getElementById('addCostPrice');
                        if (addCostPriceElem)
                            addCostPriceElem.value = '';
                        document.getElementById('addSellingPrice').value = '';

                        if (keyword === '') {
                            box.style.display = 'none';
                            box.innerHTML = '';
                            return;
                        }

                        const matchedProducts = products.filter(function (product) {
                            return product.name.toLowerCase().includes(keyword);
                        });

                        if (matchedProducts.length === 0) {
                            box.innerHTML = '<div style="padding: 8px; color: red;">Không tìm thấy sản phẩm</div>';
                            box.style.display = 'block';
                            return;
                        }

                        let html = '';
                        matchedProducts.forEach(function (product) {
                            html += '<div style="padding: 8px; cursor: pointer; border-bottom: 1px solid #eee;" '
                                    + 'onclick="selectProduct(\'' + product.id + '\', \'' + escapeSingleQuote(product.name) + '\', \'' + product.price + '\', \'' + product.costPrice + '\', \'' + escapeSingleQuote(product.unit) + '\')">'
                                    + product.name + ' - ' + product.price
                                    + '</div>';
                        });

                        box.innerHTML = html;
                        box.style.display = 'block';
                    }

                    // Chon 1 san pham tu goi y.
                    function selectProduct(productId, productName, productPrice, productCost, productUnit) {
                        document.getElementById('addProductId').value = productId;
                        document.getElementById('addProductSearch').value = productName;
                        document.getElementById('selectedProductName').textContent = 'Đã chọn: ' + productName;
                        document.getElementById('addSellingPrice').value = productPrice;
                        const addCostPriceElem = document.getElementById('addCostPrice');
                        if (addCostPriceElem)
                            addCostPriceElem.value = productCost;
                        document.getElementById('addUnit').value = productUnit;
                        document.getElementById('productSuggestions').style.display = 'none';
                    }

                    // Khong cho add neu user chua chon san pham tu goi y.
                    function validateAddProductForm() {
                        if (document.getElementById('addProductId').value === '') {
                            alert('Vui lòng chọn một sản phẩm từ danh sách gợi ý.');
                            return false;
                        }
                        return true;
                    }

                    // Xu ly dau nhay don trong ten san pham de JS khong bi loi.
                    function escapeSingleQuote(text) {
                        return text.replace(/'/g, "\\'");
                    }
                </script>

            </main>
        </div>
    </body>
</html>






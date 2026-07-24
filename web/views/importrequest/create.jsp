<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo Yêu cầu Nhập kho Mới - Bakery Sales System</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700;800&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .create-layout-grid {
                display: grid;
                grid-template-columns: minmax(0, 1.4fr) minmax(300px, 0.6fr);
                gap: 24px;
                align-items: start;
            }
            @media (max-width: 900px) {
                .create-layout-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="import-requests"/>
            </jsp:include>
            <main class="main">
                <!-- Topbar Header -->
                <div class="topbar">
                    <div>
                        <p class="eyebrow">QUẢN LÝ KHO HÀNG</p>
                        <c:choose>
                            <c:when test="${sessionScope.user.roleId == 6}">
                                <h1>Nhập sản phẩm</h1>
                                <p>Nhập bổ sung sản phẩm nguyên liệu bánh trực tiếp vào kho hàng.</p>
                            </c:when>
                            <c:otherwise>
                                <h1>Tạo Yêu cầu Nhập kho Mới</h1>
                                <p>Đề xuất bổ sung sản phẩm nguyên liệu bánh vào kho hàng.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <a href="${pageContext.request.contextPath}/import-request-list" class="btn-secondary-action">
                        <span class="material-symbols-outlined">arrow_back</span>
                        Quay lại danh sách
                    </a>
                </div>

                <!-- Error Alert Message -->
                <c:if test="${not empty error}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">error</span>
                        <span><strong>Lỗi:</strong> <c:out value="${error}"/></span>
                    </div>
                </c:if>

                <div class="create-layout-grid">
                    <!-- Form Card -->
                    <div class="modern-form-card">
                        <h2 style="font-family: 'Literata', serif; margin-top: 0; margin-bottom: 20px; font-size: 20px; color: var(--text);">Thông tin Phiếu Nhập Kho</h2>
                        <form action="${pageContext.request.contextPath}/import-request-create" method="post">
                            <div class="form-group">
                                <label for="productId">Sản phẩm nguyên liệu bánh: <span style="color: var(--danger);">*</span></label>
                                <select id="productId" name="productId" required class="form-control">
                                    <option value="">-- Chọn sản phẩm nguyên liệu --</option>
                                    <c:forEach items="${products}" var="p">
                                        <option value="${p.productId}">
                                            ${p.productName} (${p.unit}) — Tồn kho khả dụng: ${p.quantityAvailable}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="quantity">Số lượng cần nhập bổ sung: <span style="color: var(--danger);">*</span></label>
                                <input type="number" id="quantity" name="quantity" min="1" required placeholder="Nhập số lượng (vd: 50, 100...)" class="form-control">
                            </div>

                            <div class="form-group">
                                <label for="note">Ghi chú đề xuất / Lý do nhập kho:</label>
                                <textarea id="note" name="note" rows="4" placeholder="Nhập mục đích hoặc lý do yêu cầu nhập kho nguyên liệu này..." class="form-control" style="resize: vertical;"></textarea>
                            </div>

                            <div style="display: flex; gap: 12px; margin-top: 28px;">
                                <c:choose>
                                    <c:when test="${sessionScope.user.roleId == 6}">
                                        <button type="submit" class="btn-primary-action">
                                            <span class="material-symbols-outlined">download</span>
                                            Nhập sản phẩm
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="submit" class="btn-primary-action">
                                            <span class="material-symbols-outlined">send</span>
                                            Gửi yêu cầu nhập kho
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                <a href="${pageContext.request.contextPath}/import-request-list" class="btn-secondary-action">
                                    Hủy bỏ
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Side Guidelines Card -->
                    <div class="panel status-panel" style="background: var(--surface-soft); border-radius: 26px;">
                        <div class="panel-title">
                            <h2 style="margin: 0; font-size: 16px; font-weight: 800;">💡 Hướng dẫn Quy trình</h2>
                        </div>
                        <div style="font-size: 13px; color: var(--muted); line-height: 1.6; margin-top: 12px;">
                            <p style="margin-bottom: 12px;">
                                1. <strong>Tạo đề xuất:</strong> Nhân viên Sale / Nhân viên Kho tạo phiếu yêu cầu nhập nguyên liệu.
                            </p>
                            <p style="margin-bottom: 12px;">
                                2. <strong>Xử lý tại Kho:</strong> Nhân viên Kho kiểm tra thực tế và bấm <em>"Xác nhận Nhập kho"</em> để cập nhật tự động số lượng tồn kho khả dụng.
                            </p>
                            <p style="margin-bottom: 0;">
                                3. <strong>Hủy phiếu:</strong> Trong trường hợp thông tin chưa khớp, Nhân viên Kho có thể từ chối và ghi rõ lý do hủy.
                            </p>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>

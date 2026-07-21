<%--
    Document   : detail
    Created on : May 31, 2026, 12:57:11 AM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết sản phẩm</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .review-actions-dropdown {
                position: relative;
                display: inline-block;
                margin-left: 8px;
                vertical-align: middle;
            }

            .dropdown-trigger-btn {
                background: none;
                border: none;
                cursor: pointer;
                color: var(--muted);
                padding: 4px;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: background 0.2s ease, color 0.2s ease;
            }

            .dropdown-trigger-btn:hover {
                background: var(--surface-soft);
                color: var(--text);
            }

            .dropdown-menu-box {
                display: none;
                position: absolute;
                left: 0;
                top: 100%;
                z-index: 10;
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                min-width: 150px;
                padding: 6px 0;
                animation: fadeInDropdown 0.2s ease;
            }

            .dropdown-toggle-input:checked ~ .dropdown-menu-box {
                display: block;
            }

            @keyframes fadeInDropdown {
                from { opacity: 0; transform: translateY(-5px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .dropdown-item {
                display: block;
                width: 100%;
                padding: 8px 16px;
                border: none;
                background: none;
                text-align: left;
                font-size: 13px;
                font-weight: 700;
                color: var(--text);
                cursor: pointer;
                transition: color 0.2s ease;
            }

            .dropdown-item:hover {
                color: var(--primary);
                background: none;
            }

            .dropdown-item-danger {
                color: var(--danger);
            }

            .dropdown-item-danger:hover {
                color: #ff0000;
                background: none;
            }

            .edit-review-form-box {
                display: none;
                margin-top: 15px;
                background: var(--bg);
                border: 1px solid var(--line);
                border-radius: 10px;
                padding: 15px;
                flex-direction: column;
                gap: 10px;
            }

            .edit-form-toggle-input:checked ~ .edit-review-form-box {
                display: flex;
            }
            .btn-sm {
                padding: 6px 12px;
                font-size: 12px;
                border-radius: 6px;
            }

            /* Reviews Section Styles */
            .reviews-container {
                margin-top: 40px;
                padding: 30px;
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 20px;
                box-shadow: var(--shadow);
            }

            .reviews-container h2 {
                font-family: 'Literata', Georgia, serif;
                color: var(--primary);
                margin-bottom: 20px;
                font-size: 24px;
                border-bottom: 2px solid var(--line);
                padding-bottom: 10px;
            }

            .reviews-summary-card {
                display: flex;
                flex-wrap: wrap;
                gap: 30px;
                background: var(--bg);
                padding: 24px;
                border-radius: 16px;
                margin-bottom: 30px;
                border: 1px solid var(--line);
            }

            .rating-average-box {
                flex: 1;
                min-width: 200px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                border-right: 1px solid var(--line);
                padding-right: 20px;
            }

            @media (max-width: 768px) {
                .rating-average-box {
                    border-right: none;
                    padding-right: 0;
                    border-bottom: 1px solid var(--line);
                    padding-bottom: 20px;
                }
            }

            .rating-num {
                font-size: 48px;
                font-weight: 800;
                color: var(--primary);
                line-height: 1;
            }

            .big-stars .star {
                font-size: 26px;
            }

            .rating-count {
                font-size: 14px;
                color: var(--muted);
                margin-top: 5px;
            }

            .add-review-box {
                flex: 2;
                min-width: 300px;
            }

            .add-review-box h3 {
                margin-top: 0;
                color: var(--secondary);
                font-size: 18px;
                margin-bottom: 15px;
            }

            .review-locked {
                display: flex;
                align-items: center;
                height: 100%;
                color: var(--muted);
                font-style: italic;
                background: var(--surface-soft);
                padding: 15px;
                border-radius: 12px;
            }
            .review-locked span {
                margin-right: 8px;
                color: var(--tertiary);
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                font-weight: 700;
                font-size: 14px;
                margin-bottom: 6px;
            }

            .form-group textarea {
                width: 100%;
                border: 1px solid var(--line);
                border-radius: 10px;
                padding: 12px;
                background: var(--surface);
                font-family: inherit;
                font-size: 14px;
                color: var(--text);
                resize: vertical;
            }

            .form-group textarea:focus {
                outline: none;
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(74, 124, 89, 0.15);
            }

            /* Star Rating Input */
            .rating-input-group {
                display: flex;
                align-items: center;
                gap: 15px;
                margin-bottom: 15px;
            }
            .rating-input-group label {
                font-weight: 700;
                font-size: 14px;
            }

            .star-rating-input {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end;
            }

            .star-rating-input input {
                display: none;
            }

            .star-rating-input label {
                font-size: 26px;
                color: var(--surface-strong);
                cursor: pointer;
                transition: color 0.2s ease;
                margin: 0;
                padding: 0 2px;
            }

            .star-rating-input label:hover,
            .star-rating-input label:hover ~ label,
            .star-rating-input input:checked ~ label {
                color: #f39c12;
            }

            /* Reviews List Styles */
            .reviews-list {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .review-card {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 14px;
                padding: 20px;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .review-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.02);
            }

            .review-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 8px;
            }

            .reviewer-name {
                font-weight: 700;
                color: var(--text);
            }

            .review-date {
                font-size: 12px;
                color: var(--muted);
            }

            .review-comment {
                margin: 8px 0 0;
                font-size: 14px;
                line-height: 1.5;
                color: var(--text);
            }

            .star-rating .star {
                color: var(--surface-strong);
                font-size: 16px;
                letter-spacing: -2px;
            }

            .star-rating .star.active {
                color: #f39c12;
            }

            /* Staff Reply Card Styles */
            .staff-reply-card {
                margin-top: 15px;
                background: var(--primary-soft);
                border-left: 4px solid var(--primary);
                border-radius: 8px;
                padding: 15px;
            }

            .reply-header {
                display: flex;
                align-items: center;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 6px;
                font-size: 12px;
            }

            .staff-tag {
                background: var(--primary);
                color: #fff;
                font-weight: 800;
                padding: 2px 8px;
                border-radius: 20px;
                text-transform: uppercase;
                font-size: 10px;
                letter-spacing: 0.5px;
            }

            .staff-name {
                font-weight: 700;
                color: var(--primary);
            }

            .reply-content {
                margin: 0;
                font-size: 14px;
                line-height: 1.5;
                color: var(--text);
            }

            .empty-reviews-state {
                text-align: center;
                padding: 30px;
                background: var(--bg);
                border-radius: 12px;
                color: var(--muted);
                font-style: italic;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                padding: 10px 20px;
                border-radius: 12px;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
                font-size: 14px;
            }

            .btn-primary {
                background: var(--primary);
                color: #fff;
            }

            .btn-primary:hover {
                opacity: 0.9;
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="products"/>
            </jsp:include>
            <main class="main legacy-page">
                <div>
                    <c:if test="${action == 'detail'}">
                        <h1>Chi tiết sản phẩm</h1>
                    </c:if>
                    <c:if test="${action != 'detail'}">
                        <h1>Chỉnh sửa sản phẩm</h1>
                    </c:if>
                    <c:if test="${error != null}" >
                        <p>${error}</p>
                    </c:if>
                    <div>
                        <form action="edit-product" method="post">
                            <table border="1">
                                <input type="hidden" name="id" value="${product.productId}">
                                <input type="hidden" name="action" value="${action}">
                                <tr>
                                    <td>Tên sản phẩm</td>
                                    <td><input type="text" name="name" value="${product.productName}" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <c:if test="${sessionScope.user.roleId != 3}">
                                    <tr>
                                        <td>Giá gốc</td>
                                        <fmt:formatNumber var="fmtCost" value="${product.costPrice}" pattern="#"/>
                                        <td><input type="number"  name="cost" value="${fmtCost}" min="0" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                    </tr>
                                </c:if>

                                <tr>
                                    <td>Giá bán</td>
                                    <fmt:formatNumber var="fmtSell" value="${product.sellingPrice}" pattern="#"/>
                                    <td><input type="number" name="sell" value="${fmtSell}" min="0" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <tr>
                                    <td>Mô tả</td>
                                    <td><textarea name="description" rows="5" cols="20" ${action != 'detail' ? ' ' : 'readonly'} required>${product.description}</textarea></td>
                                </tr>
                                <tr>
                                    <td>Đơn vị</td>
                                    <td><input type="text" name="unit" value="${product.unit}" ${action != 'detail' ? ' ' : 'readonly'} required></td>
                                </tr>
                                <c:if test="${sessionScope.user.roleId != 3}">
                                    <tr>
                                        <td>Trạng thái sản phẩm</td>
                                        <td>
                                            <select name="status" ${action != 'detail' ? ' ' : 'disabled'}>
                                                <option value="ACTIVE" ${product.productStatus == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="OUT_OF_STOCK" ${product.productStatus == 'OUT_OF_STOCK' ? 'selected' : ''}>Hết hàng</option>
                                                <option value="INACTIVE" ${product.productStatus == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                                            </select>
                                        </td>
                                    </tr>


                                    <tr>
                                        <td>Số lượng</td>
                                        <td><input type="number" name="quantity" value="${product.quantityAvailable}" min="0" readonly></td>
                                    </tr>
                                    <tr>
                                        <td>Số lượng đặt trước</td>
                                        <td><input type="number" name="reserve" value="${product.quantityReserve}" readonly></td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <td>Danh mục</td>
                                    <td>
                                        <select name="categoryId" ${action != 'detail' ? ' ' : 'disabled'}>
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c.categoryId}" ${c.categoryId == product.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <td>Ngày tạo</td>
                                    <td><fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>

                                </tr>
                                <tr>
                                <input type="hidden" name="update_at" value="${product.updatedAt}">
                                <td>Ngày cập nhật</td>
                                <td><fmt:formatDate value="${product.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>

                                </tr>
                                <tr>
                                    <td>Người cập nhật</td>
                                    <td><input type="text" name="update_by" value="${update_by}" readonly></td>
                                </tr>
                            </table>

                            <div>
                                <c:if test="${action == 'detail' && sessionScope.user.roleId != 3}">
                                    <a href="${pageContext.request.contextPath}/edit-product?id=${product.productId}&action=edit"><button type="button">Chỉnh sửa</button></a>
                                </c:if> 
                                <c:if test="${action == 'edit'}">
                                    <input type="submit" value="Lưu">
                                </c:if>

                                <a href="${pageContext.request.contextPath}/product-list">${sessionScope.user.roleId != 3 ? 'Hủy' : 'Quay lại danh sách'}</a></div>
                        </form>
                    </div>

                    <div class="reviews-container">
                        <h2>Đánh giá & Nhận xét sản phẩm</h2>

                        <div class="reviews-summary-card">
                            <div class="rating-average-box">
                                <span class="rating-num">
                                    <fmt:formatNumber value="${empty avgRating ? 0 : avgRating}" pattern="#.0"/>
                                </span>
                                <div class="star-rating big-stars">
                                    <c:forEach var="i" begin="1" end="5">
                                        <span class="star ${i <= (empty avgRating ? 0 : avgRating) ? 'active' : ''}">★</span>
                                    </c:forEach>
                                </div>
                                <span class="rating-count">(${empty reviews ? 0 : reviews.size()} đánh giá)</span>
                            </div>

                            <c:if test="${canReview}">
                                <div class="add-review-box">
                                    <h3>Viết đánh giá của bạn</h3>
                                    <form action="${pageContext.request.contextPath}/product-review" method="post" class="review-submit-form">
                                        <input type="hidden" name="action" value="addReview">
                                        <input type="hidden" name="productId" value="${product.productId}">

                                        <div class="rating-input-group">
                                            <label>Chọn đánh giá:</label>
                                            <div class="star-rating-input">
                                                <input type="radio" id="star5" name="rating" value="5" required /><label for="star5" title="5 sao">★</label>
                                                <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="4 sao">★</label>
                                                <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="3 sao">★</label>
                                                <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="2 sao">★</label>
                                                <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="1 sao">★</label>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="comment-text">Nội dung nhận xét:</label>
                                            <textarea id="comment-text" name="comment" rows="3" placeholder="Chia sẻ trải nghiệm thực tế của bạn về sản phẩm này..." required></textarea>
                                        </div>

                                        <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                    </form>
                                </div>
                            </c:if>
                            <c:if test="${!canReview && sessionScope.user.roleId == 3}">
                                <div class="add-review-box review-locked">
                                    <p><span class="material-symbols-outlined" style="vertical-align: middle;">info</span> Bạn chỉ có thể viết đánh giá cho sản phẩm này sau khi đã mua hàng và đơn hàng ở trạng thái Hoàn thành.</p>
                                </div>
                            </c:if>
                        </div>

                        <div class="reviews-list">
                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach var="r" items="${reviews}">
                                        <div class="review-card">
                                            <div class="review-header">
                                                <div style="display: flex; align-items: center; gap: 8px;">
                                                    <span class="reviewer-name">${r.companyName}</span>
                                                    <c:if test="${r.userId == sessionScope.user.userId}">
                                                        <div class="review-actions-dropdown">
                                                            <input type="checkbox" id="dropdown-toggle-${r.reviewId}" class="dropdown-toggle-input" style="display:none;">
                                                            <label for="dropdown-toggle-${r.reviewId}" class="dropdown-trigger-btn" title="Thao tác">
                                                                <span class="material-symbols-outlined" style="pointer-events: none;">more_horiz</span>
                                                            </label>
                                                            <div class="dropdown-menu-box">
                                                                <label for="edit-form-toggle-${r.reviewId}" class="dropdown-item" style="margin: 0; display: block; box-sizing: border-box; background: transparent; border: none; outline: none; box-shadow: none;">
                                                                    Chỉnh sửa
                                                                </label>
                                                                <form action="${pageContext.request.contextPath}/product-review" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa đánh giá này?');" style="margin: 0; padding: 0; background: transparent; border: none; box-shadow: none;">
                                                                    <input type="hidden" name="action" value="deleteReview">
                                                                    <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                                    <input type="hidden" name="productId" value="${product.productId}">
                                                                    <input type="submit" id="delete-submit-${r.reviewId}" style="display: none;">
                                                                    <label for="delete-submit-${r.reviewId}" class="dropdown-item dropdown-item-danger" style="margin: 0; display: block; cursor: pointer; box-sizing: border-box; background: transparent; border: none; outline: none; box-shadow: none;">
                                                                        Xóa
                                                                    </label>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <span class="review-date">
                                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </div>
                                            <div class="review-body">
                                                <div class="star-rating">
                                                    <c:forEach var="i" begin="1" end="5">
                                                        <span class="star ${i <= r.rating ? 'active' : ''}">★</span>
                                                    </c:forEach>
                                                </div>
                                                <p class="review-comment">${r.comment}</p>

                                                <c:if test="${r.userId == sessionScope.user.userId}">
                                                    <input type="checkbox" id="edit-form-toggle-${r.reviewId}" class="edit-form-toggle-input" style="display:none;">
                                                    <div class="edit-review-form-box">
                                                        <form action="${pageContext.request.contextPath}/product-review" method="post" style="width: 100%; margin: 0;">
                                                            <input type="hidden" name="action" value="editReview">
                                                            <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                            <input type="hidden" name="productId" value="${product.productId}">

                                                            <div class="rating-input-group" style="margin-bottom: 10px;">
                                                                <label style="font-weight: 700; font-size: 13px;">Chọn lại số sao:</label>
                                                                <div class="star-rating-input">
                                                                    <input type="radio" id="edit-star5-${r.reviewId}" name="rating" value="5" ${r.rating == 5 ? 'checked' : ''} required /><label for="edit-star5-${r.reviewId}">★</label>
                                                                    <input type="radio" id="edit-star4-${r.reviewId}" name="rating" value="4" ${r.rating == 4 ? 'checked' : ''} /><label for="edit-star4-${r.reviewId}">★</label>
                                                                    <input type="radio" id="edit-star3-${r.reviewId}" name="rating" value="3" ${r.rating == 3 ? 'checked' : ''} /><label for="edit-star3-${r.reviewId}">★</label>
                                                                    <input type="radio" id="edit-star2-${r.reviewId}" name="rating" value="2" ${r.rating == 2 ? 'checked' : ''} /><label for="edit-star2-${r.reviewId}">★</label>
                                                                    <input type="radio" id="edit-star1-${r.reviewId}" name="rating" value="1" ${r.rating == 1 ? 'checked' : ''} /><label for="edit-star1-${r.reviewId}">★</label>
                                                                </div>
                                                            </div>

                                                            <div class="form-group" style="margin-bottom: 10px;">
                                                                <textarea name="comment" rows="2" style="width: 100%;" required>${r.comment}</textarea>
                                                            </div>

                                                            <div style="display: flex; gap: 8px;">
                                                                <button type="submit" class="btn btn-primary btn-sm">Cập nhật</button>
                                                                <label for="edit-form-toggle-${r.reviewId}" class="btn btn-secondary btn-sm" style="margin: 0; cursor: pointer; display: inline-flex; align-items: center;">Hủy</label>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </c:if>
                                            </div>

                                            <c:if test="${not empty r.replyContent}">
                                                <div class="staff-reply-card">
                                                    <div class="reply-header">
                                                        <span class="staff-tag">Phản hồi từ cửa hàng</span>
                                                        <span class="staff-name">bởi ${r.repliedByName}</span>
                                                        <span class="reply-date">
                                                            <fmt:formatDate value="${r.repliedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </span>
                                                    </div>
                                                    <p class="reply-content">${r.replyContent}</p>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-reviews-state">
                                        <p>Chưa có đánh giá nào cho sản phẩm này. Hãy là người đầu tiên mua và đánh giá sản phẩm!</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </body>
</html>

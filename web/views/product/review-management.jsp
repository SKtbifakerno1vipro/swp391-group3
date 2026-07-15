<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Đánh giá & Phản hồi</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">

        <style>
            .management-container {
                padding: 30px;
            }

            .page-title {
                font-family: 'Literata', Georgia, serif;
                color: var(--primary);
                font-size: 28px;
                margin-bottom: 24px;
            }

            .reviews-grid {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .admin-review-card {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 16px;
                padding: 24px;
                box-shadow: var(--shadow);
                display: flex;
                flex-direction: column;
                gap: 15px;
                position: relative;
            }

            .admin-review-card.hidden-review {
                opacity: 0.65;
                background: var(--surface-soft);
                border-style: dashed;
            }

            .card-meta-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                border-bottom: 1px solid var(--line);
                padding-bottom: 12px;
            }

            .product-info-box h3 {
                margin: 0 0 6px 0;
                font-size: 18px;
                color: var(--text);
                font-weight: 800;
            }

            .reviewer-company {
                font-size: 13px;
                color: var(--muted);
                font-weight: 600;
            }

            .card-meta-right {
                text-align: right;
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 6px;
            }

            .review-timestamp {
                font-size: 12px;
                color: var(--muted);
            }

            .status-badge {
                font-size: 11px;
                font-weight: 800;
                padding: 3px 10px;
                border-radius: 20px;
                text-transform: uppercase;
            }

            .status-badge.status-active {
                background: var(--primary-soft);
                color: var(--primary);
            }

            .status-badge.status-hidden {
                background: var(--danger-soft);
                color: var(--danger);
            }

            .review-content-body {
                font-size: 15px;
                line-height: 1.6;
                color: var(--text);
            }

            .star-rating .star {
                color: var(--surface-strong);
                font-size: 18px;
                letter-spacing: -2px;
            }

            .star-rating .star.active {
                color: #f39c12;
            }

            .action-bar-row {
                display: flex;
                gap: 12px;
                margin-top: 10px;
            }

            .btn {
                text-decoration: none;
                padding: 4px 10px;
                border-radius: 6px;
                font-size: 11px;
                font-weight: 800;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                border: none !important;
                outline: none !important;
                box-shadow: none !important;
                line-height: normal;
                transition: all 0.2s ease;
                min-height: 24px;
            }

            .btn-primary {
                background: var(--primary);
                color: #fff;
            }
            .btn-primary:hover {
                opacity: 0.9;
            }

            .btn-secondary {
                background-color: var(--primary-soft);
                color: var(--primary);
            }
            .btn-secondary:hover {
                opacity: 0.85;
            }

            .btn-danger {
                background-color: var(--danger-soft);
                color: var(--danger);
            }
            .btn-danger:hover {
                opacity: 0.85;
            }

            .btn-success {
                background-color: var(--primary-soft);
                color: var(--primary);
            }
            .btn-success:hover {
                opacity: 0.85;
            }

            /* Reply Section */
            .replied-box-wrapper {
                background: var(--surface-soft);
                border-left: 4px solid var(--secondary);
                border-radius: 8px;
                padding: 16px;
                margin-top: 10px;
            }

            .replied-header {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 12px;
                color: var(--muted);
                margin-bottom: 6px;
            }

            .replied-by-tag {
                background: var(--secondary);
                color: #fff;
                font-size: 10px;
                font-weight: 800;
                padding: 2px 8px;
                border-radius: 20px;
                text-transform: uppercase;
            }

            .replied-content-text {
                margin: 0;
                font-size: 14px;
                line-height: 1.5;
                color: var(--text);
            }

            /* Reply Form box */
            .reply-form-container {
                background: var(--bg);
                border: 1px solid var(--line);
                border-radius: 12px;
                padding: 20px;
                margin-top: 15px;
                display: flex;
                flex-direction: column;
                gap: 12px;
                animation: slideDown 0.3s ease;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .reply-form-container textarea {
                width: 100%;
                border: 1px solid var(--line);
                border-radius: 8px;
                padding: 12px;
                font-family: inherit;
                font-size: 14px;
                color: var(--text);
                background: var(--surface);
                resize: vertical;
            }

            .reply-form-container textarea:focus {
                outline: none;
                border-color: var(--primary);
            }

            .empty-reviews-state {
                text-align: center;
                padding: 50px;
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 16px;
                color: var(--muted);
                font-style: italic;
            }
        </style>

        <script>
            function toggleReplyForm(reviewId) {
                var form = document.getElementById("reply-form-" + reviewId);
                if (form.style.display === "none") {
                    form.style.display = "flex";
                } else {
                    form.style.display = "none";
                }
            }
        </script>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="reviews"/>
            </jsp:include>

            <main class="main legacy-page">
                <div class="management-container">
                    <h1 class="page-title">Quản lý Đánh giá & Phản hồi sản phẩm</h1>

                    <div class="reviews-grid">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="r" items="${reviews}">
                                    <div class="admin-review-card ${r.status == 'HIDDEN' ? 'hidden-review' : ''}">

                                        <!-- Header tin nhắn -->
                                        <div class="card-meta-header">
                                            <div class="product-info-box">
                                                <h3><a href="${pageContext.request.contextPath}/edit-product?id=${r.productId}&action=detail"> ${r.productName}</a></h3>
                                                <span class="reviewer-company">Khách hàng: ${r.companyName}</span>
                                            </div>
                                            <div class="card-meta-right">
                                                <span class="review-timestamp">
                                                    <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                                <span class="status-badge ${r.status == 'ACTIVE' ? 'status-active' : 'status-hidden'}">
                                                    ${r.status == 'ACTIVE' ? 'Hiển thị' : r.status == 'INACTIVE' ? 'Đã xóa' : 'Đang ẩn'}
                                                </span>
                                            </div>
                                        </div>

                                        <div class="review-content-body">
                                            <div class="star-rating" style="margin-bottom: 8px;">
                                                <c:forEach var="i" begin="1" end="5">
                                                    <span class="star ${i <= r.rating ? 'active' : ''}">★</span>
                                                </c:forEach>
                                            </div>
                                            <p style="margin: 0; font-style: italic;">"${r.comment}"</p>
                                        </div>

                                        <c:if test="${not empty r.replyContent}">
                                            <div class="replied-box-wrapper">
                                                <div class="replied-header">
                                                    <span class="replied-by-tag">Đã phản hồi</span>
                                                    <span>bởi <strong>${r.repliedByName}</strong> lúc <fmt:formatDate value="${r.repliedAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                                </div>
                                                <p class="replied-content-text">${r.replyContent}</p>
                                            </div>
                                        </c:if>

                                        <div class="action-bar-row">
                                            <c:if test="${r.status != 'INACTIVE'}">
                                                <button type="button" class="btn btn-secondary" onclick="toggleReplyForm(${r.reviewId})">
                                                    ${not empty r.replyContent ? 'Sửa phản hồi' : 'Viết phản hồi'}
                                                </button>

                                                <form action="${pageContext.request.contextPath}/product-review" method="post" style="display: inline; margin: 0; padding: 0; background: transparent; border: none; box-shadow: none;">
                                                    <input type="hidden" name="action" value="toggleStatus">
                                                    <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                    <input type="hidden" name="status" value="${r.status == 'ACTIVE' ? 'HIDDEN' : 'ACTIVE'}">

                                                    <button type="submit" class="btn ${r.status == 'ACTIVE' ? 'btn-danger' : 'btn-success'}" style="border: none !important; outline: none !important; box-shadow: none !important;">
                                                        ${r.status == 'ACTIVE' ? 'Ẩn đánh giá' : 'Hiện đánh giá'}
                                                    </button>


                                                </form>
                                            </c:if>
                                        </div>

                                        <div id="reply-form-${r.reviewId}" style="display:none;" class="reply-form-container">
                                            <form action="${pageContext.request.contextPath}/product-review" method="post" style="width: 100%;">
                                                <input type="hidden" name="action" value="addReply">
                                                <input type="hidden" name="reviewId" value="${r.reviewId}">
                                                <div style="margin-bottom: 10px;">
                                                    <label style="font-weight: 700; font-size: 13px; display: block; margin-bottom: 5px;">Nội dung phản hồi:</label>
                                                    <textarea name="replyContent" rows="3" placeholder="Nhập nội dung phản hồi khách hàng..." required>${r.replyContent}</textarea>
                                                </div>
                                                <div style="display: flex; gap: 8px;">
                                                    <button type="submit" class="btn btn-primary">Gửi phản hồi</button>
                                                    <button type="button" class="btn btn-secondary" onclick="toggleReplyForm(${r.reviewId})">Hủy</button>
                                                </div>
                                            </form>
                                        </div>

                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-reviews-state">
                                    <p>Chưa có đánh giá nào được gửi từ hệ thống.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>

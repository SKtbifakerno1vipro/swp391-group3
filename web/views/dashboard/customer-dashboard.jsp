<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Trang tổng quan khách hàng của hệ thống phân phối bánh mì Po Bread">
        <title>Customer Dashboard - Po Bread Portal</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <style>
            :root { 
                --bg: #faf6f0; 
                --surface: #fffaf3; 
                --surface-soft: #f0ece4; 
                --surface-strong: #e4e0d8; 
                --text: #2e3230; 
                --muted: #646b66; 
                --primary: #4a7c59; 
                --primary-soft: #dcefe1; 
                --secondary: #7a6148; 
                --tertiary: #b1812f; 
                --danger: #b83230; 
                --line: #ddd5c9; 
                --shadow: 0 18px 45px rgba(46,50,48,.08); 
            }
            * { box-sizing: border-box; }
            body { 
                margin: 0; 
                min-height: 100vh; 
                background: var(--bg); 
                color: var(--text); 
                font-family: 'Nunito Sans', Arial, sans-serif; 
            }
            a { color: inherit; text-decoration: none; }
            .material-symbols-outlined { 
                font-family: 'Material Symbols Outlined'; 
                font-weight: normal; 
                font-style: normal; 
                font-size: 22px; 
                line-height: 1; 
                letter-spacing: normal; 
                text-transform: none; 
                display: inline-flex; 
                align-items: center; 
                justify-content: center; 
                white-space: nowrap; 
                word-wrap: normal; 
                direction: ltr; 
                -webkit-font-feature-settings: 'liga'; 
                -webkit-font-smoothing: antialiased; 
                font-feature-settings: 'liga'; 
                font-variation-settings: 'FILL' 0,'wght' 500,'GRAD' 0,'opsz' 24; 
                width: 1em; 
                min-width: 1em; 
                overflow: hidden; 
            }
            .dashboard-shell { 
                display: grid; 
                grid-template-columns: 260px minmax(0, 1fr); 
                min-height: 100vh; 
            }
            .main { 
                min-width: 0; 
                padding: 26px 34px 38px; 
            }
            .topbar { 
                display: flex; 
                justify-content: space-between; 
                gap: 18px; 
                align-items: center; 
                margin-bottom: 30px; 
            }
            .eyebrow { 
                margin: 0 0 6px; 
                color: var(--primary); 
                font-weight: 800; 
                letter-spacing: .08em; 
                text-transform: uppercase; 
                font-size: 12px; 
            }
            h1, h2 { font-family: 'Literata', Georgia, serif; }
            h1 { margin: 0; font-size: clamp(30px, 4vw, 44px); line-height: 1.1; }
            .topbar p { margin: 8px 0 0; color: var(--muted); }
            .top-actions { 
                display: flex; 
                gap: 10px; 
                flex-wrap: wrap; 
                justify-content: flex-end; 
            }
            .button { 
                display: inline-flex; 
                align-items: center; 
                gap: 8px; 
                padding: 11px 18px; 
                border-radius: 999px; 
                font-weight: 800; 
                border: 1px solid var(--line); 
                background: var(--surface); 
                cursor: pointer;
                transition: all 0.2s ease;
            }
            .button:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            }
            .button.primary { 
                background: var(--primary); 
                color: white; 
                border-color: var(--primary); 
            }
            .hero { 
                display: grid; 
                grid-template-columns: minmax(0, 1.6fr) minmax(280px, .9fr); 
                gap: 20px; 
                margin-bottom: 22px; 
            }
            .panel, .metric-card { 
                background: var(--surface); 
                border: 1px solid rgba(221,213,201,.8); 
                border-radius: 26px; 
                box-shadow: var(--shadow); 
            }
            .hero-card { 
                padding: 28px; 
                background: radial-gradient(circle at top right, rgba(142, 207, 158, .42), transparent 32%), linear-gradient(135deg, #fffaf3, #f0ece4); 
                overflow: hidden; 
                position: relative; 
            }
            .hero-card h2 { margin: 0; font-size: 28px; }
            .hero-card p { max-width: 650px; color: var(--muted); line-height: 1.7; }
            .quick-grid { 
                display: grid; 
                grid-template-columns: repeat(3, minmax(0, 1fr)); 
                gap: 12px; 
                margin-top: 24px; 
            }
            .quick-link { 
                padding: 14px; 
                border-radius: 18px; 
                background: rgba(255, 255, 255, .62); 
                border: 1px solid rgba(221, 213, 201, .7); 
                font-weight: 800; 
                transition: all 0.2s ease;
            }
            .quick-link:hover {
                background: var(--surface);
                transform: translateY(-2px);
                border-color: var(--primary);
            }
            .quick-link span { 
                display: block; 
                color: var(--muted); 
                font-weight: 600; 
                font-size: 12px; 
                margin-top: 4px; 
            }
            .status-panel { padding: 22px; }
            .panel-title { 
                display: flex; 
                align-items: center; 
                justify-content: space-between; 
                gap: 12px; 
                margin-bottom: 16px; 
            }
            .panel-title h2 { margin: 0; font-size: 20px; }
            .metric-grid { 
                display: grid; 
                grid-template-columns: repeat(2, minmax(0, 1fr)); 
                gap: 16px; 
                margin-bottom: 22px; 
            }
            .metric-card { 
                padding: 24px; 
                transition: .2s ease; 
                display: flex;
                align-items: center;
                gap: 20px;
            }
            .metric-card:hover { 
                transform: translateY(-4px); 
                box-shadow: 0 20px 35px rgba(0,0,0,0.06);
            }
            .metric-icon { 
                width: 54px; 
                height: 54px; 
                display: grid; 
                place-items: center; 
                border-radius: 18px; 
                background: var(--primary-soft); 
                color: var(--primary); 
            }
            .metric-card.secondary .metric-icon { 
                background: #f8e0a8; 
                color: var(--tertiary); 
            }
            .metric-info h3 {
                margin: 0;
                font-size: 32px;
                font-family: 'Literata', Georgia, serif;
                font-weight: 700;
            }
            .metric-info p {
                margin: 4px 0 0;
                color: var(--muted);
                font-weight: 700;
                font-size: 14px;
                white-space: nowrap;
            }
            .dashboard-shell .content-grid { 
                display: grid; 
                grid-template-columns: repeat(2, minmax(0, 1fr)); 
                gap: 20px; 
            }
            @media (max-width: 1180px) {
                .dashboard-shell .content-grid {
                    grid-template-columns: 1fr;
                }
            }
            .dashboard-shell .metric-grid { 
                grid-template-columns: repeat(2, minmax(0, 1fr)); 
            }
            @media (max-width: 820px) {
                .dashboard-shell .metric-grid {
                    grid-template-columns: 1fr;
                }
            }
            .table-panel { padding: 22px; overflow: hidden; margin-bottom: 20px;}
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 14px 10px; text-align: left; border-bottom: 1px solid var(--line); }
            th { color: var(--muted); font-size: 12px; text-transform: uppercase; letter-spacing: .04em; }
            td { font-weight: 700; }
            .badge { 
                display: inline-flex; 
                padding: 6px 10px; 
                border-radius: 999px; 
                background: var(--primary-soft); 
                color: var(--primary); 
                font-size: 12px; 
                font-weight: 800; 
                text-transform: uppercase;
            }
            .badge.pending {
                background: #f8e0a8;
                color: var(--tertiary);
            }
            .badge.danger {
                background: #ffdad8;
                color: var(--danger);
            }
            .badge.info {
                background: #e2f0fd;
                color: #0b5ed7;
            }
            .btn-action {
                padding: 5px 12px;
                background: var(--surface-soft);
                border: 1px solid var(--line);
                border-radius: 8px;
                font-size: 12px;
                transition: all 0.2s;
                white-space: nowrap;
                display: inline-block;
            }
            .btn-action:hover {
                background: var(--primary);
                color: white;
                border-color: var(--primary);
            }
            .empty-state { 
                padding: 30px; 
                border-radius: 18px; 
                background: var(--surface-soft); 
                color: var(--muted); 
                text-align: center; 
                font-weight: 700; 
            }
            .support-card {
                padding: 20px;
                background: var(--surface-soft);
                border-radius: 20px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                gap: 10px;
            }
            .support-card h3 {
                margin: 0;
                font-size: 18px;
            }
            .support-card p {
                margin: 0;
                color: var(--muted);
                font-size: 13px;
                line-height: 1.5;
            }
            @keyframes sidebarFadeIn { from { opacity: 0; transform: translateX(-10px); } to { opacity: 1; transform: translateX(0); } }
            @media (max-width: 1180px) { 
                .hero { grid-template-columns: 1fr; } 
            }
            @media (max-width: 820px) { 
                .dashboard-shell { grid-template-columns: 1fr; } 
                .main { padding: 22px 16px; } 
                .metric-grid, .quick-grid { grid-template-columns: 1fr; } 
            }
        </style>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard"/>
            </jsp:include>
            <main class="main" id="main-content">
                <section class="topbar">
                    <div>
                        <p class="eyebrow" id="topbar-eyebrow">Customer Portal</p>
                        <h1 id="welcome-message">Xin chào, <c:out value="${user.fullName}"/>.</h1>
                        <p>Chào mừng bạn quay trở lại với cổng quản lý thông tin khách hàng của Po Bread.</p>
                    </div>
                    <div class="top-actions">
                        <a class="button" href="${pageContext.request.contextPath}/customer/detail?id_cus=${customer.customer.customerId}" id="btn-view-profile">
                            <span class="material-symbols-outlined">account_circle</span>Thông tin cá nhân
                        </a>
                        <a class="button primary" href="${pageContext.request.contextPath}/tool/auto-generate" id="btn-auto-generator">
                            <span class="material-symbols-outlined">bolt</span>Auto Generator Contract
                        </a>
                    </div>
                </section>

                <section class="hero">
                    <div class="panel hero-card" id="welcome-hero-panel">
                        <p class="eyebrow">Tiện ích nhanh</p>
                        <h2>Cổng thông tin khách hàng Po Bread</h2>
                        <p>Theo dõi các báo giá, trạng thái hợp đồng, đơn hàng của bạn một cách nhanh chóng và chính xác nhất.</p>
                        <div class="quick-grid">
                            <a class="quick-link" href="${pageContext.request.contextPath}/quotation-list" id="link-quotations">
                                Danh sách báo giá
                                <span>Kiểm tra báo giá & yêu cầu sửa đổi</span>
                            </a>
                            <a class="quick-link" href="${pageContext.request.contextPath}/contract-list" id="link-contracts">
                                Danh sách hợp đồng
                                <span>Xem & duyệt hợp đồng đã soạn thảo</span>
                            </a>
                            <a class="quick-link" href="${pageContext.request.contextPath}/customer/detail?id_cus=${customer.customer.customerId}" id="link-profile">
                                Thông tin tài khoản
                                <span>Cập nhật thông tin đại lý/doanh nghiệp</span>
                            </a>
                        </div>
                    </div>

                    <div class="support-card" id="support-panel">
                        <h3><span class="material-symbols-outlined" style="color:var(--primary); vertical-align:middle; margin-right:6px;">support_agent</span>Bạn cần hỗ trợ?</h3>
                        <p>Nếu bạn gặp bất kỳ khó khăn nào trong quá trình duyệt báo giá hoặc ký hợp đồng, vui lòng liên hệ nhân viên phụ trách của chúng tôi.</p>
                        <p><strong>Hotline:</strong> 1900 6000<br><strong>Email:</strong> support@pobread.com</p>
                    </div>
                </section>

                <section class="metric-grid" aria-label="Chỉ số tổng quan">
                    <a class="metric-card" href="${pageContext.request.contextPath}/quotation-list" id="card-quotations">
                        <div class="metric-icon"><span class="material-symbols-outlined">request_quote</span></div>
                        <div class="metric-info">
                            <h3 id="val-quotations"><c:out value="${totalQuotations}" default="0"/></h3>
                            <p>Báo giá của bạn</p>
                        </div>
                    </a>
                    <a class="metric-card secondary" href="${pageContext.request.contextPath}/contract-list" id="card-contracts">
                        <div class="metric-icon"><span class="material-symbols-outlined">contract</span></div>
                        <div class="metric-info">
                            <h3 id="val-contracts"><c:out value="${totalContracts}" default="0"/></h3>
                            <p>Hợp đồng của bạn</p>
                        </div>
                    </a>
                </section>

                <section class="content-grid">
                    <div class="panel table-panel" id="recent-quotations-panel">
                        <div class="panel-title">
                            <h2>Báo giá mới nhất</h2>
                            <a class="badge" href="${pageContext.request.contextPath}/quotation-list">Tất cả</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty recentQuotations}">
                                <div class="empty-state">Bạn hiện chưa có báo giá nào.</div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Mã Báo Giá</th>
                                            <th>Giá trị</th>
                                            <th>Ngày Tạo</th>
                                            <th>Trạng Thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="quote" items="${recentQuotations}">
                                            <tr>
                                                <td>#<c:out value="${quote.quotationId}"/></td>
                                                <td>
                                                    <fmt:formatNumber value="${quote.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </td>
                                                <td><c:out value="${quote.formattedCreatedAt}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${quote.quotationStatus == 'APPROVED'}">
                                                            <span class="badge">Đã duyệt</span>
                                                        </c:when>
                                                        <c:when test="${quote.quotationStatus == 'PENDING'}">
                                                            <span class="badge pending">Đang chờ</span>
                                                        </c:when>
                                                        <c:when test="${quote.quotationStatus == 'REJECTED'}">
                                                            <span class="badge danger">Bị từ chối</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge info"><c:out value="${quote.quotationStatus}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a class="btn-action" href="${pageContext.request.contextPath}/quotation-detail?id=${quote.quotationId}">Chi tiết</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="panel table-panel" id="recent-contracts-panel">
                        <div class="panel-title">
                            <h2>Hợp đồng mới nhất</h2>
                            <a class="badge" href="${pageContext.request.contextPath}/contract-list">Tất cả</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty recentContracts}">
                                <div class="empty-state">Bạn hiện chưa có hợp đồng nào.</div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Số Hợp Đồng</th>
                                            <th>Ngày Ký Kết</th>
                                            <th>Trạng Thái</th>
                                            <th>Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="con" items="${recentContracts}">
                                            <tr>
                                                <td>#<c:out value="${con.contractNumber}"/></td>
                                                <td><c:out value="${con.formattedCreatedAtDate}"/></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${con.contractStatus == 'ACTIVE'}">
                                                            <span class="badge">Hiệu lực</span>
                                                        </c:when>
                                                        <c:when test="${con.contractStatus == 'DRAFT'}">
                                                            <span class="badge pending">Bản nháp</span>
                                                        </c:when>
                                                        <c:when test="${con.contractStatus == 'EXPIRED'}">
                                                            <span class="badge danger">Hết hạn</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge info"><c:out value="${con.contractStatus}"/></span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a class="btn-action" href="${pageContext.request.contextPath}/contract-detail?id=${con.contractId}">Chi tiết</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </main>
        </div>
    </body>
</html>

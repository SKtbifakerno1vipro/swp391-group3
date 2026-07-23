<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết Yêu cầu Nhập kho #IR-${ir.importId} - Bakery Sales System</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700;800&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .detail-layout-grid {
                display: grid;
                grid-template-columns: minmax(0, 1.35fr) minmax(320px, 0.65fr);
                gap: 24px;
                align-items: start;
            }
            @media (max-width: 960px) {
                .detail-layout-grid {
                    grid-template-columns: 1fr;
                }
            }
            .detail-table-info {
                width: 100%;
                border-collapse: collapse;
            }
            .detail-table-info td {
                padding: 14px 16px;
                border-bottom: 1px solid var(--line);
                font-size: 14px;
            }
            .detail-table-info tr:last-child td {
                border-bottom: none;
            }
            .detail-table-info td.label-col {
                width: 32%;
                font-weight: 800;
                color: var(--muted);
            }
            .detail-table-info td.val-col {
                font-weight: 700;
                color: var(--text);
            }
            .btn-confirm-import {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                width: 100%;
                padding: 13px 24px;
                background: linear-gradient(135deg, var(--primary), #3d6849);
                color: #ffffff !important;
                font-family: 'Nunito Sans', sans-serif;
                font-weight: 800;
                font-size: 15px;
                border-radius: 16px;
                border: none;
                box-shadow: 0 6px 20px rgba(74, 124, 89, 0.3);
                cursor: pointer;
                transition: all 0.25s ease;
                text-decoration: none;
            }
            .btn-confirm-import:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(74, 124, 89, 0.4);
                background: linear-gradient(135deg, #3d6849, #2e4d36);
            }
            .btn-cancel-import {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                width: 100%;
                padding: 11px 20px;
                background: var(--surface-soft);
                color: var(--danger) !important;
                font-family: 'Nunito Sans', sans-serif;
                font-weight: 800;
                font-size: 14px;
                border-radius: 14px;
                border: 1px solid var(--danger-soft);
                cursor: pointer;
                transition: all 0.2s ease;
                text-decoration: none;
            }
            .btn-cancel-import:hover {
                background: var(--danger-soft);
                border-color: var(--danger);
                transform: translateY(-1px);
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
                        <p class="eyebrow">CHI TIẾT PHIẾU NHẬP KHO</p>
                        <h1 style="display: flex; align-items: center; gap: 12px;">
                            Phiếu #IR-${ir.importId}
                            <c:choose>
                                <c:when test="${ir.status == 1}">
                                    <span class="status-badge pending" style="font-size: 13px;">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">schedule</span> Chờ xử lý
                                    </span>
                                </c:when>
                                <c:when test="${ir.status == 2}">
                                    <span class="status-badge imported" style="font-size: 13px;">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">check_circle</span> Đã nhập kho
                                    </span>
                                </c:when>
                                <c:when test="${ir.status == 3}">
                                    <span class="status-badge cancelled" style="font-size: 13px;">
                                        <span class="material-symbols-outlined" style="font-size: 16px;">cancel</span> Đã hủy
                                    </span>
                                </c:when>
                            </c:choose>
                        </h1>
                        <p>Thông tin chi tiết và thao tác xử lý phiếu nhập kho nguyên liệu.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/import-request-list" class="btn-secondary-action">
                        <span class="material-symbols-outlined">arrow_back</span>
                        Quay lại danh sách
                    </a>
                </div>

                <!-- Thông báo hệ thống -->
                <c:if test="${message == 'cancelSuccess'}">
                    <div class="alert-banner warning">
                        <span class="material-symbols-outlined">warning</span>
                        <span>Đã hủy yêu cầu nhập kho thành công.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'importSuccess'}">
                    <div class="alert-banner success">
                        <span class="material-symbols-outlined">task_alt</span>
                        <span>Nhập kho sản phẩm thành công và đã tự động cập nhật số lượng tồn kho khả dụng!</span>
                    </div>
                </c:if>
                <c:if test="${message == 'permissionDenied'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">block</span>
                        <span>Bạn không có quyền thực hiện thao tác này (Yêu cầu quyền Nhân viên Kho).</span>
                    </div>
                </c:if>
                <c:if test="${message == 'invalidStatus'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">error</span>
                        <span>Trạng thái hiện tại của yêu cầu không cho phép thực hiện thao tác này.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'alreadyProcessed'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">published_with_changes</span>
                        <span>Yêu cầu này đã được xử lý hoặc bị hủy trước đó bởi người dùng khác.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'missingNote'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">edit_note</span>
                        <span>Vui lòng nhập lý do/ghi chú khi thực hiện hủy yêu cầu nhập kho.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'dbError'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">database</span>
                        <span>Lỗi hệ thống Cơ sở dữ liệu. Vui lòng thử lại sau.</span>
                    </div>
                </c:if>

                <div class="detail-layout-grid">
                    <!-- Left: Information Card -->
                    <div class="modern-form-card">
                        <h2 style="font-family: 'Literata', serif; margin-top: 0; margin-bottom: 20px; font-size: 20px; color: var(--text); border-bottom: 1px solid var(--line); padding-bottom: 12px;">
                            Thông tin Yêu cầu
                        </h2>
                        <table class="detail-table-info">
                            <tr>
                                <td class="label-col">Mã phiếu nhập:</td>
                                <td class="val-col"><span class="code-badge">#IR-${ir.importId}</span></td>
                            </tr>
                            <tr>
                                <td class="label-col">Sản phẩm:</td>
                                <td class="val-col" style="font-size: 16px; color: var(--primary);">${ir.productName}</td>
                            </tr>
                            <tr>
                                <td class="label-col">Số lượng nhập:</td>
                                <td class="val-col"><span class="qty-pill">+${ir.quantity}</span></td>
                            </tr>
                            <tr>
                                <td class="label-col">Người đề xuất:</td>
                                <td class="val-col"><c:out value="${ir.createdByName}"/></td>
                            </tr>
                            <tr>
                                <td class="label-col">Thời gian tạo:</td>
                                <td class="val-col"><fmt:formatDate value="${ir.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                            </tr>
                            <tr>
                                <td class="label-col">Ghi chú đề xuất:</td>
                                <td class="val-col" style="white-space: pre-wrap;"><c:out value="${ir.note != null && not empty ir.note ? ir.note : '(Không có ghi chú)'}"/></td>
                            </tr>
                        </table>

                        <!-- Xử lý nếu Đã nhập kho (Status = 2) -->
                        <c:if test="${ir.status == 2}">
                            <div style="margin-top: 24px; padding: 18px; background: #e8f5e9; border: 1px solid #a5d6a7; border-radius: 18px;">
                                <div style="display: flex; align-items: center; gap: 8px; color: #2e7d32; font-weight: 800; font-size: 15px; margin-bottom: 8px;">
                                    <span class="material-symbols-outlined">check_circle</span>
                                    Thông tin Nhập kho Thành công
                                </div>
                                <div style="font-size: 14px; color: #1b5e20; line-height: 1.6;">
                                    <div><strong>Người xác nhận nhập kho:</strong> <c:out value="${ir.importedByName}"/></div>
                                    <div style="margin-top: 4px;"><strong>Thời gian nhập kho:</strong> <fmt:formatDate value="${ir.importedDate}" pattern="dd/MM/yyyy HH:mm:ss"/></div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Xử lý nếu Đã Hủy (Status = 3) -->
                        <c:if test="${ir.status == 3}">
                            <div style="margin-top: 24px; padding: 18px; background: #ffebee; border: 1px solid #ef9a9a; border-radius: 18px;">
                                <div style="display: flex; align-items: center; gap: 8px; color: #c62828; font-weight: 800; font-size: 15px; margin-bottom: 8px;">
                                    <span class="material-symbols-outlined">cancel</span>
                                    Thông tin Hủy Phiếu Nhập kho
                                </div>
                                <div style="font-size: 14px; color: #b71c1c; line-height: 1.6;">
                                    <div><strong>Người hủy yêu cầu:</strong> <c:out value="${ir.importedByName != null ? ir.importedByName : '(Bộ phận Kho)'}"/></div>
                                    <div style="margin-top: 4px;"><strong>Thời gian hủy:</strong> <fmt:formatDate value="${ir.importedDate}" pattern="dd/MM/yyyy HH:mm:ss"/></div>
                                    <div style="margin-top: 8px; padding-top: 8px; border-top: 1px dashed #ef9a9a;">
                                        <strong>Lý do hủy từ Kho:</strong> <c:out value="${ir.wareHousenote != null && not empty ir.wareHousenote ? ir.wareHousenote : (ir.warehouseNote != null && not empty ir.warehouseNote ? ir.warehouseNote : '(Không có ghi chú lý do)')}"/>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Right: Actions Panel (For Warehouse Staff) -->
                    <c:if test="${ir.status == 1 && sessionScope.user.roleId == 6}">
                        <div class="modern-form-card" style="border: 2px solid var(--primary-soft); background: var(--surface);">
                            <h3 style="font-family: 'Literata', serif; margin-top: 0; margin-bottom: 20px; font-size: 18px; color: var(--primary); display: flex; align-items: center; gap: 8px;">
                                <span class="material-symbols-outlined" style="color: var(--primary);">warehouse</span>
                                Xử lý Nhập kho
                            </h3>

                            <!-- Action 1: Confirm Import -->
                            <form action="${pageContext.request.contextPath}/import-request-detail" method="post" style="margin-bottom: 24px;">
                                <input type="hidden" name="importId" value="${ir.importId}">
                                <input type="hidden" name="action" value="import">
                                <button type="submit" class="btn-confirm-import" onclick="return confirm('Xác nhận sản phẩm đã nhập thực tế vào kho và cập nhật số lượng tồn kho?')">
                                    <span class="material-symbols-outlined">check_circle</span>
                                    Xác nhận Nhập kho
                                </button>
                            </form>

                            <div style="position: relative; text-align: center; margin: 24px 0 20px;">
                                <hr style="border: none; border-top: 1px solid var(--line); margin: 0;">
                                <span style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: var(--surface); padding: 0 12px; font-size: 12px; color: var(--muted); font-weight: 700;">Hoặc từ chối</span>
                            </div>

                            <!-- Action 2: Cancel Import Request -->
                            <form action="${pageContext.request.contextPath}/import-request-detail" method="post">
                                <input type="hidden" name="importId" value="${ir.importId}">
                                <input type="hidden" name="action" value="cancel">
                                <div class="form-group" style="margin-bottom: 16px;">
                                    <label for="wareHousenote" style="font-size: 13px; font-weight: 800;">Lý do từ chối / hủy yêu cầu: <span style="color: var(--danger);">*</span></label>
                                    <textarea id="wareHousenote" name="wareHousenote" rows="3" required placeholder="Nhập lý do không thể nhập kho..." class="form-control" style="font-size: 13px;"></textarea>
                                </div>
                                <button type="submit" class="btn-cancel-import" onclick="return confirm('Bạn có chắc chắn muốn HỦY yêu cầu nhập kho này?')">
                                    <span class="material-symbols-outlined">cancel</span>
                                    Hủy yêu cầu nhập kho
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </main>
        </div>
    </body>
</html>

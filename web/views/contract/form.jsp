<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${contract == null ? 'Tạo mới' : 'Chỉnh sửa'} Hợp đồng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <link href="https://fonts.googleapis.com/css2?family=Literata:ital,opsz,wght@0,7..72,200..900;1,7..72,200..900&family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0" rel="stylesheet">
        <style>
            #contract-body {
                border: 1px solid var(--line);
                padding: 20px;
                min-height: 500px;
                background: #fff;
                margin-top: 10px;
                border-radius: 12px;
            }

            .layout-container {
                display: grid;
                grid-template-columns: 1fr 280px;
                gap: 20px;
                align-items: start;
            }

            .shortcut-panel {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 22px;
                box-shadow: var(--shadow);
                padding: 20px;
                position: sticky;
                top: 20px;
            }

            .shortcut-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;
                border-bottom: 1px dashed var(--line);
                font-size: 0.9em;
            }

            .shortcut-item:last-child {
                border-bottom: none;
            }

            kbd {
                background: #fff;
                border: 1px solid var(--line);
                border-radius: 4px;
                padding: 3px 6px;
                font-family: monospace;
                font-size: 0.9em;
                color: var(--muted);
                box-shadow: 0 1px 1px rgba(0,0,0,0.05);
            }

            @media (max-width: 900px) {
                .layout-container {
                    grid-template-columns: 1fr;
                }
            }

            /* Override app-layout.css for raw contract content */
            .legacy-page .raw-content table {
                background: #fff;
                box-shadow: none;
                border-radius: 0;
                border: none;
                margin: 10px 0;
            }
            .legacy-page .raw-content th,
            .legacy-page .raw-content thead td,
            .legacy-page .raw-content td {
                background: #fff;
                color: inherit;
                font-size: inherit;
                text-transform: none;
                letter-spacing: normal;
                font-weight: normal;
                border: none;
                padding: 8px;
            }
            .legacy-page .raw-content th {
                font-weight: bold;
            }
            .legacy-page .raw-content table[border="1"],
            .legacy-page .raw-content table[border="1"] th,
            .legacy-page .raw-content table[border="1"] td {
                border: 1px solid #000;
            }
        </style>
    </head>

    <body>
        <div class="dashboard-shell">
            <jsp:include page="../shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="contracts" />
            </jsp:include>

            <main class="main legacy-page">
                <c:if test="${not empty errorMsg}">
                    <div style="color: var(--danger); border: 1px solid var(--danger); padding: 10px; margin-bottom: 15px; border-radius: 12px; background: var(--danger-soft);">${errorMsg}</div>
                </c:if>

                <h2>${contract == null ? 'Tạo mới Hợp đồng' : 'Chỉnh sửa Hợp đồng'}</h2>

                <div class="layout-container">
                    <div class="content-panel">
                        <form action="contract-save" method="POST" id="contractForm" style="display: block; width: 100%;">
                            <input type="hidden" name="contractId" value="${contract.contractId}">
                            <input type="hidden" name="quotationId" value="${quotationId}">
                            <input type="hidden" name="customerId" value="${customerId}">
                            <input type="hidden" name="action" id="actionInput">
                            <input type="hidden" name="contractContent" id="contractContentInput">

                            <c:if test="${not empty contract.contractNumber}">
                                <p><strong>Mã Hợp đồng:</strong> ${contract.contractNumber}</p>
                            </c:if>

                            <label style="font-weight:bold; display:block; margin-top: 15px;">Nội dung Hợp đồng:</label>
                            <div id="contract-body" class="raw-content" contenteditable="${editable && sessionScope.user.roleId == 5 ? 'true' : 'false'}"
                                 style="background: ${editable && sessionScope.user.roleId == 5 ? 'white' : '#f9f9f9'};">
                                ${not empty contract.contractContent ? contract.contractContent : templateContent}
                            </div>

                            <div style="margin-top: 20px; display: flex; gap: 10px; align-items: center;">
                                <c:if test="${editable}">
                                    <c:if test="${sessionScope.user.roleId == 5}">
                                        <button type="button" onclick="submitForm('save')">Lưu thay đổi</button>
                                    </c:if>
                                    <c:if test="${contract != null}">
                                        <!--officier-->
                                        <c:if test="${sessionScope.user.roleId == 5}">
                                            <button type="button" style="background: var(--tertiary);" onclick="submitForm('submit_for_review')">Gửi yêu cầu duyệt</button>
                                        </c:if>
                                    </c:if>
                                </c:if>

                                <a href="contract-list" style="margin-left: 10px; color: var(--primary); font-weight: 600;">Quay lại danh sách</a>
                            </div>

                            <script>
                                function submitForm(action) {
                                    document.getElementById('contractContentInput').value = document.getElementById('contract-body').innerHTML;
                                    document.getElementById('actionInput').value = action;
                                    document.getElementById('contractForm').submit();
                                }
                            </script>
                        </form>
                    </div>

                    <div class="shortcut-panel">
                        <h3 style="margin-top: 0; font-size: 1.1em; color: var(--primary); display: flex; align-items: center; gap: 6px;">
                            <span class="material-symbols-outlined" style="font-size: 20px;">keyboard</span>
                            Phím tắt
                        </h3>
                        <p style="color: var(--muted); font-size: 0.85em; margin-bottom: 15px;">Sử dụng các phím tắt trong khi chỉnh sửa:</p>

                        <div class="shortcut-item">
                            <span>In đậm</span>
                            <kbd>Ctrl + B</kbd>
                        </div>
                        <div class="shortcut-item">
                            <span>In nghiêng</span>
                            <kbd>Ctrl + I</kbd>
                        </div>
                        <div class="shortcut-item">
                            <span>Gạch chân</span>
                            <kbd>Ctrl + U</kbd>
                        </div>
                        <div class="shortcut-item">
                            <span>Hoàn tác (Undo)</span>
                            <kbd>Ctrl + Z</kbd>
                        </div>
                        <div class="shortcut-item">
                            <span>Làm lại (Redo)</span>
                            <kbd>Ctrl + Y</kbd>
                        </div>
                        <div class="shortcut-item" style="margin-top: 15px; border-top: 1px solid var(--line); border-bottom: none; padding-top: 15px; display: block; color: var(--muted); font-size: 0.85em;">
                            <i>Lưu ý: Đây là các phím tắt mặc định của trình duyệt hỗ trợ bên trong vùng soạn thảo.</i>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </body>

</html>
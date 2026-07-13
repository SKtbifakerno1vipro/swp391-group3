<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Đăng nhập - Po Bread Sales</title>
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap"
                rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block"
                rel="stylesheet">
            <style>
                :root {
                    --bg: #faf6f0;
                    --surface: #fffaf3;
                    --surface-soft: #f0ece4;
                    --text: #2e3230;
                    --muted: #646b66;
                    --primary: #4a7c59;
                    --primary-dark: #2a6038;
                    --primary-soft: #dcefe1;
                    --danger: #b83230;
                    --danger-soft: #ffdad8;
                    --line: #ddd5c9;
                    --shadow: 0 24px 70px rgba(46, 50, 48, 0.12);
                }

                * {
                    box-sizing: border-box;
                }

                body {
                    margin: 0;
                    min-height: 100vh;
                    background:
                        radial-gradient(circle at top left, rgba(142, 207, 158, 0.28), transparent 28%),
                        radial-gradient(circle at bottom right, rgba(248, 224, 168, 0.35), transparent 30%),
                        var(--bg);
                    color: var(--text);
                    font-family: 'Nunito Sans', Arial, sans-serif;
                }

                a {
                    color: inherit;
                }

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
                    font-variation-settings: 'FILL' 0, 'wght' 500, 'GRAD' 0, 'opsz' 24;
                }

                .login-page {
                    min-height: 100vh;
                    display: grid;
                    place-items: center;
                    padding: 32px;
                }

                .login-card {
                    width: min(1120px, 100%);
                    min-height: 660px;
                    display: grid;
                    grid-template-columns: minmax(360px, 1.05fr) minmax(340px, 0.95fr);
                    border-radius: 34px;
                    overflow: hidden;
                    background: rgba(255, 250, 243, 0.92);
                    border: 1px solid rgba(221, 213, 201, 0.85);
                    box-shadow: var(--shadow);
                }

                .brand-panel {
                    position: relative;
                    padding: 44px;
                    display: flex;
                    flex-direction: column;
                    justify-content: space-between;
                    align-items: center;
                    text-align: center;
                    background:
                        linear-gradient(180deg, rgba(74, 124, 89, 0.10), rgba(255, 250, 243, 0.92)),
                        var(--surface-soft);
                }

                .brand-panel::before {
                    content: '';
                    position: absolute;
                    inset: 24px;
                    border: 1px solid rgba(74, 124, 89, 0.14);
                    border-radius: 28px;
                    pointer-events: none;
                }

                .logo-frame {
                    position: relative;
                    width: min(390px, 84%);
                    aspect-ratio: 1 / 1;
                    display: grid;
                    place-items: center;
                    border-radius: 50%;
                    background: #fff;
                    padding: 12px;
                    box-shadow: 0 22px 55px rgba(46, 50, 48, 0.16);
                    overflow: hidden;
                }

                .logo-frame img {
                    width: 100%;
                    height: 100%;
                    object-fit: contain;
                    display: block;
                    border-radius: 50%;
                }

                .brand-copy {
                    position: relative;
                    z-index: 1;
                    max-width: 440px;
                }

                .brand-copy h1 {
                    margin: 26px 0 10px;
                    color: var(--primary);
                    font-family: 'Literata', Georgia, serif;
                    font-size: clamp(38px, 5vw, 58px);
                    line-height: 1;
                }

                .brand-copy p {
                    margin: 0;
                    color: var(--muted);
                    font-size: 16px;
                    line-height: 1.7;
                    font-weight: 700;
                }

                .brand-badges {
                    position: relative;
                    z-index: 1;
                    display: flex;
                    flex-wrap: wrap;
                    justify-content: center;
                    gap: 10px;
                    margin-top: 24px;
                }

                .brand-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 7px;
                    padding: 9px 12px;
                    border-radius: 999px;
                    background: rgba(255, 255, 255, 0.72);
                    color: var(--primary);
                    font-size: 12px;
                    font-weight: 900;
                    border: 1px solid rgba(221, 213, 201, 0.85);
                }

                .form-panel {
                    padding: 54px;
                    display: flex;
                    align-items: center;
                    background: var(--surface);
                }

                .form-inner {
                    width: 100%;
                    max-width: 430px;
                    margin: 0 auto;
                }

                .eyebrow {
                    margin: 0 0 8px;
                    color: var(--primary);
                    font-size: 12px;
                    font-weight: 900;
                    letter-spacing: 0.1em;
                    text-transform: uppercase;
                }

                h2 {
                    margin: 0;
                    color: var(--text);
                    font-family: 'Literata', Georgia, serif;
                    font-size: 38px;
                    line-height: 1.1;
                }

                .subtitle {
                    margin: 10px 0 30px;
                    color: var(--muted);
                    line-height: 1.6;
                }

                .field {
                    margin-bottom: 18px;
                }

                .field label {
                    display: block;
                    margin-bottom: 8px;
                    color: var(--muted);
                    font-weight: 900;
                    font-size: 13px;
                }

                .input-wrap {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    min-height: 52px;
                    padding: 0 15px;
                    border: 1px solid var(--line);
                    border-radius: 17px;
                    background: #fff;
                    transition: border-color 0.2s ease, box-shadow 0.2s ease;
                }

                .input-wrap:focus-within {
                    border-color: var(--primary);
                    box-shadow: 0 0 0 4px rgba(74, 124, 89, 0.12);
                }

                .input-wrap span {
                    color: var(--primary);
                }

                .input-wrap input {
                    width: 100%;
                    border: 0;
                    outline: 0;
                    background: transparent;
                    color: var(--text);
                    font: inherit;
                    font-weight: 700;
                }

                .form-row {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    gap: 12px;
                    margin: 6px 0 22px;
                    color: var(--muted);
                    font-size: 13px;
                    font-weight: 800;
                }

                .form-row a {
                    color: var(--primary);
                    text-decoration: none;
                }

                .submit-btn {
                    width: 100%;
                    min-height: 54px;
                    border: 0;
                    border-radius: 18px;
                    background: var(--primary);
                    color: white;
                    font: inherit;
                    font-weight: 900;
                    letter-spacing: 0.02em;
                    cursor: pointer;
                    box-shadow: 0 16px 28px rgba(74, 124, 89, 0.24);
                    transition: transform 0.2s ease, background 0.2s ease, box-shadow 0.2s ease;
                }

                .submit-btn:hover {
                    background: var(--primary-dark);
                    transform: translateY(-2px);
                    box-shadow: 0 20px 34px rgba(74, 124, 89, 0.28);
                }

                .error-message {
                    margin: 18px 0 0;
                    padding: 13px 15px;
                    border-radius: 15px;
                    background: var(--danger-soft);
                    color: var(--danger);
                    font-weight: 900;
                    text-align: center;
                }

                .copyright {
                    margin-top: 30px;
                    padding-top: 20px;
                    border-top: 1px solid var(--line);
                    color: var(--muted);
                    font-size: 12px;
                    text-align: center;
                    font-weight: 800;
                }

                @media (max-width: 900px) {
                    .login-page {
                        padding: 18px;
                    }

                    .login-card {
                        grid-template-columns: 1fr;
                    }

                    .brand-panel {
                        min-height: 430px;
                        padding: 34px 24px;
                    }

                    .logo-frame {
                        width: min(300px, 78%);
                    }

                    .form-panel {
                        padding: 36px 24px;
                    }
                }
            </style>
        </head>

        <body>
            <main class="login-page">
                <section class="login-card">
                    <aside class="brand-panel">
                        <div></div>
                        <div class="brand-copy">
                            <div class="logo-frame">
                                <img src="${pageContext.request.contextPath}/assets/img/po-bread-logo.jpg"
                                    alt="Po Bread logo">
                            </div>
                            <h1>Po Bread</h1>
                            <p>Hệ thống số hóa quy trình bán hàng: Quản lý khách hàng, sản phẩm, báo giá, hợp đồng và đơn hàng.</p>
                            <div class="brand-badges">
                                <span class="brand-badge"><span class="material-symbols-outlined">verified</span>Cổng truy cập an toàn</span>
                                <span class="brand-badge"><span class="material-symbols-outlined">bakery_dining</span>Po
                                    Bread Team</span>
                            </div>
                        </div>
                        <div></div>
                    </aside>

                    <section class="form-panel">
                        <div class="form-inner">
                            <p class="eyebrow">Cổng nội bộ Doanh nghiệp</p>
                            <h2>Chào mừng trở lại</h2>
                            <p class="subtitle">Đăng nhập vào tài khoản của bạn để tiếp tục quản lý quy trình bán hàng của Po Bread.</p>

                            <form action="${pageContext.request.contextPath}/login" method="post">
                                <div class="field">
                                    <label for="username">Tài khoản</label>
                                    <div class="input-wrap">
                                        <span class="material-symbols-outlined">person</span>
                                        <input type="text" id="username" name="username" required
                                            placeholder="Nhập tài khoản" autocomplete="username">
                                    </div>
                                </div>

                                <div class="field">
                                    <label for="password">Mật khẩu</label>
                                    <div class="input-wrap">
                                        <span class="material-symbols-outlined">lock</span>
                                        <input type="password" id="password" name="password" required
                                            placeholder="Nhập mật khẩu" autocomplete="current-password">
                                        <span class="material-symbols-outlined" id="togglePasswordIcon" onclick="togglePassword()" style="cursor: pointer; color: var(--muted); user-select: none;">visibility_off</span>
                                    </div>
                                </div>

                                <div class="form-row">
                                    <a href="${pageContext.request.contextPath}/auth/forgot">Quên mật khẩu?</a>
                                </div>

                                <button class="submit-btn" type="submit">Đăng nhập</button>

                                <c:if test="${not empty error}">
                                    <div class="error-message">
                                        <c:out value="${error}" />
                                    </div>
                                </c:if>
                            </form>

                            <div class="copyright">2026 Po Bread. SWP391 Group 3.</div>
                        </div>
                    </section>
                </section>
            </main>
            <script>
                function togglePassword() {
                    var pwdInput = document.getElementById("password");
                    var icon = document.getElementById("togglePasswordIcon");
                    if (pwdInput.type === "password") {
                        pwdInput.type = "text";
                        icon.innerText = "visibility";
                    } else {
                        pwdInput.type = "password";
                        icon.innerText = "visibility_off";
                    }
                }
            </script>
        </body>
        </html>
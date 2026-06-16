<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            th {
                background-color: #f4f4f4;
            }
            .signature-container {
                display: flex;
                justify-content: space-between;
                gap: 20px;
                margin-bottom: 30px;
            }
            .signature-box {
                flex: 1;
                border: 1px solid #ccc;
                padding: 15px;
                border-radius: 8px;
                background-color: #fdfdfd;
                text-align: center;
            }
            .signature-box h3 {
                margin-top: 0;
            }
            canvas {
                border: 1px solid #aaa;
                cursor: crosshair;
                background-color: #fff !important;
                margin-bottom: 10px;
            }
            .btn {
                padding: 8px 16px;
                cursor: pointer;
                border: none;
                border-radius: 4px;
            }
            .btn-clear {
                background-color: #ff4d4d;
                color: white;
            }
            .btn-clear:hover {
                background-color: #ff1a1a;
            }

            .submit-container {
                text-align: center;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 2px dashed #ddd;
            }
            .btn-submit {
                background-color: #4CAF50;
                color: white;
                font-size: 18px;
                padding: 12px 40px;
            }
            .btn-submit:hover {
                background-color: #45a049;
            }
        </style>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="contracts"/>
            </jsp:include>
            <main class="main legacy-page">
        <h1>Signature List</h1>
        <div>
            <table>
                <tr>
                    <th>ID</th>
                    <th>File Name</th>
                    <th>File URL</th>
                    <th>Image</th>
                    <th>Signed At</th>
                </tr>
                <c:if test="${signatures != null && !signatures.isEmpty()}">
                    <c:forEach var="s" items="${signatures}">
                        <tr>
                            <td> ${s.id} </td>
                            <td>${s.fileName}</td>
                            <td>${s.fileUrl}</td>
                            <td><img src="File?name=${s.fileName}" alt="Signature" style="height:40px;"/></td>
                            <td>${s.signedAt}</td>
                        </tr>
                    </c:forEach>
                </c:if>
            </table>
        </div>

        <h1>Signature</h1>
        <form action="Signature" id="signatureForm" method="post">

            <div class="signature-container">

                <div class="signature-box">
                    <h3>Bên A</h3>
                    <canvas id="canvasA" width="300" height="150"></canvas>
                    <input type="hidden" name="signatureA" value="${signatureA}" id="inputA">
                    <br/>
                    <input type="button" class="btn btn-clear" id="clearBtnA" value="Xóa chữ ký A" />
                </div>


                <div class="signature-box">
                    <h3>Bên B</h3>
                    <canvas id="canvasB" width="300" height="150"></canvas>
                    <input type="hidden" name="signatureB" value="${signatureB}" id="inputB">
                    <br/>
                    <input type="button" class="btn btn-clear" id="clearBtnB" value="Xóa chữ ký B" />
                </div>
            </div>


            <div class="submit-container">
                <button type="submit" class="btn btn-submit" id="submit">Xác Nhận</button>
            </div>
        </form>

        <script>
            function setupCanvas(canvasId, clearBtnId) {
                var canvas = document.getElementById(canvasId);
                var clearBtn = document.getElementById(clearBtnId);
                var ctx = canvas.getContext("2d");
                var isDrawing = false;
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.lineWidth = 2;

                function draw(e) {

                    var x = e.offsetX;
                    var y = e.offsetY;
                    if (canvas.dataset.locked === "true")
                        return;

                    if (e.type === "mousedown") {
                        isDrawing = true;
                        ctx.beginPath();
                        ctx.moveTo(x, y);
                    }
                    if (e.type === "mousemove" && isDrawing) {
                        ctx.lineTo(x, y);
                        ctx.stroke();
                    }
                    if (e.type === "mouseup" || e.type === "mouseleave") {
                        isDrawing = false;
                    }
                }
                function clear(e) {
                    if (canvas.dataset.locked === "true")
                        return;
                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                }
                clearBtn.onclick = clear;
                canvas.onmousedown = draw;
                canvas.onmousemove = draw;
                canvas.onmouseup = draw;
                canvas.onmouseleave = draw;
            }

            function storeCanvas(canvasId, inputId) {
                var canvas = document.getElementById(canvasId);
                var input = document.getElementById(inputId);

                if (canvas.dataset.locked === "true")
                    return;
                var blankCanvas = document.createElement('canvas');
                blankCanvas.width = canvas.width;
                blankCanvas.height = canvas.height;
                var blankDataUrl = blankCanvas.toDataURL("image/png");

                var currentDataUrl = canvas.toDataURL("image/png");

                if (currentDataUrl !== blankDataUrl) {
                    input.value = currentDataUrl;
                } else {
                    input.value = "";
                }
            }

            function loadCanvas(canvasId, inputId, clearBtnId) {
                var canvas = document.getElementById(canvasId);
                var input = document.getElementById(inputId);
                var clearBtn = document.getElementById(clearBtnId);
                var ctx = canvas.getContext("2d");

                if (input.value && input.value.trim() !== "") {
                    var img = new Image();
                    img.onload = function () {
                        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                        canvas.dataset.locked = "true";
                        clearBtn.disabled = true;
                        clearBtn.style.cursor = "not-allowed";
                        clearBtn.value = "Đã ký";
                    };
                    img.src = "File?name=" + input.value;
                }
            }

            setupCanvas("canvasA", "clearBtnA");
            loadCanvas("canvasA", "inputA", "clearBtnA");

            setupCanvas("canvasB", "clearBtnB");
            loadCanvas("canvasB", "inputB", "clearBtnB");

            document.getElementById("signatureForm").onsubmit = function () {
                storeCanvas("canvasA", "inputA");
                storeCanvas("canvasB", "inputB");
            };
        </script>

            </main>
        </div>
    </body>
</html>

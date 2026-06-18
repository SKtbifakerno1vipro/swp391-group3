<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hệ thống Ký tên</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .container {
                max-width: 800px;
                margin: 0 auto;
                background-color: #fff;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #f8f9fa;
            }
            .signature-section {
                text-align: center;
                margin-top: 30px;
                padding: 20px;
                border: 1px solid #eee;
                border-radius: 8px;
            }
            canvas {
                border: 1px solid #aaa;
                cursor: crosshair;
                background-color: #fff;
                margin-bottom: 15px;
                display: block;
                margin-left: auto;
                margin-right: auto;
            }
            .btn {
                padding: 10px 20px;
                cursor: pointer;
                border: none;
                border-radius: 4px;
                font-weight: bold;
                transition: background-color 0.3s;
            }
            .btn-clear {
                background-color: #dc3545;
                color: white;
            }
            .btn-clear:hover {
                background-color: #c82333;
            }
            .btn-submit {
                background-color: #28a745;
                color: white;
                font-size: 18px;
                padding: 12px 60px;
            }
            .btn-submit:hover {
                background-color: #218838;
            }
            .submit-container {
                text-align: center;
                margin-top: 30px;
            }
            h1, h2 {
                color: #333;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Ký tên xác nhận</h1>
            <form action="Signature" id="signatureForm" method="post">
                <input type="hidden" name="contractId" value="${contractId}">
                <input type="hidden" name="signerId" value="${signerId}">
                    <h2>Welcome ${signerName}</h2>
                <div class="signature-section">
                    <h3>Vui lòng ký vào khung bên dưới</h3>
                    <canvas id="signatureCanvas" width="400" height="200"></canvas>
                    <input type="hidden" name="signatureData" id="signatureData">
                    <br/>
                    <button type="button" class="btn btn-clear" id="clearBtn">Xóa chữ ký</button>
                </div>

                <div class="submit-container">
                    <button type="submit" class="btn btn-submit">Xác nhận ký tên</button>
                </div>
                    <c:if test="${not empty error}">
                    ${error}
                </c:if>
            </form>
        </div>

        <script>
//            const canvas = document.getElementById('signatureCanvas');
//            const ctx = canvas.getContext('2d');
//            const clearBtn = document.getElementById('clearBtn');
//            const signatureForm = document.getElementById('signatureForm');
//            const signatureDataInput = document.getElementById('signatureData');
//            
//            let isDrawing = false;
//            ctx.lineCap = 'round';
//            ctx.lineJoin = 'round';
//            ctx.lineWidth = 2;
//            ctx.strokeStyle = '#000';
//
//            function getMousePos(canvasDom, mouseEvent) {
//                const rect = canvasDom.getBoundingClientRect();
//                return {
//                    x: mouseEvent.clientX - rect.left,
//                    y: mouseEvent.clientY - rect.top
//                };
//            }
//
//            canvas.addEventListener('mousedown', (e) => {
//                isDrawing = true;
//                const pos = getMousePos(canvas, e);
//                ctx.beginPath();
//                ctx.moveTo(pos.x, pos.y);
//            });
//
//            canvas.addEventListener('mousemove', (e) => {
//                if (!isDrawing) return;
//                const pos = getMousePos(canvas, e);
//                ctx.lineTo(pos.x, pos.y);
//                ctx.stroke();
//            });
//
//            canvas.addEventListener('mouseup', () => isDrawing = false);
//            canvas.addEventListener('mouseleave', () => isDrawing = false);
//
//            clearBtn.addEventListener('click', () => {
//                ctx.clearRect(0, 0, canvas.width, canvas.height);
//            });
//
//            signatureForm.onsubmit = function(e) {
//                const blank = document.createElement('canvas');
//                blank.width = canvas.width;
//                blank.height = canvas.height;
//                
//                if (canvas.toDataURL() === blank.toDataURL()) {
//                    alert('Vui lòng ký tên trước khi gửi!');
//                    e.preventDefault();
//                    return false;
//                }
//                
//                signatureDataInput.value = canvas.toDataURL('image/png');
//            };
            
            
            
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
            setupCanvas("signatureCanvas", "clearBtn");

            document.getElementById("signatureForm").onsubmit = function () {
                storeCanvas("signatureCanvas", "signatureData");
            };
        </script>
    </body>
</html>

<%-- 
    Document   : ContractTemplate
    Created on : Jun 8, 2026, 10:57:03 PM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mẫu Hợp Đồng Mua Bán</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Times+New+Roman&display=swap');
            body {
                font-family: 'Times New Roman', Times, serif;
                background-color: #ffffff;
                color: #000000;
            }
            /* Định dạng in ấn A4 */
            @media print {
                @page {
                    size: A4;
                    margin: 20mm;
                }
                .no-print {
                    display: none;
                }
                .a4-page {
                    border: none !important;
                    padding: 0 !important;
                    width: 100% !important;
                    margin: 0 !important;
                }
            }
            /* Tạo các dòng kẻ chấm chấm để điền tay hoặc điền sau */
            .dotted-line {
                border-bottom: 1px dotted #000;
                display: inline-block;
                min-width: 150px;
            }
        </style>


        <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>

        <script>
            tinymce.init({
                selector: '#contract-editor', // ID của cái div hợp đồng
                plugins: 'table lists',
                toolbar: 'undo redo | bold italic underline | table | alignleft aligncenter alignright | bullist numlist',
                menubar: false,
                inline: true, // Chế độ này giúp bạn click vào đâu sửa ở đó mà không mất định dạng Tailwind
                fixed_toolbar_container: '#toolbar-container'
            });
        </script>

    </head>
    <body class="py-10">
        <div id="contract-editor" class="a4-page max-w-[210mm] mx-auto border border-black p-[20mm] bg-white min-h-[297mm] outline-none" contenteditable="true">

            <!-- Tiêu đề dùng font đậm, dễ nhìn -->
            <div class="text-center mb-8">
                <h1 class="font-bold text-lg uppercase">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</h1>
                <h2 class="font-bold text-md underline underline-offset-4 decoration-1">Độc lập – Tự do – Hạnh phúc</h2>

                <div class="mt-12">
                    <h3 class="font-bold text-xl uppercase">HỢP ĐỒNG MUA BÁN HÀNG HÓA</h3>
                    <p class="italic">Số: <span class="dotted-line">...........................</span></p>
                </div>
            </div>
            <!-- Container giả lập trang A4 -->
            <div class="a4-page max-w-[210mm] mx-auto border border-black p-[20mm] bg-white">

                <!-- Quốc hiệu & Tiêu ngữ -->
                <div class="text-center">
                    <h1 class="font-bold text-lg uppercase">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</h1>
                    <h2 class="font-bold text-md uppercase underline underline-offset-4">Độc lập – Tự do – Hạnh phúc</h2>

                    <div class="mt-10">
                        <h3 class="font-bold text-xl uppercase">HỢP ĐỒNG MUA BÁN HÀNG HÓA</h3>
                        <p class="italic mt-2">Số: ...........................................</p>
                    </div>
                </div>

                <!-- Căn cứ pháp lý -->
                <div class="mt-8 text-sm italic space-y-1">
                    <p>- Bộ luật Dân sự số 91/2015/QH13 ngày 24/11/2015;</p>
                    <p>- Luật Thương mại số 36/2005/QH11 ngày 14/06/2005;</p>
                    <p>- Nhu cầu và khả năng của các bên.</p>
                    <p class="not-italic mt-4">Hôm nay, ngày ...... tháng ...... năm ......, tại: ................................................................</p>
                    <p class="not-italic">Chúng tôi gồm có:</p>
                </div>

                <!-- Thông tin các bên -->
                <div class="mt-6 space-y-8">
                    <!-- Bên A -->
                    <section>
                        <h4 class="font-bold uppercase">BÊN BÁN (BÊN A):</h4>
                        <div class="mt-2 space-y-2 pl-4">
                            <p>Tên doanh nghiệp: .................................................................................................................</p>
                            <p>Địa chỉ trụ sở: ........................................................................................................................</p>
                            <p>Điện thoại: .................................................... Mã số thuế: .....................................................</p>
                            <p>Người đại diện: ............................................ Chức vụ: ..........................................................</p>
                        </div>
                    </section>

                    <!-- Bên B -->
                    <section>
                        <h4 class="font-bold uppercase">BÊN MUA (BÊN B):</h4>
                        <div class="mt-2 space-y-2 pl-4">
                            <p>Tên doanh nghiệp: .................................................................................................................</p>
                            <p>Địa chỉ trụ sở: ........................................................................................................................</p>
                            <p>Điện thoại: .................................................... Mã số thuế: .....................................................</p>
                            <p>Người đại diện: ............................................ Chức vụ: ..........................................................</p>
                        </div>
                    </section>
                </div>

                <!-- Nội dung hàng hóa -->
                <div class="mt-8">
                    <h4 class="font-bold uppercase mb-2">ĐIỀU 1: NỘI DUNG HÀNG HÓA</h4>
                    <table class="w-full border-collapse border border-black text-center text-sm">
                        <thead>
                            <tr>
                                <th class="border border-black p-2 w-12">STT</th>
                                <th class="border border-black p-2">Tên hàng hóa / Quy cách</th>
                                <th class="border border-black p-2 w-20">ĐVT</th>
                                <th class="border border-black p-2 w-20">Số lượng</th>
                                <th class="border border-black p-2">Đơn giá</th>
                                <th class="border border-black p-2">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Dòng trống để điền -->
                            <tr>
                                <td class="border border-black p-2 h-8"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                            </tr>
                            <tr>
                                <td class="border border-black p-2 h-8"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                                <td class="border border-black p-2"></td>
                            </tr>
                            <tr class="font-bold">
                                <td colspan="5" class="border border-black p-2 text-right uppercase">Cộng giá trị hợp đồng:</td>
                                <td class="border border-black p-2"></td>
                            </tr>
                        </tbody>
                    </table>
                    <p class="mt-2 text-sm italic">Bằng chữ: ...............................................................................................................................</p>
                </div>

                <!-- Các điều khoản khác -->
                <div class="mt-6 space-y-4 text-sm text-justify">
                    <div>
                        <p class="font-bold italic underline">ĐIỀU 2: THANH TOÁN</p>
                        <p>Phương thức thanh toán: ............................................................................................................</p>
                        <p>Thời hạn thanh toán: ................................................................................................................</p>
                    </div>
                    <div>
                        <p class="font-bold italic underline">ĐIỀU 3: GIAO NHẬN</p>
                        <p>Địa điểm giao nhận: ..................................................................................................................</p>
                        <p>Thời gian giao nhận: ..................................................................................................................</p>
                    </div>
                    <div>
                        <p class="font-bold italic underline">ĐIỀU 4: CAM KẾT CHUNG</p>
                        <p>Hai bên cam kết thực hiện đúng các điều khoản trong hợp đồng. Mọi tranh chấp sẽ được giải quyết thông qua thương lượng, trường hợp không thành sẽ đưa ra Tòa án có thẩm quyền.</p>
                    </div>
                </div>

                <!-- Chữ ký -->
                <div class="mt-12 grid grid-cols-2 text-center uppercase font-bold">
                    <div>
                        <p>ĐẠI DIỆN BÊN A</p>
                        <p class="text-[10px] font-normal italic lowercase">(Ký tên, đóng dấu)</p>
                        <div class="h-28"></div>
                    </div>
                    <div>
                        <p>ĐẠI DIỆN BÊN B</p>
                        <p class="text-[10px] font-normal italic lowercase">(Ký tên, đóng dấu)</p>
                        <div class="h-28"></div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Nút In (Ẩn khi in) -->
        <div class="no-print fixed bottom-10 right-10">
            <button onclick="window.print()" class="bg-black text-white px-8 py-3 font-bold border-2 border-black hover:bg-white hover:text-black transition-all">
                IN MẪU HỢP ĐỒNG
            </button>
        </div>

    </body>
</html>
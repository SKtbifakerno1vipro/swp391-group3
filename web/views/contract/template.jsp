<div style="font-family: 'Times New Roman', Times, serif; font-size: 14pt; line-height: 1.5; padding: 40px; background-color: white; color: black; max-width: 800px; margin: auto; border: 1px solid #ddd; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
    <div style="text-align: center; font-weight: bold; margin-bottom: 20px;">
        <p style="margin: 0;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</p>
        <p style="margin: 0; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc</p>
    </div>

    <div style="text-align: center; font-weight: bold; margin-bottom: 30px;">
        <h2 style="margin: 0; font-size: 16pt;">HỢP ĐỒNG MUA BÁN HÀNG HÓA</h2>
        <p style="margin: 0; font-weight: normal;">Hợp đồng số: {contract_number}/HĐMB</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="margin: 5px 0;">- Căn cứ Bộ luật Dân sự năm 2015;</p>
        <p style="margin: 5px 0;">- Căn cứ vào đơn chào hàng (đặt hàng hoặc sự thực hiện thỏa thuận của hai bên).</p>
    </div>

    <p style="margin-bottom: 20px;">Hôm nay, ngày {sign_date}</p>
    <p style="margin-bottom: 20px;">Tại địa điểm: {company_address}</p>
    <p style="margin-bottom: 20px;">Chúng tôi gồm:</p>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Bên A (Bên Bán):</p>
        <p style="margin: 5px 0;">Tên doanh nghiệp: <strong>{company_name}</strong></p>
        <p style="margin: 5px 0;">Địa chỉ trụ sở chính: {company_address}</p>
        <p style="margin: 5px 0;">Điện thoại: {company_phone}</p>
        <p style="margin: 5px 0;">Mã số thuế: {company_tax}</p>
        <p style="margin: 5px 0;">Đại diện là Ông (bà): <strong>{company_rep}</strong> - Chức vụ: {company_position}</p>
    </div>

    <div style="margin-bottom: 30px;">
        <p style="font-weight: bold; text-decoration: underline;">Bên B (Bên Mua):</p>
        <p style="margin: 5px 0;">Tên doanh nghiệp: <strong>{customer_name}</strong></p>
        <p style="margin: 5px 0;">Địa chỉ trụ sở chính: {customer_address}</p>
        <p style="margin: 5px 0;">Điện thoại: {customer_phone}</p>
        <p style="margin: 5px 0;">Mã số thuế: {customer_tax}</p>
    </div>

    <p style="font-weight: bold; margin-bottom: 15px;">Hai bên thống nhất thỏa thuận nội dung hợp đồng như sau:</p>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Điều 1: Nội dung công việc giao dịch</p>
        <p style="margin: 5px 0;">Bên A bán cho bên B:</p>
        
        <table style="width: 100%; border-collapse: collapse; margin-top: 10px; margin-bottom: 10px;">
            <thead>
                <tr>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Tên hàng</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Đơn vị tính</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Số lượng</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Đơn giá</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                {product_list}
            </tbody>
        </table>
        
        <p style="margin: 5px 0; font-weight: bold;">Tổng trị giá: {total_amount} VNĐ</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Điều 2: Phương thức thanh toán</p>
        <p style="margin: 5px 0;">Bên B thanh toán cho bên A bằng hình thức Chuyển Khoản Ngân Hàng (VNPay) ngay sau khi ký hợp đồng.</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Điều 3: Trách nhiệm vật chất trong việc thực hiện hợp đồng</p>
        <p style="margin: 5px 0;">1. Hai bên cam kết thực hiện nghiêm túc các điều khoản đã thỏa thuận trên, không được đơn phương thay đổi hoặc hủy bỏ hợp đồng.</p>
        <p style="margin: 5px 0;">2. Bên nào vi phạm các điều khoản trên đây sẽ phải chịu trách nhiệm vật chất theo quy định của các văn bản pháp luật có hiệu lực hiện hành.</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Điều 4: Hiệu lực của hợp đồng</p>
        <p style="margin: 5px 0;">Hợp đồng này có hiệu lực từ ngày <strong>{effective_date}</strong> đến ngày <strong>{end_date}</strong>.</p>
        <p style="margin: 5px 0;">Hợp đồng này được lập thành các bản có giá trị pháp lý như nhau. Đại diện hai bên đồng ý ký xác nhận bằng phương thức điện tử.</p>
    </div>

    <table style="width: 100%; margin-top: 50px;">
        <tr>
            <td style="width: 50%; text-align: center; vertical-align: top;">
                <p style="font-weight: bold; margin: 0;">ĐẠI DIỆN BÊN A</p>
                <p style="margin: 0; font-style: italic;">(Ký tên, đóng dấu)</p>
                <br><br><br><br>
                <p style="font-weight: bold; margin: 0;">{company_rep}</p>
            </td>
            <td style="width: 50%; text-align: center; vertical-align: top;">
                <p style="font-weight: bold; margin: 0;">ĐẠI DIỆN BÊN B</p>
                <p style="margin: 0; font-style: italic;">(Ký tên, xác nhận điện tử)</p>
                <br><br><br><br>
                <p style="font-weight: bold; margin: 0;">{customer_name}</p>
            </td>
        </tr>
    </table>
</div>
<div style="font-family: 'Times New Roman', Times, serif; font-size: 13pt; line-height: 1.5; padding: 40px; background-color: white; color: black; max-width: 800px; margin: 0 auto; border: 1px solid #ccc; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
    <div style="text-align: center; font-weight: bold;">
        <p style="margin: 0;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</p>
        <p style="margin: 0; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc</p>
    </div>

    <div style="text-align: center; font-weight: bold; margin-top: 20px;">
        <h2 style="margin: 0;">HỢP ĐỒNG MUA BÁN HÀNG HÓA</h2>
        <p style="margin: 0; font-weight: normal; font-style: italic;">Hợp đồng số: {contract_number}</p>
    </div>

    <div style="margin-top: 20px;">
        <p style="margin: 5px 0;">- Căn cứ Bộ luật Dân sự năm 2015;</p>
        <p style="margin: 5px 0;">- Căn cứ vào đơn chào hàng (đặt hàng hoặc sự thực hiện thỏa thuận của hai bên).</p>
    </div>

    <p style="margin: 5px 0;">Hôm nay, ngày {sign_date}. Tại địa điểm: {company_address}</p>
    <p style="margin: 5px 0;">Chúng tôi gồm:</p>

    <div style="margin-top: 15px;">
        <p style="font-weight: bold; text-decoration: underline; margin: 0;">Bên A (Bên Bán):</p>
        <p style="margin: 0;">Tên doanh nghiệp: <strong>{company_name}</strong></p>
        <p style="margin: 0;">Địa chỉ trụ sở chính: {company_address}</p>
        <p style="margin: 0;">Điện thoại: {company_phone}</p>
        <p style="margin: 0;">Tài khoản số: ....................................................</p>
        <p style="margin: 0;">Mở tại ngân hàng: ................................................</p>
        <p style="margin: 0;">Đại diện là Ông (bà): <strong>{company_rep}</strong></p>
        <p style="margin: 0;">Chức vụ: {company_position}</p>
    </div>

    <div style="margin-top: 20px;">
        <p style="font-weight: bold; text-decoration: underline; margin: 0;">Bên B (Bên Mua):</p>
        <p style="margin: 0;">Tên doanh nghiệp: <strong>{customer_name}</strong></p>
        <p style="margin: 0;">Địa chỉ trụ sở chính: {customer_address}</p>
        <p style="margin: 0;">Điện thoại: {customer_phone}</p>
        <p style="margin: 0;">Tài khoản số: ....................................................</p>
        <p style="margin: 0;">Mở tại ngân hàng: ................................................</p>
        <p style="margin: 0;">Đại diện là Ông (bà): ....................................................</p>
        <p style="margin: 0;">Chức vụ: .........................................................</p>
    </div>

    <p style="margin-top: 15px;">Hai bên thống nhất thỏa thuận nội dung hợp đồng như sau:</p>

    <p style="font-weight: bold; margin: 0;">Điều 1: Nội dung công việc giao dịch</p>
    <table style="width: 100%; border-collapse: collapse; margin: 10px 0;">
        <thead>
            <tr>
                <th style="border: 1px solid black; padding: 5px;">STT</th>
                <th style="border: 1px solid black; padding: 5px;">Tên hàng</th>
                <th style="border: 1px solid black; padding: 5px;">Đơn vị tính</th>
                <th style="border: 1px solid black; padding: 5px;">Số lượng</th>
                <th style="border: 1px solid black; padding: 5px;">Đơn giá</th>
                <th style="border: 1px solid black; padding: 5px;">Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            {product_list}
        </tbody>
    </table>
    <p style="margin: 0;">Tổng trị giá: {total_amount} VNĐ</p>

    <p style="font-weight: bold; margin-top: 10px;">Điều 2: Chất lượng và quy cách hàng hóa</p>
    <p style="margin: 0;">Chất lượng mặt hàng ................. được quy định theo...........................</p>

    <p style="font-weight: bold; margin-top: 10px;">Điều 11: Hiệu lực của hợp đồng</p>
    <p style="margin: 0;">Hợp đồng có hiệu lực từ ngày <strong>{effective_date}</strong> đến ngày <strong>{end_date}</strong>.</p>

    <table style="width: 100%; margin-top: 40px;">
        <tr>
            <td style="width: 50%; text-align: center;"><strong>ĐẠI DIỆN BÊN A</strong><br><br><br><br><strong>{company_rep}</strong></td>
            <td style="width: 50%; text-align: center;"><strong>ĐẠI DIỆN BÊN B</strong><br><br><br><br><strong>{customer_name}</strong></td>
        </tr>
    </table>
</div>
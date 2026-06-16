<div style="font-family: 'Times New Roman', Times, serif; font-size: 14pt; line-height: 1.5; padding: 40px; background-color: white; color: black; max-width: 800px; margin: auto; border: 1px solid #ddd; box-shadow: 0 0 10px rgba(0,0,0,0.1);">
    <div style="text-align: center; font-weight: bold; margin-bottom: 20px;">
        <p style="margin: 0;">SOCIALIST REPUBLIC OF VIETNAM</p>
        <p style="margin: 0; text-decoration: underline;">Independence - Freedom - Happiness</p>
    </div>

    <div style="text-align: center; font-weight: bold; margin-bottom: 30px;">
        <h2 style="margin: 0; font-size: 16pt;">GOODS SALE CONTRACT</h2>
        <p style="margin: 0; font-weight: normal;">Contract No: {contract_number}/HDMB</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="margin: 5px 0;">- Pursuant to the Civil Code 2015;</p>
        <p style="margin: 5px 0;">- Pursuant to the quotation, order request and agreement between both parties.</p>
    </div>

    <p style="margin-bottom: 20px;">Today, {sign_date}</p>
    <p style="margin-bottom: 20px;">At: {company_address}</p>
    <p style="margin-bottom: 20px;">We include:</p>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Party A (Seller):</p>
        <p style="margin: 5px 0;">Company name: <strong>{company_name}</strong></p>
        <p style="margin: 5px 0;">Head office address: {company_address}</p>
        <p style="margin: 5px 0;">Phone: {company_phone}</p>
        <p style="margin: 5px 0;">Tax code: {company_tax}</p>
        <p style="margin: 5px 0;">Representative: <strong>{company_rep}</strong> - Position: {company_position}</p>
    </div>

    <div style="margin-bottom: 30px;">
        <p style="font-weight: bold; text-decoration: underline;">Party B (Buyer):</p>
        <p style="margin: 5px 0;">Company name: <strong>{customer_name}</strong></p>
        <p style="margin: 5px 0;">Head office address: {customer_address}</p>
        <p style="margin: 5px 0;">Phone: {customer_phone}</p>
        <p style="margin: 5px 0;">Tax code: {customer_tax}</p>
    </div>

    <p style="font-weight: bold; margin-bottom: 15px;">Both parties agree to the contract terms below:</p>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Article 1: Transaction content</p>
        <p style="margin: 5px 0;">Party A sells to Party B:</p>
        <table style="width: 100%; border-collapse: collapse; margin-top: 10px; margin-bottom: 10px;">
            <thead>
                <tr>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Product</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Unit</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Quantity</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Unit Price</th>
                    <th style="border: 1px solid black; padding: 5px; text-align: center;">Amount</th>
                </tr>
            </thead>
            <tbody>{product_list}</tbody>
        </table>
        <p style="margin: 5px 0; font-weight: bold;">Total value: {total_amount} VND</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Article 2: Payment method</p>
        <p style="margin: 5px 0;">Party B pays Party A by bank transfer after signing this contract.</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Article 3: Responsibilities</p>
        <p style="margin: 5px 0;">1. Both parties commit to comply with all agreed terms and must not unilaterally change or cancel the contract.</p>
        <p style="margin: 5px 0;">2. Any violating party shall be responsible according to applicable regulations and this contract.</p>
    </div>

    <div style="margin-bottom: 20px;">
        <p style="font-weight: bold; text-decoration: underline;">Article 4: Contract validity</p>
        <p style="margin: 5px 0;">This contract is effective from <strong>{effective_date}</strong> to <strong>{end_date}</strong>.</p>
        <p style="margin: 5px 0;">This contract is made in valid copies with the same legal value. Representatives of both parties confirm by electronic signature.</p>
    </div>

    <table style="width: 100%; margin-top: 50px;">
        <tr>
            <td style="width: 50%; text-align: center; vertical-align: top;">
                <p style="font-weight: bold; margin: 0;">PARTY A REPRESENTATIVE</p>
                <p style="margin: 0; font-style: italic;">(Signature and seal)</p>
                <br><br><br><br>
                <p style="font-weight: bold; margin: 0;">{company_rep}</p>
            </td>
            <td style="width: 50%; text-align: center; vertical-align: top;">
                <p style="font-weight: bold; margin: 0;">PARTY B REPRESENTATIVE</p>
                <p style="margin: 0; font-style: italic;">(Electronic confirmation)</p>
                <br><br><br><br>
                <p style="font-weight: bold; margin: 0;">{customer_name}</p>
            </td>
        </tr>
    </table>
</div>

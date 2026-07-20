const fs = require('fs');

// We organize the tables by columns (logical groups) to minimize crossings.
const columnsGroup = [
    // Column 1: User & Authorization
    ["role", "permission", "role_permission", "user", "system_audit_log", "email_log"],
    
    // Column 2: Customer & Quotation
    ["customer", "quotation", "quotation_detail", "quotation_history"],
    
    // Column 3: Contract
    ["customer_contract", "contract_edit_history", "contract_revision_item", "signature"],
    
    // Column 4: Order & Payment
    ["customer_order", "customer_order_detail", "invoice", "payment"],
    
    // Column 5: Product & Inventory
    ["category", "product", "import_request", "product_review"]
];

const tables = {
    "role": [
        ["role_id", "INT", "PK"],
        ["role_name", "NVARCHAR(100)", ""],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""],
        ["status", "VARCHAR(20)", ""]
    ],
    "permission": [
        ["permission_id", "INT", "PK"],
        ["permission_name", "NVARCHAR(100)", ""],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""]
    ],
    "role_permission": [
        ["role_id", "INT", "PK, FK"],
        ["permission_id", "INT", "PK, FK"]
    ],
    "user": [
        ["user_id", "INT", "PK"],
        ["user_name", "NVARCHAR(100)", ""],
        ["password_hash", "NVARCHAR(255)", ""],
        ["email", "NVARCHAR(255)", ""],
        ["gender", "CHAR(1)", ""],
        ["date_of_birth", "DATE", ""],
        ["full_name", "NVARCHAR(255)", ""],
        ["address", "NVARCHAR(255)", ""],
        ["phone", "VARCHAR(20)", ""],
        ["account_status", "VARCHAR(20)", ""],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""],
        ["created_by", "INT", "FK"],
        ["updated_by", "INT", "FK"],
        ["role_id", "INT", "FK"]
    ],
    "system_audit_log": [
        ["log_id", "INT", "PK"],
        ["user_id", "INT", "FK"],
        ["action_type", "NVARCHAR(255)", ""],
        ["affected_object", "NVARCHAR(255)", ""],
        ["description", "NVARCHAR(MAX)", ""],
        ["created_at", "DATETIME", ""]
    ],
    "email_log": [
        ["log_id", "INT", "PK"],
        ["recipient", "NVARCHAR(255)", ""],
        ["subject", "NVARCHAR(255)", ""],
        ["content", "NVARCHAR(MAX)", ""],
        ["sent_at", "DATETIME", ""],
        ["status", "VARCHAR(20)", ""]
    ],
    "category": [
        ["category_id", "INT", "PK"],
        ["category_name", "NVARCHAR(255)", ""]
    ],
    "product": [
        ["product_id", "INT", "PK"],
        ["product_name", "NVARCHAR(255)", ""],
        ["cost_price", "DECIMAL(18,2)", ""],
        ["selling_price", "DECIMAL(18,2)", ""],
        ["description", "NVARCHAR(MAX)", ""],
        ["unit", "NVARCHAR(50)", ""],
        ["product_status", "VARCHAR(20)", ""],
        ["reorder_level", "INT", ""],
        ["quantity_available", "INT", ""],
        ["quantity_reserve", "INT", ""],
        ["updated_by", "INT", "FK"],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""],
        ["category_id", "INT", "FK"]
    ],
    "import_request": [
        ["import_id", "INT", "PK"],
        ["product_id", "INT", "FK"],
        ["quantity", "INT", ""],
        ["status", "INT", ""],
        ["created_by", "INT", "FK"],
        ["created_date", "DATETIME", ""],
        ["imported_by", "INT", "FK"],
        ["imported_date", "DATETIME", ""],
        ["note", "NVARCHAR(MAX)", ""]
    ],
    "product_review": [
        ["review_id", "INT", "PK"],
        ["product_id", "INT", "FK"],
        ["user_id", "INT", "FK"],
        ["rating", "INT", ""],
        ["comment", "NVARCHAR(1000)", ""],
        ["created_at", "DATETIME", ""],
        ["reply_content", "NVARCHAR(1000)", ""],
        ["replied_by", "INT", "FK"],
        ["replied_at", "DATETIME", ""],
        ["status", "VARCHAR(20)", ""]
    ],
    "customer": [
        ["customer_id", "INT", "PK"],
        ["tax_code", "VARCHAR(20)", ""],
        ["customer_type", "VARCHAR(50)", ""],
        ["company_name", "NVARCHAR(255)", ""],
        ["user_id", "INT", "FK"],
        ["assigned_to_user_id", "INT", "FK"],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""]
    ],
    "quotation": [
        ["quotation_id", "INT", "PK"],
        ["customer_id", "INT", "FK"],
        ["quotation_date", "DATETIME", ""],
        ["quotation_status", "VARCHAR(20)", ""],
        ["created_by", "INT", "FK"],
        ["created_at", "DATETIME", ""],
        ["total_price", "DECIMAL(18,2)", ""]
    ],
    "quotation_detail": [
        ["quotation_detail_id", "INT", "PK"],
        ["quotation_id", "INT", "FK"],
        ["product_id", "INT", "FK"],
        ["product_name", "NVARCHAR(255)", ""],
        ["unit", "NVARCHAR(50)", ""],
        ["quantity", "INT", ""],
        ["cost_price", "DECIMAL(18,2)", ""],
        ["selling_price", "DECIMAL(18,2)", ""],
        ["discount_percent", "DECIMAL(5,2)", ""],
        ["tax_percent", "DECIMAL(5,2)", ""]
    ],
    "quotation_history": [
        ["quotation_history_id", "INT", "PK"],
        ["quotation_id", "INT", "FK"],
        ["created_by", "INT", "FK"],
        ["created_at", "DATETIME", ""],
        ["edit_history", "NVARCHAR(MAX)", ""]
    ],
    "customer_contract": [
        ["customer_contract_id", "INT", "PK"],
        ["customer_id", "INT", "FK"],
        ["quotation_id", "INT", "FK"],
        ["contract_number", "NVARCHAR(100)", ""],
        ["contract_file_url", "NVARCHAR(1000)", ""],
        ["contract_status", "VARCHAR(50)", ""],
        ["effective_date", "DATETIME", ""],
        ["end_date", "DATETIME", ""],
        ["signed_date", "DATETIME", ""],
        ["contract_content", "NVARCHAR(MAX)", ""],
        ["storage_type", "VARCHAR(10)", ""],
        ["token", "VARCHAR(255)", ""],
        ["token_expired_at", "DATETIME", ""],
        ["created_by", "INT", "FK"],
        ["updated_by", "INT", "FK"],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""]
    ],
    "contract_edit_history": [
        ["history_id", "INT", "PK"],
        ["contract_id", "INT", "FK"],
        ["from_status", "VARCHAR(50)", ""],
        ["to_status", "VARCHAR(50)", ""],
        ["edit_status", "VARCHAR(50)", ""],
        ["note", "NVARCHAR(MAX)", ""],
        ["changed_by", "INT", "FK"],
        ["created_at", "DATETIME", ""]
    ],
    "contract_revision_item": [
        ["revision_item_id", "INT", "PK"],
        ["history_id", "INT", "FK"],
        ["contract_id", "INT", "FK"],
        ["revision_type", "NVARCHAR(100)", ""],
        ["revision_detail", "NVARCHAR(MAX)", ""]
    ],
    "signature": [
        ["signature_id", "INT", "PK"],
        ["customer_contract_id", "INT", "FK"],
        ["invoice_id", "INT", "FK"],
        ["file_name", "NVARCHAR(255)", ""],
        ["file_url", "NVARCHAR(1000)", ""],
        ["signer_user_id", "INT", "FK"],
        ["signer_name", "NVARCHAR(255)", ""],
        ["signed_at", "DATETIME", ""],
        ["uploaded_by", "INT", "FK"],
        ["uploaded_at", "DATETIME", ""]
    ],
    "customer_order": [
        ["customer_order_id", "INT", "PK"],
        ["customer_id", "INT", "FK"],
        ["customer_contract_id", "INT", "FK"],
        ["order_status", "VARCHAR(20)", ""],
        ["created_by", "INT", "FK"],
        ["created_at", "DATETIME", ""]
    ],
    "customer_order_detail": [
        ["customer_order_detail_id", "INT", "PK"],
        ["customer_order_id", "INT", "FK"],
        ["quotation_detail_id", "INT", "FK"],
        ["quantity", "INT", ""],
        ["cost_price", "DECIMAL(18,2)", ""],
        ["selling_price", "DECIMAL(18,2)", ""]
    ],
    "invoice": [
        ["invoice_id", "INT", "PK"],
        ["customer_contract_id", "INT", "FK"],
        ["customer_order_id", "INT", "FK"],
        ["invoice_no", "NVARCHAR(100)", ""],
        ["issue_date", "DATETIME", ""],
        ["invoice_status", "VARCHAR(50)", ""],
        ["invoice_type", "VARCHAR(20)", ""],
        ["invoice_symbol", "VARCHAR(20)", ""],
        ["seller_name", "NVARCHAR(255)", ""],
        ["seller_tax_code", "VARCHAR(20)", ""],
        ["seller_address", "NVARCHAR(255)", ""],
        ["seller_phone", "VARCHAR(20)", ""],
        ["buyer_name", "NVARCHAR(255)", ""],
        ["buyer_tax_code", "VARCHAR(20)", ""],
        ["buyer_address", "NVARCHAR(255)", ""],
        ["buyer_phone", "VARCHAR(20)", ""],
        ["total_amount", "DECIMAL(18,2)", ""],
        ["customer_note", "NVARCHAR(MAX)", ""],
        ["internal_note", "NVARCHAR(MAX)", ""],
        ["created_by", "INT", "FK"],
        ["created_at", "DATETIME", ""],
        ["updated_at", "DATETIME", ""]
    ],
    "payment": [
        ["payment_id", "INT", "PK"],
        ["customer_contract_id", "INT", "FK"],
        ["invoice_id", "INT", "FK"],
        ["amount", "DECIMAL(18,2)", ""],
        ["payment_type", "VARCHAR(50)", ""],
        ["payment_status", "VARCHAR(20)", ""],
        ["paid_at", "DATETIME2(6)", ""],
        ["created_by", "INT", "FK"],
        ["created_at", "DATETIME2(6)", ""]
    ]
};

const relations = [
    ["role", "role_id", "role_permission", "role_id"],
    ["permission", "permission_id", "role_permission", "permission_id"],
    ["role", "role_id", "user", "role_id"],
    ["user", "user_id", "user", "created_by"],
    ["user", "user_id", "user", "updated_by"],
    ["user", "user_id", "system_audit_log", "user_id"],
    ["category", "category_id", "product", "category_id"],
    ["user", "user_id", "product", "updated_by"],
    ["product", "product_id", "import_request", "product_id"],
    ["user", "user_id", "import_request", "created_by"],
    ["user", "user_id", "import_request", "imported_by"],
    ["product", "product_id", "product_review", "product_id"],
    ["user", "user_id", "product_review", "user_id"],
    ["user", "user_id", "product_review", "replied_by"],
    ["user", "user_id", "customer", "user_id"],
    ["user", "user_id", "customer", "assigned_to_user_id"],
    ["customer", "customer_id", "quotation", "customer_id"],
    ["user", "user_id", "quotation", "created_by"],
    ["quotation", "quotation_id", "quotation_detail", "quotation_id"],
    ["product", "product_id", "quotation_detail", "product_id"],
    ["quotation", "quotation_id", "quotation_history", "quotation_id"],
    ["user", "user_id", "quotation_history", "created_by"],
    ["customer", "customer_id", "customer_contract", "customer_id"],
    ["quotation", "quotation_id", "customer_contract", "quotation_id"],
    ["user", "user_id", "customer_contract", "created_by"],
    ["user", "user_id", "customer_contract", "updated_by"],
    ["customer_contract", "customer_contract_id", "contract_edit_history", "contract_id"],
    ["user", "user_id", "contract_edit_history", "changed_by"],
    ["contract_edit_history", "history_id", "contract_revision_item", "history_id"],
    ["customer_contract", "customer_contract_id", "contract_revision_item", "contract_id"],
    ["customer_contract", "customer_contract_id", "signature", "customer_contract_id"],
    ["user", "user_id", "signature", "signer_user_id"],
    ["user", "user_id", "signature", "uploaded_by"],
    ["customer", "customer_id", "customer_order", "customer_id"],
    ["customer_contract", "customer_contract_id", "customer_order", "customer_contract_id"],
    ["user", "user_id", "customer_order", "created_by"],
    ["customer_order", "customer_order_id", "customer_order_detail", "customer_order_id"],
    ["quotation_detail", "quotation_detail_id", "customer_order_detail", "quotation_detail_id"],
    ["customer_contract", "customer_contract_id", "invoice", "customer_contract_id"],
    ["customer_order", "customer_order_id", "invoice", "customer_order_id"],
    ["user", "user_id", "invoice", "created_by"],
    ["customer_contract", "customer_contract_id", "payment", "customer_contract_id"],
    ["invoice", "invoice_id", "payment", "invoice_id"],
    ["user", "user_id", "payment", "created_by"]
];

const xml_out = [];
xml_out.push('<mxfile host="Electron" modified="2026-07-19T03:44:48.000Z" agent="Antigravity" version="21.0.0" type="device">');
xml_out.push('  <diagram id="database-diagram" name="Database Diagram">');
xml_out.push('    <mxGraphModel dx="1200" dy="1200" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="2400" pageHeight="2400" math="0" shadow="0">');
xml_out.push('      <root>');
xml_out.push('        <mxCell id="0" />');
xml_out.push('        <mxCell id="1" parent="0" />');

const col_width = 240;
const row_height = 26;

// Horizontal positions of columns (1 to 5)
const col_x = [40, 360, 680, 1000, 1320];

// Render the tables in their grouped columns
columnsGroup.forEach((columnTables, colIdx) => {
    let currentY = 40;
    columnTables.forEach((tableName) => {
        const cols = tables[tableName];
        if (!cols) return;
        
        const x = col_x[colIdx];
        const y = currentY;
        const tableHeight = 30 + cols.length * row_height;
        const table_id = `table_${tableName}`;
        
        // Output swimlane container for the table
        xml_out.push(`        <mxCell id="${table_id}" value="${tableName}" style="swimlane;fontStyle=1;childLayout=cascadeLayout;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=1;marginBottom=0;align=center;fontSize=12;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">`);
        xml_out.push(`          <mxGeometry x="${x}" y="${y}" width="${col_width}" height="${tableHeight}" as="geometry" />`);
        xml_out.push('        </mxCell>');
        
        let curr_y = 30;
        cols.forEach(([col_name, col_type, constraint]) => {
            const col_id = `${tableName}_${col_name}`;
            const cons_str = constraint ? ` [${constraint}]` : "";
            const val = `+ ${col_name} : ${col_type}${cons_str}`;
            const font_style = constraint.includes("PK") ? "fontStyle=1;" : "";
            
            // Output row inside the table
            xml_out.push(`        <mxCell id="${col_id}" value="${val}" style="text;strokeColor=none;fillColor=none;align=left;verticalAlign=middle;spacingLeft=4;spacingRight=4;overflow=hidden;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;rotatable=0;whiteSpace=wrap;html=1;${font_style}" vertex="1" parent="${table_id}">`);
            xml_out.push(`          <mxGeometry y="${curr_y}" width="${col_width}" height="${row_height}" as="geometry" />`);
            xml_out.push('        </mxCell>');
            curr_y += row_height;
        });
        
        currentY += tableHeight + 60; // Leave 60px space between vertical tables
    });
});

// Render dynamic Crow's Foot relations (NO hardcoded ports like exitX, entryX)
// Draw.io automatically routes connections between cells avoiding obstacles and overlaps when exit/entry ports are omitted!
relations.forEach(([parentTable, parentCol, childTable, childCol], relIdx) => {
    const parentCellId = `${parentTable}_${parentCol}`;
    const childCellId = `${childTable}_${childCol}`;
    const relId = `rel_${relIdx}`;
    
    // Style has rounded=1, jettySize=auto, orthogonalLoop=1 to enable premium auto-routing routing
    xml_out.push(`        <mxCell id="${relId}" value="" style="edgeStyle=orthogonalEdgeStyle;fontSize=12;html=1;endArrow=ERmany;startArrow=ERone;rounded=1;jettySize=auto;orthogonalLoop=1;" edge="1" parent="1" source="${parentCellId}" target="${childCellId}">`);
    xml_out.push('          <mxGeometry relative="1" as="geometry" />');
    xml_out.push('        </mxCell>');
});

xml_out.push('      </root>');
xml_out.push('    </mxGraphModel>');
xml_out.push('  </diagram>');
xml_out.push('</mxfile>');

const outputPath = "c:\\Users\\ADMIN\\Desktop\\Project_Swp\\swp391-group3\\db\\db_diagram.xml";
fs.writeFileSync(outputPath, xml_out.join('\n'), 'utf-8');
console.log(`Success: Generated non-overlapping dynamic draw.io XML at ${outputPath}`);

# Screen & Action Permission Matrix — Final Version

> Dự án: **Pơ Bread Sales Process Digitalization System**  
> Mục tiêu: tổng hợp danh sách màn hình, action permission và bảng phân quyền theo các vai trò:
> **Admin, Manager, Sale, Provider, Customer**.

---

## 1. Danh sách màn hình final

### 1.1 Dashboard & Report (Manager)

| STT | Screen |
|---:|---|
| 1 | Dashboard |
| 2 | Business Report |
| 3 | Revenue Report |
| 4 | Cost Report |
| 5 | Profit Report |
---

### 1.2 User & Role Management (Admin)

| STT | Screen |
|---:|---|
| 8 | User List |
| 9 | User Detail |
| 10 | Create User |
| 11 | Edit User |
| 12 | Role List |
| 13 | Role Detail |
| 14 | Create Role |
| 15 | Edit Role |
| 16 | Edit Role Permissions |

---

### 1.3 Customer Management(Sale)

| STT | Screen |
|---:|---|
| 17 | Customer List |
| 18 | Customer Detail |
| 19 | Create Customer |
| 20 | Edit Customer |

---

### 1.4 Provider Management(Manager)

| STT | Screen |
|---:|---|
| 21 | Provider List |
| 22 | Provider Detail |
| 23 | Create Provider |
| 24 | Edit Provider |
| 25 | Provider Category Management |
| 26 | Provider Review List | <ko cần thiết>
| 27 | Provider Review Detail | <ko cần thiết>

---

### 1.5 Product/ Service & Category Management(Manager)

| STT | Screen |
|---:|---|
| 28 | Product / Service List |
| 29 | Product / Service Detail |
| 30 | Create Product / Service |
| 31 | Edit Product / Service |
| 32 | Category List |
| 33 | Category Detail |
| 34 | Create Category |
| 35 | Edit Category |
| 36 | Product Price History |

---

### 1.6 Customer Order Management(Sale + Manager)

| STT | Screen |
|---:|---|
| 37 | Customer Order List |
| 38 | Customer Order Detail |
| 39 | Create Customer Order |
| 40 | Edit Customer Order |
| 41 | Customer Order Status History |

---

### 1.7 Provider Order Management(Manager)

| STT | Screen |
|---:|---|
| 42 | Provider Order List |
| 43 | Provider Order Detail |
| 44 | Create Provider Order |
| 45 | Edit Provider Order |
| 46 | Provider Order Status History |

---

### 1.8 Quotation / Negotiation(Manager)

| STT | Screen |
|---:|---|
| 47 | Quotation List |
| 48 | Quotation Detail |
| 49 | Create Quotation |
| 50 | Edit Quotation |
| 51 | Negotiation History |

---

### 1.9 Customer Contract Management(Sale + Manager)

| STT | Screen |
|---:|---|
| 52 | Customer Contract List |
| 53 | Customer Contract Detail |
| 54 | Create Customer Contract | 
| 55 | Edit Customer Contract |
| 56 | Customer Contract Template | 
| 5x | Create Contract Template | <Manager>
| 5x | Edit Contract Template | <Manager>
| 57 | Customer Contract Version History |
| 58 | Customer Contract Status History |

---

### 1.10 Provider Contract Management(Provider + Manager)

| STT | Screen |
|---:|---|
| 59 | Provider Contract List |
| 60 | Provider Contract Detail |
| 61 | Create Provider Contract | <only manager>
| 62 | Edit Provider Contract | <only manager>
| 63 | Provider Contract Template |
| 6x | Create Contract Template | <Manager>
| 6x | Edit Contract Template | <Manager>
| 64 | Provider Contract Version History |
| 65 | Provider Contract Status History |

---


### 1.13 Payment Management(Costumer + Manager + Provider)

| STT | Screen |
|---:|---|
| 74 | Customer Payment List | <only manager>
| 75 | Customer Payment Detail | 
| 76 | Create Customer Payment Request | <only manager>
| 77 | Customer Payment History |
| 78 | Provider Payment List | <only manager>
| 79 | Provider Payment Detail |
| 80 | Create Provider Payment Request | <only manager>
| 81 | Provider Payment History |

---

### 1.14 Invoice Management (Customer + Manager + Provider)

| STT | Screen |
|---:|---|
| 82 | Customer Invoice List | <only manager>
| 83 | Customer Invoice Detail |
| 84 | Create Customer Invoice | <only manager>
| 85 | Provider Invoice List | <only manager>
| 86 | Provider Invoice Detail |
| 87 | Create Provider Invoice | <only manager>

---

## 2. Danh sách Action Permission final

> Các mục dưới đây **không nên tách thành màn hình riêng**.  
> Đây là các nút bấm, thao tác trong List / Detail / Modal / Form.

### 2.1 Customer Order Actions

| STT | Action Permission |
|---:|---|
| A01 | Submit Customer Order for Approval |
| A02 | Approve Customer Order |
| A03 | Reject Customer Order |
| A04 | Send Customer Order Quotation |
| A05 | Mark Customer Order as Negotiating |
| A06 | Accept Customer Order |
| A07 | Cancel Customer Order |
| A08 | Expire Customer Order |
| A09 | Create Customer Contract from Customer Order |

---

### 2.2 Provider Order Actions

| STT | Action Permission |
|---:|---|
| A10 | Submit Provider Order for Approval |
| A11 | Approve Provider Order |
| A12 | Reject Provider Order |
| A13 | Send Provider Order to Provider |
| A14 | Mark Provider Order as Negotiating |
| A15 | Accept Provider Order |
| A16 | Reject Provider Order by Provider |
| A17 | Cancel Provider Order |
| A18 | Expire Provider Order |
| A19 | Create Provider Contract from Provider Order |

---

### 2.3 Quotation / Negotiation Actions

| STT | Action Permission |
|---:|---|
| A20 | Send Quotation |
| A21 | Revise Quotation |
| A22 | Accept Quotation |
| A23 | Reject Quotation |
| A24 | Add Negotiation Note |

---

### 2.4 Customer Contract Actions

| STT | Action Permission |
|---:|---|
| A25 | Submit Customer Contract for Approval |
| A26 | Approve Customer Contract |
| A27 | Reject Customer Contract |
| A28 | Send Customer Contract for Signature |
| A29 | Sign Customer Contract |
| A30 | Decline Customer Contract |
| A31 | Cancel Customer Contract |
| A32 | Create Customer Contract Version |
| A33 | Add Customer Contract Reject Note |
| A34 | Move Customer Contract to In Execution |
| A35 | Complete Customer Contract |

---

### 2.5 Provider Contract Actions

| STT | Action Permission |
|---:|---|
| A36 | Submit Provider Contract for Approval |
| A37 | Approve Provider Contract |
| A38 | Reject Provider Contract |
| A39 | Send Provider Contract for Signature |
| A40 | Sign / Accept Provider Contract |
| A41 | Decline Provider Contract |
| A42 | Cancel Provider Contract |
| A43 | Create Provider Contract Version |
| A44 | Add Provider Contract Reject Note |
| A45 | Assign Provider Contract |
| A46 | Move Provider Contract to In Progress |
| A47 | Complete Provider Contract |

---

### 2.6 Provider Task / Delivery Actions

| STT | Action Permission |
|---:|---|
| A48 | Assign Provider Task |
| A49 | Edit Provider Task |
| A50 | Accept Provider Task |
| A51 | Reject Provider Task |
| A52 | Update Provider Task Progress |
| A53 | Mark Provider Task as Completed |
| A54 | Update Delivery Status |
| A55 | Mark as Delivered |
| A56 | Confirm Customer Received Order |
| A57 | Lock Provider Task |

---

### 2.7 Quality Check Actions

| STT | Action Permission |
|---:|---|
| A58 | Submit Quality Check Result |
| A59 | Approve Quality Check |
| A60 | Reject Quality Check |
| A61 | Request Provider Rework |

---

### 2.8 Payment Actions

| STT | Action Permission |
|---:|---|
| A62 | Create Customer Payment Request |
| A63 | Confirm Customer Payment |
| A64 | Reject Customer Payment |
| A65 | Create Provider Payment Request |
| A66 | Approve Provider Payment |
| A67 | Reject Provider Payment |
| A68 | Mark Provider Payment as Paid |

---

### 2.9 Invoice Actions

| STT | Action Permission |
|---:|---|
| A69 | Generate Customer Invoice |
| A70 | Export Customer Invoice |
| A71 | Cancel Customer Invoice |
| A72 | Generate Provider Invoice |
| A73 | Export Provider Invoice |
| A74 | Cancel Provider Invoice |

---

### 2.10 System / Common Actions

| STT | Action Permission |
|---:|---|
| A75 | Export Report |
| A76 | Export Excel |
| A77 | Export PDF |
| A78 | View History |
| A79 | Upload Attachment |
| A80 | Download Attachment |

---

## 3. Bảng Screen Permission

> Ký hiệu:
> - `✓`: Có quyền truy cập màn hình
> - `-`: Không có quyền truy cập

| Screen | Admin | Manager | Sale | Provider | Customer |
|---|:---:|:---:|:---:|:---:|:---:|
| Dashboard | ✓ | ✓ | ✓ | ✓ | ✓ |
| Business Report | ✓ | ✓ | - | - | - |
| Revenue Report | ✓ | ✓ | - | - | - |
| Cost Report | ✓ | ✓ | - | - | - |
| Profit Report | ✓ | ✓ | - | - | - |
| Sales Performance Report | ✓ | ✓ | ✓ | - | - |
| Provider Performance Report | ✓ | ✓ | - | - | - |
| User List | ✓ | ✓ | - | - | - |
| User Detail | ✓ | ✓ | - | - | - |
| Create User | ✓ | - | - | - | - |
| Edit User | ✓ | - | - | - | - |
| Role List | ✓ | - | - | - | - |
| Role Detail | ✓ | - | - | - | - |
| Create Role | ✓ | - | - | - | - |
| Edit Role | ✓ | - | - | - | - |
| Edit Role Permissions | ✓ | - | - | - | - |
| Customer List | ✓ | ✓ | ✓ | - | - |
| Customer Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Customer | ✓ | ✓ | ✓ | - | - |
| Edit Customer | ✓ | ✓ | ✓ | - | ✓ |
| Provider List | ✓ | ✓ | ✓ | - | - |
| Provider Detail | ✓ | ✓ | ✓ | ✓ | - |
| Create Provider | ✓ | ✓ | - | - | - |
| Edit Provider | ✓ | ✓ | - | ✓ | - |
| Provider Category Management | ✓ | ✓ | - | - | - |
| Provider Review List | ✓ | ✓ | - | ✓ | - |
| Provider Review Detail | ✓ | ✓ | - | ✓ | - |
| Product / Service List | ✓ | ✓ | ✓ | - | ✓ |
| Product / Service Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Product / Service | ✓ | ✓ | - | - | - |
| Edit Product / Service | ✓ | ✓ | - | - | - |
| Category List | ✓ | ✓ | ✓ | - | ✓ |
| Category Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Category | ✓ | ✓ | - | - | - |
| Edit Category | ✓ | ✓ | - | - | - |
| Product Price History | ✓ | ✓ | ✓ | - | - |
| Customer Order List | ✓ | ✓ | ✓ | - | ✓ |
| Customer Order Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Customer Order | ✓ | ✓ | ✓ | - | ✓ |
| Edit Customer Order | ✓ | ✓ | ✓ | - | ✓ |
| Customer Order Status History | ✓ | ✓ | ✓ | - | ✓ |
| Provider Order List | ✓ | ✓ | - | ✓ | - |
| Provider Order Detail | ✓ | ✓ | - | ✓ | - |
| Create Provider Order | ✓ | ✓ | - | - | - |
| Edit Provider Order | ✓ | ✓ | - | - | - |
| Provider Order Status History | ✓ | ✓ | - | ✓ | - |
| Quotation List | ✓ | ✓ | ✓ | - | ✓ |
| Quotation Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Quotation | ✓ | ✓ | ✓ | - | - |
| Edit Quotation | ✓ | ✓ | ✓ | - | - |
| Negotiation History | ✓ | ✓ | ✓ | - | ✓ |
| Customer Contract List | ✓ | ✓ | ✓ | - | ✓ |
| Customer Contract Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Customer Contract | ✓ | ✓ | - | - | - |
| Edit Customer Contract | ✓ | ✓ | ✓ | - | - |
| Customer Contract Template | ✓ | ✓ | - | - | - |
| Customer Contract Version History | ✓ | ✓ | ✓ | - | ✓ |
| Customer Contract Status History | ✓ | ✓ | ✓ | - | ✓ |
| Provider Contract List | ✓ | ✓ | - | ✓ | - |
| Provider Contract Detail | ✓ | ✓ | - | ✓ | - |
| Create Provider Contract | ✓ | ✓ | - | - | - |
| Edit Provider Contract | ✓ | ✓ | - | - | - |
| Provider Contract Template | ✓ | ✓ | - | - | - |
| Provider Contract Version History | ✓ | ✓ | - | ✓ | - |
| Provider Contract Status History | ✓ | ✓ | - | ✓ | - |
| Provider Task List | ✓ | ✓ | - | ✓ | - |
| Provider Task Detail | ✓ | ✓ | - | ✓ | - |
| Provider Task Progress History | ✓ | ✓ | - | ✓ | - |
| Delivery Status Tracking | ✓ | ✓ | - | ✓ | ✓ |
| Quality Check List | ✓ | ✓ | - | ✓ | - |
| Quality Check Detail | ✓ | ✓ | - | ✓ | - |
| Create Quality Check | ✓ | ✓ | - | - | - |
| Edit Quality Check | ✓ | ✓ | - | - | - |
| Customer Payment List | ✓ | ✓ | ✓ | - | ✓ |
| Customer Payment Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Customer Payment Request | ✓ | ✓ | ✓ | - | - |
| Customer Payment History | ✓ | ✓ | ✓ | - | ✓ |
| Provider Payment List | ✓ | ✓ | - | ✓ | - |
| Provider Payment Detail | ✓ | ✓ | - | ✓ | - |
| Create Provider Payment Request | ✓ | ✓ | - | - | - |
| Provider Payment History | ✓ | ✓ | - | ✓ | - |
| Customer Invoice List | ✓ | ✓ | ✓ | - | ✓ |
| Customer Invoice Detail | ✓ | ✓ | ✓ | - | ✓ |
| Create Customer Invoice | ✓ | ✓ | - | - | - |
| Provider Invoice List | ✓ | ✓ | - | ✓ | - |
| Provider Invoice Detail | ✓ | ✓ | - | ✓ | - |
| Create Provider Invoice | ✓ | ✓ | - | - | - |

---

## 4. Bảng Action Permission

> Ký hiệu:
> - `✓`: Có quyền thực hiện action
> - `-`: Không có quyền thực hiện action

| Action Permission | Admin | Manager | Sale | Provider | Customer |
|---|:---:|:---:|:---:|:---:|:---:|
| Submit Customer Order for Approval | ✓ | ✓ | ✓ | - | - |
| Approve Customer Order | ✓ | ✓ | - | - | - |
| Reject Customer Order | ✓ | ✓ | - | - | - |
| Send Customer Order Quotation | ✓ | ✓ | ✓ | - | - |
| Mark Customer Order as Negotiating | ✓ | ✓ | ✓ | - | - |
| Accept Customer Order | ✓ | ✓ | ✓ | - | ✓ |
| Cancel Customer Order | ✓ | ✓ | ✓ | - | ✓ |
| Expire Customer Order | ✓ | ✓ | - | - | - |
| Create Customer Contract from Customer Order | ✓ | ✓ | - | - | - |
| Submit Provider Order for Approval | ✓ | ✓ | - | - | - |
| Approve Provider Order | ✓ | ✓ | - | - | - |
| Reject Provider Order | ✓ | ✓ | - | - | - |
| Send Provider Order to Provider | ✓ | ✓ | - | - | - |
| Mark Provider Order as Negotiating | ✓ | ✓ | - | ✓ | - |
| Accept Provider Order | ✓ | ✓ | - | ✓ | - |
| Reject Provider Order by Provider | - | - | - | ✓ | - |
| Cancel Provider Order | ✓ | ✓ | - | - | - |
| Expire Provider Order | ✓ | ✓ | - | - | - |
| Create Provider Contract from Provider Order | ✓ | ✓ | - | - | - |
| Send Quotation | ✓ | ✓ | ✓ | - | - |
| Revise Quotation | ✓ | ✓ | ✓ | - | - |
| Accept Quotation | ✓ | ✓ | - | - | ✓ |
| Reject Quotation | - | - | - | - | ✓ |
| Add Negotiation Note | ✓ | ✓ | ✓ | - | - |
| Submit Customer Contract for Approval | ✓ | ✓ | ✓ | - | - |
| Approve Customer Contract | ✓ | ✓ | - | - | - |
| Reject Customer Contract | ✓ | ✓ | - | - | - |
| Send Customer Contract for Signature | ✓ | ✓ | ✓ | - | - |
| Sign Customer Contract | - | - | - | - | ✓ |
| Decline Customer Contract | - | - | - | - | ✓ |
| Cancel Customer Contract | ✓ | ✓ | - | - | - |
| Create Customer Contract Version | ✓ | ✓ | ✓ | - | - |
| Add Customer Contract Reject Note | ✓ | ✓ | - | - | - |
| Move Customer Contract to In Execution | ✓ | ✓ | - | - | - |
| Complete Customer Contract | ✓ | ✓ | - | - | - |
| Submit Provider Contract for Approval | ✓ | ✓ | - | - | - |
| Approve Provider Contract | ✓ | ✓ | - | - | - |
| Reject Provider Contract | ✓ | ✓ | - | - | - |
| Send Provider Contract for Signature | ✓ | ✓ | - | - | - |
| Sign / Accept Provider Contract | - | - | - | ✓ | - |
| Decline Provider Contract | - | - | - | ✓ | - |
| Cancel Provider Contract | ✓ | ✓ | - | - | - |
| Create Provider Contract Version | ✓ | ✓ | - | - | - |
| Add Provider Contract Reject Note | ✓ | ✓ | - | - | - |
| Assign Provider Contract | ✓ | ✓ | - | - | - |
| Move Provider Contract to In Progress | ✓ | ✓ | - | ✓ | - |
| Complete Provider Contract | ✓ | ✓ | - | ✓ | - |
| Assign Provider Task | ✓ | ✓ | - | - | - |
| Edit Provider Task | ✓ | ✓ | - | - | - |
| Accept Provider Task | - | - | - | ✓ | - |
| Reject Provider Task | - | - | - | ✓ | - |
| Update Provider Task Progress | - | - | - | ✓ | - |
| Mark Provider Task as Completed | - | - | - | ✓ | - |
| Update Delivery Status | ✓ | ✓ | - | ✓ | - |
| Mark as Delivered | - | - | - | ✓ | - |
| Confirm Customer Received Order | - | - | - | - | ✓ |
| Lock Provider Task | ✓ | ✓ | - | - | - |
| Submit Quality Check Result | ✓ | ✓ | - | - | - |
| Approve Quality Check | ✓ | ✓ | - | - | - |
| Reject Quality Check | ✓ | ✓ | - | - | - |
| Request Provider Rework | ✓ | ✓ | - | - | - |
| Create Customer Payment Request | ✓ | ✓ | ✓ | - | - |
| Confirm Customer Payment | ✓ | ✓ | - | - | - |
| Reject Customer Payment | ✓ | ✓ | - | - | - |
| Create Provider Payment Request | ✓ | ✓ | - | - | - |
| Approve Provider Payment | ✓ | ✓ | - | - | - |
| Reject Provider Payment | ✓ | ✓ | - | - | - |
| Mark Provider Payment as Paid | ✓ | ✓ | - | - | - |
| Generate Customer Invoice | ✓ | ✓ | - | - | - |
| Export Customer Invoice | ✓ | ✓ | ✓ | - | ✓ |
| Cancel Customer Invoice | ✓ | ✓ | - | - | - |
| Generate Provider Invoice | ✓ | ✓ | - | - | - |
| Export Provider Invoice | ✓ | ✓ | - | ✓ | - |
| Cancel Provider Invoice | ✓ | ✓ | - | - | - |
| Export Report | ✓ | ✓ | ✓ | - | - |
| Export Excel | ✓ | ✓ | ✓ | - | - |
| Export PDF | ✓ | ✓ | ✓ | - | - |
| View History | ✓ | ✓ | ✓ | ✓ | ✓ |
| Upload Attachment | ✓ | ✓ | ✓ | ✓ | ✓ |
| Download Attachment | ✓ | ✓ | ✓ | ✓ | ✓ |

---

## 5. Ghi chú thiết kế

### 5.1 Không tách action thành screen riêng

Các thao tác như:

- Approve / Reject
- Cancel
- Export
- Confirm Payment
- Accept / Reject Task
- Update Progress
- Mark as Completed

nên là **button/action** trong màn hình List hoặc Detail, không nên đưa vào danh sách screen.

Ví dụ:

```text
Customer Invoice Detail
├── Export Invoice
└── Cancel Invoice
```

```text
Provider Task Detail
├── Accept Task
├── Reject Task
├── Update Progress
└── Mark as Completed
```

---

### 5.2 Các màn hình cần ưu tiên cho Iteration 1

Nếu cần làm trước MVP, nên ưu tiên:

| Module | Screen cần làm trước |
|---|---|
| User & Role | User List, User Detail, Create User, Edit User, Role List |
| Customer | Customer List, Customer Detail, Create Customer, Edit Customer |
| Provider | Provider List, Provider Detail, Create Provider, Edit Provider |
| Product / Service | Product List, Product Detail, Create Product, Edit Product |
| Customer Order | Customer Order List, Customer Order Detail, Create Customer Order |
| Provider Order | Provider Order List, Provider Order Detail, Create Provider Order |
| Customer Contract | Customer Contract List, Customer Contract Detail |
| Provider Contract | Provider Contract List, Provider Contract Detail |
| Payment | Customer Payment List, Provider Payment List |
| Report | Dashboard, Revenue Report, Profit Report |

---

### 5.3 Business rule quan trọng cần nhớ khi code permission

| Rule | Ý nghĩa |
|---|---|
| BR01 | Customer Order phải Accepted trước khi tạo Customer Contract |
| BR02 | Customer Contract phải Approved trước khi tạo Provider Order |
| BR03 | Provider Order phải Accepted trước khi tạo Provider Contract |
| BR04 | Một Customer Contract có thể có nhiều Provider Contract |
| BR05 | Provider chỉ thấy contract/task của chính mình |
| BR06 | Completed contract không được sửa giá trị tiền |
| BR07 | Mọi thay đổi workflow phải lưu history |
| BR08 | Provider Contract phải gắn với Customer Contract |
| BR09 | Không được thanh toán provider nếu task chưa completed |
| BR10 | Nếu Customer Contract chưa được ký thì không được triển khai provider workflow |
| BR11 | Nếu Provider từ chối contract thì task phải bị khóa |
| BR12 | Hệ thống phải lưu lý do từ chối của customer/provider |
| BR13 | Mỗi lần sửa contract phải tạo version mới |
| BR14 | Provider phải cập nhật trạng thái delivery của đơn hàng lên hệ thống |
| BR15 | Manager phải kiểm tra chất lượng sản phẩm trước khi provider giao hàng cho customer |
| BR16 | Provider chỉ được chuyển trạng thái Delivered khi customer đã xác nhận nhận hàng |

---

## 6. Sidebar đề xuất

```text
Dashboard
├── Dashboard
├── Business Report
├── Revenue Report
├── Cost Report
├── Profit Report
├── Sales Performance Report
└── Provider Performance Report

System Management
├── Users
├── Roles
└── Role Permissions

Customer Management
└── Customers

Provider Management
├── Providers
├── Provider Categories
└── Provider Reviews

Product Management
├── Products / Services
├── Categories
└── Product Price History

Sales Management
├── Customer Orders
├── Quotations
└── Negotiation History

Provider Coordination
├── Provider Orders
├── Provider Tasks
└── Delivery Status Tracking

Contract Management
├── Customer Contracts
├── Provider Contracts
├── Contract Templates
├── Contract Version History
└── Contract Status History

Quality Management
└── Quality Checks

Payment Management
├── Customer Payments
└── Provider Payments

Invoice Management
├── Customer Invoices
└── Provider Invoices
```

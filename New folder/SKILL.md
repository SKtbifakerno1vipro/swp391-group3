---
name: srs-usecase-formatter
description: Tự động format raw text Use Case thành bảng Markdown chuẩn SRS, đồng thời tự động cấp số và map mã Business Rules (BR-xx) và System Messages (MSG-xx) từ file trung tâm.
---

# Mục đích
Skill này giúp tự động hóa quá trình viết tài liệu SRS, chuyển đổi text thô của Use Case thành bảng chuẩn, đồng thời đồng bộ mã BR/MSG vào một file chung.

# Trigger
Khi user gửi text Use Case thô hoặc yêu cầu "format use case", "chuẩn hóa use case".

# Workflow Bắt Buộc

1. **Đọc State:**
   - Đọc file `docs/business_rules.md` (hoặc tên file user chỉ định) để lấy danh sách BR và MSG hiện có. Tìm max ID (`BR-xx`, `MSG-xx`).
   - *Nếu chưa có file, tự động khởi tạo.*

2. **Trích xuất & Map ID:**
   - Parse text Use Case user gửi.
   - So khớp Exceptions và Business Rules cũ (ví dụ: `EM-xxx`, `BR-xxx`).
   - Tái sử dụng `MSG-xx`/`BR-xx` nếu nội dung trùng lặp.
   - Cấp số ID tiếp theo nếu nội dung mới.

3. **Cập nhật State:**
   - Dùng tool chỉnh sửa file để thêm (append) các BR và MSG mới vào `docs/business_rules.md`.

4. **Generate Output:**
   - Trả cho user Bảng Use Case chuẩn bằng Markdown (Attribute | Description).
   - Nội dung Exceptions và Business Rules trong bảng phải dùng mã chuẩn (`MSG-xx`, `BR-xx`).

# Style Guide
- Giữ văn phong Terse. Không giải thích dông dài.
- Định dạng in đậm các key chính trong bảng (`**Use Case Name**`, `**Normal Sequence**`...).

package utils;

public class Validation {

    public static String validateInputSearch(String str, int max) {
        if (str == null || str.isBlank()) {
            return null; // cho phép bỏ trống
        }
        if (str.length() > max) {
            return "Must be at most " + max + " characters long";
        }
        return null;
    }
    public static String validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return "Email không được để trống!";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Email format invalid";
        }
        return null; // OK
    }

    public static String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return "Not be empty";
        }
        if (!phone.matches("^\\d{10}$")) {
            return "Phone requires exactly 10 digits";
        }
        return null; // OK
    }

    public static String validatePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "Password cannot be empty!";
        }
        if (password.length() < 4) {
            return "Password must have at least 4 characters!";
        }
        return null; // OK
    }

    public static String validateEmpty(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            return fieldName + " Not be empty";
        }
        return null; // OK
    }

    public static String validateUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return "Username không được để trống!";
        }
        String trimmedUsername = username.trim();

        if (trimmedUsername.length() > 15) {
            return "Username chỉ được phép tối đa 15 kí tự!";
        }

        if (!trimmedUsername.matches("^[a-zA-Z0-9_]+$")) {
            return "Username chỉ được chứa chữ không dấu, số và dấu gạch dưới!";
        }

        return null; // OK - Hợp lệ
    }

    public static String validateFullName(String fullName) {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full Name không được để trống!";
        }
        String trimmed = fullName.trim();
        if (trimmed.length() > 50) {
            return "Full Name tối đa chỉ được 50 kí tự!";
        }
        // Chap nhan chu tieng Viet co dau, khoang trang. Khong chua so hay ky tu đac biet.
        if (trimmed.matches(".*[0-9].*") || trimmed.matches(".*[^a-zA-ZÀ-ỹ\\s].*")) {
            return "Full Name không được chứa số hoặc kí tự đặc biệt!";
        }
        return null; // Hợp lệ
    }

    // 2. Kiem tra Validate cho Tax Code (Ma so thue)
    public static String validateTaxCode(String taxCode) {
        if (taxCode == null || taxCode.trim().isEmpty()) {
            return "Tax Code không được để trống!";
        }
        String trimmed = taxCode.trim();
        // Ma so thue VN chuan co 2 loai: 10 so (ma doanh nghiep) hoac 13 so (ma chi nhanh dang xxxxxxxxxx-xxx)
        if (!trimmed.matches("^\\d{10}$") && !trimmed.matches("^\\d{10}-\\d{3}$")) {
            return "Tax Code không đúng định dạng (Phải gồm 10 số hoặc 13 số có dạng XXXXXXXXXX-XXX)!";
        }
        return null; // Hợp lệ
    }

    // 3. Kiem tra Validate cho Company Name
    public static String validateCompanyName(String companyName) {
        if (companyName == null || companyName.trim().isEmpty()) {
            return "Company Name không được để trống!";
        }
        String trimmed = companyName.trim();
        if (trimmed.length() > 200) {
            return "Company Name tối đa chỉ được 200 kí tự!";
        }
        return null; // Hợp lệ
    }

    public static String validateQuantity(String quantity) {
        quantity = quantity.trim();
        if (quantity == null || quantity.isEmpty()) {
            return "Quantity must not be empty!";
        }
        try {
            int q = Integer.parseInt(quantity);
            if (q < 0) {
                return "Quantity must be greater than or equal to zero";
            } if (q > Integer.MAX_VALUE) {
                return "Quantity exceeds the permitted limit";
            }
        } catch (NumberFormatException e) {
            return "Quantity must be integer";
        }
        return null;
    }
    
    public static String validatePrice(String price) {
        price = price.trim();
        if (price == null || price.isEmpty()) {
            return "Price must not be empty!";
        }
        try {
            double p = Double.parseDouble(price);
            if (p < 0) {
                return "Price must be greater than or equal to zero";
            } if (p > Double.MAX_VALUE) {
                return "Price exceeds the permitted limit";
            }
        } catch (NumberFormatException e) {
            return "Price must be a valid number";
        }
        return null;
    }

    public static String validateProductName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "Tên sản phẩm không được để trống!";
        }
        String trimmed = name.trim();
        if (trimmed.length() > 255) {
            return "Tên sản phẩm tối đa chỉ được 255 kí tự!";
        }
        return null;
    }

    public static String validateProductUnit(String unit) {
        if (unit == null || unit.trim().isEmpty()) {
            return "Đơn vị tính không được để trống!";
        }
        String trimmed = unit.trim();
        if (trimmed.length() > 50) {
            return "Đơn vị tính tối đa chỉ được 50 kí tự!";
        }
        return null;
    }

    public static String validateCostAndSellingPrice(String costPriceStr, String sellingPriceStr) {
        String validateCost = validatePrice(costPriceStr);
        if (validateCost != null) {
            return "Giá gốc: " + validateCost;
        }
        String validateSelling = validatePrice(sellingPriceStr);
        if (validateSelling != null) {
            return "Giá bán: " + validateSelling;
        }

        try {
            double cost = Double.parseDouble(costPriceStr.trim());
            double selling = Double.parseDouble(sellingPriceStr.trim());
            if (selling < cost) {
                return "Giá bán phải lớn hơn hoặc bằng giá gốc sản phẩm!";
            }
        } catch (NumberFormatException e) {
            return "Định dạng giá gốc hoặc giá bán không hợp lệ!";
        }
        return null;
    }

    public static String validateAddress(String address) {
        if (address == null || address.isBlank()) {
            return null; // cho phép bỏ trống
        }
        if (address.trim().length() > 255) {
            return "Địa chỉ tối đa chỉ được 255 kí tự!";
        }
        return null;
    }

    public static String validateGender(String gender) {
        if (gender == null || gender.isBlank()) {
            return null; // cho phép bỏ trống
        }
        String g = gender.trim().toUpperCase();
        if (!g.equals("M") && !g.equals("F") && !g.equals("O")) {
            return "Giới tính không hợp lệ (Phải là M, F hoặc O)!";
        }
        return null;
    }

    public static String validateDateBirth(String dateStr) {
        if (dateStr == null || dateStr.isBlank()) {
            return null; // cho phép bỏ trống
        }
        try {
            java.time.LocalDate birthDate = java.time.LocalDate.parse(dateStr.trim());
            if (birthDate.isAfter(java.time.LocalDate.now())) {
                return "Ngày sinh không được lớn hơn ngày hiện tại!";
            }
        } catch (java.time.format.DateTimeParseException e) {
            return "Định dạng ngày sinh không hợp lệ!";
        }
        return null;
    }
}

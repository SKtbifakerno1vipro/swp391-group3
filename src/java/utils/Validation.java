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
            return "Price must be integer";
        }
        return null;
    }
}

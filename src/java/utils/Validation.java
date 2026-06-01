package utils;

public class Validation {

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
        
        // Cắt khoảng trắng thừa ở 2 đầu trước khi kiểm tra length
        String trimmedUsername = username.trim();
        
        if (trimmedUsername.length() > 15) {
            return "Username chỉ được phép tối đa 15 kí tự!";
        }
        // ^[a-zA-Z0-9_]+$ : Chỉ chấp nhận chữ cái không dấu, số, và dấu gạch dưới. 
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
        // Chấp nhận chữ tiếng Việt có dấu, khoảng trắng. Không chứa số hay ký tự đặc biệt.
        if (trimmed.matches(".*[0-9].*") || trimmed.matches(".*[^a-zA-ZÀ-ỹ\\s].*")) {
            return "Full Name không được chứa số hoặc kí tự đặc biệt!";
        }
        return null; // Hợp lệ
    }

    // 2. Kiểm tra Validate cho Tax Code (Mã số thuế)
    public static String validateTaxCode(String taxCode) {
        if (taxCode == null || taxCode.trim().isEmpty()) {
            return "Tax Code không được để trống!";
        }
        String trimmed = taxCode.trim();
        // Mã số thuế VN chuẩn có 2 loại: 10 số (mã doanh nghiệp) hoặc 13 số (mã chi nhánh dạng xxxxxxxxxx-xxx)
        if (!trimmed.matches("^\\d{10}$") && !trimmed.matches("^\\d{10}-\\d{3}$")) {
            return "Tax Code không đúng định dạng (Phải gồm 10 số hoặc 13 số có dạng XXXXXXXXXX-XXX)!";
        }
        return null; // Hợp lệ
    }

    // 3. Kiểm tra Validate cho Company Name
    public static String validateCompanyName(String companyName) {
        if (companyName == null || companyName.trim().isEmpty()) {
            return "Company Name không được để trống!";
        }
        String trimmed = companyName.trim();
        if (trimmed.length() > 100) {
            return "Company Name tối đa chỉ được 100 kí tự!";
        }
        return null; // Hợp lệ
    }
}

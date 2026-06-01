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
//        return null; // OK
//    }

    public static String validateEmpty(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            return fieldName + " Not be empty";
        }
        return null; // OK
    }
}

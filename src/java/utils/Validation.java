package utils;

public class Validation {


    public  String validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return "Email không được để trống!";
        }
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Email fomart invalid";
        }
        return null; // OK
    }

    public  String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return "Not be empty";
        }
        if (!phone.matches("^\\d{10}$")) {
            return "Phone  require exectly 10 numbers";
        }
        return null; // OK
    }

//    public  String validatePassword(String password) {
//        if (password == null || password.length() < 6) {
//            return "Mật khẩu phải có tối thiểu 6 ký tự!";
//        }
//        return null; // OK
//    }

    public  String validateEmpty(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            return fieldName + " Not be empty";
        }
        return null; // OK
    }
}

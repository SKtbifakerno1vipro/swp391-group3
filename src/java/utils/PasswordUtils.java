package utils;

import java.security.SecureRandom;

public class PasswordUtils {

    // Chuoi ky tu dung đe sinh mat khau ngau nhien
    private static final String ALPHA_NUMERIC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                                              + "abcdefghijklmnopqrstuvwxyz"
                                              + "0123456789";
    
    // Su dung SecureRandom thay vi Random thong thuong đe tang tinh bao mat ma hoa
    private static final SecureRandom random = new SecureRandom();

    public static String generateRandomText() {
        StringBuilder sb = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            int randomIndex = random.nextInt(ALPHA_NUMERIC.length());
            char randomChar = ALPHA_NUMERIC.charAt(randomIndex);
            sb.append(randomChar);
        }
        
        System.out.println("[INFO] Generated raw random text successfully.");
        return sb.toString();
    }
}
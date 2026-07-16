package service;

import dal.SignatureDAO;
import model.Signature;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.List;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;

public class SignatureService {

    private SignatureDAO signatureDAO = new SignatureDAO();

    public boolean insertSignature(Signature signature) {
        return signatureDAO.insertSignature(signature);
    }

    public List<Signature> getAllSignature() {
        return signatureDAO.getAllSignature();
    }

    public Signature getSignatureById(int id) {
        return signatureDAO.getSignatureById(id);
    }

    public Signature getSignatureByContractIdAndSignerId(int contractId, int signerUserId) {
        return signatureDAO.getSignatureByContractIdAndSignerId(contractId, signerUserId);
    }

    public String standardFileName(String value) {
        if (value == null) {
            return "signature_";
        }
        String result = value.trim().replaceAll("[\\s+]", "_");
        result = result.replaceAll("[\\\\/:*?\"<>|]", "");

        return result;
    }
    
    public List<Signature> getSignaturesByContractId(int contractId) {
        return signatureDAO.getSignaturesByContractId(contractId);
    }

    public String storeSignature(String data, File parentFile, String nameFile) {
        try {
            if (data == null || !data.contains(",")) {
                return "Dữ liệu chữ ký không đúng định dạng Base64.";
            }

            String base64 = data.split(",")[1].replace(" ", "+");
            byte[] bytes;
            try {
                bytes = Base64.getDecoder().decode(base64);
            } catch (IllegalArgumentException e) {
                return "Không thể giải mã chuỗi Base64: " + e.getMessage();
            }

            long maxSizeBytes = 1024 * 1024; // 1 MB
            if (bytes.length > maxSizeBytes) {
                return "Dung lượng chữ ký vượt quá giới hạn cho phép (1MB).";
            }

            File fileA = new File(parentFile, nameFile);
            String parentPath = parentFile.getCanonicalPath();
            String filePath = fileA.getCanonicalPath();
            if (!filePath.startsWith(parentPath)) {
                return "Phát hiện hành vi Directory Traversal nguy hiểm!";
            }

            if (!isValidImageBytes(bytes)) {
                return "Tệp tải lên không phải là định dạng ảnh hợp lệ (chỉ chấp nhận PNG/JPG).";
            }

            try (FileOutputStream newFile = new FileOutputStream(fileA)) {
                newFile.write(bytes);
                newFile.flush();
            }
            return "SUCCESS";
        } catch (Exception e) {
            return "Lỗi hệ thống khi lưu chữ ký: " + e.getMessage();
        }
    }

    private boolean isValidImageBytes(byte[] bytes) {
        if (bytes == null || bytes.length < 8) {
            return false;
        }

        boolean isPng = (bytes[0] & 0xFF) == 0x89 &&
                        (bytes[1] & 0xFF) == 0x50 &&
                        (bytes[2] & 0xFF) == 0x4E &&
                        (bytes[3] & 0xFF) == 0x47 &&
                        (bytes[4] & 0xFF) == 0x0D &&
                        (bytes[5] & 0xFF) == 0x0A &&
                        (bytes[6] & 0xFF) == 0x1A &&
                        (bytes[7] & 0xFF) == 0x0A;

        boolean isJpeg = (bytes[0] & 0xFF) == 0xFF &&
                         (bytes[1] & 0xFF) == 0xD8 &&
                         (bytes[2] & 0xFF) == 0xFF;

        if (!isPng && !isJpeg) {
            return false;
        }

        try (ByteArrayInputStream bais = new ByteArrayInputStream(bytes)) {
            BufferedImage image = ImageIO.read(bais);
            return image != null;
        } catch (IOException e) {
            return false;
        }
    }
}

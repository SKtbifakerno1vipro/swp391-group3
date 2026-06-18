package service;

import dal.SignatureDAO;
import model.Signature;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.List;

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

    public Signature getLatestSignatureBySigner(String signerName) {
        return signatureDAO.getLatestSignatureBySigner(signerName);
    }

    public Signature getSignatureByContractIdAndSignerId(int contractId, int signerUserId) {
        return signatureDAO.getSignatureByContractIdAndSignerId(contractId, signerUserId);
    }
    
    public String editFileName(String value){
        String split[] = value.split("\\s+");
        String result = "";
        for (String string : split) {
            result+=string;
        }
        return result;
    }

    // Logic cũ
    public void storeSignature(String data, File parentFile, String nameFile) throws IOException {
        String base64 = data.split(",")[1].replace(" ", "+");
        byte[] bytes = Base64.getDecoder().decode(base64);
        
        File fileA = new File(parentFile, nameFile);
        
        try (FileOutputStream newFile = new FileOutputStream(fileA)) {
            newFile.write(bytes);
            newFile.close();
        }
    }
}

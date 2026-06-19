package service;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Base64;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author ADMIN
 */
public class SignatureService {
    public void storeSignature(String file, File parentFile, String customer) throws IOException{
           String base64 = file.split(",")[1].replace(" ", "+");
            byte[] bytes = Base64.getDecoder().decode(base64);
            
            File fileA = new File(parentFile,customer);
            
            try (FileOutputStream newFile = new FileOutputStream(fileA)){
                newFile.write(bytes);
            } 
            
    }
}

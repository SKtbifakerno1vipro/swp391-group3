package dal;


import model.Signature;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SignatureDAO extends DBContext {

    public boolean insertSignature(Signature signature) {
        String sql = "INSERT INTO signature (file_name, file_url, signer_name, signed_at) VALUES (?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, signature.getFileName());
            st.setString(2, signature.getFileUrl());
            st.setString(3, signature.getSignerName());
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Signature> getAllSignature() {
        List<Signature> list = new ArrayList<>();
        String sql = "SELECT signature_id, file_name, file_url, signer_name, signed_at, uploaded_at FROM signature";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Signature getSignatureById(int id) {
        String sql = "SELECT signature_id, file_name, file_url, signer_name, signed_at, uploaded_at FROM signature WHERE signature_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Signature getLatestSignatureBySigner(String signerName) {
        String sql = "SELECT TOP 1 signature_id, file_name, file_url, signer_name, signed_at, uploaded_at FROM signature WHERE signer_name = ? ORDER BY signature_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, signerName);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

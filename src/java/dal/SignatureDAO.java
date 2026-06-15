package dal;

import model.Signature;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class SignatureDAO extends DBContext {

    public boolean insertSignature(Signature signature) {
        String sql = "INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, signature.getCustomerContractId());
            st.setString(2, signature.getFileName());
            st.setString(3, signature.getFileUrl());
            
            if (signature.getSignerUserId() != null) {
                st.setInt(4, signature.getSignerUserId());
            } else {
                st.setNull(4, Types.INTEGER);
            }
            
            st.setString(5, signature.getSignerName());
            st.setTimestamp(6, signature.getSignedAt());
            
            if (signature.getUploadedBy() != null) {
                st.setInt(7, signature.getUploadedBy());
            } else {
                st.setNull(7, Types.INTEGER);
            }
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Signature> getAllSignature() {
        List<Signature> list = new ArrayList<>();
        String sql = "SELECT signature_id, customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setCustomerContractId(rs.getInt("customer_contract_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                
                int signerUserId = rs.getInt("signer_user_id");
                if (!rs.wasNull()) {
                    s.setSignerUserId(signerUserId);
                }
                
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                
                int uploadedBy = rs.getInt("uploaded_by");
                if (!rs.wasNull()) {
                    s.setUploadedBy(uploadedBy);
                }
                
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Signature getSignatureById(int id) {
        String sql = "SELECT signature_id, customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature WHERE signature_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setCustomerContractId(rs.getInt("customer_contract_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                
                int signerUserId = rs.getInt("signer_user_id");
                if (!rs.wasNull()) {
                    s.setSignerUserId(signerUserId);
                }
                
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                
                int uploadedBy = rs.getInt("uploaded_by");
                if (!rs.wasNull()) {
                    s.setUploadedBy(uploadedBy);
                }
                
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Signature getLatestSignatureBySigner(String signerName) {
        String sql = "SELECT TOP 1 signature_id, customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature WHERE signer_name = ? ORDER BY signature_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, signerName);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setCustomerContractId(rs.getInt("customer_contract_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                
                int signerUserId = rs.getInt("signer_user_id");
                if (!rs.wasNull()) {
                    s.setSignerUserId(signerUserId);
                }
                
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                
                int uploadedBy = rs.getInt("uploaded_by");
                if (!rs.wasNull()) {
                    s.setUploadedBy(uploadedBy);
                }
                
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Signature getSignatureByContractId(int contractId) {
        List<Signature> list = new ArrayList<>();
        String sql = "SELECT TOP 2 signature_id, customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature WHERE customer_contract_id = ? ORDER BY uploaded_at DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, contractId);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setCustomerContractId(rs.getInt("customer_contract_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                
                int signerUserId = rs.getInt("signer_user_id");
                if (!rs.wasNull()) {
                    s.setSignerUserId(signerUserId);
                }
                
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                
                int uploadedBy = rs.getInt("uploaded_by");
                if (!rs.wasNull()) {
                    s.setUploadedBy(uploadedBy);
                }
                
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Signature getSignatureByContractIdAndSignerId(int contractId, int signerUserId) {
        String sql = "SELECT TOP 1 signature_id, customer_contract_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature WHERE customer_contract_id = ? AND signer_user_id = ? ORDER BY uploaded_at DESC, signature_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, contractId);
            st.setInt(2, signerUserId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Signature s = new Signature();
                s.setId(rs.getInt("signature_id"));
                s.setCustomerContractId(rs.getInt("customer_contract_id"));
                s.setFileName(rs.getString("file_name"));
                s.setFileUrl(rs.getString("file_url"));
                
                int dbSignerUserId = rs.getInt("signer_user_id");
                if (!rs.wasNull()) {
                    s.setSignerUserId(dbSignerUserId);
                }
                
                s.setSignerName(rs.getString("signer_name"));
                s.setSignedAt(rs.getTimestamp("signed_at"));
                
                int uploadedBy = rs.getInt("uploaded_by");
                if (!rs.wasNull()) {
                    s.setUploadedBy(uploadedBy);
                }
                
                s.setUploadedAt(rs.getTimestamp("uploaded_at"));
                return s;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

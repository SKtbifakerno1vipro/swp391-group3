package dal;

import model.Signature;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;

public class SignatureDAO extends DBContext {

    public boolean insertSignature(Signature signature) {
        String sql = "INSERT INTO signature (customer_contract_id, invoice_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?, GETDATE())";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            if (signature.getCustomerContractId() > 0) {
                st.setInt(1, signature.getCustomerContractId());
            } else {
                st.setNull(1, Types.INTEGER);
            }
            if (signature.getInvoiceId() != null) {
                st.setInt(2, signature.getInvoiceId());
            } else {
                st.setNull(2, Types.INTEGER);
            }
            st.setString(3, signature.getFileName());
            st.setString(4, signature.getFileUrl());
            st.setObject(5, signature.getSignerUserId(), Types.INTEGER);
            st.setString(6, signature.getSignerName());
            st.setObject(7, signature.getUploadedBy(), Types.INTEGER);

            return st.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Signature> getAllSignature() {
        List<Signature> list = new ArrayList<>();
        String sql = "SELECT signature_id, customer_contract_id, invoice_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapResultSetToSignature(rs));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Signature getSignatureById(int id) {
        String sql = "SELECT signature_id, customer_contract_id, invoice_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature WHERE signature_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapResultSetToSignature(rs);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Signature> getSignaturesByContractId(int contractId) {
        List<Signature> list = new ArrayList<>();
        String sql = "SELECT * FROM signature WHERE customer_contract_id = ? ORDER BY signed_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSignature(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Signature> getSignaturesByInvoiceId(int invoiceId) {
        List<Signature> list = new ArrayList<>();
        String sql = "SELECT * FROM signature WHERE invoice_id = ? ORDER BY signed_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToSignature(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Signature getSignatureByContractIdAndSignerId(int contractId, int signerUserId) {
        String sql = "SELECT TOP 1 signature_id, customer_contract_id, invoice_id, file_name, file_url, signer_user_id, signer_name, signed_at, uploaded_by, uploaded_at FROM signature WHERE customer_contract_id = ? AND signer_user_id = ? ORDER BY uploaded_at DESC, signature_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, contractId);
            st.setInt(2, signerUserId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapResultSetToSignature(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Signature mapResultSetToSignature(ResultSet rs) throws Exception {
        Signature s = new Signature();
        s.setId(rs.getInt("signature_id"));
        s.setCustomerContractId(rs.getInt("customer_contract_id"));
        s.setInvoiceId(rs.getObject("invoice_id") != null ? rs.getInt("invoice_id") : null);
        s.setFileName(rs.getString("file_name"));
        s.setFileUrl(rs.getString("file_url"));
        s.setSignerUserId(rs.getObject("signer_user_id") != null ? rs.getInt("signer_user_id") : null);
        s.setSignerName(rs.getString("signer_name"));
        s.setSignedAt(rs.getTimestamp("signed_at"));
        s.setUploadedBy(rs.getObject("uploaded_by") != null ? rs.getInt("uploaded_by") : null);
        s.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return s;
    }
}

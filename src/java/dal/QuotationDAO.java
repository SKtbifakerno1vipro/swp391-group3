package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Quotation;
import model.QuotationHistory;

public class QuotationDAO extends DBContext {

    public List<Quotation> getAllQuotations() {
        List<Quotation> list = new ArrayList();
        String sql = "SELECT quotation.quotation_id, quotation.customer_id, quotation.quotation_date, "
                + "quotation.quotation_status, quotation.created_by, quotation.created_at, "
                + "customer.company_name, [user].user_name "
                + "FROM quotation "
                + "LEFT JOIN customer ON quotation.customer_id = customer.customer_id "
                + "LEFT JOIN [user] ON quotation.created_by = [user].user_id "
                + "ORDER BY quotation.created_at DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Quotation quotation = new Quotation();
                //lay du lieu tu resultset do vao object java
                quotation.setQuotationId(rs.getInt("quotation_id"));
                quotation.setCustomerId(rs.getInt("customer_id"));

                //xu ly ngay thang
                if (rs.getTimestamp("quotation_date") != null) {
                    quotation.setQuotationDate(rs.getTimestamp("quotation_date").toLocalDateTime());
                }

                quotation.setQuotationStatus(rs.getString("quotation_status"));
                quotation.setCreatedBy(rs.getInt("created_by"));

                if (rs.getTimestamp("created_at") != null) {
                    quotation.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                }

                //cac truong lay tu bang JOIN
                quotation.setCustomerName(rs.getString("company_name"));
                quotation.setCreatedByName(rs.getString("user_name"));

                list.add(quotation);
            }

        } catch (Exception e) {
            System.out.println("getHistoryByQuotationId error: " + e.getMessage());
        }

        return list;
    }

    public List<QuotationHistory> getHistoryByQuotationId(int quotationId) {

        //lay lich su theo quotation id
        List<QuotationHistory> histories = new ArrayList(); //tao danh sach rong
        String sql = "SELECT * FROM quotation_history WHERE quotation_id = ? ORDER BY quotation_id DESC "; //desc: lich su moi nhat nam tren cung sau do giam dan
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quotationId); // so 1 la vi tri cua dau  ? khong phai quotation_id

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                QuotationHistory history = new QuotationHistory();

                history.setQuotationHistoryId(rs.getInt("quotation_history_id"));
                history.setQuotationId(rs.getInt("quotation_id"));
                history.setCreatedBy(rs.getInt("created_by"));
                history.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                history.setEditHistory(rs.getString("edit_history"));

                histories.add(history);
            }
        } catch (Exception e) {
            System.out.println("getHistoryByQuotationId error: " + e.getMessage());
        }
        return histories;
    }

}

package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.ProductReview;

public class ProductReviewDAO extends DBContext {

    public boolean hasPurchasedProduct(int customerId, int productId) {
        String sql = "SELECT COUNT(*) "
                   + "FROM customer_order o "
                   + "JOIN customer_order_detail od ON o.customer_order_id = od.customer_order_id "
                   + "JOIN quotation_detail qd ON od.quotation_detail_id = qd.quotation_detail_id "
                   + "WHERE o.customer_id = ? "
                   + "  AND qd.product_id = ? "
                   + "  AND o.order_status = 'COMPLETED'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            System.err.println("Error in hasPurchasedProduct: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean addReview(ProductReview review) {
        String sql = "INSERT INTO product_review (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in addReview: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<ProductReview> getReviewsByProductId(int productId) {
        List<ProductReview> list = new ArrayList<>();
        // Lấy thông tin review, JOIN lấy Tên công ty khách hàng, JOIN lấy Tên nhân viên phản hồi (nếu có)
        String sql = "SELECT pr.*, c.company_name, u_staff.full_name AS staff_name "
                   + "FROM product_review pr "
                   + "JOIN [user] u_cust ON pr.user_id = u_cust.user_id "
                   + "JOIN customer c ON u_cust.user_id = c.user_id "
                   + "LEFT JOIN [user] u_staff ON pr.replied_by = u_staff.user_id "
                   + "WHERE pr.product_id = ? AND pr.status = 'ACTIVE' "
                   + "ORDER BY pr.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReview pr = mapResultSetToReview(rs);
                    pr.setCompanyName(rs.getString("company_name"));
                    pr.setRepliedByName(rs.getString("staff_name"));
                    list.add(pr);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getReviewsByProductId: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(CAST(rating AS DECIMAL(3,2))) FROM product_review WHERE product_id = ? AND status = 'ACTIVE'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getAverageRating: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    public boolean addReply(int reviewId, String replyContent, int staffId) {
        String sql = "UPDATE product_review SET reply_content = ?, replied_by = ?, replied_at = GETDATE() WHERE review_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, replyContent);
            ps.setInt(2, staffId);
            ps.setInt(3, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in addReply: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<ProductReview> getAllReviews() {
        List<ProductReview> list = new ArrayList<>();
        String sql = "SELECT pr.*, c.company_name, u_staff.full_name AS staff_name, p.product_name "
                   + "FROM product_review pr "
                   + "JOIN product p ON pr.product_id = p.product_id "
                   + "JOIN [user] u_cust ON pr.user_id = u_cust.user_id "
                   + "JOIN customer c ON u_cust.user_id = c.user_id "
                   + "LEFT JOIN [user] u_staff ON pr.replied_by = u_staff.user_id "
                   + "ORDER BY pr.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductReview pr = mapResultSetToReview(rs);
                    pr.setCompanyName(rs.getString("company_name"));
                    pr.setRepliedByName(rs.getString("staff_name"));
                    pr.setProductName(rs.getString("product_name"));
                    list.add(pr);
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getAllReviews: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateReviewStatus(int reviewId, String status) {
        String sql = "UPDATE product_review SET status = ? WHERE review_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in updateReviewStatus: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReview(int reviewId, int userId, int rating, String comment) {
        String sql = "UPDATE product_review SET rating = ?, comment = ?, created_at = GETDATE() WHERE review_id = ? AND user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, reviewId);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in updateReview: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteReview(int reviewId, int userId) {
        String sql = "UPDATE product_review SET status = 'INACTIVE' WHERE review_id = ? AND user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in deleteReview (soft delete): " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private ProductReview mapResultSetToReview(ResultSet rs) throws Exception {
        ProductReview pr = new ProductReview();
        pr.setReviewId(rs.getInt("review_id"));
        pr.setProductId(rs.getInt("product_id"));
        pr.setUserId(rs.getInt("user_id"));
        pr.setRating(rs.getInt("rating"));
        pr.setComment(rs.getString("comment"));
        pr.setCreatedAt(rs.getTimestamp("created_at"));
        pr.setReplyContent(rs.getString("reply_content"));
        
        int staffId = rs.getInt("replied_by");
        if (rs.wasNull()) {
            pr.setRepliedBy(null);
        } else {
            pr.setRepliedBy(staffId);
        }
        
        pr.setRepliedAt(rs.getTimestamp("replied_at"));
        pr.setStatus(rs.getString("status"));
        return pr;
    }
}

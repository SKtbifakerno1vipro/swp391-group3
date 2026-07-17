package service;

import dal.ProductReviewDAO;
import java.util.List;
import model.ProductReview;
import java.sql.Timestamp;
public class ProductReviewService {

    private final ProductReviewDAO productReviewDAO = new ProductReviewDAO();

    public boolean hasPurchasedProduct(int customerId, int productId) {
        return productReviewDAO.hasPurchasedProduct(customerId, productId);
    }

    public boolean addReview(ProductReview review) {
        return productReviewDAO.addReview(review);
    }

    public List<ProductReview> getReviewsByProductId(int productId) {
        return productReviewDAO.getReviewsByProductId(productId);
    }

    public double getAverageRating(int productId) {
        return productReviewDAO.getAverageRating(productId);
    }

    public boolean addReply(int reviewId, String replyContent, int staffId) {
        return productReviewDAO.addReply(reviewId, replyContent, staffId);
    }

    public List<ProductReview> getAllReviews() {
        return productReviewDAO.getAllReviews();
    }

    public boolean updateReviewStatus(int reviewId, String status) {
        return productReviewDAO.updateReviewStatus(reviewId, status);
    }

    public boolean updateReview(int reviewId, int userId, int rating, String comment) {
        return productReviewDAO.updateReview(reviewId, userId, rating, comment);
    }

    public boolean deleteReview(int reviewId, int userId) {
        return productReviewDAO.deleteReview(reviewId, userId);
    }

    public List<ProductReview> getReviewsSince(Timestamp since, Integer customerUserId) {
        return productReviewDAO.getReviewsSince(since, customerUserId);
    }
}

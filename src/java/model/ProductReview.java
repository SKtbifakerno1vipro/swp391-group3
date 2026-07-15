package model;

import java.sql.Timestamp;

public class ProductReview {
    private int reviewId;
    private int productId;
    private int userId;
    private int rating;
    private String comment;
    private Timestamp createdAt;
    private String replyContent;
    private Integer repliedBy;
    private Timestamp repliedAt;
    private String status;

    private String companyName;      
    private String repliedByName;    
    private String productName;      

    public ProductReview() {
    }

    public ProductReview(int reviewId, int productId, int userId, int rating, String comment, Timestamp createdAt, String replyContent, Integer repliedBy, Timestamp repliedAt, String status) {
        this.reviewId = reviewId;
        this.productId = productId;
        this.userId = userId;
        this.rating = rating;
        this.comment = comment;
        this.createdAt = createdAt;
        this.replyContent = replyContent;
        this.repliedBy = repliedBy;
        this.repliedAt = repliedAt;
        this.status = status;
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment != null ? comment : "";
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getReplyContent() {
        return replyContent != null ? replyContent : "";
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public Integer getRepliedBy() {
        return repliedBy;
    }

    public void setRepliedBy(Integer repliedBy) {
        this.repliedBy = repliedBy;
    }

    public Timestamp getRepliedAt() {
        return repliedAt;
    }

    public void setRepliedAt(Timestamp repliedAt) {
        this.repliedAt = repliedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCompanyName() {
        return companyName != null ? companyName : "";
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getRepliedByName() {
        return repliedByName != null ? repliedByName : "";
    }

    public void setRepliedByName(String repliedByName) {
        this.repliedByName = repliedByName;
    }

    public String getProductName() {
        return productName != null ? productName : "";
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }
}

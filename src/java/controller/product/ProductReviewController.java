package controller.product;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProductReview;
import model.User;
import service.ProductReviewService;
import dal.CustomerDAO;
import dto.CustomerDTO;

@WebServlet(name = "ProductReviewController", urlPatterns = {"/product-review"})
public class ProductReviewController extends HttpServlet {

    private final ProductReviewService reviewService = new ProductReviewService();
    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || user.getRoleId() == 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<ProductReview> allReviews = reviewService.getAllReviews();
        request.setAttribute("reviews", allReviews);
        request.getRequestDispatcher("/views/product/review-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("addReview".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                CustomerDTO customerDTO = customerDAO.getCustomerDTOByUserId(user.getUserId());
                if (customerDTO != null && customerDTO.getCustomer() != null) {
                    int customerId = customerDTO.getCustomer().getCustomerId();

                    boolean hasPurchased = reviewService.hasPurchasedProduct(customerId, productId);
                    if (hasPurchased) {
                        ProductReview review = new ProductReview();
                        review.setProductId(productId);
                        review.setUserId(user.getUserId());
                        review.setRating(rating);
                        review.setComment(comment);

                        reviewService.addReview(review);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/edit-product?id=" + productId + "&action=detail");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/product-list");
            }

        } else if ("editReview".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int productId = Integer.parseInt(request.getParameter("productId"));
                int rating = Integer.parseInt(request.getParameter("rating"));
                String comment = request.getParameter("comment");

                reviewService.updateReview(reviewId, user.getUserId(), rating, comment);
                response.sendRedirect(request.getContextPath() + "/edit-product?id=" + productId + "&action=detail");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/product-list");
            }

        } else if ("deleteReview".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                int productId = Integer.parseInt(request.getParameter("productId"));

                reviewService.deleteReview(reviewId, user.getUserId());
                response.sendRedirect(request.getContextPath() + "/edit-product?id=" + productId + "&action=detail");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/product-list");
            }

        } else if ("addReply".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String replyContent = request.getParameter("replyContent");
                String productIdParam = request.getParameter("productId"); // Chuyển hướng về trang chi tiết nếu gửi từ trang chi tiết

                reviewService.addReply(reviewId, replyContent, user.getUserId());

                if (productIdParam != null && !productIdParam.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/edit-product?id=" + productIdParam + "&action=detail");
                } else {
                    response.sendRedirect(request.getContextPath() + "/product-review");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/product-review");
            }

        } else if ("toggleStatus".equals(action)) {
            try {
                int reviewId = Integer.parseInt(request.getParameter("reviewId"));
                String status = request.getParameter("status"); 

                reviewService.updateReviewStatus(reviewId, status);
                response.sendRedirect(request.getContextPath() + "/product-review");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/product-review");
            }
        }
    }
}

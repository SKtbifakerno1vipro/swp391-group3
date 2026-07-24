package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.ImportRequest;

public class ImportRequestDAO extends DBContext {

    // Lấy toàn bộ danh sách yêu cầu nhập kho
    public List<ImportRequest> getAllImportRequests() {
        List<ImportRequest> list = new ArrayList<>();
        String sql = "SELECT ir.*, p.product_name, u_c.full_name AS creator_name, u_i.full_name AS importer_name "
                + "FROM import_request ir "
                + "JOIN product p ON ir.product_id = p.product_id "
                + "JOIN [user] u_c ON ir.created_by = u_c.user_id "
                + "LEFT JOIN [user] u_i ON ir.imported_by = u_i.user_id "
                + "ORDER BY ir.created_date DESC, ir.import_id DESC";
        try {
            System.out.println("[DEBUG] ImportRequestDAO: getAllImportRequests called");
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                list.add(mapImportRequest(rs));
            }
        } catch (Exception e) {
            System.out.println("ImportRequestDAO getAllImportRequests error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Tìm kiếm yêu cầu nhập kho theo tên sản phẩm hoặc tên người tạo hoặc ghi chú
    public List<ImportRequest> searchImportRequests(String searchText) {
        List<ImportRequest> list = new ArrayList<>();
        String sql = "SELECT ir.*, p.product_name, u_c.full_name AS creator_name, u_i.full_name AS importer_name "
                + "FROM import_request ir "
                + "JOIN product p ON ir.product_id = p.product_id "
                + "JOIN [user] u_c ON ir.created_by = u_c.user_id "
                + "LEFT JOIN [user] u_i ON ir.imported_by = u_i.user_id "
                + "WHERE p.product_name LIKE ? OR u_c.full_name LIKE ? OR ir.note LIKE ? "
                + "ORDER BY ir.created_date DESC, ir.import_id DESC";
        try {
            String searchPattern = "%" + searchText + "%";
            System.out.println("[DEBUG] ImportRequestDAO: searchImportRequests called with pattern: " + searchPattern);
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, searchPattern);
            stm.setString(2, searchPattern);
            stm.setString(3, searchPattern);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                ImportRequest ir = mapImportRequest(rs);
                System.out.println("[DEBUG] Match found: IR-" + ir.getImportId() + " " + ir.getProductName());
                list.add(ir);
            }
        } catch (Exception e) {
            System.out.println("ImportRequestDAO searchImportRequests error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy yêu cầu nhập kho theo ID
    public ImportRequest getImportRequestById(int id) {
        String sql = "SELECT ir.*, p.product_name, u_c.full_name AS creator_name, u_i.full_name AS importer_name "
                + "FROM import_request ir "
                + "JOIN product p ON ir.product_id = p.product_id "
                + "JOIN [user] u_c ON ir.created_by = u_c.user_id "
                + "LEFT JOIN [user] u_i ON ir.imported_by = u_i.user_id "
                + "WHERE ir.import_id = ?";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return mapImportRequest(rs);
            }
        } catch (Exception e) {
            System.out.println("ImportRequestDAO getImportRequestById error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Tạo yêu cầu nhập kho mới (Mặc định status = 1: Pending)
    public boolean createImportRequest(ImportRequest ir) {
        String sql = "INSERT INTO import_request (product_id, quantity, status, created_by, created_date, note) "
                + "VALUES (?, ?, 1, ?, GETDATE(), ?)";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, ir.getProductId());
            stm.setInt(2, ir.getQuantity());
            stm.setInt(3, ir.getCreatedBy());
            stm.setString(4, ir.getNote());
            return stm.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("ImportRequestDAO createImportRequest error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Tạo và thực hiện nhập kho trực tiếp (DATABASE TRANSACTION) dành cho Warehouse
    public boolean createAndPerformImport(ImportRequest ir) {
        String sqlInsert = "INSERT INTO import_request (product_id, quantity, status, created_by, created_date, imported_by, imported_date, note) VALUES (?, ?, 2, ?, GETDATE(), ?, GETDATE(), ?)";
        String sqlUpdateStock = "UPDATE product SET quantity_available = quantity_available + ? WHERE product_id = ?";
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psInsert = connection.prepareStatement(sqlInsert); PreparedStatement psUpdateStock = connection.prepareStatement(sqlUpdateStock)) {

                psInsert.setInt(1, ir.getProductId());
                psInsert.setInt(2, ir.getQuantity());
                psInsert.setInt(3, ir.getCreatedBy());
                psInsert.setInt(4, ir.getImportedBy());
                psInsert.setString(5, ir.getNote());

                psUpdateStock.setInt(1, ir.getQuantity());
                psUpdateStock.setInt(2, ir.getProductId());

                if (psInsert.executeUpdate() > 0 && psUpdateStock.executeUpdate() > 0) {
                    connection.commit();
                    return true;
                }
            }
            connection.rollback();
        } catch (Exception e) {
            System.out.println("ImportRequestDAO createAndPerformImport error: " + e.getMessage());
            e.printStackTrace();
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // Hủy yêu cầu nhập kho (Status chuyển sang 3: Cancelled, lưu ghi chú kho và người hủy, chỉ cho phép nếu đang Pending - 1)
    public boolean cancelImportRequest(int id, String wareHousenote, int userId) {
        // Thử cập nhật với 'ware_housenote' trước, nếu DB dùng 'warehouse_note' thì tự động fallback
        String sql = "UPDATE import_request SET status = 3, ware_housenote = ?, imported_by = ?, imported_date = GETDATE() WHERE import_id = ? AND status = 1";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, wareHousenote);
            stm.setInt(2, userId);
            stm.setInt(3, id);
            int rows = stm.executeUpdate();
            stm.close();
            return rows > 0;
        } catch (Exception e) {
            System.out.println("ImportRequestDAO cancelImportRequest note column fallback triggered: " + e.getMessage());
            try {
                String sqlFallback = "UPDATE import_request SET status = 3, warehouse_note = ?, imported_by = ?, imported_date = GETDATE() WHERE import_id = ? AND status = 1";
                PreparedStatement stmFallback = connection.prepareStatement(sqlFallback);
                stmFallback.setString(1, wareHousenote);
                stmFallback.setInt(2, userId);
                stmFallback.setInt(3, id);
                int rows = stmFallback.executeUpdate();
                stmFallback.close();
                return rows > 0;
            } catch (Exception ex) {
                System.out.println("ImportRequestDAO cancelImportRequest error: " + ex.getMessage());
                ex.printStackTrace();
            }
        }
        return false;
    }

    // Thực hiện nhập kho (DATABASE TRANSACTION: cập nhật status và số lượng tồn kho sản phẩm)
    public boolean performImport(int importId, int productId, int quantity, int userId) {
        PreparedStatement psUpdateStatus = null;
        PreparedStatement psUpdateStock = null;
        try {
            // Tắt auto-commit để bắt đầu Transaction
            connection.setAutoCommit(false);

            // 1. Cập nhật trạng thái yêu cầu sang 2: Imported, lưu thông tin người nhập và ngày nhập
            String sqlUpdateStatus = "UPDATE import_request SET status = 2, imported_by = ?, imported_date = GETDATE() "
                    + "WHERE import_id = ? AND status = 1";
            psUpdateStatus = connection.prepareStatement(sqlUpdateStatus);
            psUpdateStatus.setInt(1, userId);
            psUpdateStatus.setInt(2, importId);
            int rowsStatus = psUpdateStatus.executeUpdate();

            if (rowsStatus == 0) {
                // Nếu không cập nhật được dòng nào (yêu cầu không tồn tại hoặc không ở trạng thái Pending), rollback
                connection.rollback();
                return false;
            }

            // 2. Cộng dồn số lượng hàng nhập vào kho sản phẩm (quantity_available)
            String sqlUpdateStock = "UPDATE product SET quantity_available = quantity_available + ? WHERE product_id = ?";
            psUpdateStock = connection.prepareStatement(sqlUpdateStock);
            psUpdateStock.setInt(1, quantity);
            psUpdateStock.setInt(2, productId);
            int rowsStock = psUpdateStock.executeUpdate();

            if (rowsStock == 0) {
                // Nếu cập nhật sản phẩm thất bại, rollback
                connection.rollback();
                return false;
            }
            String updateProductActiveSql = "UPDATE product SET product_status = 'ACTIVE' "
                    + "WHERE product_id = ? AND quantity_available > 0 AND product_status = 'OUT_OF_STOCK'";
            try (PreparedStatement psProductActive = connection.prepareStatement(updateProductActiveSql)) {
                psProductActive.setInt(1, productId);
                psProductActive.executeUpdate();
            }
            // Commit transaction thành công
            connection.commit();
            return true;
        } catch (Exception e) {
            System.out.println("ImportRequestDAO performImport error in transaction: " + e.getMessage());
            e.printStackTrace();
            try {
                if (connection != null) {
                    connection.rollback(); // Rollback nếu có lỗi xảy ra
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (psUpdateStatus != null) {
                    psUpdateStatus.close();
                }
                if (psUpdateStock != null) {
                    psUpdateStock.close();
                }
                // Bật lại auto-commit mặc định
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    // Đếm số lượng yêu cầu nhập kho đang chờ xử lý (status = 1)
    public int countPendingRequests() {
        String sql = "SELECT COUNT(*) FROM import_request WHERE status = 1";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("ImportRequestDAO countPendingRequests error: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy danh sách các yêu cầu Pending mới tạo kể từ thời điểm truyền vào (Dành cho Server-Sent Events notification)
    public List<ImportRequest> getPendingRequestsSince(Timestamp since) {
        List<ImportRequest> list = new ArrayList<>();
        String sql = "SELECT ir.*, p.product_name, u_c.full_name AS creator_name "
                + "FROM import_request ir "
                + "JOIN product p ON ir.product_id = p.product_id "
                + "JOIN [user] u_c ON ir.created_by = u_c.user_id "
                + "WHERE ir.status = 1 AND ir.created_date > ? "
                + "ORDER BY ir.import_id ASC";
        try {
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setTimestamp(1, since);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                ImportRequest ir = new ImportRequest();
                ir.setImportId(rs.getInt("import_id"));
                ir.setProductId(rs.getInt("product_id"));
                ir.setProductName(rs.getString("product_name"));
                ir.setQuantity(rs.getInt("quantity"));
                ir.setStatus(rs.getInt("status"));
                ir.setCreatedBy(rs.getInt("created_by"));
                ir.setCreatedByName(rs.getString("creator_name"));
                ir.setCreatedDate(rs.getTimestamp("created_date"));
                ir.setNote(rs.getString("note"));
                list.add(ir);
            }
        } catch (Exception e) {
            System.out.println("ImportRequestDAO getPendingRequestsSince error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Hàm ánh xạ ResultSet sang đối tượng ImportRequest
    private ImportRequest mapImportRequest(ResultSet rs) throws SQLException {
        ImportRequest ir = new ImportRequest();
        ir.setImportId(rs.getInt("import_id"));
        ir.setProductId(rs.getInt("product_id"));
        ir.setProductName(rs.getString("product_name"));
        ir.setQuantity(rs.getInt("quantity"));
        ir.setStatus(rs.getInt("status"));
        ir.setCreatedBy(rs.getInt("created_by"));
        ir.setCreatedByName(rs.getString("creator_name"));
        ir.setCreatedDate(rs.getTimestamp("created_date"));

        int importedByVal = rs.getInt("imported_by");
        if (!rs.wasNull()) {
            ir.setImportedBy(importedByVal);
            ir.setImportedByName(rs.getString("importer_name"));
            ir.setImportedDate(rs.getTimestamp("imported_date"));
        }

        ir.setNote(rs.getString("note"));

        // Lấy an toàn ghi chú từ tên cột 'ware_housenote' hoặc 'warehouse_note' mà không làm treo câu lệnh SQL
        String whNote = null;
        try {
            whNote = rs.getString("ware_housenote");
        } catch (SQLException ignored) {
        }
        if (whNote == null) {
            try {
                whNote = rs.getString("warehouse_note");
            } catch (SQLException ignored) {
            }
        }
        ir.setWareHousenote(whNote);

        return ir;
    }
}

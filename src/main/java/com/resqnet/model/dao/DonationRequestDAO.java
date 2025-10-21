package com.resqnet.model.dao;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestItem;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DonationRequestDAO {

    public int create(DonationRequest request) {
        String sql = "INSERT INTO donation_requests(user_id, relief_center_name, special_notes, status) VALUES(?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, request.getUserId());
            ps.setString(2, request.getReliefCenterName());
            ps.setString(3, request.getSpecialNotes());
            ps.setString(4, request.getStatus() != null ? request.getStatus() : "Pending");
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int requestId = rs.getInt(1);
                    
                    // Insert request items
                    if (request.getItems() != null && !request.getItems().isEmpty()) {
                        insertRequestItems(con, requestId, request.getItems());
                    }
                    
                    return requestId;
                }
            }
            throw new SQLException("Creating donation request failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating donation request", e);
        }
    }

    private void insertRequestItems(Connection con, int requestId, List<DonationRequestItem> items) throws SQLException {
        String sql = "INSERT INTO donation_request_items(request_id, item_id, quantity) VALUES(?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (DonationRequestItem item : items) {
                ps.setInt(1, requestId);
                ps.setInt(2, item.getItemId());
                ps.setInt(3, item.getQuantity());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    public void update(DonationRequest request) {
        String sql = "UPDATE donation_requests SET relief_center_name = ?, special_notes = ? WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, request.getReliefCenterName());
            ps.setString(2, request.getSpecialNotes());
            ps.setInt(3, request.getRequestId());
            ps.executeUpdate();
            
            // Update items if needed
            if (request.getItems() != null) {
                deleteRequestItems(con, request.getRequestId());
                if (!request.getItems().isEmpty()) {
                    insertRequestItems(con, request.getRequestId(), request.getItems());
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation request", e);
        }
    }

    public void approve(int requestId) {
        String sql = "UPDATE donation_requests SET status = 'Approved', approved_at = CURRENT_TIMESTAMP WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error approving donation request", e);
        }
    }

    public void delete(int requestId) {
        String sql = "DELETE FROM donation_requests WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting donation request", e);
        }
    }

    private void deleteRequestItems(Connection con, int requestId) throws SQLException {
        String sql = "DELETE FROM donation_request_items WHERE request_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        }
    }

    public Optional<DonationRequest> findById(int requestId) {
        String sql = "SELECT request_id, user_id, relief_center_name, status, special_notes, submitted_at, approved_at " +
                     "FROM donation_requests WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DonationRequest request = map(rs);
                    request.setItems(findRequestItems(con, requestId));
                    return Optional.of(request);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation request", e);
        }
        return Optional.empty();
    }

    public List<DonationRequest> findByUserId(int userId) {
        String sql = "SELECT request_id, user_id, relief_center_name, status, special_notes, submitted_at, approved_at " +
                     "FROM donation_requests WHERE user_id = ? ORDER BY submitted_at DESC";
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonationRequest request = map(rs);
                    request.setItems(findRequestItems(con, request.getRequestId()));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests for user", e);
        }
        return requests;
    }

    public List<DonationRequest> findByStatus(String status) {
        String sql = "SELECT request_id, user_id, relief_center_name, status, special_notes, submitted_at, approved_at " +
                     "FROM donation_requests WHERE status = ? ORDER BY submitted_at DESC";
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonationRequest request = map(rs);
                    request.setItems(findRequestItems(con, request.getRequestId()));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests by status", e);
        }
        return requests;
    }

    public List<DonationRequest> findAll() {
        String sql = "SELECT request_id, user_id, relief_center_name, status, special_notes, submitted_at, approved_at " +
                     "FROM donation_requests ORDER BY submitted_at DESC";
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DonationRequest request = map(rs);
                request.setItems(findRequestItems(con, request.getRequestId()));
                requests.add(request);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all donation requests", e);
        }
        return requests;
    }

    private List<DonationRequestItem> findRequestItems(Connection con, int requestId) throws SQLException {
        String sql = "SELECT dri.request_item_id, dri.request_id, dri.item_id, dri.quantity, " +
                     "dic.item_name, dic.category " +
                     "FROM donation_request_items dri " +
                     "JOIN donation_items_catalog dic ON dri.item_id = dic.item_id " +
                     "WHERE dri.request_id = ?";
        List<DonationRequestItem> items = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(mapItem(rs));
                }
            }
        }
        return items;
    }

    private DonationRequest map(ResultSet rs) throws SQLException {
        DonationRequest request = new DonationRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setUserId(rs.getInt("user_id"));
        request.setReliefCenterName(rs.getString("relief_center_name"));
        request.setStatus(rs.getString("status"));
        request.setSpecialNotes(rs.getString("special_notes"));
        request.setSubmittedAt(rs.getTimestamp("submitted_at"));
        request.setApprovedAt(rs.getTimestamp("approved_at"));
        return request;
    }

    private DonationRequestItem mapItem(ResultSet rs) throws SQLException {
        DonationRequestItem item = new DonationRequestItem();
        item.setRequestItemId(rs.getInt("request_item_id"));
        item.setRequestId(rs.getInt("request_id"));
        item.setItemId(rs.getInt("item_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setItemName(rs.getString("item_name"));
        item.setCategory(rs.getString("category"));
        return item;
    }
}

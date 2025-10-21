package com.resqnet.model.dao;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestWithDetails;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class DonationRequestDAO {

    public int create(DonationRequest request) {
        String sql = "INSERT INTO donation_requests(user_id, relief_center_name, gn_id, status, special_notes) " +
                     "VALUES(?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, request.getUserId());
            ps.setString(2, request.getReliefCenterName());
            if (request.getGnId() != null) {
                ps.setInt(3, request.getGnId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, request.getStatus() != null ? request.getStatus() : "Pending");
            ps.setString(5, request.getSpecialNotes());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            throw new SQLException("Creating donation request failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating donation request", e);
        }
    }

    public void update(DonationRequest request) {
        String sql = "UPDATE donation_requests SET relief_center_name = ?, gn_id = ?, " +
                     "status = ?, special_notes = ?, approved_at = ? WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, request.getReliefCenterName());
            if (request.getGnId() != null) {
                ps.setInt(2, request.getGnId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, request.getStatus());
            ps.setString(4, request.getSpecialNotes());
            if (request.getApprovedAt() != null) {
                ps.setTimestamp(5, request.getApprovedAt());
            } else {
                ps.setNull(5, Types.TIMESTAMP);
            }
            ps.setInt(6, request.getRequestId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation request", e);
        }
    }

    public void approve(int requestId, int gnId) {
        String sql = "UPDATE donation_requests SET status = 'Approved', gn_id = ?, approved_at = CURRENT_TIMESTAMP " +
                     "WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, gnId);
            ps.setInt(2, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error approving donation request", e);
        }
    }

    public Optional<DonationRequest> findById(int requestId) {
        String sql = "SELECT request_id, user_id, relief_center_name, gn_id, status, special_notes, " +
                     "submitted_at, approved_at FROM donation_requests WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation request", e);
        }
        return Optional.empty();
    }

    public List<DonationRequest> findByUserId(int userId) {
        String sql = "SELECT request_id, user_id, relief_center_name, gn_id, status, special_notes, " +
                     "submitted_at, approved_at FROM donation_requests WHERE user_id = ? ORDER BY submitted_at DESC";
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests for user", e);
        }
        return requests;
    }

    public List<DonationRequestWithDetails> findByStatus(String status) {
        String sql = "SELECT dr.request_id, dr.user_id, dr.relief_center_name, dr.gn_id, dr.status, " +
                     "dr.special_notes, dr.submitted_at, dr.approved_at, " +
                     "gu.name as user_name, gu.contact_number as user_contact, " +
                     "gn.name as gn_name " +
                     "FROM donation_requests dr " +
                     "INNER JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "LEFT JOIN grama_niladhari gn ON dr.gn_id = gn.user_id " +
                     "WHERE dr.status = ? " +
                     "ORDER BY dr.submitted_at DESC";
        
        List<DonationRequestWithDetails> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapWithDetails(rs));
                }
            }
            
            // Load items for each request
            for (DonationRequestWithDetails request : requests) {
                request.setItems(loadRequestItems(con, request.getRequestId()));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests by status", e);
        }
        return requests;
    }

    public List<DonationRequestWithDetails> findAll() {
        String sql = "SELECT dr.request_id, dr.user_id, dr.relief_center_name, dr.gn_id, dr.status, " +
                     "dr.special_notes, dr.submitted_at, dr.approved_at, " +
                     "gu.name as user_name, gu.contact_number as user_contact, " +
                     "gn.name as gn_name " +
                     "FROM donation_requests dr " +
                     "INNER JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "LEFT JOIN grama_niladhari gn ON dr.gn_id = gn.user_id " +
                     "ORDER BY dr.submitted_at DESC";
        
        List<DonationRequestWithDetails> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                requests.add(mapWithDetails(rs));
            }
            
            // Load items for each request
            for (DonationRequestWithDetails request : requests) {
                request.setItems(loadRequestItems(con, request.getRequestId()));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all donation requests", e);
        }
        return requests;
    }

    private List<DonationRequestWithDetails.DonationRequestItemDetail> loadRequestItems(Connection con, int requestId) throws SQLException {
        String sql = "SELECT dri.item_id, dri.quantity, dic.item_name, dic.category " +
                     "FROM donation_request_items dri " +
                     "INNER JOIN donation_items_catalog dic ON dri.item_id = dic.item_id " +
                     "WHERE dri.request_id = ?";
        
        List<DonationRequestWithDetails.DonationRequestItemDetail> items = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonationRequestWithDetails.DonationRequestItemDetail item = 
                        new DonationRequestWithDetails.DonationRequestItemDetail();
                    item.setItemId(rs.getInt("item_id"));
                    item.setItemName(rs.getString("item_name"));
                    item.setCategory(rs.getString("category"));
                    item.setQuantity(rs.getInt("quantity"));
                    items.add(item);
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
        int gnId = rs.getInt("gn_id");
        request.setGnId(rs.wasNull() ? null : gnId);
        request.setStatus(rs.getString("status"));
        request.setSpecialNotes(rs.getString("special_notes"));
        request.setSubmittedAt(rs.getTimestamp("submitted_at"));
        request.setApprovedAt(rs.getTimestamp("approved_at"));
        return request;
    }

    private DonationRequestWithDetails mapWithDetails(ResultSet rs) throws SQLException {
        DonationRequestWithDetails request = new DonationRequestWithDetails();
        request.setRequestId(rs.getInt("request_id"));
        request.setUserId(rs.getInt("user_id"));
        request.setReliefCenterName(rs.getString("relief_center_name"));
        int gnId = rs.getInt("gn_id");
        request.setGnId(rs.wasNull() ? null : gnId);
        request.setStatus(rs.getString("status"));
        request.setSpecialNotes(rs.getString("special_notes"));
        request.setSubmittedAt(rs.getTimestamp("submitted_at"));
        request.setApprovedAt(rs.getTimestamp("approved_at"));
        request.setUserName(rs.getString("user_name"));
        request.setUserContact(rs.getString("user_contact"));
        request.setGnName(rs.getString("gn_name"));
        return request;
    }
}

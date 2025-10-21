package com.resqnet.model.dao;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestWithItems;
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
        String sql = "UPDATE donation_requests SET relief_center_name = ?, gn_id = ?, status = ?, " +
                     "special_notes = ?, verified_at = ?, approved_at = ? WHERE request_id = ?";
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
            ps.setTimestamp(5, request.getVerifiedAt());
            ps.setTimestamp(6, request.getApprovedAt());
            ps.setInt(7, request.getRequestId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation request", e);
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

    public Optional<DonationRequest> findById(int requestId) {
        String sql = "SELECT request_id, user_id, relief_center_name, gn_id, status, special_notes, " +
                     "submitted_at, verified_at, approved_at FROM donation_requests WHERE request_id = ?";
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
                     "submitted_at, verified_at, approved_at FROM donation_requests WHERE user_id = ? " +
                     "ORDER BY submitted_at DESC";
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

    public List<DonationRequest> findByStatus(String status) {
        String sql = "SELECT request_id, user_id, relief_center_name, gn_id, status, special_notes, " +
                     "submitted_at, verified_at, approved_at FROM donation_requests WHERE status = ? " +
                     "ORDER BY submitted_at DESC";
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests by status", e);
        }
        return requests;
    }

    public List<DonationRequestWithItems> findAllWithItems() {
        String sql = "SELECT dr.request_id, dr.user_id, gu.name as user_name, gu.contact_number as user_contact, " +
                     "dr.relief_center_name, dr.gn_id, gn.name as gn_name, dr.status, dr.special_notes, " +
                     "dr.submitted_at, dr.verified_at, dr.approved_at, " +
                     "dic.item_name, dic.category, dri.quantity " +
                     "FROM donation_requests dr " +
                     "JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "LEFT JOIN grama_niladhari gn ON dr.gn_id = gn.user_id " +
                     "LEFT JOIN donation_request_items dri ON dr.request_id = dri.request_id " +
                     "LEFT JOIN donation_items_catalog dic ON dri.item_id = dic.item_id " +
                     "ORDER BY dr.submitted_at DESC";
        return executeQueryWithItems(sql, null);
    }

    public List<DonationRequestWithItems> findByStatusWithItems(String status) {
        String sql = "SELECT dr.request_id, dr.user_id, gu.name as user_name, gu.contact_number as user_contact, " +
                     "dr.relief_center_name, dr.gn_id, gn.name as gn_name, dr.status, dr.special_notes, " +
                     "dr.submitted_at, dr.verified_at, dr.approved_at, " +
                     "dic.item_name, dic.category, dri.quantity " +
                     "FROM donation_requests dr " +
                     "JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "LEFT JOIN grama_niladhari gn ON dr.gn_id = gn.user_id " +
                     "LEFT JOIN donation_request_items dri ON dr.request_id = dri.request_id " +
                     "LEFT JOIN donation_items_catalog dic ON dri.item_id = dic.item_id " +
                     "WHERE dr.status = ? " +
                     "ORDER BY dr.submitted_at DESC";
        return executeQueryWithItems(sql, status);
    }

    private List<DonationRequestWithItems> executeQueryWithItems(String sql, String status) {
        Map<Integer, DonationRequestWithItems> requestMap = new HashMap<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (status != null) {
                ps.setString(1, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int requestId = rs.getInt("request_id");
                    DonationRequestWithItems request = requestMap.get(requestId);
                    if (request == null) {
                        request = new DonationRequestWithItems();
                        request.setRequestId(requestId);
                        request.setUserId(rs.getInt("user_id"));
                        request.setUserName(rs.getString("user_name"));
                        request.setUserContact(rs.getString("user_contact"));
                        request.setReliefCenterName(rs.getString("relief_center_name"));
                        request.setGnId(rs.getInt("gn_id"));
                        if (rs.wasNull()) {
                            request.setGnId(null);
                        }
                        request.setGnName(rs.getString("gn_name"));
                        request.setStatus(rs.getString("status"));
                        request.setSpecialNotes(rs.getString("special_notes"));
                        request.setSubmittedAt(rs.getTimestamp("submitted_at"));
                        request.setVerifiedAt(rs.getTimestamp("verified_at"));
                        request.setApprovedAt(rs.getTimestamp("approved_at"));
                        request.setItems(new ArrayList<>());
                        requestMap.put(requestId, request);
                    }
                    
                    String itemName = rs.getString("item_name");
                    if (itemName != null) {
                        DonationRequestWithItems.DonationRequestItemDetail item = 
                            new DonationRequestWithItems.DonationRequestItemDetail();
                        item.setItemName(itemName);
                        item.setCategory(rs.getString("category"));
                        item.setQuantity(rs.getInt("quantity"));
                        request.getItems().add(item);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests with items", e);
        }
        return new ArrayList<>(requestMap.values());
    }

    private DonationRequest map(ResultSet rs) throws SQLException {
        DonationRequest request = new DonationRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setUserId(rs.getInt("user_id"));
        request.setReliefCenterName(rs.getString("relief_center_name"));
        request.setGnId(rs.getInt("gn_id"));
        if (rs.wasNull()) {
            request.setGnId(null);
        }
        request.setStatus(rs.getString("status"));
        request.setSpecialNotes(rs.getString("special_notes"));
        request.setSubmittedAt(rs.getTimestamp("submitted_at"));
        request.setVerifiedAt(rs.getTimestamp("verified_at"));
        request.setApprovedAt(rs.getTimestamp("approved_at"));
        return request;
    }
}

package com.resqnet.model.dao;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestItem;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DonationRequestDAO {
    private final DonationRequestItemDAO itemDAO = new DonationRequestItemDAO();

    public int create(DonationRequest request) {
        String sql = "INSERT INTO donation_requests(user_id, relief_center_name, status, special_notes) " +
                     "VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, request.getUserId());
            ps.setString(2, request.getReliefCenterName());
            ps.setString(3, request.getStatus() != null ? request.getStatus() : "Pending");
            ps.setString(4, request.getSpecialNotes());
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
        String sql = "UPDATE donation_requests SET relief_center_name = ?, status = ?, special_notes = ?, " +
                     "gn_id = ?, verified_at = ?, approved_at = ? WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, request.getReliefCenterName());
            ps.setString(2, request.getStatus());
            ps.setString(3, request.getSpecialNotes());
            if (request.getGnId() != null) {
                ps.setInt(4, request.getGnId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setTimestamp(5, request.getVerifiedAt());
            ps.setTimestamp(6, request.getApprovedAt());
            ps.setInt(7, request.getRequestId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation request", e);
        }
    }

    public void updateStatus(int requestId, String status, Integer gnId) {
        String sql = "UPDATE donation_requests SET status = ?, gn_id = ?, " +
                     "verified_at = CASE WHEN ? = 'Verified' THEN CURRENT_TIMESTAMP ELSE verified_at END, " +
                     "approved_at = CASE WHEN ? = 'Approved' THEN CURRENT_TIMESTAMP ELSE approved_at END " +
                     "WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            if (gnId != null) {
                ps.setInt(2, gnId);
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, status);
            ps.setString(4, status);
            ps.setInt(5, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation request status", e);
        }
    }

    public Optional<DonationRequest> findById(int requestId) {
        String sql = "SELECT dr.request_id, dr.user_id, dr.relief_center_name, dr.gn_id, dr.status, " +
                     "dr.special_notes, dr.submitted_at, dr.verified_at, dr.approved_at, " +
                     "gu.name as submitter_name, gu.contact_number as submitter_contact " +
                     "FROM donation_requests dr " +
                     "JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "WHERE dr.request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DonationRequest request = map(rs);
                    request.setItems(itemDAO.findByRequestId(requestId));
                    return Optional.of(request);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation request", e);
        }
        return Optional.empty();
    }

    public List<DonationRequest> findByUserId(int userId) {
        String sql = "SELECT dr.request_id, dr.user_id, dr.relief_center_name, dr.gn_id, dr.status, " +
                     "dr.special_notes, dr.submitted_at, dr.verified_at, dr.approved_at, " +
                     "gu.name as submitter_name, gu.contact_number as submitter_contact " +
                     "FROM donation_requests dr " +
                     "JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "WHERE dr.user_id = ? ORDER BY dr.submitted_at DESC";
        return findRequests(sql, userId);
    }

    public List<DonationRequest> findByStatus(String status) {
        String sql = "SELECT dr.request_id, dr.user_id, dr.relief_center_name, dr.gn_id, dr.status, " +
                     "dr.special_notes, dr.submitted_at, dr.verified_at, dr.approved_at, " +
                     "gu.name as submitter_name, gu.contact_number as submitter_contact " +
                     "FROM donation_requests dr " +
                     "JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "WHERE dr.status = ? ORDER BY dr.submitted_at DESC";
        return findRequests(sql, status);
    }

    public List<DonationRequest> findAll() {
        String sql = "SELECT dr.request_id, dr.user_id, dr.relief_center_name, dr.gn_id, dr.status, " +
                     "dr.special_notes, dr.submitted_at, dr.verified_at, dr.approved_at, " +
                     "gu.name as submitter_name, gu.contact_number as submitter_contact " +
                     "FROM donation_requests dr " +
                     "JOIN general_user gu ON dr.user_id = gu.user_id " +
                     "ORDER BY dr.submitted_at DESC";
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DonationRequest request = map(rs);
                request.setItems(itemDAO.findByRequestId(request.getRequestId()));
                requests.add(request);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests", e);
        }
        return requests;
    }

    private List<DonationRequest> findRequests(String sql, Object param) {
        List<DonationRequest> requests = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (param instanceof Integer) {
                ps.setInt(1, (Integer) param);
            } else {
                ps.setString(1, param.toString());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonationRequest request = map(rs);
                    request.setItems(itemDAO.findByRequestId(request.getRequestId()));
                    requests.add(request);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation requests", e);
        }
        return requests;
    }

    private DonationRequest map(ResultSet rs) throws SQLException {
        DonationRequest request = new DonationRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setUserId(rs.getInt("user_id"));
        request.setReliefCenterName(rs.getString("relief_center_name"));
        
        int gnId = rs.getInt("gn_id");
        if (!rs.wasNull()) {
            request.setGnId(gnId);
        }
        
        request.setStatus(rs.getString("status"));
        request.setSpecialNotes(rs.getString("special_notes"));
        request.setSubmittedAt(rs.getTimestamp("submitted_at"));
        request.setVerifiedAt(rs.getTimestamp("verified_at"));
        request.setApprovedAt(rs.getTimestamp("approved_at"));
        request.setSubmitterName(rs.getString("submitter_name"));
        request.setSubmitterContact(rs.getString("submitter_contact"));
        return request;
    }
}

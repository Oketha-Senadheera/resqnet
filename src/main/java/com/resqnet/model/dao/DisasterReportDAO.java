package com.resqnet.model.dao;

import com.resqnet.model.DisasterReport;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DisasterReportDAO {

    public int create(DisasterReport report) {
        String sql = "INSERT INTO disaster_reports(user_id, reporter_name, contact_number, disaster_type, " +
                     "other_disaster_type, disaster_datetime, location, proof_image_path, confirmation, " +
                     "status, description) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, report.getUserId());
            ps.setString(2, report.getReporterName());
            ps.setString(3, report.getContactNumber());
            ps.setString(4, report.getDisasterType());
            ps.setString(5, report.getOtherDisasterType());
            ps.setTimestamp(6, report.getDisasterDatetime());
            ps.setString(7, report.getLocation());
            ps.setString(8, report.getProofImagePath());
            ps.setBoolean(9, report.getConfirmation() != null ? report.getConfirmation() : true);
            ps.setString(10, report.getStatus() != null ? report.getStatus() : "Pending");
            ps.setString(11, report.getDescription());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            throw new SQLException("Creating disaster report failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating disaster report", e);
        }
    }

    public void update(DisasterReport report) {
        String sql = "UPDATE disaster_reports SET reporter_name = ?, contact_number = ?, " +
                     "disaster_type = ?, other_disaster_type = ?, disaster_datetime = ?, location = ?, " +
                     "proof_image_path = ?, status = ?, description = ?, verified_at = ? WHERE report_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, report.getReporterName());
            ps.setString(2, report.getContactNumber());
            ps.setString(3, report.getDisasterType());
            ps.setString(4, report.getOtherDisasterType());
            ps.setTimestamp(5, report.getDisasterDatetime());
            ps.setString(6, report.getLocation());
            ps.setString(7, report.getProofImagePath());
            ps.setString(8, report.getStatus());
            ps.setString(9, report.getDescription());
            ps.setTimestamp(10, report.getVerifiedAt());
            ps.setInt(11, report.getReportId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating disaster report", e);
        }
    }

    public void delete(int reportId) {
        String sql = "DELETE FROM disaster_reports WHERE report_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting disaster report", e);
        }
    }

    public Optional<DisasterReport> findById(int reportId) {
        String sql = "SELECT report_id, user_id, reporter_name, contact_number, disaster_type, " +
                     "other_disaster_type, disaster_datetime, location, proof_image_path, confirmation, " +
                     "status, description, submitted_at, verified_at FROM disaster_reports WHERE report_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching disaster report", e);
        }
        return Optional.empty();
    }

    public List<DisasterReport> findByUserId(int userId) {
        String sql = "SELECT report_id, user_id, reporter_name, contact_number, disaster_type, " +
                     "other_disaster_type, disaster_datetime, location, proof_image_path, confirmation, " +
                     "status, description, submitted_at, verified_at FROM disaster_reports WHERE user_id = ? " +
                     "ORDER BY submitted_at DESC";
        List<DisasterReport> reports = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching disaster reports for user", e);
        }
        return reports;
    }

    public List<DisasterReport> findByStatus(String status) {
        String sql = "SELECT report_id, user_id, reporter_name, contact_number, disaster_type, " +
                     "other_disaster_type, disaster_datetime, location, proof_image_path, confirmation, " +
                     "status, description, submitted_at, verified_at FROM disaster_reports WHERE status = ? " +
                     "ORDER BY submitted_at DESC";
        List<DisasterReport> reports = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    reports.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching disaster reports by status", e);
        }
        return reports;
    }

    public List<DisasterReport> findAll() {
        String sql = "SELECT report_id, user_id, reporter_name, contact_number, disaster_type, " +
                     "other_disaster_type, disaster_datetime, location, proof_image_path, confirmation, " +
                     "status, description, submitted_at, verified_at FROM disaster_reports " +
                     "ORDER BY submitted_at DESC";
        List<DisasterReport> reports = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                reports.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all disaster reports", e);
        }
        return reports;
    }

    public void approve(int reportId) {
        String sql = "UPDATE disaster_reports SET status = 'Approved', verified_at = CURRENT_TIMESTAMP WHERE report_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error approving disaster report", e);
        }
    }

    public void reject(int reportId) {
        String sql = "UPDATE disaster_reports SET status = 'Rejected', verified_at = CURRENT_TIMESTAMP WHERE report_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, reportId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error rejecting disaster report", e);
        }
    }

    private DisasterReport map(ResultSet rs) throws SQLException {
        DisasterReport report = new DisasterReport();
        report.setReportId(rs.getInt("report_id"));
        report.setUserId(rs.getInt("user_id"));
        report.setReporterName(rs.getString("reporter_name"));
        report.setContactNumber(rs.getString("contact_number"));
        report.setDisasterType(rs.getString("disaster_type"));
        report.setOtherDisasterType(rs.getString("other_disaster_type"));
        report.setDisasterDatetime(rs.getTimestamp("disaster_datetime"));
        report.setLocation(rs.getString("location"));
        report.setProofImagePath(rs.getString("proof_image_path"));
        report.setConfirmation(rs.getBoolean("confirmation"));
        report.setStatus(rs.getString("status"));
        report.setDescription(rs.getString("description"));
        report.setSubmittedAt(rs.getTimestamp("submitted_at"));
        report.setVerifiedAt(rs.getTimestamp("verified_at"));
        return report;
    }
}

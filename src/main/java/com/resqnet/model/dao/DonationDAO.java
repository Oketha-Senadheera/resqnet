package com.resqnet.model.dao;

import com.resqnet.model.Donation;
import com.resqnet.model.DonationWithItems;
import com.resqnet.model.DonationItemWithDetails;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DonationDAO {

    public int create(Donation donation) {
        String sql = "INSERT INTO donations(user_id, collection_point_id, name, contact_number, email, address, " +
                     "collection_date, time_slot, special_notes, confirmation, status) " +
                     "VALUES(?,?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, donation.getUserId());
            ps.setInt(2, donation.getCollectionPointId());
            ps.setString(3, donation.getName());
            ps.setString(4, donation.getContactNumber());
            ps.setString(5, donation.getEmail());
            ps.setString(6, donation.getAddress());
            ps.setDate(7, donation.getCollectionDate());
            ps.setString(8, donation.getTimeSlot());
            ps.setString(9, donation.getSpecialNotes());
            ps.setBoolean(10, donation.getConfirmation());
            ps.setString(11, donation.getStatus() != null ? donation.getStatus() : "Pending");
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            throw new SQLException("Creating donation failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating donation", e);
        }
    }

    public void updateStatus(int donationId, String status) {
        String sql = "UPDATE donations SET status = ?, " +
                     (status.equals("Received") ? "received_at = CURRENT_TIMESTAMP, delivered_at = CURRENT_TIMESTAMP" :
                      status.equals("Cancelled") ? "cancelled_at = CURRENT_TIMESTAMP" : 
                      status.equals("Delivered") ? "delivered_at = CURRENT_TIMESTAMP" : "") +
                     " WHERE donation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, donationId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation status", e);
        }
    }

    public Optional<Donation> findById(int donationId) {
        String sql = "SELECT donation_id, user_id, collection_point_id, name, contact_number, email, address, " +
                     "collection_date, time_slot, special_notes, confirmation, status, submitted_at, " +
                     "received_at, cancelled_at, delivered_at FROM donations WHERE donation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, donationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation", e);
        }
        return Optional.empty();
    }

    public List<Donation> findByUserId(int userId) {
        String sql = "SELECT donation_id, user_id, collection_point_id, name, contact_number, email, address, " +
                     "collection_date, time_slot, special_notes, confirmation, status, submitted_at, " +
                     "received_at, cancelled_at, delivered_at FROM donations WHERE user_id = ? ORDER BY submitted_at DESC";
        List<Donation> donations = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    donations.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donations for user", e);
        }
        return donations;
    }

    public List<DonationWithItems> findByNgoId(int ngoId) {
        String sql = "SELECT d.donation_id, d.user_id, d.collection_point_id, d.name, d.contact_number, d.email, " +
                     "d.address, d.collection_date, d.time_slot, d.special_notes, d.confirmation, d.status, " +
                     "d.submitted_at, d.received_at, d.cancelled_at, d.delivered_at, " +
                     "cp.name as cp_name, cp.full_address as cp_address " +
                     "FROM donations d " +
                     "JOIN collection_points cp ON d.collection_point_id = cp.collection_point_id " +
                     "WHERE cp.ngo_id = ? ORDER BY d.submitted_at DESC";
        List<DonationWithItems> donations = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ngoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonationWithItems dwi = new DonationWithItems();
                    dwi.setDonation(map(rs));
                    dwi.setCollectionPointName(rs.getString("cp_name"));
                    dwi.setCollectionPointAddress(rs.getString("cp_address"));
                    
                    // Load items for this donation
                    dwi.setItems(findItemsByDonationId(rs.getInt("donation_id")));
                    donations.add(dwi);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donations for NGO", e);
        }
        return donations;
    }

    public DonationWithItems findWithItemsById(int donationId) {
        String sql = "SELECT d.donation_id, d.user_id, d.collection_point_id, d.name, d.contact_number, d.email, " +
                     "d.address, d.collection_date, d.time_slot, d.special_notes, d.confirmation, d.status, " +
                     "d.submitted_at, d.received_at, d.cancelled_at, d.delivered_at, " +
                     "cp.name as cp_name, cp.full_address as cp_address " +
                     "FROM donations d " +
                     "JOIN collection_points cp ON d.collection_point_id = cp.collection_point_id " +
                     "WHERE d.donation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, donationId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DonationWithItems dwi = new DonationWithItems();
                    dwi.setDonation(map(rs));
                    dwi.setCollectionPointName(rs.getString("cp_name"));
                    dwi.setCollectionPointAddress(rs.getString("cp_address"));
                    dwi.setItems(findItemsByDonationId(donationId));
                    return dwi;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation with items", e);
        }
        return null;
    }

    private List<DonationItemWithDetails> findItemsByDonationId(int donationId) {
        String sql = "SELECT di.donation_item_id, di.donation_id, di.item_id, di.quantity, " +
                     "dic.item_name, dic.category " +
                     "FROM donation_items di " +
                     "JOIN donation_items_catalog dic ON di.item_id = dic.item_id " +
                     "WHERE di.donation_id = ?";
        List<DonationItemWithDetails> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, donationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DonationItemWithDetails item = new DonationItemWithDetails();
                    item.setDonationItemId(rs.getInt("donation_item_id"));
                    item.setDonationId(rs.getInt("donation_id"));
                    item.setItemId(rs.getInt("item_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setItemName(rs.getString("item_name"));
                    item.setCategory(rs.getString("category"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation items", e);
        }
        return items;
    }

    private Donation map(ResultSet rs) throws SQLException {
        Donation d = new Donation();
        d.setDonationId(rs.getInt("donation_id"));
        d.setUserId(rs.getInt("user_id"));
        d.setCollectionPointId(rs.getInt("collection_point_id"));
        d.setName(rs.getString("name"));
        d.setContactNumber(rs.getString("contact_number"));
        d.setEmail(rs.getString("email"));
        d.setAddress(rs.getString("address"));
        d.setCollectionDate(rs.getDate("collection_date"));
        d.setTimeSlot(rs.getString("time_slot"));
        d.setSpecialNotes(rs.getString("special_notes"));
        d.setConfirmation(rs.getBoolean("confirmation"));
        d.setStatus(rs.getString("status"));
        d.setSubmittedAt(rs.getTimestamp("submitted_at"));
        d.setReceivedAt(rs.getTimestamp("received_at"));
        d.setCancelledAt(rs.getTimestamp("cancelled_at"));
        d.setDeliveredAt(rs.getTimestamp("delivered_at"));
        return d;
    }
}

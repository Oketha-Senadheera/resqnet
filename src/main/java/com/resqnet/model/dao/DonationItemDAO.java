package com.resqnet.model.dao;

import com.resqnet.model.DonationItem;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonationItemDAO {

    public int create(DonationItem item) {
        String sql = "INSERT INTO donation_items(donation_id, item_id, quantity) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getDonationId());
            ps.setInt(2, item.getItemId());
            ps.setInt(3, item.getQuantity());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            throw new SQLException("Creating donation item failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating donation item", e);
        }
    }

    public List<DonationItem> findByDonationId(int donationId) {
        String sql = "SELECT donation_item_id, donation_id, item_id, quantity " +
                     "FROM donation_items WHERE donation_id = ?";
        List<DonationItem> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, donationId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation items", e);
        }
        return items;
    }

    private DonationItem map(ResultSet rs) throws SQLException {
        DonationItem item = new DonationItem();
        item.setDonationItemId(rs.getInt("donation_item_id"));
        item.setDonationId(rs.getInt("donation_id"));
        item.setItemId(rs.getInt("item_id"));
        item.setQuantity(rs.getInt("quantity"));
        return item;
    }
}

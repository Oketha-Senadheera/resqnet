package com.resqnet.model.dao;

import com.resqnet.model.DonationItemsCatalog;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class DonationItemsCatalogDAO {

    public int create(DonationItemsCatalog item) {
        String sql = "INSERT INTO donation_items_catalog(item_name, category) VALUES(?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getCategory());
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

    public Optional<DonationItemsCatalog> findById(int itemId) {
        String sql = "SELECT item_id, item_name, category FROM donation_items_catalog WHERE item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation item", e);
        }
        return Optional.empty();
    }

    public List<DonationItemsCatalog> findAll() {
        String sql = "SELECT item_id, item_name, category FROM donation_items_catalog ORDER BY category, item_name";
        List<DonationItemsCatalog> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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

    public List<DonationItemsCatalog> findByCategory(String category) {
        String sql = "SELECT item_id, item_name, category FROM donation_items_catalog WHERE category = ? ORDER BY item_name";
        List<DonationItemsCatalog> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation items by category", e);
        }
        return items;
    }

    private DonationItemsCatalog map(ResultSet rs) throws SQLException {
        DonationItemsCatalog item = new DonationItemsCatalog();
        item.setItemId(rs.getInt("item_id"));
        item.setItemName(rs.getString("item_name"));
        item.setCategory(rs.getString("category"));
        return item;
    }
}

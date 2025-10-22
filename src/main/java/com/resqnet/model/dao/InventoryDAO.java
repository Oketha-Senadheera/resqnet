package com.resqnet.model.dao;

import com.resqnet.model.Inventory;
import com.resqnet.model.InventoryWithDetails;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class InventoryDAO {

    public void upsertInventoryItem(int ngoId, int collectionPointId, int itemId, int quantityToAdd) {
        String checkSql = "SELECT inventory_id, quantity FROM inventory " +
                          "WHERE ngo_id = ? AND collection_point_id = ? AND item_id = ?";
        String insertSql = "INSERT INTO inventory(ngo_id, collection_point_id, item_id, quantity) VALUES(?,?,?,?)";
        String updateSql = "UPDATE inventory SET quantity = quantity + ? WHERE inventory_id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            // Check if item exists
            try (PreparedStatement ps = con.prepareStatement(checkSql)) {
                ps.setInt(1, ngoId);
                ps.setInt(2, collectionPointId);
                ps.setInt(3, itemId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Update existing
                        int inventoryId = rs.getInt("inventory_id");
                        try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                            updatePs.setInt(1, quantityToAdd);
                            updatePs.setInt(2, inventoryId);
                            updatePs.executeUpdate();
                        }
                    } else {
                        // Insert new
                        try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                            insertPs.setInt(1, ngoId);
                            insertPs.setInt(2, collectionPointId);
                            insertPs.setInt(3, itemId);
                            insertPs.setInt(4, quantityToAdd);
                            insertPs.executeUpdate();
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error upserting inventory item", e);
        }
    }

    public void updateQuantity(int inventoryId, int newQuantity) {
        String sql = "UPDATE inventory SET quantity = ? WHERE inventory_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newQuantity);
            ps.setInt(2, inventoryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating inventory quantity", e);
        }
    }

    public List<InventoryWithDetails> findByNgoId(int ngoId) {
        String sql = "SELECT i.inventory_id, i.ngo_id, i.collection_point_id, i.item_id, i.quantity, i.status, " +
                     "i.last_updated, cp.name as cp_name, dic.item_name, dic.category " +
                     "FROM inventory i " +
                     "JOIN collection_points cp ON i.collection_point_id = cp.collection_point_id " +
                     "JOIN donation_items_catalog dic ON i.item_id = dic.item_id " +
                     "WHERE i.ngo_id = ? ORDER BY dic.category, dic.item_name";
        List<InventoryWithDetails> inventory = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ngoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    inventory.add(mapWithDetails(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching inventory for NGO", e);
        }
        return inventory;
    }

    public Optional<Inventory> findByNgoCollectionPointAndItem(int ngoId, int collectionPointId, int itemId) {
        String sql = "SELECT inventory_id, ngo_id, collection_point_id, item_id, quantity, status, last_updated " +
                     "FROM inventory WHERE ngo_id = ? AND collection_point_id = ? AND item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ngoId);
            ps.setInt(2, collectionPointId);
            ps.setInt(3, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching inventory item", e);
        }
        return Optional.empty();
    }

    private Inventory map(ResultSet rs) throws SQLException {
        Inventory inv = new Inventory();
        inv.setInventoryId(rs.getInt("inventory_id"));
        inv.setNgoId(rs.getInt("ngo_id"));
        inv.setCollectionPointId(rs.getInt("collection_point_id"));
        inv.setItemId(rs.getInt("item_id"));
        inv.setQuantity(rs.getInt("quantity"));
        inv.setStatus(rs.getString("status"));
        inv.setLastUpdated(rs.getTimestamp("last_updated"));
        return inv;
    }

    private InventoryWithDetails mapWithDetails(ResultSet rs) throws SQLException {
        InventoryWithDetails inv = new InventoryWithDetails();
        inv.setInventoryId(rs.getInt("inventory_id"));
        inv.setNgoId(rs.getInt("ngo_id"));
        inv.setCollectionPointId(rs.getInt("collection_point_id"));
        inv.setCollectionPointName(rs.getString("cp_name"));
        inv.setItemId(rs.getInt("item_id"));
        inv.setItemName(rs.getString("item_name"));
        inv.setCategory(rs.getString("category"));
        inv.setQuantity(rs.getInt("quantity"));
        inv.setStatus(rs.getString("status"));
        inv.setLastUpdated(rs.getTimestamp("last_updated"));
        return inv;
    }
}

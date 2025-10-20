package com.resqnet.model.dao;

import com.resqnet.model.DonationRequestItem;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonationRequestItemDAO {

    public int create(DonationRequestItem item) {
        String sql = "INSERT INTO donation_request_items(request_id, item_id, quantity) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getRequestId());
            ps.setInt(2, item.getItemId());
            ps.setInt(3, item.getQuantity());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            throw new SQLException("Creating donation request item failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating donation request item", e);
        }
    }

    public void update(DonationRequestItem item) {
        String sql = "UPDATE donation_request_items SET item_id = ?, quantity = ? WHERE request_item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, item.getItemId());
            ps.setInt(2, item.getQuantity());
            ps.setInt(3, item.getRequestItemId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating donation request item", e);
        }
    }

    public void delete(int requestItemId) {
        String sql = "DELETE FROM donation_request_items WHERE request_item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestItemId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting donation request item", e);
        }
    }

    public List<DonationRequestItem> findByRequestId(int requestId) {
        String sql = "SELECT dri.request_item_id, dri.request_id, dri.item_id, dri.quantity, " +
                     "dic.item_name, dic.category " +
                     "FROM donation_request_items dri " +
                     "JOIN donation_items_catalog dic ON dri.item_id = dic.item_id " +
                     "WHERE dri.request_id = ?";
        List<DonationRequestItem> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    items.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching donation request items", e);
        }
        return items;
    }

    private DonationRequestItem map(ResultSet rs) throws SQLException {
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

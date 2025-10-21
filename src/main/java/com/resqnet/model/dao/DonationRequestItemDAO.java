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

    public void deleteByRequestId(int requestId) {
        String sql = "DELETE FROM donation_request_items WHERE request_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting donation request items", e);
        }
    }

    public List<DonationRequestItem> findByRequestId(int requestId) {
        String sql = "SELECT request_item_id, request_id, item_id, quantity FROM donation_request_items " +
                     "WHERE request_id = ?";
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
        return item;
    }
}

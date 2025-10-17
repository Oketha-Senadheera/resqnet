package com.resqnet.model.dao;

import com.resqnet.model.GramaNiladhari;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class GramaNiladhariDAO {

    public void create(GramaNiladhari gn) {
        String sql = "INSERT INTO grama_niladhari(user_id, name, contact_number, address, gn_division, service_number, gn_division_number) " +
                     "VALUES(?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, gn.getUserId());
            ps.setString(2, gn.getName());
            ps.setString(3, gn.getContactNumber());
            ps.setString(4, gn.getAddress());
            ps.setString(5, gn.getGnDivision());
            ps.setString(6, gn.getServiceNumber());
            ps.setString(7, gn.getGnDivisionNumber());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error creating grama niladhari", e);
        }
    }

    public Optional<GramaNiladhari> findByUserId(int userId) {
        String sql = "SELECT user_id, name, contact_number, address, gn_division, service_number, gn_division_number " +
                     "FROM grama_niladhari WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching grama niladhari", e);
        }
        return Optional.empty();
    }

    public List<GramaNiladhari> findAll() {
        List<GramaNiladhari> list = new ArrayList<>();
        String sql = "SELECT user_id, name, contact_number, address, gn_division, service_number, gn_division_number " +
                     "FROM grama_niladhari ORDER BY name";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all grama niladharis", e);
        }
        return list;
    }

    public boolean update(GramaNiladhari gn) {
        String sql = "UPDATE grama_niladhari SET name=?, contact_number=?, address=?, gn_division=?, " +
                     "service_number=?, gn_division_number=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, gn.getName());
            ps.setString(2, gn.getContactNumber());
            ps.setString(3, gn.getAddress());
            ps.setString(4, gn.getGnDivision());
            ps.setString(5, gn.getServiceNumber());
            ps.setString(6, gn.getGnDivisionNumber());
            ps.setInt(7, gn.getUserId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating grama niladhari", e);
        }
    }

    public boolean delete(int userId) {
        String sql = "DELETE FROM grama_niladhari WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting grama niladhari", e);
        }
    }

    private GramaNiladhari map(ResultSet rs) throws SQLException {
        GramaNiladhari gn = new GramaNiladhari();
        gn.setUserId(rs.getInt("user_id"));
        gn.setName(rs.getString("name"));
        gn.setContactNumber(rs.getString("contact_number"));
        gn.setAddress(rs.getString("address"));
        gn.setGnDivision(rs.getString("gn_division"));
        gn.setServiceNumber(rs.getString("service_number"));
        gn.setGnDivisionNumber(rs.getString("gn_division_number"));
        return gn;
    }
}

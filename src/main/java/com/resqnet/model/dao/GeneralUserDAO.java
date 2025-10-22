package com.resqnet.model.dao;

import com.resqnet.model.GeneralUser;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.Optional;

public class GeneralUserDAO {

    public void create(GeneralUser generalUser) {
        String sql = "INSERT INTO general_user(user_id, name, contact_number, house_no, street, city, district, gn_division, sms_alert) " +
                     "VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, generalUser.getUserId());
            ps.setString(2, generalUser.getName());
            ps.setString(3, generalUser.getContactNumber());
            ps.setString(4, generalUser.getHouseNo());
            ps.setString(5, generalUser.getStreet());
            ps.setString(6, generalUser.getCity());
            ps.setString(7, generalUser.getDistrict());
            ps.setString(8, generalUser.getGnDivision());
            ps.setBoolean(9, generalUser.isSmsAlert());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error creating general user", e);
        }
    }

    public Optional<GeneralUser> findByUserId(int userId) {
        String sql = "SELECT user_id, name, contact_number, house_no, street, city, district, gn_division, sms_alert " +
                     "FROM general_user WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching general user", e);
        }
        return Optional.empty();
    }

    public boolean delete(int userId) {
        String sql = "DELETE FROM general_user WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting general user", e);
        }
    }

    private GeneralUser map(ResultSet rs) throws SQLException {
        GeneralUser gu = new GeneralUser();
        gu.setUserId(rs.getInt("user_id"));
        gu.setName(rs.getString("name"));
        gu.setContactNumber(rs.getString("contact_number"));
        gu.setHouseNo(rs.getString("house_no"));
        gu.setStreet(rs.getString("street"));
        gu.setCity(rs.getString("city"));
        gu.setDistrict(rs.getString("district"));
        gu.setGnDivision(rs.getString("gn_division"));
        gu.setSmsAlert(rs.getBoolean("sms_alert"));
        return gu;
    }
}

package com.resqnet.model.dao;

import com.resqnet.model.NGO;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.Optional;

public class NGODAO {

    public void create(NGO ngo) {
        String sql = "INSERT INTO ngos(user_id, organization_name, registration_number, years_of_operation, address, " +
                     "contact_person_name, contact_person_telephone, contact_person_email) VALUES(?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ngo.getUserId());
            ps.setString(2, ngo.getOrganizationName());
            ps.setString(3, ngo.getRegistrationNumber());
            if (ngo.getYearsOfOperation() != null) {
                ps.setInt(4, ngo.getYearsOfOperation());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setString(5, ngo.getAddress());
            ps.setString(6, ngo.getContactPersonName());
            ps.setString(7, ngo.getContactPersonTelephone());
            ps.setString(8, ngo.getContactPersonEmail());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error creating NGO", e);
        }
    }

    public Optional<NGO> findByUserId(int userId) {
        String sql = "SELECT user_id, organization_name, registration_number, years_of_operation, address, " +
                     "contact_person_name, contact_person_telephone, contact_person_email FROM ngos WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching NGO", e);
        }
        return Optional.empty();
    }

    private NGO map(ResultSet rs) throws SQLException {
        NGO ngo = new NGO();
        ngo.setUserId(rs.getInt("user_id"));
        ngo.setOrganizationName(rs.getString("organization_name"));
        ngo.setRegistrationNumber(rs.getString("registration_number"));
        int years = rs.getInt("years_of_operation");
        if (!rs.wasNull()) {
            ngo.setYearsOfOperation(years);
        }
        ngo.setAddress(rs.getString("address"));
        ngo.setContactPersonName(rs.getString("contact_person_name"));
        ngo.setContactPersonTelephone(rs.getString("contact_person_telephone"));
        ngo.setContactPersonEmail(rs.getString("contact_person_email"));
        return ngo;
    }
}

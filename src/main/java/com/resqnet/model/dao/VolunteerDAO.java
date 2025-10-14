package com.resqnet.model.dao;

import com.resqnet.model.Volunteer;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerDAO {

    public void create(Volunteer volunteer) {
        String sql = "INSERT INTO volunteers(user_id, name, age, gender, contact_number, house_no, street, city, district, gn_division) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, volunteer.getUserId());
            ps.setString(2, volunteer.getName());
            if (volunteer.getAge() != null) {
                ps.setInt(3, volunteer.getAge());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            ps.setString(4, volunteer.getGender());
            ps.setString(5, volunteer.getContactNumber());
            ps.setString(6, volunteer.getHouseNo());
            ps.setString(7, volunteer.getStreet());
            ps.setString(8, volunteer.getCity());
            ps.setString(9, volunteer.getDistrict());
            ps.setString(10, volunteer.getGnDivision());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error creating volunteer", e);
        }
    }

    public Volunteer findByUserId(int userId) {
        String sql = "SELECT user_id, name, age, gender, contact_number, house_no, street, city, district, gn_division " +
                "FROM volunteers WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching volunteer", e);
        }
    }

    public void addSkills(int userId, List<String> skills) {
        if (skills == null || skills.isEmpty()) return;
        
        try (Connection con = DBConnection.getConnection()) {
            // First, ensure skills exist in skills table
            String insertSkillSql = "INSERT IGNORE INTO skills(skill_name) VALUES(?)";
            try (PreparedStatement ps = con.prepareStatement(insertSkillSql)) {
                for (String skill : skills) {
                    ps.setString(1, skill);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            
            // Then link skills to volunteer
            String linkSql = "INSERT INTO skills_volunteers(user_id, skill_id) " +
                    "SELECT ?, skill_id FROM skills WHERE skill_name = ?";
            try (PreparedStatement ps = con.prepareStatement(linkSql)) {
                for (String skill : skills) {
                    ps.setInt(1, userId);
                    ps.setString(2, skill);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding skills", e);
        }
    }

    public void addPreferences(int userId, List<String> preferences) {
        if (preferences == null || preferences.isEmpty()) return;
        
        try (Connection con = DBConnection.getConnection()) {
            // First, ensure preferences exist in volunteer_preferences table
            String insertPrefSql = "INSERT IGNORE INTO volunteer_preferences(preference_name) VALUES(?)";
            try (PreparedStatement ps = con.prepareStatement(insertPrefSql)) {
                for (String pref : preferences) {
                    ps.setString(1, pref);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            
            // Then link preferences to volunteer
            String linkSql = "INSERT INTO volunteer_preference_volunteers(user_id, preference_id) " +
                    "SELECT ?, preference_id FROM volunteer_preferences WHERE preference_name = ?";
            try (PreparedStatement ps = con.prepareStatement(linkSql)) {
                for (String pref : preferences) {
                    ps.setInt(1, userId);
                    ps.setString(2, pref);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding preferences", e);
        }
    }

    private Volunteer map(ResultSet rs) throws SQLException {
        Integer age = rs.getInt("age");
        if (rs.wasNull()) age = null;
        
        return new Volunteer(
                rs.getInt("user_id"),
                rs.getString("name"),
                age,
                rs.getString("gender"),
                rs.getString("contact_number"),
                rs.getString("house_no"),
                rs.getString("street"),
                rs.getString("city"),
                rs.getString("district"),
                rs.getString("gn_division")
        );
    }
}

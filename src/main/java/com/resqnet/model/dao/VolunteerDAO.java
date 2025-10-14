package com.resqnet.model.dao;

import com.resqnet.model.Volunteer;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class VolunteerDAO {

    public void create(Volunteer volunteer) {
        String sql = "INSERT INTO volunteers(user_id, name, age, gender, contact_number, house_no, street, city, district, gn_division) " +
                     "VALUES(?,?,?,?,?,?,?,?,?,?)";
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

    public void addSkill(int userId, String skillName) {
        try (Connection con = DBConnection.getConnection()) {
            // First, get or create the skill
            int skillId = getOrCreateSkillId(con, skillName);
            // Then link it to the volunteer
            String sql = "INSERT INTO skills_volunteers(user_id, skill_id) VALUES(?,?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, skillId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding skill to volunteer", e);
        }
    }

    public void addPreference(int userId, String preferenceName) {
        try (Connection con = DBConnection.getConnection()) {
            // First, get or create the preference
            int prefId = getOrCreatePreferenceId(con, preferenceName);
            // Then link it to the volunteer
            String sql = "INSERT INTO volunteer_preference_volunteers(user_id, preference_id) VALUES(?,?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, prefId);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding preference to volunteer", e);
        }
    }

    public Optional<Volunteer> findByUserId(int userId) {
        String sql = "SELECT user_id, name, age, gender, contact_number, house_no, street, city, district, gn_division " +
                     "FROM volunteers WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Volunteer v = map(rs);
                    v.setSkills(getSkillsForVolunteer(con, userId));
                    v.setPreferences(getPreferencesForVolunteer(con, userId));
                    return Optional.of(v);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching volunteer", e);
        }
        return Optional.empty();
    }

    private int getOrCreateSkillId(Connection con, String skillName) throws SQLException {
        // Try to find existing skill
        String selectSql = "SELECT skill_id FROM skills WHERE skill_name = ?";
        try (PreparedStatement ps = con.prepareStatement(selectSql)) {
            ps.setString(1, skillName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("skill_id");
                }
            }
        }
        // Create new skill
        String insertSql = "INSERT INTO skills(skill_name) VALUES(?)";
        try (PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, skillName);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create skill");
    }

    private int getOrCreatePreferenceId(Connection con, String preferenceName) throws SQLException {
        // Try to find existing preference
        String selectSql = "SELECT preference_id FROM volunteer_preferences WHERE preference_name = ?";
        try (PreparedStatement ps = con.prepareStatement(selectSql)) {
            ps.setString(1, preferenceName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("preference_id");
                }
            }
        }
        // Create new preference
        String insertSql = "INSERT INTO volunteer_preferences(preference_name) VALUES(?)";
        try (PreparedStatement ps = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, preferenceName);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Failed to create preference");
    }

    private List<String> getSkillsForVolunteer(Connection con, int userId) throws SQLException {
        List<String> skills = new ArrayList<>();
        String sql = "SELECT s.skill_name FROM skills s " +
                     "JOIN skills_volunteers sv ON s.skill_id = sv.skill_id " +
                     "WHERE sv.user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skills.add(rs.getString("skill_name"));
                }
            }
        }
        return skills;
    }

    private List<String> getPreferencesForVolunteer(Connection con, int userId) throws SQLException {
        List<String> preferences = new ArrayList<>();
        String sql = "SELECT vp.preference_name FROM volunteer_preferences vp " +
                     "JOIN volunteer_preference_volunteers vpv ON vp.preference_id = vpv.preference_id " +
                     "WHERE vpv.user_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    preferences.add(rs.getString("preference_name"));
                }
            }
        }
        return preferences;
    }

    private Volunteer map(ResultSet rs) throws SQLException {
        Volunteer v = new Volunteer();
        v.setUserId(rs.getInt("user_id"));
        v.setName(rs.getString("name"));
        int age = rs.getInt("age");
        if (!rs.wasNull()) {
            v.setAge(age);
        }
        v.setGender(rs.getString("gender"));
        v.setContactNumber(rs.getString("contact_number"));
        v.setHouseNo(rs.getString("house_no"));
        v.setStreet(rs.getString("street"));
        v.setCity(rs.getString("city"));
        v.setDistrict(rs.getString("district"));
        v.setGnDivision(rs.getString("gn_division"));
        return v;
    }
}

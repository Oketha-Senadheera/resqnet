package com.resqnet.model.dao;

import com.resqnet.model.User;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.Optional;

public class UserDAO {

    public Optional<User> findByEmail(String email) {
        String sql = "SELECT user_id, username, email, password_hash, role FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user", e);
        }
        return Optional.empty();
    }
    
    public Optional<User> findByUsername(String username) {
        String sql = "SELECT user_id, username, email, password_hash, role FROM users WHERE username = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user", e);
        }
        return Optional.empty();
    }
    
    public Optional<User> findById(int userId) {
        String sql = "SELECT user_id, username, email, password_hash, role FROM users WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching user", e);
        }
        return Optional.empty();
    }

    public int create(User user) {
        String sql = "INSERT INTO users(username, email, password_hash, role) VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name().toLowerCase());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int id = keys.getInt(1);
                    user.setId(id);
                    return id;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating user", e);
        }
        return 0;
    }

    public boolean updatePassword(int userId, String newHash) {
        String sql = "UPDATE users SET password_hash=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating password", e);
        }
    }

    public String createResetToken(int userId, long ttlMinutes) {
        String token = java.util.UUID.randomUUID().toString().replaceAll("-", "");
        String sql = "INSERT INTO password_reset_tokens(token,user_id,expires_at) VALUES(?,?,DATE_ADD(NOW(), INTERVAL ? MINUTE))";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setInt(2, userId);
            ps.setLong(3, ttlMinutes);
            ps.executeUpdate();
            return token;
        } catch (SQLException e) {
            throw new RuntimeException("Error creating reset token", e);
        }
    }

    public Optional<Integer> validateResetToken(String token) {
        String sql = "SELECT user_id FROM password_reset_tokens WHERE token=? AND used=0 AND expires_at > NOW()";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(rs.getInt(1));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error validating token", e);
        }
        return Optional.empty();
    }

    public void markTokenUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used=1 WHERE token=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error marking token used", e);
        }
    }

    private User map(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("password_hash"),
                rs.getString("role")
        );
    }
}

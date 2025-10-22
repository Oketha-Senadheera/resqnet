package com.resqnet.model.dao;

import com.resqnet.model.CollectionPoint;
import com.resqnet.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class CollectionPointDAO {

    public int create(CollectionPoint collectionPoint) {
        String sql = "INSERT INTO collection_points(ngo_id, name, location_landmark, full_address, " +
                     "contact_person, contact_number) VALUES(?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, collectionPoint.getNgoId());
            ps.setString(2, collectionPoint.getName());
            ps.setString(3, collectionPoint.getLocationLandmark());
            ps.setString(4, collectionPoint.getFullAddress());
            ps.setString(5, collectionPoint.getContactPerson());
            ps.setString(6, collectionPoint.getContactNumber());
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            throw new SQLException("Creating collection point failed, no ID obtained.");
        } catch (SQLException e) {
            throw new RuntimeException("Error creating collection point", e);
        }
    }

    public void update(CollectionPoint collectionPoint) {
        String sql = "UPDATE collection_points SET name = ?, location_landmark = ?, full_address = ?, " +
                     "contact_person = ?, contact_number = ? WHERE collection_point_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, collectionPoint.getName());
            ps.setString(2, collectionPoint.getLocationLandmark());
            ps.setString(3, collectionPoint.getFullAddress());
            ps.setString(4, collectionPoint.getContactPerson());
            ps.setString(5, collectionPoint.getContactNumber());
            ps.setInt(6, collectionPoint.getCollectionPointId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating collection point", e);
        }
    }

    public void delete(int collectionPointId) {
        String sql = "DELETE FROM collection_points WHERE collection_point_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, collectionPointId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting collection point", e);
        }
    }

    public Optional<CollectionPoint> findById(int collectionPointId) {
        String sql = "SELECT collection_point_id, ngo_id, name, location_landmark, full_address, " +
                     "contact_person, contact_number FROM collection_points WHERE collection_point_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, collectionPointId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching collection point", e);
        }
        return Optional.empty();
    }

    public List<CollectionPoint> findByNgoId(int ngoId) {
        String sql = "SELECT collection_point_id, ngo_id, name, location_landmark, full_address, " +
                     "contact_person, contact_number FROM collection_points WHERE ngo_id = ? ORDER BY name";
        List<CollectionPoint> collectionPoints = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ngoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    collectionPoints.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching collection points for NGO", e);
        }
        return collectionPoints;
    }

    public List<CollectionPoint> findAll() {
        String sql = "SELECT collection_point_id, ngo_id, name, location_landmark, full_address, " +
                     "contact_person, contact_number FROM collection_points ORDER BY name";
        List<CollectionPoint> collectionPoints = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    collectionPoints.add(map(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all collection points", e);
        }
        return collectionPoints;
    }

    private CollectionPoint map(ResultSet rs) throws SQLException {
        CollectionPoint cp = new CollectionPoint();
        cp.setCollectionPointId(rs.getInt("collection_point_id"));
        cp.setNgoId(rs.getInt("ngo_id"));
        cp.setName(rs.getString("name"));
        cp.setLocationLandmark(rs.getString("location_landmark"));
        cp.setFullAddress(rs.getString("full_address"));
        cp.setContactPerson(rs.getString("contact_person"));
        cp.setContactNumber(rs.getString("contact_number"));
        return cp;
    }
}

package com.resqnet.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;


public class DBConnection {
    // Hardcoded DigitalOcean Managed MySQL credentials (requested). WARNING: Don't commit real secrets in production.
    private static final String HOST = Env.get("DB_HOST");
    private static final String PORT = Env.get("DB_PORT");
    private static final String DB = Env.get("DB_NAME");
    private static final String SSL_MODE = Env.get("DB_SSL_MODE");
    private static final String USER = Env.get("DB_USER");
    private static final String PASS = Env.get("DB_PASS");
    private static final String URL = String.format(
            "jdbc:mysql://%s:%s/%s?sslMode=%s&serverTimezone=UTC", HOST, PORT, DB, SSL_MODE);

    static {
        try {
            // Driver auto registers via SPI since Connector/J 8+, but explicit load is fine
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        // Check if required properties are set
        if (USER == null || USER.isEmpty()) {
            throw new SQLException("Database user (DB_USER) is not configured. Please set environment variable or add to application.properties");
        }
        if (PASS == null) {
            throw new SQLException("Database password (DB_PASS) is not configured. Please set environment variable or add to application.properties");
        }
        if (HOST == null || HOST.isEmpty()) {
            throw new SQLException("Database host (DB_HOST) is not configured. Please set environment variable or add to application.properties");
        }
        
        Properties props = new Properties();
        props.setProperty("user", USER);
        props.setProperty("password", PASS);
        // Optional fallback properties
        props.setProperty("characterEncoding", "UTF-8");
        return DriverManager.getConnection(URL, props);
    }

    // Removed getenv usage since values are hardcoded.
}

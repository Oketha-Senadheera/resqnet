package com.resqnet.model;

public class User {
    private int userId;
    private String username;
    private String email;
    private String passwordHash;
    private Role role; // ENUM based role

    public User() {}
    public User(int userId, String username, String email, String passwordHash, String role) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role == null ? null : Role.valueOf(role.toUpperCase());
    }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
    public void setRole(String role) { this.role = role == null ? null : Role.valueOf(role.toUpperCase()); }
    public boolean hasRole(Role r) { return r != null && r == role; }
    public boolean hasRole(String r) { return r != null && role != null && role.name().equalsIgnoreCase(r); }
}

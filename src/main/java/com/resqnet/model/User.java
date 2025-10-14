package com.resqnet.model;

public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private Role role;

    public User() {}
    
    public User(int id, String username, String email, String passwordHash, String role) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role == null ? null : Role.valueOf(role.toUpperCase());
    }
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }
    
    public boolean isGeneral() { return hasRole(Role.GENERAL); }
    public boolean isVolunteer() { return hasRole(Role.VOLUNTEER); }
    public boolean isNGO() { return hasRole(Role.NGO); }
    public boolean isGramaNiladhari() { return hasRole(Role.GRAMA_NILADHARI); }
    public boolean isDMC() { return hasRole(Role.DMC); }
    
    public boolean hasRole(Role r) { return r != null && r == role; }
    public boolean hasRole(String r) { return r != null && role != null && role.name().equalsIgnoreCase(r); }
}

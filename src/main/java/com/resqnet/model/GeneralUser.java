package com.resqnet.model;

public class GeneralUser {
    private int userId;
    private String name;
    private String contactNumber;
    private String houseNo;
    private String street;
    private String city;
    private String district;
    private String gnDivision;
    private boolean smsAlert;

    public GeneralUser() {}

    public GeneralUser(int userId, String name, String contactNumber, String houseNo, 
                      String street, String city, String district, String gnDivision, boolean smsAlert) {
        this.userId = userId;
        this.name = name;
        this.contactNumber = contactNumber;
        this.houseNo = houseNo;
        this.street = street;
        this.city = city;
        this.district = district;
        this.gnDivision = gnDivision;
        this.smsAlert = smsAlert;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }
    public String getHouseNo() { return houseNo; }
    public void setHouseNo(String houseNo) { this.houseNo = houseNo; }
    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }
    public String getGnDivision() { return gnDivision; }
    public void setGnDivision(String gnDivision) { this.gnDivision = gnDivision; }
    public boolean isSmsAlert() { return smsAlert; }
    public void setSmsAlert(boolean smsAlert) { this.smsAlert = smsAlert; }
}

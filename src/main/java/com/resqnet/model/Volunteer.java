package com.resqnet.model;

import java.util.List;

public class Volunteer {
    private int userId;
    private String name;
    private Integer age;
    private String gender;
    private String contactNumber;
    private String houseNo;
    private String street;
    private String city;
    private String district;
    private String gnDivision;
    private List<String> skills;
    private List<String> preferences;

    public Volunteer() {}

    public Volunteer(int userId, String name, Integer age, String gender, String contactNumber,
                    String houseNo, String street, String city, String district, String gnDivision) {
        this.userId = userId;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.contactNumber = contactNumber;
        this.houseNo = houseNo;
        this.street = street;
        this.city = city;
        this.district = district;
        this.gnDivision = gnDivision;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
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
    public List<String> getSkills() { return skills; }
    public void setSkills(List<String> skills) { this.skills = skills; }
    public List<String> getPreferences() { return preferences; }
    public void setPreferences(List<String> preferences) { this.preferences = preferences; }
}

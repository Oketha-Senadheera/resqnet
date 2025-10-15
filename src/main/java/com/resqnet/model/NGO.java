package com.resqnet.model;

public class NGO {
    private int userId;
    private String organizationName;
    private String registrationNumber;
    private Integer yearsOfOperation;
    private String address;
    private String contactPersonName;
    private String contactPersonTelephone;
    private String contactPersonEmail;

    public NGO() {}

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getOrganizationName() { return organizationName; }
    public void setOrganizationName(String organizationName) { this.organizationName = organizationName; }

    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }

    public Integer getYearsOfOperation() { return yearsOfOperation; }
    public void setYearsOfOperation(Integer yearsOfOperation) { this.yearsOfOperation = yearsOfOperation; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactPersonName() { return contactPersonName; }
    public void setContactPersonName(String contactPersonName) { this.contactPersonName = contactPersonName; }

    public String getContactPersonTelephone() { return contactPersonTelephone; }
    public void setContactPersonTelephone(String contactPersonTelephone) { this.contactPersonTelephone = contactPersonTelephone; }

    public String getContactPersonEmail() { return contactPersonEmail; }
    public void setContactPersonEmail(String contactPersonEmail) { this.contactPersonEmail = contactPersonEmail; }
}

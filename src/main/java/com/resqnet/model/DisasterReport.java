package com.resqnet.model;

import java.sql.Timestamp;

public class DisasterReport {
    private Integer reportId;
    private Integer userId;
    private String reporterName;
    private String contactNumber;
    private String disasterType;  // Flood, Landslide, Fire, Earthquake, Tsunami, Other
    private String otherDisasterType;
    private Timestamp disasterDatetime;
    private String location;
    private String proofImagePath;
    private Boolean confirmation;
    private String status;  // Pending, Approved, Rejected
    private String description;
    private Timestamp submittedAt;
    private Timestamp verifiedAt;

    public DisasterReport() {
    }

    public Integer getReportId() {
        return reportId;
    }

    public void setReportId(Integer reportId) {
        this.reportId = reportId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getReporterName() {
        return reporterName;
    }

    public void setReporterName(String reporterName) {
        this.reporterName = reporterName;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getDisasterType() {
        return disasterType;
    }

    public void setDisasterType(String disasterType) {
        this.disasterType = disasterType;
    }

    public String getOtherDisasterType() {
        return otherDisasterType;
    }

    public void setOtherDisasterType(String otherDisasterType) {
        this.otherDisasterType = otherDisasterType;
    }

    public Timestamp getDisasterDatetime() {
        return disasterDatetime;
    }

    public void setDisasterDatetime(Timestamp disasterDatetime) {
        this.disasterDatetime = disasterDatetime;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getProofImagePath() {
        return proofImagePath;
    }

    public void setProofImagePath(String proofImagePath) {
        this.proofImagePath = proofImagePath;
    }

    public Boolean getConfirmation() {
        return confirmation;
    }

    public void setConfirmation(Boolean confirmation) {
        this.confirmation = confirmation;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }

    public Timestamp getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(Timestamp verifiedAt) {
        this.verifiedAt = verifiedAt;
    }
}

package com.resqnet.model;

import java.sql.Timestamp;

public class DonationRequest {
    private Integer requestId;
    private Integer userId;
    private String reliefCenterName;
    private String status;  // Pending, Verified, Approved, Rejected
    private String specialNotes;
    private Timestamp submittedAt;
    private Timestamp approvedAt;

    public DonationRequest() {
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getReliefCenterName() {
        return reliefCenterName;
    }

    public void setReliefCenterName(String reliefCenterName) {
        this.reliefCenterName = reliefCenterName;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSpecialNotes() {
        return specialNotes;
    }

    public void setSpecialNotes(String specialNotes) {
        this.specialNotes = specialNotes;
    }

    public Timestamp getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }


    public Timestamp getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
}

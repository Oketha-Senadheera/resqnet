package com.resqnet.model;

import java.sql.Timestamp;

public class DonationRequest {
    private int requestId;
    private int userId;
    private String reliefCenterName;
    private Integer gnId;
    private String status; // Pending, Approved
    private String specialNotes;
    private Timestamp submittedAt;
    private Timestamp approvedAt;

    public DonationRequest() {}

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getReliefCenterName() { return reliefCenterName; }
    public void setReliefCenterName(String reliefCenterName) { this.reliefCenterName = reliefCenterName; }

    public Integer getGnId() { return gnId; }
    public void setGnId(Integer gnId) { this.gnId = gnId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSpecialNotes() { return specialNotes; }
    public void setSpecialNotes(String specialNotes) { this.specialNotes = specialNotes; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }

    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }
}

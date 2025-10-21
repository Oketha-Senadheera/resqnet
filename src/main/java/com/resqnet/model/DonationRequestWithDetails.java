package com.resqnet.model;

import java.sql.Timestamp;
import java.util.List;

/**
 * Data Transfer Object for donation requests with all related information
 */
public class DonationRequestWithDetails {
    private int requestId;
    private int userId;
    private String userName;
    private String userContact;
    private String reliefCenterName;
    private Integer gnId;
    private String gnName;
    private String status;
    private String specialNotes;
    private Timestamp submittedAt;
    private Timestamp approvedAt;
    private List<DonationRequestItemDetail> items;

    public DonationRequestWithDetails() {}

    // Inner class for item details
    public static class DonationRequestItemDetail {
        private int itemId;
        private String itemName;
        private String category;
        private int quantity;

        public DonationRequestItemDetail() {}

        public int getItemId() { return itemId; }
        public void setItemId(int itemId) { this.itemId = itemId; }

        public String getItemName() { return itemName; }
        public void setItemName(String itemName) { this.itemName = itemName; }

        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
    }

    // Getters and setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserContact() { return userContact; }
    public void setUserContact(String userContact) { this.userContact = userContact; }

    public String getReliefCenterName() { return reliefCenterName; }
    public void setReliefCenterName(String reliefCenterName) { this.reliefCenterName = reliefCenterName; }

    public Integer getGnId() { return gnId; }
    public void setGnId(Integer gnId) { this.gnId = gnId; }

    public String getGnName() { return gnName; }
    public void setGnName(String gnName) { this.gnName = gnName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getSpecialNotes() { return specialNotes; }
    public void setSpecialNotes(String specialNotes) { this.specialNotes = specialNotes; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }

    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }

    public List<DonationRequestItemDetail> getItems() { return items; }
    public void setItems(List<DonationRequestItemDetail> items) { this.items = items; }
}

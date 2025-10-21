package com.resqnet.model;

import java.sql.Timestamp;
import java.util.List;

public class DonationRequestWithItems {
    private Integer requestId;
    private Integer userId;
    private String userName;
    private String userContact;
    private String reliefCenterName;
    private String gnName;
    private String status;
    private String specialNotes;
    private Timestamp submittedAt;
    private Timestamp approvedAt;
    private List<DonationRequestItemDetail> items;

    public DonationRequestWithItems() {
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserContact() {
        return userContact;
    }

    public void setUserContact(String userContact) {
        this.userContact = userContact;
    }

    public String getReliefCenterName() {
        return reliefCenterName;
    }

    public void setReliefCenterName(String reliefCenterName) {
        this.reliefCenterName = reliefCenterName;
    }

    public String getGnName() {
        return gnName;
    }

    public void setGnName(String gnName) {
        this.gnName = gnName;
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

    public List<DonationRequestItemDetail> getItems() {
        return items;
    }

    public void setItems(List<DonationRequestItemDetail> items) {
        this.items = items;
    }

    public static class DonationRequestItemDetail {
        private String itemName;
        private String category;
        private Integer quantity;

        public DonationRequestItemDetail() {
        }

        public String getItemName() {
            return itemName;
        }

        public void setItemName(String itemName) {
            this.itemName = itemName;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public Integer getQuantity() {
            return quantity;
        }

        public void setQuantity(Integer quantity) {
            this.quantity = quantity;
        }
    }
}

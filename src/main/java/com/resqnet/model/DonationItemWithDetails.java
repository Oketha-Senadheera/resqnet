package com.resqnet.model;

public class DonationItemWithDetails {
    private Integer donationItemId;
    private Integer donationId;
    private Integer itemId;
    private String itemName;
    private String category;
    private Integer quantity;

    public DonationItemWithDetails() {
    }

    public Integer getDonationItemId() {
        return donationItemId;
    }

    public void setDonationItemId(Integer donationItemId) {
        this.donationItemId = donationItemId;
    }

    public Integer getDonationId() {
        return donationId;
    }

    public void setDonationId(Integer donationId) {
        this.donationId = donationId;
    }

    public Integer getItemId() {
        return itemId;
    }

    public void setItemId(Integer itemId) {
        this.itemId = itemId;
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

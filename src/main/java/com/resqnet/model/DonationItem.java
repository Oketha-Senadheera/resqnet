package com.resqnet.model;

public class DonationItem {
    private Integer donationItemId;
    private Integer donationId;
    private Integer itemId;
    private Integer quantity;

    public DonationItem() {
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

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}

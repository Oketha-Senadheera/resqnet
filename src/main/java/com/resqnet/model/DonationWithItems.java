package com.resqnet.model;

import java.util.List;

public class DonationWithItems {
    private Donation donation;
    private List<DonationItemWithDetails> items;
    private String collectionPointName;
    private String collectionPointAddress;

    public DonationWithItems() {
    }

    public Donation getDonation() {
        return donation;
    }

    public void setDonation(Donation donation) {
        this.donation = donation;
    }

    public List<DonationItemWithDetails> getItems() {
        return items;
    }

    public void setItems(List<DonationItemWithDetails> items) {
        this.items = items;
    }

    public String getCollectionPointName() {
        return collectionPointName;
    }

    public void setCollectionPointName(String collectionPointName) {
        this.collectionPointName = collectionPointName;
    }

    public String getCollectionPointAddress() {
        return collectionPointAddress;
    }

    public void setCollectionPointAddress(String collectionPointAddress) {
        this.collectionPointAddress = collectionPointAddress;
    }
}

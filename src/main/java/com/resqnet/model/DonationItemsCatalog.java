package com.resqnet.model;

public class DonationItemsCatalog {
    private int itemId;
    private String itemName;
    private String category; // Medicine, Food, Shelter

    public DonationItemsCatalog() {}

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}

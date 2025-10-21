package com.resqnet.model;

public class DonationItemsCatalog {
    private Integer itemId;
    private String itemName;
    private String category;  // Medicine, Food, Shelter

    public DonationItemsCatalog() {
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
}

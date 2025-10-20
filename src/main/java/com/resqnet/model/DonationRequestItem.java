package com.resqnet.model;

public class DonationRequestItem {
    private Integer requestItemId;
    private Integer requestId;
    private Integer itemId;
    private Integer quantity;
    
    // Additional fields for display purposes
    private String itemName;
    private String category;

    public DonationRequestItem() {
    }

    public Integer getRequestItemId() {
        return requestItemId;
    }

    public void setRequestItemId(Integer requestItemId) {
        this.requestItemId = requestItemId;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
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

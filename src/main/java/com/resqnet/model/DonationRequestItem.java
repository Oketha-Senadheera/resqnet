package com.resqnet.model;

public class DonationRequestItem {
    private int requestItemId;
    private int requestId;
    private int itemId;
    private int quantity;

    public DonationRequestItem() {}

    public int getRequestItemId() { return requestItemId; }
    public void setRequestItemId(int requestItemId) { this.requestItemId = requestItemId; }

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}

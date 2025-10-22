package com.resqnet.model;

import java.sql.Timestamp;

public class Inventory {
    private Integer inventoryId;
    private Integer ngoId;
    private Integer collectionPointId;
    private Integer itemId;
    private Integer quantity;
    private String status;  // In Stock, Low on Stock, Out of Stock (computed)
    private Timestamp lastUpdated;

    public Inventory() {
    }

    public Integer getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(Integer inventoryId) {
        this.inventoryId = inventoryId;
    }

    public Integer getNgoId() {
        return ngoId;
    }

    public void setNgoId(Integer ngoId) {
        this.ngoId = ngoId;
    }

    public Integer getCollectionPointId() {
        return collectionPointId;
    }

    public void setCollectionPointId(Integer collectionPointId) {
        this.collectionPointId = collectionPointId;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(Timestamp lastUpdated) {
        this.lastUpdated = lastUpdated;
    }
}

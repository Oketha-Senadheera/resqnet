package com.resqnet.model;

import java.sql.Timestamp;

public class InventoryWithDetails {
    private Integer inventoryId;
    private Integer ngoId;
    private Integer collectionPointId;
    private String collectionPointName;
    private Integer itemId;
    private String itemName;
    private String category;
    private Integer quantity;
    private String status;
    private Timestamp lastUpdated;

    public InventoryWithDetails() {
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

    public String getCollectionPointName() {
        return collectionPointName;
    }

    public void setCollectionPointName(String collectionPointName) {
        this.collectionPointName = collectionPointName;
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

package com.resqnet.model;

public class CollectionPoint {
    private Integer collectionPointId;
    private Integer ngoId;
    private String name;
    private String locationLandmark;
    private String fullAddress;
    private String contactPerson;
    private String contactNumber;

    public CollectionPoint() {
    }

    public Integer getCollectionPointId() {
        return collectionPointId;
    }

    public void setCollectionPointId(Integer collectionPointId) {
        this.collectionPointId = collectionPointId;
    }

    public Integer getNgoId() {
        return ngoId;
    }

    public void setNgoId(Integer ngoId) {
        this.ngoId = ngoId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocationLandmark() {
        return locationLandmark;
    }

    public void setLocationLandmark(String locationLandmark) {
        this.locationLandmark = locationLandmark;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

    public String getContactPerson() {
        return contactPerson;
    }

    public void setContactPerson(String contactPerson) {
        this.contactPerson = contactPerson;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }
}

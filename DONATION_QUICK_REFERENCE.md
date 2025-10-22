# Donation Management System - Quick Reference

## URLs

### General User
- `/general/make-donation` - Make a donation form
- `/general/donations/list` - View my donations
- `/general/make-donation/submit` - Submit donation (POST)
- `/general/donations/cancel` - Cancel donation (POST)

### NGO
- `/ngo/donations` - View all donations
- `/ngo/donations/mark-received` - Mark as received (POST)
- `/ngo/manage-inventory` - View/manage inventory
- `/ngo/inventory/update` - Update quantity (POST)

## Database Tables

### donations
```sql
donation_id, user_id, collection_point_id, name, contact_number, email, 
address, collection_date, time_slot, special_notes, confirmation, status,
submitted_at, received_at, cancelled_at, delivered_at
```

### donation_items
```sql
donation_item_id, donation_id, item_id, quantity
```

### inventory
```sql
inventory_id, ngo_id, collection_point_id, item_id, quantity, 
status (computed), last_updated
```

### donation_items_catalog
```sql
item_id, item_name, category (Medicine/Food/Shelter)
```

## Status Flow

```
General User View          NGO View              Inventory
─────────────────────────────────────────────────────────
Submitted → Pending        Pending               No change
                              ↓
                           [Mark as Received]
                              ↓
            Delivered      Received              Updated (+quantity)
                              ↓
User can:   [View]        [View History]         [View/Update]
            [Cancel]
```

## Key Methods

### DonationDAO
```java
int create(Donation)
void updateStatus(int donationId, String status)
List<Donation> findByUserId(int userId)
List<DonationWithItems> findByNgoId(int ngoId)
DonationWithItems findWithItemsById(int donationId)
```

### InventoryDAO
```java
void upsertInventoryItem(int ngoId, int cpId, int itemId, int qtyToAdd)
void updateQuantity(int inventoryId, int newQuantity)
List<InventoryWithDetails> findByNgoId(int ngoId)
```

### DonationItemDAO
```java
int create(DonationItem)
List<DonationItem> findByDonationId(int donationId)
```

## Request Parameters

### Make Donation Form
```
donorName, donorContact, donorEmail, donorAddress
collectionPoint (collection_point_id)
collectionDate (yyyy-MM-dd)
timeSlot (9am–12pm | 12pm–4pm | 6pm–9pm)
itemId[] (array of item IDs)
quantity[] (array of quantities)
specialNotes (optional)
confirmation (checkbox, must be checked)
```

### Mark as Received
```
donationId
```

### Update Inventory
```
inventoryId
quantity
```

### Cancel Donation
```
donationId
```

## JSP Includes

### General User Make Donation
```jsp
${collectionPoints} - List<CollectionPoint>
${itemsCatalog} - List<DonationItemsCatalog>
${generalUser} - GeneralUser (for autofill)
```

### General User Donations List
```jsp
${donations} - List<Donation>
```

### NGO Donations
```jsp
${donations} - List<DonationWithItems>
```

### NGO Inventory
```jsp
${inventory} - List<InventoryWithDetails>
${collectionPoints} - List<CollectionPoint>
```

## Common Snippets

### Check if user can cancel donation
```jsp
<c:if test="${donation.status == 'Pending'}">
  <button>Cancel</button>
</c:if>
```

### Display status badge
```jsp
<span class="status-badge ${donation.status.toLowerCase()}">
  <c:choose>
    <c:when test="${donation.status == 'Received'}">Delivered</c:when>
    <c:otherwise>${donation.status}</c:otherwise>
  </c:choose>
</span>
```

### Filter donations by status in JSP
```jsp
<c:forEach items="${donations}" var="donation">
  <c:if test="${donation.donation.status == 'Pending'}">
    <!-- Show pending donation -->
  </c:if>
</c:forEach>
```

## Testing Queries

### Get all pending donations for NGO ID 1
```sql
SELECT d.* FROM donations d
JOIN collection_points cp ON d.collection_point_id = cp.collection_point_id
WHERE cp.ngo_id = 1 AND d.status = 'Pending';
```

### Get inventory summary for NGO ID 1
```sql
SELECT i.*, dic.item_name, dic.category, cp.name as cp_name
FROM inventory i
JOIN donation_items_catalog dic ON i.item_id = dic.item_id
JOIN collection_points cp ON i.collection_point_id = cp.collection_point_id
WHERE i.ngo_id = 1;
```

### Get donation with items
```sql
SELECT d.*, di.quantity, dic.item_name
FROM donations d
JOIN donation_items di ON d.donation_id = di.donation_id
JOIN donation_items_catalog dic ON di.item_id = dic.item_id
WHERE d.donation_id = ?;
```

## Troubleshooting

### Donation not showing for NGO
- Check if collection point belongs to the NGO
- Verify donation status is not 'Cancelled'

### Inventory not updating
- Verify donation was marked as 'Received'
- Check logs for InventoryDAO.upsertInventoryItem errors
- Verify item_id exists in catalog

### Form submission fails
- Check all required fields are filled
- Verify at least one item is selected with quantity > 0
- Ensure confirmation checkbox is checked
- Check collection_point_id exists

### Status showing incorrectly
- For general users: 'Received' should display as 'Delivered'
- Verify status logic in JSP view
- Check DonationDAO.updateStatus is setting both received_at and delivered_at

## Performance Tips

1. Use pagination for large donation lists
2. Add indexes on:
   - donations.user_id
   - donations.collection_point_id
   - donations.status
   - inventory.ngo_id
3. Cache donation_items_catalog (rarely changes)
4. Consider archiving old donations after 1 year

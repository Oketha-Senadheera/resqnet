# Donation and Inventory Management System - Database Setup

## Database Schema

### New Tables Created

1. **donations** - Stores donation submissions from general users
2. **donation_items** - Stores items in each donation
3. **inventory** - Maintains NGO's stock of received items
4. **donation_inventory_log** - Tracks donation to inventory updates (optional traceability)

## Setup Instructions

### 1. Create Database Schema

Run the main schema file to create all tables:

```sql
mysql -u root -p resqnet < src/main/resources/db/migration/resqnet_schema.sql
```

### 2. Seed Donation Items Catalog

To populate the donation items catalog with sample items:

```sql
mysql -u root -p resqnet < src/main/resources/db/migration/donation_items_seed.sql
```

This will insert 18 items across 3 categories:
- **Medicine**: Amoxicillin, Bandages, Paracetamol, Aspirin, Mosquito Repellent, Alcohol Swabs
- **Food**: Rice, Dhal, Canned Fish, Drinking Water, Instant Noodles, Biscuits
- **Shelter**: Blankets, Towels, Soap, Basic Clothing, Baby Diapers, Disinfectant

## Workflow

### General User Flow
1. User navigates to "Make a Donation" page
2. Form auto-fills user details (name, contact, email, address)
3. User selects a collection point from dropdown (shows ALL collection points)
4. User selects collection date and time slot
5. User selects items and quantities from the catalog
6. User submits donation
7. Donation status: **Pending**

### NGO Flow
1. NGO navigates to "Donations" page
2. Views donations filtered by their collection points
3. Donations organized by status tabs: Pending, Received, Cancelled
4. For pending donations, NGO clicks "Mark as Received" button
5. System updates:
   - Donation status: **Received**
   - Inventory is automatically updated with donated items
   - For general user, status appears as **Delivered**

### Inventory Management
1. NGO navigates to "Manage Inventory" page
2. Views all inventory items grouped by collection point
3. Can filter by:
   - Item name (search)
   - Category (Medicine/Food/Shelter)
   - Collection Point
   - Status (In Stock/Low on Stock/Out of Stock)
4. Can update quantities manually
5. Status auto-calculated:
   - **Out of Stock**: quantity = 0
   - **Low on Stock**: quantity < 20
   - **In Stock**: quantity >= 20

## Status Flow

### Donation Status States
- **Pending**: Initial state after submission
- **Received**: NGO has received the donation (shown as "Delivered" to general user)
- **Cancelled**: User cancelled before NGO received it

### Important Notes
- When NGO marks as "Received", it becomes "Delivered" for the general user
- Inventory is automatically updated when donation is marked as received
- Each item in inventory is unique per (NGO, Collection Point, Item) combination
- Quantities are cumulative - new donations add to existing inventory

## Testing the System

### Prerequisites
1. Have at least one NGO account created
2. Have at least one general user account created
3. Have at least one collection point created for the NGO
4. Run the donation_items_seed.sql to populate the catalog

### Test Scenario
1. Login as general user
2. Click "Make a Donation"
3. Fill in the form and select items
4. Submit donation
5. View in "My Donations" - status should be "Pending"
6. Logout and login as NGO
7. Click "Donations" in sidebar
8. See the pending donation in the "Pending" tab
9. Click "Mark as Received"
10. Verify:
    - Donation moves to "Received" tab
    - Click "Manage Inventory" to see updated quantities
11. Logout and login as general user again
12. View "My Donations" - status should now be "Delivered"

## API Endpoints

### General User
- `GET /general/make-donation` - Display donation form
- `POST /general/make-donation/submit` - Submit new donation
- `GET /general/donations/list` - View user's donations
- `POST /general/donations/cancel` - Cancel a donation

### NGO
- `GET /ngo/donations` - View donations by status
- `POST /ngo/donations/mark-received` - Mark donation as received
- `GET /ngo/manage-inventory` - View inventory
- `POST /ngo/inventory/update` - Update inventory quantity

## Database Queries

### Get all pending donations for an NGO
```sql
SELECT d.*, cp.name as cp_name 
FROM donations d
JOIN collection_points cp ON d.collection_point_id = cp.collection_point_id
WHERE cp.ngo_id = ? AND d.status = 'Pending'
ORDER BY d.submitted_at DESC;
```

### Get inventory summary for an NGO
```sql
SELECT 
    i.*, 
    cp.name as cp_name, 
    dic.item_name, 
    dic.category
FROM inventory i
JOIN collection_points cp ON i.collection_point_id = cp.collection_point_id
JOIN donation_items_catalog dic ON i.item_id = dic.item_id
WHERE i.ngo_id = ?
ORDER BY dic.category, dic.item_name;
```

### Update inventory when marking donation as received
```sql
-- For each item in the donation
INSERT INTO inventory (ngo_id, collection_point_id, item_id, quantity)
VALUES (?, ?, ?, ?)
ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity);
```

# Donation Requests Feature

This document describes the donation requests CRUD functionality implemented in ResQnet.

## Overview

The donation requests feature allows general users to submit requests for donations to relief centers, which are then reviewed and approved by Grama Niladhari (GN) officers.

## Database Setup

Before using the donation requests feature, you need to:

1. Run the updated schema from `src/main/resources/db/migration/resqnet_schema.sql`
2. Populate the donation items catalog with sample data:

```sql
-- Sample donation items catalog
INSERT INTO donation_items_catalog (item_name, category) VALUES
('Rice - 1kg', 'Food'),
('Rice - 5kg', 'Food'),
('Rice - 10kg', 'Food'),
('Wheat Flour', 'Food'),
('Dhal', 'Food'),
('Sugar', 'Food'),
('Canned Fish', 'Food'),
('Canned Meat', 'Food'),
('Dry Rations Pack', 'Food'),
('Infant Formula', 'Food'),
('Baby Food', 'Food'),
('Drinking Water - 1L', 'Food'),
('Paracetamol', 'Medicine'),
('First Aid Kit', 'Medicine'),
('Bandages', 'Medicine'),
('Antiseptic', 'Medicine'),
('Pain Relief Medication', 'Medicine'),
('Cold Medicine', 'Medicine'),
('Antibiotics', 'Medicine'),
('Tents', 'Shelter'),
('Blankets', 'Shelter'),
('Sleeping Bags', 'Shelter'),
('Tarpaulins', 'Shelter'),
('Mosquito Nets', 'Shelter'),
('Mattresses', 'Shelter'),
('Pillows', 'Shelter');
```

## Features

### For General Users

#### Submit Donation Request
- Navigate to: Dashboard → "Request a Donation" (sidebar or quick action button)
- URL: `/general/donation-requests/new`
- Fill in the relief center name
- Select items from the catalog and specify quantities
- Add any special notes
- Submit the request

#### View Donation Requests
- Navigate to: Dashboard → "Request a Donation" (from sidebar)
- URL: `/general/donation-requests`
- View all submitted requests with their current status:
  - **Pending**: Awaiting GN review
  - **Verified**: Reviewed by GN
  - **Approved**: Approved by GN
  - **Rejected**: Rejected by GN

### For Grama Niladhari (GN) Officers

#### View Donation Requests
- Navigate to: Dashboard → "Donation Requests"
- URL: `/gn/donation-requests`
- View requests in two tabs:
  - **Pending Donation Requests**: Requests awaiting review
  - **Approved Donation Requests**: Already approved requests

#### Edit Request Details
- From the pending requests tab, click "Edit" on any request
- Modify relief center name, items, quantities, or special notes
- Save changes

#### Verify and Approve Requests
- From the pending requests tab, click "Verify" on any request
- Confirm the action
- Request moves to "Approved" tab and status changes to "Approved"

## API Endpoints

### General User Endpoints
- `GET /general/donation-requests` - View user's donation requests
- `GET /general/donation-requests/new` - Show donation request form
- `POST /general/donation-requests/submit` - Submit new donation request

### GN Endpoints
- `GET /gn/donation-requests` - View all donation requests (pending/approved)
- `GET /gn/donation-requests/edit?id={requestId}` - Edit request form
- `POST /gn/donation-requests/update` - Update request details
- `POST /gn/donation-requests/verify` - Verify and approve a request

## Database Schema

### Tables Created

#### donation_items_catalog
Master list of available donation items.
- `item_id` (PK): Auto-increment ID
- `item_name`: Name of the item
- `category`: ENUM('Medicine', 'Food', 'Shelter')

#### donation_requests
Main donation request records.
- `request_id` (PK): Auto-increment ID
- `user_id` (FK): References general_user
- `relief_center_name`: Name of the relief center
- `gn_id` (FK): References grama_niladhari (verifying officer)
- `status`: ENUM('Pending', 'Verified', 'Approved', 'Rejected')
- `special_notes`: Additional information
- `submitted_at`: Timestamp of submission
- `verified_at`: Timestamp of verification
- `approved_at`: Timestamp of approval

#### donation_request_items
Items included in each donation request.
- `request_item_id` (PK): Auto-increment ID
- `request_id` (FK): References donation_requests
- `item_id` (FK): References donation_items_catalog
- `quantity`: Number of items requested (must be > 0)

## Security

All endpoints are protected with:
- Session authentication checks
- Role-based access control
- CSRF protection (via POST methods)
- Input validation and sanitization

## Testing

To test the functionality:

1. Log in as a general user
2. Navigate to donation requests and create a new request
3. Log out and log in as a GN user
4. Navigate to donation requests and verify the pending request
5. Edit the request if needed
6. Verify and approve the request
7. Log back in as the general user to see the updated status

## Notes

- The donation items catalog should be pre-populated with items relevant to disaster relief
- GN officers can edit request details before approving to correct any errors
- Once approved, requests move from the pending tab to the approved tab
- Users can view the status of their requests but cannot edit them after submission

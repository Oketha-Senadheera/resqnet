# Donation Requests CRUD Implementation

## Overview
This implementation adds a complete CRUD (Create, Read, Update, Delete) system for donation requests in the ResQnet application. General users can submit donation requests, and Grama Niladhari (GN) officers can view, edit, and verify these requests.

## Database Schema

### Tables Added
1. **donation_items_catalog** - Stores the master list of donation items
   - item_id (PK)
   - item_name
   - category (Medicine, Food, Shelter)

2. **donation_requests** - Stores donation requests submitted by general users
   - request_id (PK)
   - user_id (FK to general_user)
   - relief_center_name
   - gn_id (FK to grama_niladhari, nullable)
   - status (Pending, Verified, Approved, Rejected)
   - special_notes
   - submitted_at, verified_at, approved_at

3. **donation_request_items** - Links items to requests
   - request_item_id (PK)
   - request_id (FK to donation_requests)
   - item_id (FK to donation_items_catalog)
   - quantity

### Database Setup
Before using the application, you need to:
1. Run the SQL schema in `src/main/resources/db/migration/resqnet_schema.sql`
2. Populate the `donation_items_catalog` table with sample items:

```sql
INSERT INTO donation_items_catalog (item_name, category) VALUES
('Rice', 'Food'),
('Canned Food', 'Food'),
('Water Bottles', 'Food'),
('First Aid Kits', 'Medicine'),
('Bandages', 'Medicine'),
('Tents', 'Shelter'),
('Blankets', 'Shelter'),
('Sleeping Bags', 'Shelter');
```

## Features

### General User Features

#### Submit Donation Request
- **URL**: `/general/donation-requests/form`
- **Access**: From dashboard "Request a Donation" button or sidebar navigation
- **Fields**:
  - Relief Center Name (required)
  - Special Notes (optional)
  - Multiple items with quantities

#### View My Requests
- **URL**: `/general/donation-requests/list`
- **Access**: From sidebar navigation "Request a Donation"
- **Shows**: All donation requests submitted by the logged-in user
- **Status indicators**: Pending, Approved, Rejected

### Grama Niladhari Features

#### View Donation Requests
- **URL**: `/gn/donation-requests`
- **Access**: From sidebar navigation "Donation Requests"
- **Two tabs**:
  1. **Pending Donation Requests**: Shows requests awaiting verification
  2. **Approved Donation Requests**: Shows verified/approved requests
- **Actions on pending requests**:
  - Verify: Approve the request immediately
  - Edit: Modify request details before approval

#### Edit Donation Request
- **URL**: `/gn/donation-requests/edit?id={requestId}`
- **Access**: Click "Edit" button on pending request
- **Can modify**:
  - Relief Center Name
  - Special Notes
  - Items and quantities

## URL Mappings

### General User Servlets
- `GET /general/donation-requests/form` - Show donation request form
- `POST /general/donation-requests/submit` - Submit donation request
- `GET /general/donation-requests/list` - List user's donation requests

### GN Servlets
- `GET /gn/donation-requests` - View all donation requests (pending/approved)
- `GET /gn/donation-requests/edit?id={requestId}` - Show edit form
- `POST /gn/donation-requests/edit` - Update donation request
- `POST /gn/donation-requests/verify` - Verify and approve request

## Code Structure

### Models
- `DonationItemsCatalog.java` - Represents donation items
- `DonationRequest.java` - Represents a donation request
- `DonationRequestItem.java` - Represents items in a request
- `DonationRequestWithItems.java` - Combined view with all details

### DAOs
- `DonationItemsCatalogDAO.java` - CRUD operations for items catalog
- `DonationRequestDAO.java` - CRUD operations for donation requests
- `DonationRequestItemDAO.java` - CRUD operations for request items

### Controllers (Servlets)
#### General User
- `DonationRequestFormServlet.java` - Display form
- `DonationRequestSubmitServlet.java` - Handle submission
- `DonationRequestListServlet.java` - List user's requests

#### Grama Niladhari
- `DonationRequestsServlet.java` - List all requests
- `DonationRequestEditServlet.java` - Edit requests
- `DonationRequestVerifyServlet.java` - Verify requests

### Views (JSP)
#### General User
- `/WEB-INF/views/general-user/donation-requests/form.jsp` - Request form
- `/WEB-INF/views/general-user/donation-requests/list.jsp` - User's requests list

#### Grama Niladhari
- `/WEB-INF/views/grama-niladhari/donation-requests.jsp` - Main view with tabs
- `/WEB-INF/views/grama-niladhari/donation-requests-edit.jsp` - Edit form

## Security

All servlets implement:
- Session validation
- Role-based access control (GENERAL for users, GRAMA_NILADHARI for GN)
- Input validation
- SQL injection prevention through parameterized queries

## Testing Instructions

1. **As a General User**:
   - Login with a general user account
   - Click "Request a Donation" button on dashboard
   - Fill in the form with relief center name and add items
   - Submit the request
   - View your submitted requests in the sidebar navigation

2. **As a Grama Niladhari**:
   - Login with a GN account
   - Navigate to "Donation Requests" in sidebar
   - View pending requests in the first tab
   - Click "Edit" to modify a request
   - Click "Verify" to approve a request
   - View approved requests in the second tab

## Notes

- Make sure the database tables are created before testing
- Populate the `donation_items_catalog` table with items
- The status flow is: Pending → Approved (after GN verification)
- GN can edit requests before approving them
- All timestamps are automatically managed by the database

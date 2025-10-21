# Donation Requests CRUD Implementation Summary

## Overview
This implementation adds complete CRUD (Create, Read, Update, Delete) operations for donation requests in the ResQnet application. General users can submit donation requests, and Grama Niladhari (GN) officers can view, manage, and approve these requests.

## Database Schema Changes

### Tables Created

1. **donation_items_catalog**
   - Stores catalog of available donation items
   - Fields: item_id, item_name, category (Medicine, Food, Shelter)
   - Includes 25 pre-populated sample items

2. **donation_requests**
   - Stores donation requests from general users
   - Fields: request_id, user_id, relief_center_name, gn_id, status, special_notes, submitted_at, approved_at
   - Status: Pending or Approved
   - Links to general_user and grama_niladhari tables

3. **donation_request_items**
   - Junction table linking requests to catalog items
   - Fields: request_item_id, request_id, item_id, quantity
   - Supports multiple items per request

## Java Components

### Model Classes
- `DonationItemsCatalog.java` - Catalog item model
- `DonationRequest.java` - Donation request model
- `DonationRequestItem.java` - Request item model
- `DonationRequestWithDetails.java` - DTO for displaying requests with all related information

### DAO (Data Access Object) Classes
- `DonationItemsCatalogDAO.java` - CRUD operations for catalog items
- `DonationRequestDAO.java` - CRUD operations for donation requests
- `DonationRequestItemDAO.java` - CRUD operations for request items

### Servlets

#### General User Servlets (package: com.resqnet.controller.general)
- `DonationRequestFormServlet.java` - Displays donation request form (GET /general/donation-requests/form)
- `DonationRequestSubmitServlet.java` - Handles form submission (POST /general/donation-requests/submit)

#### Grama Niladhari Servlets (package: com.resqnet.controller.gn)
- `DonationRequestsServlet.java` - Displays pending and approved requests (GET /gn/donation-requests)
- `DonationRequestVerifyServlet.java` - Approves/verifies requests (POST /gn/donation-requests/verify)

## Views (JSP Files)

### General User View
- `/WEB-INF/views/general-user/donation-requests/donation-request-form.jsp`
  - Form with relief center name, special notes
  - Dynamic item selection from catalog
  - Add/remove multiple items with quantities
  - Integrated with general-user-dashboard layout

### Grama Niladhari View
- `/WEB-INF/views/grama-niladhari/donation-requests/donation-requests-gn.jsp`
  - Tabbed interface for Pending and Approved requests
  - Table view with request details, submitter info, items, and dates
  - Verify button for pending requests
  - Integrated with grama-niladhari-dashboard layout

## Navigation Updates

### General User Dashboard
- Updated sidebar navigation to link "Request a Donation" to `/general/donation-requests/form`
- Updated dashboard quick action button to redirect to donation request form

### Grama Niladhari Dashboard
- Existing "Donation Requests" navigation item already points to `/gn/donation-requests`

## Key Features

1. **Item Selection**: Users select items from a pre-populated catalog organized by category (Medicine, Food, Shelter)
2. **Multi-item Requests**: Users can add multiple items with different quantities to a single request
3. **Status Tracking**: Requests start as "Pending" and move to "Approved" when verified by GN
4. **Timestamp Tracking**: Records submission time and approval time
5. **User Attribution**: Tracks which user submitted the request and which GN officer approved it
6. **Detailed Display**: GN view shows all request details including submitter information and item lists

## Security

- All servlets include authentication and authorization checks
- Role-based access control (GENERAL users can submit, GRAMA_NILADHARI can manage)
- SQL injection protection through PreparedStatements
- CodeQL security scan completed with 0 vulnerabilities

## URLs

### General Users
- Form: `/general/donation-requests/form`
- Submit: `/general/donation-requests/submit` (POST)

### Grama Niladhari
- View Requests: `/gn/donation-requests`
- Verify Request: `/gn/donation-requests/verify` (POST)

## Sample Data

The schema includes 25 sample items in the catalog:
- **Food**: Rice, Wheat Flour, Canned Food, Dried Fish, Dhal, Sugar, Salt, Cooking Oil, Bottled Water, Baby Food
- **Medicine**: Paracetamol, Antibiotics, First Aid Kits, Bandages, Antiseptic, Pain Relievers, Fever Medication, Cough Syrup
- **Shelter**: Tents, Blankets, Sleeping Bags, Tarpaulins, Mosquito Nets, Pillows, Mattresses

## Testing Notes

To test the implementation:
1. Run the database migration script to create tables and populate sample data
2. Log in as a general user
3. Navigate to "Request a Donation" from sidebar or dashboard
4. Fill out the form with relief center name, select items, and submit
5. Log in as a Grama Niladhari officer
6. Navigate to "Donation Requests" from sidebar
7. View pending requests and click "Verify" to approve
8. Check approved requests tab to see verified requests

## Files Modified/Created

### Database
- Modified: `src/main/resources/db/migration/resqnet_schema.sql`

### Java Models
- Created: `src/main/java/com/resqnet/model/DonationItemsCatalog.java`
- Created: `src/main/java/com/resqnet/model/DonationRequest.java`
- Created: `src/main/java/com/resqnet/model/DonationRequestItem.java`
- Created: `src/main/java/com/resqnet/model/DonationRequestWithDetails.java`

### Java DAOs
- Created: `src/main/java/com/resqnet/model/dao/DonationItemsCatalogDAO.java`
- Created: `src/main/java/com/resqnet/model/dao/DonationRequestDAO.java`
- Created: `src/main/java/com/resqnet/model/dao/DonationRequestItemDAO.java`

### Java Controllers
- Created: `src/main/java/com/resqnet/controller/general/DonationRequestFormServlet.java`
- Created: `src/main/java/com/resqnet/controller/general/DonationRequestSubmitServlet.java`
- Created: `src/main/java/com/resqnet/controller/gn/DonationRequestsServlet.java`
- Created: `src/main/java/com/resqnet/controller/gn/DonationRequestVerifyServlet.java`

### Views
- Created: `src/main/webapp/WEB-INF/views/general-user/donation-requests/donation-request-form.jsp`
- Created: `src/main/webapp/WEB-INF/views/grama-niladhari/donation-requests/donation-requests-gn.jsp`

### Navigation
- Modified: `src/main/webapp/WEB-INF/tags/layouts/general-user-dashboard.tag`
- Modified: `src/main/webapp/WEB-INF/views/general-user/dashboard.jsp`

## Compilation Status
✅ All code compiles successfully
✅ No security vulnerabilities detected by CodeQL

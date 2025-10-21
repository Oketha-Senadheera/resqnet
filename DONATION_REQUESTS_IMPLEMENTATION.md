# Donation Requests CRUD Implementation

## Overview
This implementation provides a complete CRUD (Create, Read, Update, Delete) system for managing donation requests in the ResQnet disaster management system. General users can submit donation requests, and Grama Niladhari (GN) officers can review, edit, approve, or reject these requests.

## Database Schema

### Tables Created

#### 1. donation_items_catalog
Stores the catalog of items that can be requested.
```sql
CREATE TABLE donation_items_catalog (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category ENUM('Medicine', 'Food', 'Shelter') NOT NULL,
    UNIQUE KEY uq_item_name (item_name)
);
```

#### 2. donation_requests
Stores the main donation request information.
```sql
CREATE TABLE donation_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    relief_center_name VARCHAR(150) NOT NULL,
    status ENUM('Pending', 'Approved') DEFAULT 'Pending',
    special_notes TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES general_user(user_id)
);
```

#### 3. donation_request_items
Links donation requests with items and quantities.
```sql
CREATE TABLE donation_request_items (
    request_item_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT DEFAULT 1 CHECK (quantity > 0),
    FOREIGN KEY (request_id) REFERENCES donation_requests(request_id),
    FOREIGN KEY (item_id) REFERENCES donation_items_catalog(item_id)
);
```

## Implementation Components

### Model Classes

1. **DonationItem** (`src/main/java/com/resqnet/model/DonationItem.java`)
   - Represents items in the donation catalog
   - Properties: itemId, itemName, category

2. **DonationRequest** (`src/main/java/com/resqnet/model/DonationRequest.java`)
   - Represents a donation request
   - Properties: requestId, userId, reliefCenterName, status, specialNotes, submittedAt, approvedAt, items

3. **DonationRequestItem** (`src/main/java/com/resqnet/model/DonationRequestItem.java`)
   - Represents items within a donation request
   - Properties: requestItemId, requestId, itemId, quantity, itemName, category

### DAO Classes

1. **DonationItemDAO** (`src/main/java/com/resqnet/model/dao/DonationItemDAO.java`)
   - Methods: create(), findById(), findAll(), findByCategory()
   - Manages catalog items

2. **DonationRequestDAO** (`src/main/java/com/resqnet/model/dao/DonationRequestDAO.java`)
   - Methods: create(), update(), approve(), delete(), findById(), findByUserId(), findByStatus(), findAll()
   - Manages donation requests and their items
   - Handles transactional operations for request items

### Servlets

#### General User Servlets

1. **DonationRequestFormServlet** (`/general/donation-requests`)
   - GET: Displays the donation request form
   - Loads available items from the catalog

2. **DonationRequestSubmitServlet** (`/general/donation-requests/submit`)
   - POST: Processes form submission
   - Validates input data
   - Creates new donation request with status "Pending"

#### Grama Niladhari Servlets

1. **DonationRequestsServlet** (`/gn/donation-requests`)
   - GET: Displays pending and approved requests in separate tabs
   - Provides approve and reject actions

2. **DonationRequestEditServlet** (`/gn/donation-requests/edit`)
   - GET: Displays edit form for a request
   - POST: Updates request details (relief center name and notes)

3. **DonationRequestApproveServlet** (`/gn/donation-requests/approve`)
   - POST: Approves a request
   - Sets status to "Approved" and records approval timestamp

4. **DonationRequestRejectServlet** (`/gn/donation-requests/reject`)
   - POST: Rejects and deletes a request from the database

### JSP Views

1. **form.jsp** (`/WEB-INF/views/general-user/donation-requests/form.jsp`)
   - User-friendly form for submitting donation requests
   - Dynamic item selection with quantity inputs
   - JavaScript for adding/removing item rows

2. **donation-requests.jsp** (`/WEB-INF/views/grama-niladhari/donation-requests.jsp`)
   - Tabbed interface for pending and approved requests
   - Table view with request details and items
   - Action buttons for approve, edit, and reject

3. **donation-request-edit.jsp** (`/WEB-INF/views/grama-niladhari/donation-request-edit.jsp`)
   - Edit form for GN officers
   - Allows modification of relief center name and notes
   - Displays read-only item list

## User Workflows

### General User Workflow
1. Navigate to "Request a Donation" from the dashboard
2. Fill in the relief center name
3. Select items and quantities (can add multiple items)
4. Add optional special notes
5. Submit the request
6. Request is saved with "Pending" status

### Grama Niladhari Workflow
1. Navigate to "Donation Requests" from the dashboard
2. View pending requests in the "Pending Requests" tab
3. For each request, GN can:
   - **Edit**: Modify relief center name or notes
   - **Approve**: Mark request as approved (moves to "Approved Requests" tab)
   - **Reject**: Delete the request from the database
4. View approved requests in the "Approved Requests" tab

## Navigation Links

### General User Dashboard
- Updated navigation link: `/general/donation-requests`
- Icon: package-plus
- Label: "Request a Donation"

### Grama Niladhari Dashboard
- Existing navigation link: `/gn/donation-requests`
- Icon: gift
- Label: "Donation Requests"

## Sample Data
Sample donation items are provided in `src/main/resources/db/migration/sample_donation_items.sql`:
- 10 Medicine items (e.g., Paracetamol, Bandages, First Aid Kit)
- 10 Food items (e.g., Rice, Canned Food, Bottled Water)
- 10 Shelter items (e.g., Tents, Blankets, Flashlights)

## Security Features
- All servlets check user authentication and authorization
- Role-based access control (GENERAL users can create, GN can manage)
- Input validation on both client and server side
- Prepared statements used in all database operations (SQL injection protection)
- No security vulnerabilities detected by CodeQL analysis

## Error Handling
- User-friendly error messages for validation failures
- Success messages for completed actions
- Graceful handling of database errors
- Redirect to login if session expires

## Testing Recommendations
1. Create a general user account
2. Submit multiple donation requests with different items
3. Log in as a GN officer
4. View pending requests
5. Edit a request and verify changes
6. Approve a request and verify it moves to approved tab
7. Reject a request and verify it's removed
8. Verify timestamps are recorded correctly

## Future Enhancements (Optional)
- Email notifications when requests are approved/rejected
- Search and filter functionality for GN dashboard
- Export requests to PDF or CSV
- Request history view for general users
- Bulk approval/rejection operations
- Analytics dashboard for donation trends

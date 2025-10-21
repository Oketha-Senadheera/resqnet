# Disaster Reports CRUD Implementation

## Overview
This implementation provides complete CRUD functionality for disaster reports in the ResQnet application. General users can submit disaster reports, and DMC (Disaster Management Center) administrators can approve or reject them.

## Features Implemented

### 1. Database Schema
- Added `disaster_reports` table with the following fields:
  - `report_id`: Auto-increment primary key
  - `user_id`: Foreign key to general_user table
  - `reporter_name`: Name of the person reporting
  - `contact_number`: Contact number of reporter
  - `disaster_type`: ENUM (Flood, Landslide, Fire, Earthquake, Tsunami, Other)
  - `other_disaster_type`: Custom disaster type when "Other" is selected
  - `disaster_datetime`: Date and time of the disaster
  - `location`: Location of the disaster
  - `proof_image_path`: Path to uploaded proof image (optional)
  - `confirmation`: Boolean flag (must be true for submission)
  - `status`: ENUM (Pending, Approved, Rejected) - defaults to Pending
  - `description`: Additional description (optional)
  - `submitted_at`: Timestamp of submission
  - `verified_at`: Timestamp of verification/rejection

### 2. Backend Components

#### Models
- **DisasterReport.java**: Model class representing a disaster report

#### DAOs (Data Access Objects)
- **DisasterReportDAO.java**: Handles all database operations
  - `create()`: Create a new disaster report
  - `update()`: Update an existing report
  - `delete()`: Delete a report
  - `findById()`: Find a report by ID
  - `findByUserId()`: Find all reports by a specific user
  - `findByStatus()`: Find all reports with a specific status
  - `findAll()`: Get all disaster reports
  - `approve()`: Approve a report (change status to Approved)
  - `reject()`: Reject a report (change status to Rejected)

#### Servlets

##### General User Servlets
- **DisasterReportFormServlet.java** (`/general/disaster-reports/form`)
  - GET: Display the disaster report form
  - Requires GENERAL user role

- **DisasterReportSubmitServlet.java** (`/general/disaster-reports/submit`)
  - POST: Handle disaster report submission
  - Validates required fields
  - Ensures confirmation checkbox is checked
  - Handles image upload (optional)
  - Saves report with "Pending" status
  - Requires GENERAL user role

##### DMC Servlets
- **DisasterReportsServlet.java** (`/dmc/disaster-reports`)
  - GET: Display pending and approved disaster reports
  - POST: Handle approve/reject actions
  - Requires DMC role

### 3. Frontend Components

#### General User Views
- **form.jsp**: Disaster report submission form
  - Reporter name and contact number fields
  - Disaster type selection (radio buttons)
  - Additional field for "Other" disaster type
  - Date/time picker for disaster occurrence
  - Location field
  - Optional image upload
  - Optional description field
  - Required confirmation checkbox
  - Form validation

#### DMC Views
- **disaster-reports.jsp**: Disaster reports management page
  - Two tabs: "Approved" and "Pending" (starts on Pending tab)
  - Displays reports in a table with:
    - Report ID
    - Reporter name and contact
    - Disaster date/time
    - Location
    - Disaster type
    - Description/notes
  - Pending tab includes action buttons:
    - Verify button (approves the report)
    - Reject button (rejects the report)
  - Responsive design for mobile devices

### 4. Navigation Updates
- **General User Dashboard**: Updated "Report a Disaster" button to link to `/general/disaster-reports/form`
- **General User Dashboard Layout**: Updated navigation to use correct route
- **DMC Dashboard Layout**: Already includes "Disaster Reports" navigation item

## User Flow

### General User Flow
1. User logs in as a general user
2. Clicks "Report a Disaster" from the dashboard or sidebar
3. Fills in the disaster report form:
   - Enters name and contact number
   - Selects disaster type (or specifies if "Other")
   - Enters date/time of disaster
   - Enters location
   - Optionally uploads proof image
   - Optionally adds description
   - **Must check confirmation box**
4. Submits the form
5. Report is saved with "Pending" status
6. User is redirected to dashboard with success message

### DMC Administrator Flow
1. DMC admin logs in
2. Navigates to "Disaster Reports" from sidebar
3. Views two tabs:
   - **Pending Disaster Reports**: Shows all reports awaiting review
   - **Approved Disaster Reports**: Shows all verified reports
4. For each pending report, DMC can:
   - **Verify**: Changes status to "Approved" and moves to Approved tab
   - **Reject**: Changes status to "Rejected" and removes from display
5. Action confirmation shown via success message

## Security Features
- Role-based access control (RBAC)
- Only GENERAL users can submit reports
- Only DMC users can approve/reject reports
- CSRF protection via POST forms
- Input validation on both client and server side
- File upload restrictions (images only, size limits)
- SQL injection prevention via PreparedStatements
- XSS protection via JSTL escaping

## Testing Instructions

### Prerequisites
1. Database must have the `disaster_reports` table created
2. Test users should exist:
   - At least one GENERAL user account
   - At least one DMC user account

### Test Cases

#### Test 1: Submit Disaster Report (Happy Path)
1. Log in as a general user
2. Navigate to disaster report form
3. Fill all required fields
4. Check confirmation box
5. Submit form
6. Verify: Success message shown, redirected to dashboard
7. As DMC user, verify report appears in Pending tab

#### Test 2: Submit Without Confirmation
1. Log in as a general user
2. Navigate to disaster report form
3. Fill all fields but DON'T check confirmation box
4. Submit form
5. Verify: Error message about confirmation

#### Test 3: Submit With "Other" Disaster Type
1. Log in as a general user
2. Navigate to disaster report form
3. Select "Other" as disaster type
4. Enter custom disaster type in the text field
5. Fill other required fields
6. Submit form
7. Verify: Report saved with custom disaster type

#### Test 4: DMC Approve Report
1. Log in as DMC user
2. Navigate to Disaster Reports
3. Go to Pending tab
4. Click "Verify" on a report
5. Verify: Report moves to Approved tab

#### Test 5: DMC Reject Report
1. Log in as DMC user
2. Navigate to Disaster Reports
3. Go to Pending tab
4. Click "Reject" on a report
5. Verify: Report is removed from display

#### Test 6: Access Control
1. Try to access `/general/disaster-reports/form` while not logged in
   - Verify: Redirected to login
2. Try to access `/general/disaster-reports/form` as DMC user
   - Verify: Access denied (403)
3. Try to access `/dmc/disaster-reports` as general user
   - Verify: Access denied (403)

## Files Changed/Created

### Created Files
1. `src/main/java/com/resqnet/model/DisasterReport.java`
2. `src/main/java/com/resqnet/model/dao/DisasterReportDAO.java`
3. `src/main/java/com/resqnet/controller/general/DisasterReportFormServlet.java`
4. `src/main/java/com/resqnet/controller/general/DisasterReportSubmitServlet.java`
5. `src/main/java/com/resqnet/controller/dmc/DisasterReportsServlet.java`
6. `src/main/webapp/WEB-INF/views/general-user/disaster-reports/form.jsp`
7. `src/main/webapp/WEB-INF/views/dmc/disaster-reports.jsp`

### Modified Files
1. `src/main/resources/db/migration/resqnet_schema.sql`
2. `src/main/webapp/WEB-INF/views/general-user/dashboard.jsp`
3. `src/main/webapp/WEB-INF/tags/layouts/general-user-dashboard.tag`

## Notes
- Image uploads are stored in `uploads/disaster-reports/` directory within the webapp
- The confirmation checkbox is required before submission (validated on both client and server)
- Rejected reports are not deleted from database but hidden from DMC dashboard
- All dates are stored in the database timezone
- The implementation follows the existing code patterns in the repository for consistency

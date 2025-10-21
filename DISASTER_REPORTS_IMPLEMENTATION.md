# Disaster Reports CRUD Implementation

## Overview
This document describes the disaster reports functionality that allows general users to report disasters and DMC staff to verify or reject those reports.

## Database Schema

### Table: disaster_reports
```sql
CREATE TABLE IF NOT EXISTS disaster_reports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    reporter_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    disaster_type ENUM('Flood', 'Landslide', 'Fire', 'Earthquake', 'Tsunami', 'Other') NOT NULL,
    other_disaster_type VARCHAR(100) DEFAULT NULL,
    disaster_datetime DATETIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    proof_image_path VARCHAR(255) DEFAULT NULL,
    confirmation BOOLEAN NOT NULL DEFAULT TRUE,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    description TEXT DEFAULT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP NULL,
    CONSTRAINT fk_disaster_report_user FOREIGN KEY (user_id)
        REFERENCES general_user (user_id) ON DELETE CASCADE
);
```

## General User Workflow

### Accessing the Form
1. Login as a general user
2. From the dashboard, click "Report a Disaster" button in the quick actions section
3. Or use the sidebar navigation: "Report a Disaster"
4. URL: `/general/disaster-reports/form`

### Submitting a Report
1. Fill in the required fields:
   - Reporter's Name (required)
   - Contact Number (required)
   - Type of Disaster (required, radio selection)
     - Flood
     - Landslide
     - Fire
     - Earthquake
     - Tsunami
     - Other (requires specification in additional field)
   - Date and Time of Disaster (required)
   - Location (required)
2. Optional fields:
   - Upload Image of Proof (file upload)
   - Additional Description (textarea)
3. **Important**: Check the confirmation box to acknowledge accuracy
4. Click "Submit Report"
5. Upon success, redirected to dashboard with success message
6. Report status is automatically set to "Pending"

## DMC Workflow

### Accessing Disaster Reports
1. Login as DMC staff
2. Click "Disaster Reports" in the sidebar navigation
3. URL: `/dmc/disaster-reports`

### Viewing Reports
The page has two tabs:
- **Pending Disaster Reports**: Shows all reports with status "Pending"
- **Approved Disaster Reports**: Shows all reports with status "Approved"

### Processing Pending Reports
For each pending report, DMC staff can:

#### Verify a Report
1. Click the "Verify" button
2. Report status changes to "Approved"
3. Report moves to "Approved Disaster Reports" tab
4. `verified_at` timestamp is set to current time

#### Reject a Report
1. Click the "Reject" button
2. Report status changes to "Rejected"
3. Report is removed from view (no longer shown in any tab)
4. `verified_at` timestamp is set to current time

## File Structure

### Backend (Java)
```
src/main/java/com/resqnet/
├── model/
│   ├── DisasterReport.java              # Model class
│   └── dao/
│       └── DisasterReportDAO.java       # Database operations
└── controller/
    ├── general/
    │   └── DisasterReportFormServlet.java  # Form display & submission
    └── dmc/
        ├── DisasterReportsServlet.java     # List reports
        └── DisasterReportVerifyServlet.java # Verify/reject actions
```

### Frontend (JSP)
```
src/main/webapp/WEB-INF/views/
├── general-user/
│   └── disaster-reports/
│       └── form.jsp                    # Report submission form
└── dmc/
    └── disaster-reports.jsp            # DMC management interface
```

## API Endpoints

### General User Endpoints
- `GET /general/disaster-reports/form` - Display the disaster report form
- `POST /general/disaster-reports/form` - Submit a new disaster report
  - Supports multipart/form-data for file uploads
  - Redirects to dashboard on success

### DMC Endpoints
- `GET /dmc/disaster-reports` - Display pending and approved reports
- `POST /dmc/disaster-reports/verify` - Verify or reject a report
  - Parameters:
    - `reportId` (required): The ID of the report to process
    - `action` (required): Either "verify" or "reject"
  - Redirects back to reports list with success/error message

## Model: DisasterReport

### Properties
- `reportId` (Integer) - Auto-generated primary key
- `userId` (Integer) - ID of the reporting user
- `reporterName` (String) - Name of the reporter
- `contactNumber` (String) - Contact number
- `disasterType` (String) - Type of disaster (ENUM)
- `otherDisasterType` (String) - Specified when type is "Other"
- `disasterDatetime` (Timestamp) - When the disaster occurred
- `location` (String) - Location of the disaster
- `proofImagePath` (String) - Path to uploaded proof image
- `confirmation` (Boolean) - User confirmed accuracy
- `status` (String) - Current status (Pending/Approved/Rejected)
- `description` (String) - Additional description
- `submittedAt` (Timestamp) - When report was submitted
- `verifiedAt` (Timestamp) - When report was verified/rejected

## DAO: DisasterReportDAO

### Methods
- `create(DisasterReport)` - Insert new report, returns generated ID
- `update(DisasterReport)` - Update existing report
- `updateStatus(reportId, status)` - Change report status and set verified_at
- `delete(reportId)` - Remove report
- `findById(reportId)` - Get report by ID
- `findByUserId(userId)` - Get all reports by a user
- `findByStatus(status)` - Get all reports with specific status
- `findAll()` - Get all reports

## Features Implemented

### Security
✅ Role-based access control (GENERAL for form, DMC for management)
✅ Session validation on all endpoints
✅ SQL injection prevention via PreparedStatements
✅ No security vulnerabilities (CodeQL verified)

### Validation
✅ Required field validation (client and server-side)
✅ Confirmation checkbox must be checked
✅ Date/time format validation
✅ File upload size limits (2MB threshold, 10MB max file, 50MB max request)

### User Experience
✅ Clean, responsive UI matching existing dashboard design
✅ Success/error messages for all operations
✅ Dynamic form behavior (Other disaster type field)
✅ Tab-based interface for DMC (Pending/Approved)
✅ Empty state handling

### Data Management
✅ Complete CRUD operations
✅ Foreign key constraints
✅ CASCADE delete on user removal
✅ Timestamp tracking
✅ Status workflow (Pending → Approved/Rejected)

## Testing Notes

To test the functionality:
1. Create a general user account and login
2. Navigate to "Report a Disaster"
3. Fill out and submit the form (ensure confirmation is checked)
4. Login as DMC user
5. Navigate to "Disaster Reports"
6. View the pending report
7. Click "Verify" to approve or "Reject" to reject
8. Verify the report moves to appropriate tab or is removed

## Future Enhancements (Not in Scope)
- View image proof in DMC interface
- Edit reports before submission
- Comments/notes on reports by DMC
- Email notifications
- Report statistics/analytics
- Export reports to PDF/Excel

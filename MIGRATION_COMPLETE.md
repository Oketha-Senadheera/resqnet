# Migration Summary: ResQnet Database Schema Alignment and Sign-Up Implementation

## Overview
This migration aligns the ResQnet application with the new database schema defined in `src/main/resources/db/migration/resqnet_schema.sql` and implements comprehensive sign-up functionality for different user types based on the HTML templates in the `auth-html-template` folder.

## Key Changes

### 1. Role System Updated
**File**: `src/main/java/com/resqnet/model/Role.java`

Old roles (removed):
- ADMIN
- MANAGER  
- STAFF

New roles (added):
- GENERAL (for general users seeking assistance)
- VOLUNTEER (for volunteers offering help)
- NGO (for NGO organizations)
- GRAMA_NILADHARI (for Grama Niladhari officials)
- DMC (for Disaster Management Center officials)

### 2. User Model Enhanced
**File**: `src/main/java/com/resqnet/model/User.java`

Added:
- `username` field (required by new schema)
- Updated helper methods (`isGeneral()`, `isVolunteer()`, `isNGO()`, etc.)

### 3. UserDAO Updated
**File**: `src/main/java/com/resqnet/model/dao/UserDAO.java`

Changes:
- Removed dependency on `roles` table (now using ENUM directly in users table)
- Updated SQL queries to work with new schema
- Added `findByUsername()` method
- Added `findById()` method
- Updated `create()` to return user ID

### 4. New Model Classes Created

#### GeneralUser Model
**File**: `src/main/java/com/resqnet/model/GeneralUser.java`
- Represents general users in the system
- Fields: name, contact_number, address fields, sms_alert

#### Volunteer Model
**File**: `src/main/java/com/resqnet/model/Volunteer.java`
- Represents volunteers
- Fields: name, age, gender, contact details, address, skills, preferences

#### NGO Model
**File**: `src/main/java/com/resqnet/model/NGO.java`
- Represents NGO organizations
- Fields: organization_name, registration_number, years_of_operation, address, contact person details

### 5. New DAO Classes Created

#### GeneralUserDAO
**File**: `src/main/java/com/resqnet/model/dao/GeneralUserDAO.java`
- Handles CRUD operations for general users
- Maps to `general_user` table

#### VolunteerDAO
**File**: `src/main/java/com/resqnet/model/dao/VolunteerDAO.java`
- Handles volunteer data including skills and preferences
- Manages many-to-many relationships with skills and preferences tables
- Automatically creates new skills/preferences if they don't exist

#### NGODAO
**File**: `src/main/java/com/resqnet/model/dao/NGODAO.java`
- Handles NGO organization data
- Maps to `ngos` table

### 6. New Servlets Created

#### SignupServlet
**File**: `src/main/java/com/resqnet/controller/SignupServlet.java`
**Route**: `/signup`
- Displays role selection page

#### GeneralUserSignupServlet
**File**: `src/main/java/com/resqnet/controller/GeneralUserSignupServlet.java`
**Route**: `/signup/general`
- Handles general user registration
- Creates user account and general user profile

#### VolunteerSignupServlet
**File**: `src/main/java/com/resqnet/controller/VolunteerSignupServlet.java`
**Route**: `/signup/volunteer`
- Handles volunteer registration
- Creates user account, volunteer profile, and links skills/preferences

#### NGOSignupServlet
**File**: `src/main/java/com/resqnet/controller/NGOSignupServlet.java`
**Route**: `/signup/ngo`
- Handles NGO registration
- Creates user account and NGO organization profile

### 7. New JSP Pages Created

#### Role Selection Page
**File**: `src/main/webapp/WEB-INF/views/auth/roles.jsp`
- Allows users to select their role before signing up
- Three options: General User, Volunteer, NGO

#### General User Signup Page
**File**: `src/main/webapp/WEB-INF/views/auth/general-user-signup.jsp`
- Two-column layout with personal info and address sections
- Fields: name, contact, username, email, password, address, SMS alert option

#### Volunteer Signup Page
**File**: `src/main/webapp/WEB-INF/views/auth/volunteer-signup.jsp`
- Two-column layout
- Left: personal info and address
- Right: volunteer preferences, specialized skills, account details

#### NGO Signup Page
**File**: `src/main/webapp/WEB-INF/views/auth/ngo-signup.jsp`
- Grid layout for organization details
- Fields: org name, registration number, years of operation, contact person, account credentials

### 8. CSS and Assets Migrated
**Copied to**: `src/main/webapp/static/`

New CSS files:
- `core.css` - Core design tokens and base styles
- `dashboard.css` - Dashboard-specific styles
- `roles.css` - Role selection page styles

Assets:
- `assets/img/logo.svg` - ResQnet logo

### 9. Authentication and Authorization Updates

#### LoginServlet Updated
**File**: `src/main/java/com/resqnet/controller/LoginServlet.java`
- Updated redirects based on new roles:
  - General users → `/user/dashboard`
  - Volunteers → `/volunteer/dashboard`
  - NGOs → `/ngo/dashboard`
  - Grama Niladhari → `/gn/dashboard`
  - DMC → `/dmc/dashboard`

#### AuthFilter Updated
**File**: `src/main/java/com/resqnet/security/AuthFilter.java`
- Updated role-based access control for new roles
- Added public paths for signup routes
- Updated role rules for new dashboard paths

#### Index Page Updated
**File**: `src/main/webapp/index.jsp`
- Now redirects to `/signup` instead of `/students`

### 10. Old Code Removed

Deleted files:
- `src/main/java/com/resqnet/model/Student.java`
- `src/main/java/com/resqnet/model/dao/StudentDAO.java`
- `src/main/java/com/resqnet/repository/StudentDao.java`
- `src/main/java/com/resqnet/controller/AddStudentServlet.java`
- `src/main/java/com/resqnet/controller/StudentDetailServlet.java`
- `src/main/java/com/resqnet/controller/StudentListServlet.java`
- `src/main/java/com/resqnet/controller/AdminDashboardServlet.java`
- `src/main/java/com/resqnet/controller/ManagerDashboardServlet.java`
- `src/main/java/com/resqnet/controller/StaffDashboardServlet.java`

Deleted JSP files and folders:
- `src/main/webapp/WEB-INF/views/students.jsp`
- `src/main/webapp/WEB-INF/views/student-detail.jsp`
- `src/main/webapp/WEB-INF/views/add-student.jsp`
- `src/main/webapp/WEB-INF/views/admin/` (entire folder)
- `src/main/webapp/WEB-INF/views/manager/` (entire folder)
- `src/main/webapp/WEB-INF/views/staff/` (entire folder)

## Database Schema Alignment

The application now fully aligns with the database schema in `resqnet_schema.sql`:

1. **users table**: Uses direct ENUM for roles, includes username field
2. **general_user table**: Linked via foreign key to users
3. **volunteers table**: Linked via foreign key to users
4. **ngos table**: Linked via foreign key to users
5. **skills & skills_volunteers**: Many-to-many relationship for volunteer skills
6. **volunteer_preferences & volunteer_preference_volunteers**: Many-to-many for preferences
7. **password_reset_tokens**: Already supported (no changes needed)

## Sign-Up Flow

1. User visits `/signup` (or root `/`)
2. Role selection page displays three options
3. User selects a role (General User, Volunteer, or NGO)
4. Redirected to appropriate signup form
5. User fills out the form with required information
6. Backend creates:
   - User account in `users` table
   - Role-specific profile in corresponding table
   - Related data (skills/preferences for volunteers)
7. User redirected to login page

## Testing Checklist

- [ ] General user can sign up with all fields
- [ ] Volunteer can sign up and select skills/preferences
- [ ] NGO can sign up with organization details
- [ ] Username uniqueness is enforced
- [ ] Email uniqueness is enforced
- [ ] Password confirmation works
- [ ] SMS alert checkbox works for general users
- [ ] Login redirects correctly based on role
- [ ] CSS styles are properly applied
- [ ] Forms validate required fields

## Deployment Notes

1. Database must have the schema from `resqnet_schema.sql` applied
2. Environment variables for database connection must be set (DB_HOST, DB_PORT, DB_NAME, etc.)
3. WAR file is built at `target/resqnet.war`
4. Deploy to Tomcat or compatible servlet container
5. Application will be accessible at `/resqnet` context path

## Build Commands

```bash
# Compile only
mvn clean compile

# Package WAR file
mvn clean package

# Skip tests if needed
mvn clean package -DskipTests
```

## Routes Summary

### Public Routes (no authentication required)
- `/` - Redirects to signup
- `/signup` - Role selection
- `/signup/general` - General user signup
- `/signup/volunteer` - Volunteer signup  
- `/signup/ngo` - NGO signup
- `/login` - Login page
- `/forgot-password` - Password reset request
- `/reset-password` - Password reset form
- `/static/**` - Static resources (CSS, JS, images)

### Protected Routes (authentication required)
- `/user/**` - General user dashboard (GENERAL role)
- `/volunteer/**` - Volunteer dashboard (VOLUNTEER role)
- `/ngo/**` - NGO dashboard (NGO role)
- `/gn/**` - Grama Niladhari dashboard (GRAMA_NILADHARI role)
- `/dmc/**` - DMC dashboard (DMC role)

## Next Steps

The following features can be implemented next:
1. Create dashboard pages for each role
2. Implement profile editing functionality
3. Add email verification during signup
4. Implement volunteer skill matching with disaster needs
5. Create NGO resource management pages
6. Add Grama Niladhari and DMC specific features

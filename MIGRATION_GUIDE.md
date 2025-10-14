# Database Migration and Sign-Up Implementation

This document describes the changes made to migrate the ResQnet project to match the new database schema and implement sign-up functionality for different user types.

## Changes Made

### 1. Database Schema Migration

#### Updated Models
- **Role enum** (`src/main/java/com/resqnet/model/Role.java`)
  - Changed from: `ADMIN`, `MANAGER`, `STAFF`
  - Changed to: `GENERAL`, `VOLUNTEER`, `NGO`, `GRAMA_NILADHARI`, `DMC`
  - Matches the database schema's role column in the users table

- **User model** (`src/main/java/com/resqnet/model/User.java`)
  - Added `username` field (required by database schema)
  - Changed `id` to `userId` to match database column name `user_id`
  - Updated getters/setters accordingly

#### New Entity Models
Created new entity models to match database schema:

1. **GeneralUser** (`src/main/java/com/resqnet/model/GeneralUser.java`)
   - Fields: userId, name, contactNumber, houseNo, street, city, district, gnDivision, smsAlert
   - Maps to `general_user` table

2. **Volunteer** (`src/main/java/com/resqnet/model/Volunteer.java`)
   - Fields: userId, name, age, gender, contactNumber, address fields, skills, preferences
   - Maps to `volunteers` table
   - Supports many-to-many relationships with skills and preferences

3. **NGO** (`src/main/java/com/resqnet/model/NGO.java`)
   - Fields: userId, organizationName, registrationNumber, yearsOfOperation, address, contact person details
   - Maps to `ngos` table

### 2. Data Access Layer (DAOs)

#### Updated UserDAO
- **UserDAO** (`src/main/java/com/resqnet/model/dao/UserDAO.java`)
  - Updated SQL queries to use new schema (no more roles table join)
  - Added `findByUsername()` method
  - Updated field mapping to use `username` and `user_id`
  - Changed role to be stored as enum string directly in users table

#### New DAOs
Created DAOs for new entities:

1. **GeneralUserDAO** (`src/main/java/com/resqnet/model/dao/GeneralUserDAO.java`)
   - `create()`: Insert general user profile
   - `findByUserId()`: Retrieve general user by user ID

2. **VolunteerDAO** (`src/main/java/com/resqnet/model/dao/VolunteerDAO.java`)
   - `create()`: Insert volunteer profile
   - `addSkills()`: Link skills to volunteer (many-to-many)
   - `addPreferences()`: Link preferences to volunteer (many-to-many)
   - `findByUserId()`: Retrieve volunteer by user ID

3. **NGODAO** (`src/main/java/com/resqnet/model/dao/NGODAO.java`)
   - `create()`: Insert NGO profile
   - `findByUserId()`: Retrieve NGO by user ID

### 3. Controllers (Servlets)

#### Updated Existing Servlets
- **LoginServlet**: Updated to handle new roles (DMC, GRAMA_NILADHARI, VOLUNTEER, NGO, GENERAL)
- **ForgotPasswordRequestServlet**: Changed `getId()` to `getUserId()`
- **AuthFilter**: Updated role-based authorization rules and added public paths for signup

#### New Signup Servlets

1. **SignupServlet** (`src/main/java/com/resqnet/controller/SignupServlet.java`)
   - URL: `/signup`, `/register`
   - Displays role selection page

2. **GeneralUserSignupServlet** (`src/main/java/com/resqnet/controller/GeneralUserSignupServlet.java`)
   - URL: `/signup-general`
   - Handles general user registration
   - Creates user account and general_user profile
   - Validates username and email uniqueness
   - Redirects to dashboard after successful registration

3. **VolunteerSignupServlet** (`src/main/java/com/resqnet/controller/VolunteerSignupServlet.java`)
   - URL: `/signup-volunteer`
   - Handles volunteer registration
   - Creates user account and volunteer profile
   - Links skills and preferences (many-to-many relationships)
   - Redirects to volunteer dashboard after successful registration

4. **NGOSignupServlet** (`src/main/java/com/resqnet/controller/NGOSignupServlet.java`)
   - URL: `/signup-ngo`
   - Handles NGO registration
   - Creates user account and NGO profile
   - Validates organization details
   - Redirects to NGO dashboard after successful registration

### 4. Views (JSP Pages)

Created signup JSP pages based on HTML templates:

1. **signup.jsp** (`src/main/webapp/WEB-INF/views/auth/signup.jsp`)
   - Role selection page with three cards (General User, Volunteer, NGO)
   - Clean, modern design with hover effects

2. **signup-general.jsp** (`src/main/webapp/WEB-INF/views/auth/signup-general.jsp`)
   - Form fields: Personal info (name, contact, username, email, password)
   - Address fields (house no, street, city, district, GN division)
   - SMS alert checkbox
   - Client-side password confirmation validation

3. **signup-volunteer.jsp** (`src/main/webapp/WEB-INF/views/auth/signup-volunteer.jsp`)
   - Two-column layout
   - Left: Personal info and address
   - Right: Volunteer preferences (checkboxes), specialized skills (checkboxes), account details
   - Client-side password confirmation validation

4. **signup-ngo.jsp** (`src/main/webapp/WEB-INF/views/auth/signup-ngo.jsp`)
   - Organization details (name, registration number, years of operation)
   - Contact person details
   - Address
   - Account credentials
   - Client-side password confirmation validation

## Database Schema Alignment

The implementation now correctly aligns with the database schema defined in:
`src/main/resources/db/migration/resqnet_schema.sql`

Key alignments:
- Users table uses `user_id`, `username`, `email`, `password_hash`, and `role` (ENUM)
- Role-specific tables (general_user, volunteers, ngos) use `user_id` as foreign key
- Many-to-many relationships for volunteer skills and preferences are properly handled
- Field names match database column names exactly

## Usage

### Accessing Signup Pages

1. **Role Selection**: Navigate to `/signup` or `/register`
2. **General User Signup**: Navigate to `/signup-general` or click from role selection
3. **Volunteer Signup**: Navigate to `/signup-volunteer` or click from role selection
4. **NGO Signup**: Navigate to `/signup-ngo` or click from role selection

### Registration Flow

1. User selects their role type
2. Fills out the appropriate registration form
3. System validates input (required fields, password match, unique username/email)
4. Creates user account in `users` table
5. Creates role-specific profile (general_user, volunteers, or ngos table)
6. For volunteers: links selected skills and preferences
7. Logs user in automatically
8. Redirects to appropriate dashboard based on role

## Security Features

- Password hashing using BCrypt
- Username and email uniqueness validation
- Required field validation
- Password confirmation validation
- Session management after successful registration

## Future Enhancements

Potential improvements for the future:
- Email verification after registration
- CAPTCHA for bot prevention
- More sophisticated form validation
- Integration with HTML templates from `sign-up-html-template` folder for better UI
- Profile picture upload
- Additional fields as needed by business requirements

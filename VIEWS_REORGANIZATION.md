# Views Folder Reorganization

## Overview
The views folder has been reorganized to follow a role-based structure, making it easier to maintain and locate view files for specific user roles.

## New Directory Structure

```
src/main/webapp/WEB-INF/views/
├── auth/                           # Common authentication pages
│   ├── forgot-password.jsp
│   ├── forgot-password-requested.jsp
│   ├── login.jsp
│   ├── reset-password.jsp
│   └── roles.jsp
├── general-user/                   # General User role views
│   ├── dashboard.jsp
│   └── signup.jsp
├── volunteer/                      # Volunteer role views
│   ├── dashboard.jsp
│   └── signup.jsp
├── ngo/                           # NGO role views
│   ├── dashboard.jsp
│   └── signup.jsp
├── grama-niladhari/               # Grama Niladhari role views
│   └── dashboard.jsp
├── dmc/                           # DMC role views
│   └── dashboard.jsp
├── fragments/                     # Reusable JSP fragments
│   ├── alerts.jspf
│   ├── footer.jspf
│   └── header.jspf
└── error.jsp                      # Error page
```

## Changes Made

### 1. Directory Structure
- **Created** role-based directories:
  - `general-user/` - For general user views
  - `volunteer/` - For volunteer views
  - `ngo/` - For NGO views
  - `grama-niladhari/` - For Grama Niladhari views
  - `dmc/` - For DMC (Disaster Management Center) views

- **Removed** the `dashboard/` directory (now empty)

### 2. File Movements

#### Dashboard Files
- `dashboard/general-dashboard.jsp` → `general-user/dashboard.jsp`
- `dashboard/volunteer-dashboard.jsp` → `volunteer/dashboard.jsp`
- `dashboard/ngo-dashboard.jsp` → `ngo/dashboard.jsp`
- `dashboard/gn-dashboard.jsp` → `grama-niladhari/dashboard.jsp`
- `dashboard/dmc-dashboard.jsp` → `dmc/dashboard.jsp`

#### Signup Files
- `auth/general-user-signup.jsp` → `general-user/signup.jsp`
- `auth/volunteer-signup.jsp` → `volunteer/signup.jsp`
- `auth/ngo-signup.jsp` → `ngo/signup.jsp`

### 3. Controller Updates

#### DashboardController.java
Updated all view paths:
- `/WEB-INF/views/dashboard/general-dashboard.jsp` → `/WEB-INF/views/general-user/dashboard.jsp`
- `/WEB-INF/views/dashboard/volunteer-dashboard.jsp` → `/WEB-INF/views/volunteer/dashboard.jsp`
- `/WEB-INF/views/dashboard/ngo-dashboard.jsp` → `/WEB-INF/views/ngo/dashboard.jsp`
- `/WEB-INF/views/dashboard/gn-dashboard.jsp` → `/WEB-INF/views/grama-niladhari/dashboard.jsp`
- `/WEB-INF/views/dashboard/dmc-dashboard.jsp` → `/WEB-INF/views/dmc/dashboard.jsp`

#### GeneralUserSignupServlet.java
Updated all view paths:
- `/WEB-INF/views/auth/general-user-signup.jsp` → `/WEB-INF/views/general-user/signup.jsp`

#### NGOSignupServlet.java
Updated all view paths:
- `/WEB-INF/views/auth/ngo-signup.jsp` → `/WEB-INF/views/ngo/signup.jsp`

#### VolunteerSignupServlet.java
Updated all view paths:
- `/WEB-INF/views/auth/volunteer-signup.jsp` → `/WEB-INF/views/volunteer/signup.jsp`

## Benefits

1. **Better Organization**: Each role has its own dedicated folder for views
2. **Easier Maintenance**: Role-specific views are grouped together
3. **Scalability**: Easy to add new views for each role
4. **Clear Separation**: Role-specific views are separate from common authentication views
5. **Consistency**: Uniform naming convention (`dashboard.jsp`, `signup.jsp`) across roles

## Common Files

The `auth/` folder retains common authentication-related views that are not role-specific:
- Login page
- Password reset pages
- Role selection page

The `fragments/` folder contains reusable JSP fragments used across multiple views.

## Verification

✅ All files successfully moved
✅ All controller references updated
✅ Project compiles successfully
✅ No broken references found

## Future Additions

When adding new views for a specific role:
1. Create the JSP file in the appropriate role folder
2. Use consistent naming (e.g., `feature-name.jsp`)
3. Update the corresponding controller to reference the new path
4. Follow the pattern: `/WEB-INF/views/{role}/feature-name.jsp`

## Migration Date
October 17, 2025

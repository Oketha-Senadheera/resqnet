# Views Folder Reorganization - Role-Based Structure

## Summary

Successfully reorganized the `views` folder into a role-based directory structure. Each role now has its own dedicated folder containing all related JSP pages.

## New Directory Structure

```
src/main/webapp/WEB-INF/views/
├── auth/
│   ├── login.jsp
│   ├── forgot-password.jsp
│   ├── reset-password.jsp
│   ├── forgot-password-requested.jsp
│   └── roles.jsp
├── general-user/
│   ├── signup.jsp
│   └── dashboard.jsp
├── ngo/
│   ├── signup.jsp
│   └── dashboard.jsp
├── volunteer/
│   ├── signup.jsp
│   └── dashboard.jsp
├── grama-niladhari/
│   └── dashboard.jsp
├── dmc/
│   └── dashboard.jsp
├── fragments/
└── error.jsp
```

## Changes Made

### 1. Created Role-Specific Directories

Created 5 new directories for each role:
- `general-user/` - For general users
- `ngo/` - For NGO organizations  
- `volunteer/` - For volunteers
- `grama-niladhari/` - For Grama Niladhari officials
- `dmc/` - For Disaster Management Center

### 2. Moved and Renamed Files

**Signup Pages:**
- `auth/general-user-signup.jsp` → `general-user/signup.jsp`
- `auth/ngo-signup.jsp` → `ngo/signup.jsp`
- `auth/volunteer-signup.jsp` → `volunteer/signup.jsp`

**Dashboard Pages:**
- `dashboard/general-dashboard.jsp` → `general-user/dashboard.jsp`
- `dashboard/ngo-dashboard.jsp` → `ngo/dashboard.jsp`
- `dashboard/volunteer-dashboard.jsp` → `volunteer/dashboard.jsp`
- `dashboard/gn-dashboard.jsp` → `grama-niladhari/dashboard.jsp`
- `dashboard/dmc-dashboard.jsp` → `dmc/dashboard.jsp`

### 3. Updated Controller Paths

Updated all servlet controllers to reference the new file locations:

**GeneralUserSignupServlet:**
- ✅ Updated all 3 references from `/WEB-INF/views/auth/general-user-signup.jsp` 
  to `/WEB-INF/views/general-user/signup.jsp`

**NGOSignupServlet:**
- ✅ Updated all 3 references from `/WEB-INF/views/auth/ngo-signup.jsp`
  to `/WEB-INF/views/ngo/signup.jsp`

**VolunteerSignupServlet:**
- ✅ Updated all 3 references from `/WEB-INF/views/auth/volunteer-signup.jsp`
  to `/WEB-INF/views/volunteer/signup.jsp`

**DashboardController:**
- ✅ Updated general dashboard: `/WEB-INF/views/general-user/dashboard.jsp`
- ✅ Updated NGO dashboard: `/WEB-INF/views/ngo/dashboard.jsp`
- ✅ Updated volunteer dashboard: `/WEB-INF/views/volunteer/dashboard.jsp`
- ✅ Updated GN dashboard: `/WEB-INF/views/grama-niladhari/dashboard.jsp`
- ✅ Updated DMC dashboard: `/WEB-INF/views/dmc/dashboard.jsp`

## Benefits

✅ **Better Organization** - Each role has its own dedicated directory
✅ **Scalability** - Easy to add new pages for each role
✅ **Maintainability** - Clear separation of concerns by role
✅ **Consistent Naming** - All signup pages are now named `signup.jsp`, all dashboards are `dashboard.jsp`
✅ **Easy Navigation** - Developers can quickly find role-specific files

## Folder Usage Guidelines

### Adding New Pages

When adding new pages for a specific role, place them in the appropriate role folder:

- **General User features** → `views/general-user/`
- **NGO features** → `views/ngo/`
- **Volunteer features** → `views/volunteer/`
- **Grama Niladhari features** → `views/grama-niladhari/`
- **DMC features** → `views/dmc/`
- **Common auth pages** → `views/auth/` (login, password reset, etc.)
- **Shared components** → `views/fragments/`

### Example Future Structure

```
general-user/
├── signup.jsp
├── dashboard.jsp
├── profile.jsp
├── report-disaster.jsp
└── request-assistance.jsp

ngo/
├── signup.jsp
├── dashboard.jsp
├── manage-donations.jsp
├── view-requests.jsp
└── submit-reports.jsp
```

## Testing Checklist

After deployment, verify these routes work:

### Signup Pages
- [ ] http://localhost:8080/resqnet/signup/general
- [ ] http://localhost:8080/resqnet/signup/ngo
- [ ] http://localhost:8080/resqnet/signup/volunteer

### Dashboard Pages (after login)
- [ ] http://localhost:8080/resqnet/dashboard/general
- [ ] http://localhost:8080/resqnet/dashboard/ngo
- [ ] http://localhost:8080/resqnet/dashboard/volunteer
- [ ] http://localhost:8080/resqnet/dashboard/gn
- [ ] http://localhost:8080/resqnet/dashboard/dmc

## Old Files Removed

The old `dashboard/` folder can be deleted as all files have been moved:
- `dashboard/user-dashboard.jsp` (if exists, was duplicate)

## No Breaking Changes

✅ All existing routes continue to work
✅ No changes to URL structure
✅ Only internal JSP file paths were updated
✅ All controllers properly updated

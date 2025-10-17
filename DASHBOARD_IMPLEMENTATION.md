# Role-Based Dashboard Implementation

## Summary

Created simple dashboard pages for each user role that display the user's email from the session. After login, users are automatically redirected to their role-specific dashboard.

## Files Created

### Dashboard JSP Pages (in `src/main/webapp/WEB-INF/views/dashboard/`)

1. **`general-dashboard.jsp`** - For GENERAL users
2. **`volunteer-dashboard.jsp`** - For VOLUNTEER users
3. **`ngo-dashboard.jsp`** - For NGO users
4. **`gn-dashboard.jsp`** - For GRAMA_NILADHARI users
5. **`dmc-dashboard.jsp`** - For DMC users

Each dashboard displays:
- Role-specific heading
- User's email from session (`${sessionScope.authUser.email}`)
- User's role (`${sessionScope.authUser.role}`)
- Logout button

### Controller

**`DashboardController.java`** - Handles all dashboard routes

## Routes

### Main Dashboard Route
- **`/dashboard`** - Automatically redirects to role-specific dashboard based on logged-in user's role

### Role-Specific Routes (Hardcoded)
- **`/dashboard/general`** - General user dashboard (requires GENERAL role)
- **`/dashboard/volunteer`** - Volunteer dashboard (requires VOLUNTEER role)
- **`/dashboard/ngo`** - NGO dashboard (requires NGO role)
- **`/dashboard/gn`** - Grama Niladhari dashboard (requires GRAMA_NILADHARI role)
- **`/dashboard/dmc`** - DMC dashboard (requires DMC role)

### Access Control
- Each role-specific route checks if the logged-in user has the correct role
- Returns 403 Forbidden error if user tries to access a dashboard they don't have permission for
- Redirects to login if user is not authenticated

## Login Flow

1. User logs in at `/login`
2. `LoginServlet` authenticates user and sets session
3. Redirects to `/dashboard`
4. `DashboardController` reads user's role from session
5. Redirects to appropriate role-specific dashboard:
   - GENERAL → `/dashboard/general`
   - VOLUNTEER → `/dashboard/volunteer`
   - NGO → `/dashboard/ngo`
   - GRAMA_NILADHARI → `/dashboard/gn`
   - DMC → `/dashboard/dmc`

## Security Features

✅ **Session Check** - Redirects to login if user is not authenticated
✅ **Role Verification** - Each dashboard verifies user has correct role
✅ **Access Denied** - Returns 403 if user tries to access unauthorized dashboard
✅ **Automatic Routing** - Main `/dashboard` route automatically sends user to correct dashboard

## Testing

After successful login, test each role:

1. **General User:**
   - http://localhost:8080/resqnet/dashboard/general
   - Should show "General User Dashboard" with email

2. **Volunteer:**
   - http://localhost:8080/resqnet/dashboard/volunteer
   - Should show "Volunteer Dashboard" with email

3. **NGO:**
   - http://localhost:8080/resqnet/dashboard/ngo
   - Should show "NGO Dashboard" with email

4. **Grama Niladhari:**
   - http://localhost:8080/resqnet/dashboard/gn
   - Should show "Grama Niladhari Dashboard" with email

5. **DMC:**
   - http://localhost:8080/resqnet/dashboard/dmc
   - Should show "DMC Dashboard" with email

## Next Steps

These are basic dashboards ready for enhancement:
- Add navigation menus
- Add role-specific features and content
- Apply CSS styling from core.css
- Add charts, statistics, or role-specific functionality
- Implement role-specific operations (reports, requests, etc.)

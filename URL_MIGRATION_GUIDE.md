# URL Migration Guide

This document describes the URL routing changes made to organize controllers by role.

## Controller Organization

Controllers have been reorganized into the following structure:

```
src/main/java/com/resqnet/controller/
├── auth/                       # Authentication controllers
│   ├── LoginServlet.java
│   ├── LogoutServlet.java
│   ├── SignupServlet.java
│   ├── GeneralUserSignupServlet.java
│   ├── VolunteerSignupServlet.java
│   ├── NGOSignupServlet.java
│   ├── ForgotPasswordRequestServlet.java
│   └── ResetPasswordServlet.java
├── dmc/                        # DMC (admin) role controllers
│   ├── DashboardServlet.java
│   ├── GNListServlet.java
│   ├── GNAddServlet.java
│   ├── GNEditServlet.java
│   └── GNDeleteServlet.java
├── general/                    # General user role controllers
│   └── DashboardServlet.java
├── volunteer/                  # Volunteer role controllers
│   └── DashboardServlet.java
├── ngo/                        # NGO role controllers
│   └── DashboardServlet.java
├── gn/                         # Grama Niladhari role controllers
│   └── DashboardServlet.java
└── DashboardController.java    # Legacy redirector
```

## URL Changes

### Dashboard URLs

The routing pattern has been changed from `dashboard/{role}` to `{role}/dashboard`:

| Old URL                | New URL                | Role            |
| ---------------------- | ---------------------- | --------------- |
| `/dashboard/dmc`       | `/dmc/dashboard`       | DMC (Admin)     |
| `/dashboard/volunteer` | `/volunteer/dashboard` | Volunteer       |
| `/dashboard/general`   | `/general/dashboard`   | General User    |
| `/dashboard/ngo`       | `/ngo/dashboard`       | NGO             |
| `/dashboard/gn`        | `/gn/dashboard`        | Grama Niladhari |

**Note:** Old URLs are still supported and will redirect to new URLs for backward compatibility.

### Admin to DMC Migration

All admin URLs have been renamed to use "dmc" (Disaster Management Center):

| Old URL                   | New URL                   |
| ------------------------- | ------------------------- |
| `/dmc/gn-registry`        | `/dmc/gn-registry`        |
| `/dmc/gn-registry/add`    | `/dmc/gn-registry/add`    |
| `/dmc/gn-registry/edit`   | `/dmc/gn-registry/edit`   |
| `/dmc/gn-registry/delete` | `/dmc/gn-registry/delete` |

### Authentication URLs (Unchanged)

These URLs remain the same:

- `/login`
- `/logout`
- `/signup`
- `/signup/general`
- `/signup/volunteer`
- `/signup/ngo`
- `/forgot-password`
- `/reset-password`

## View Files Migration

View files have been reorganized to match the controller structure:

```
src/main/webapp/WEB-INF/views/
├── auth/
├── dmc/                        # Renamed from admin/
│   ├── dashboard.jsp
│   └── gn/
│       ├── list.jsp
│       └── form.jsp
├── general-user/
│   └── dashboard.jsp
├── volunteer/
│   └── dashboard.jsp
├── ngo/
│   └── dashboard.jsp
└── grama-niladhari/
    └── dashboard.jsp
```

## Security Configuration

The AuthFilter has been updated to protect role-based URL patterns:

- `/dmc/*` - Requires DMC role
- `/gn/*` - Requires GRAMA_NILADHARI role
- `/ngo/*` - Requires NGO role
- `/volunteer/*` - Requires VOLUNTEER role
- `/general/*` - Requires GENERAL role

## Benefits

1. **Clearer Organization**: Controllers are now organized by role, making it easier to find and maintain code
2. **Consistent URL Pattern**: All role-specific URLs now follow the pattern `/{role}/{resource}`
3. **Better Security**: URL patterns match role boundaries, making security configuration clearer
4. **Admin Renamed to DMC**: More accurately reflects that DMC (Disaster Management Center) is the admin in this application
5. **Backward Compatibility**: Old dashboard URLs are maintained with redirects

## Testing

After deployment, test the following:

1. Login with each role type and verify redirection to correct dashboard
2. Test old dashboard URLs redirect properly
3. Test DMC GN registry management features work correctly
4. Verify role-based access control is working (users can't access other roles' URLs)

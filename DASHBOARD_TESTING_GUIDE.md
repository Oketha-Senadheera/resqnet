# Dashboard Testing Guide

## Overview
This guide provides a comprehensive testing checklist for all refactored dashboard pages to ensure the reusable layout fragments work correctly.

## Prerequisites

### 1. Build and Deploy
```bash
# Build the application
mvn clean package

# Deploy to Tomcat
# Copy target/resqnet.war to Tomcat's webapps directory
# Start Tomcat server
```

### 2. Test User Accounts
Ensure you have test accounts for each role:
- General User (GENERAL)
- Volunteer (VOLUNTEER)
- NGO (NGO)
- Grama Niladhari (GRAMA_NILADHARI)
- DMC (DMC)

## Testing Checklist

### Common Elements (Test for ALL Dashboards)

#### Visual Elements
- [ ] Page loads without JavaScript errors (check browser console)
- [ ] ResQnet logo displays in sidebar
- [ ] All Lucide icons render correctly
- [ ] Font (Plus Jakarta Sans) loads properly
- [ ] Core CSS and dashboard CSS apply correctly
- [ ] Layout structure is intact (sidebar + topbar + main content)

#### Topbar
- [ ] Breadcrumb shows correct dashboard name
- [ ] Breadcrumb shows current page ("Overview")
- [ ] Hotline number "117" displays with phone icon
- [ ] User avatar placeholder appears
- [ ] Menu toggle button shows (mobile view)

#### Sidebar
- [ ] Brand logo is visible and sized correctly
- [ ] Navigation items render with correct icons
- [ ] "Overview" is marked as active (has active class)
- [ ] Logout button is present at bottom
- [ ] Logout button has proper styling

#### Interactive Features
- [ ] Clicking a navigation item changes its active state
- [ ] Only one navigation item is active at a time
- [ ] All navigation icons are visible
- [ ] Navigation items are clickable

#### Responsive Design
- [ ] Desktop view (1920x1080): All elements visible
- [ ] Tablet view (768x1024): Layout adjusts properly
- [ ] Mobile view (375x667): Menu toggle appears, layout stacks

---

## Role-Specific Testing

### 1. Volunteer Dashboard
**URL:** `/dashboard/volunteer`

**Page-Specific Elements:**
- [ ] Page title: "ResQnet - Volunteer Overview"
- [ ] Welcome message shows user email
- [ ] Warning alert displays correctly
- [ ] Quick action cards (4 cards in grid)
- [ ] Verified disaster reports section loads
- [ ] Report cards populate dynamically
- [ ] "I will assist" buttons work correctly
- [ ] Button changes to "Assisting" on click
- [ ] Button background changes to #ffe28a

**Navigation Items:**
- [ ] Overview
- [ ] Forecast Dashboard
- [ ] Safe Locations
- [ ] Make a Donation
- [ ] Request a Donation
- [ ] Report a Disaster
- [ ] Forum
- [ ] Profile Settings

---

### 2. NGO Dashboard
**URL:** `/dashboard/ngo`

**Page-Specific Elements:**
- [ ] Page title: "ResQnet NGO Dashboard"
- [ ] Welcome message shows user email
- [ ] Warning alert displays
- [ ] Quick action cards (4 cards)
- [ ] Donation Requests section loads
- [ ] Request cards render with tags
- [ ] Collection Points section displays
- [ ] Collection point cards populate
- [ ] "Reserved" status shows yellow highlight
- [ ] "Fulfill" buttons are functional

**Navigation Items:**
- [ ] Overview
- [ ] Forecast Dashboard
- [ ] Safe Locations
- [ ] Donation Requests
- [ ] Manage Inventory
- [ ] Manage Collection Points
- [ ] Forum
- [ ] Profile Settings

---

### 3. DMC Dashboard
**URL:** `/dashboard/dmc`

**Page-Specific Elements:**
- [ ] Page title: "ResQnet - DMC Overview"
- [ ] Welcome message shows user email
- [ ] Statistics grid (4 stat cards)
- [ ] Stat cards show correct numbers
- [ ] Safe Locations section displays
- [ ] Map iframe loads correctly
- [ ] Location list populates
- [ ] "Add New Location" button present
- [ ] Real-time Disaster Reports table loads
- [ ] "Verify" and "Reject" buttons work
- [ ] Verify changes status to "Verified"
- [ ] Reject removes table row
- [ ] Incoming NGO Deliveries table displays
- [ ] "Confirm" buttons functional

**Navigation Items:**
- [ ] Overview
- [ ] Forecast Dashboard
- [ ] Disaster Reports
- [ ] Volunteer Applications
- [ ] Delivery Confirmations
- [ ] Safe Locations
- [ ] GN Registry
- [ ] Forum
- [ ] Profile Settings

---

### 4. General User Dashboard
**URL:** `/dashboard/general`

**Page-Specific Elements:**
- [ ] Page title: "ResQnet - General Public Overview"
- [ ] Welcome message shows user email
- [ ] Warning alert displays
- [ ] Quick action cards (4 cards)
- [ ] Safe Locations section shows
- [ ] Safe location list populates
- [ ] Map section renders
- [ ] Map search box visible
- [ ] Map zoom controls present

**Navigation Items:**
- [ ] Overview
- [ ] Forecast Dashboard
- [ ] Make a Donation
- [ ] Request a Donation
- [ ] Report a Disaster
- [ ] Be a Volunteer
- [ ] Forum
- [ ] Profile Settings

---

### 5. Grama Niladhari Dashboard
**URL:** `/dashboard/gn`

**Page-Specific Elements:**
- [ ] Page title: "ResQnet - Grama Niladhari Dashboard"
- [ ] Welcome message shows user email
- [ ] Statistics grid (3 stat cards)
- [ ] Stat values display correctly
- [ ] Safe Locations section shows
- [ ] "Update Details" button present
- [ ] Location items populate
- [ ] Map iframe loads
- [ ] Real-time Disaster Reports table displays
- [ ] Table rows render with correct data
- [ ] Location links are clickable
- [ ] Status colors are correct (pending = orange)

**Navigation Items:**
- [ ] Overview
- [ ] Forecast Dashboard
- [ ] Donation Requests
- [ ] Disaster Reports
- [ ] Safe Locations
- [ ] Forum
- [ ] Profile Settings

---

## Browser Testing

Test on multiple browsers:
- [ ] Google Chrome (latest)
- [ ] Mozilla Firefox (latest)
- [ ] Safari (latest)
- [ ] Microsoft Edge (latest)

## Performance Testing

- [ ] Page load time < 3 seconds
- [ ] No console errors
- [ ] No 404 errors for resources
- [ ] CSS files load correctly
- [ ] JavaScript files load correctly
- [ ] External fonts load correctly

## Accessibility Testing

- [ ] All buttons have aria-labels
- [ ] Images have alt text
- [ ] Navigation is keyboard accessible
- [ ] Tab order is logical
- [ ] Focus indicators are visible

## Security Testing

- [ ] Session check redirects to login if not authenticated
- [ ] Role verification prevents unauthorized access
- [ ] Logout button properly ends session
- [ ] No sensitive data in client-side JavaScript

## Common Issues and Solutions

### Issue: Lucide Icons Not Showing
**Solution:** Check browser console for CDN errors. Ensure internet connectivity.

### Issue: Styles Not Applied
**Solution:** Verify core.css and dashboard.css are accessible. Check contextPath.

### Issue: Navigation Not Working
**Solution:** Check browser console for JavaScript errors. Verify dashboard-scripts.jspf is included.

### Issue: Wrong Breadcrumb Text
**Solution:** Verify `breadcrumbPrefix` and `breadcrumbCurrent` variables are set correctly.

### Issue: Page Title Wrong
**Solution:** Check `pageTitle` variable is set before including dashboard-head.jspf.

## Regression Testing

After any changes to fragments, test ALL dashboards:
1. Volunteer Dashboard
2. NGO Dashboard
3. DMC Dashboard
4. General User Dashboard
5. Grama Niladhari Dashboard

## Reporting Issues

When reporting issues, include:
1. Dashboard affected (role)
2. Browser and version
3. Screen size / device
4. Steps to reproduce
5. Expected behavior
6. Actual behavior
7. Console errors (if any)
8. Screenshots

## Test Results Template

```
Date: YYYY-MM-DD
Tester: [Name]
Browser: [Browser + Version]

Dashboard: [Role Name]
Status: [ ] PASS [ ] FAIL

Issues Found:
1. [Description]
2. [Description]

Notes:
[Any additional observations]
```

## Automation Opportunities (Future)

Consider automating:
- [ ] Fragment inclusion tests
- [ ] Parameter validation tests
- [ ] Icon rendering tests
- [ ] Navigation state tests
- [ ] Responsive layout tests

---

**Last Updated:** October 17, 2025

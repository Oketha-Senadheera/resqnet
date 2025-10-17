# Dashboard Developer Guide

## Overview
This guide explains how to use the reusable dashboard layout fragments when creating or modifying role-based dashboards in the ResQnet application.

## Quick Start

### Creating a New Dashboard

1. **Create the JSP file** in the appropriate role folder:
   ```
   /WEB-INF/views/{role-name}/dashboard.jsp
   ```

2. **Start with this template:**

```jsp
<%-- Set page-specific parameters --%>
<c:set var="pageTitle" value="ResQnet - Your Dashboard Name" />
<c:set var="breadcrumbPrefix" value="Your Dashboard" />
<c:set var="breadcrumbCurrent" value="Overview" />

<%-- Include common dashboard head --%>
<%@ include file="../fragments/dashboard-head.jspf" %>

    <%-- Optional: Add page-specific styles --%>
    <style>
      /* Your custom styles here */
      .custom-card {
        background: #fff;
        padding: 1rem;
        border-radius: 8px;
      }
    </style>
  </head>
  <body>
    <div class="layout">
      <%-- Sidebar Navigation --%>
      <aside class="sidebar" aria-label="Primary">
        <div class="brand">
          <img class="logo-img" src="${pageContext.request.contextPath}/static/assets/img/logo.svg" 
               alt="ResQnet Logo" width="120" height="32" />
          <span class="brand-name sr-only">ResQnet</span>
        </div>
        <nav class="nav">
          <button class="nav-item active" data-section="overview">
            <span class="icon" data-lucide="home"></span>
            <span>Overview</span>
          </button>
          <!-- Add more navigation items -->
        </nav>
        <div class="sidebar-footer">
          <form method="post" action="${pageContext.request.contextPath}/logout" style="margin:0;">
            <button type="submit" class="logout" aria-label="Logout">↩ Logout</button>
          </form>
        </div>
      </aside>

      <%-- Include common dashboard topbar --%>
      <%@ include file="../fragments/dashboard-topbar.jspf" %>

      <%-- Main Content --%>
      <main class="content" id="mainContent" tabindex="-1">
        <section class="welcome">
          <h1>Welcome ${sessionScope.authUser.email}!</h1>
        </section>
        
        <!-- Your dashboard content here -->
        
      </main>
    </div>

    <%-- Include common dashboard scripts --%>
    <%@ include file="../fragments/dashboard-scripts.jspf" %>
    
    <%-- Optional: Add page-specific scripts --%>
    <script>
      // Your custom JavaScript here
      document.addEventListener('DOMContentLoaded', () => {
        console.log('Dashboard loaded');
      });
    </script>
  </body>
</html>
```

## Fragment Reference

### 1. dashboard-head.jspf

**Purpose:** Includes HTML head with meta tags, title, and stylesheets.

**Parameters:**
- `pageTitle` (String, optional) - Page title. Defaults to "ResQnet Dashboard"

**Usage:**
```jsp
<c:set var="pageTitle" value="ResQnet - My Dashboard" />
<%@ include file="../fragments/dashboard-head.jspf" %>
```

**What it includes:**
- UTF-8 charset
- Responsive viewport
- Page title with XSS protection (`<c:out>`)
- Core CSS stylesheet
- Dashboard CSS stylesheet
- Google Fonts (Plus Jakarta Sans)
- Lucide icons CDN script

**Important:** Always close the `<head>` tag and add custom styles BEFORE `</head>`:
```jsp
<%@ include file="../fragments/dashboard-head.jspf" %>
    <style>
      /* Your styles */
    </style>
  </head>
```

---

### 2. dashboard-topbar.jspf

**Purpose:** Provides the top navigation bar with breadcrumb and user controls.

**Parameters:**
- `breadcrumbPrefix` (String, optional) - First part of breadcrumb. Defaults to "Dashboard"
- `breadcrumbCurrent` (String, optional) - Current page. Defaults to "Overview"

**Usage:**
```jsp
<c:set var="breadcrumbPrefix" value="Admin Dashboard" />
<c:set var="breadcrumbCurrent" value="Settings" />
<%@ include file="../fragments/dashboard-topbar.jspf" %>
```

**Output:**
```
Admin Dashboard / Settings
```

**Features:**
- Dynamic breadcrumb navigation
- Emergency hotline number (117)
- User avatar (placeholder)
- Mobile menu toggle button
- All elements use Lucide icons

**Customization:**
To change the hotline number or user avatar, modify the fragment file directly.

---

### 3. dashboard-scripts.jspf

**Purpose:** Initializes common JavaScript functionality.

**Parameters:** None

**Usage:**
```jsp
<%@ include file="../fragments/dashboard-scripts.jspf" %>
```

**What it does:**
1. Initializes Lucide icons
2. Sets up navigation item click handlers
3. Manages active state for sidebar navigation

**Always include this BEFORE your custom scripts:**
```jsp
<%@ include file="../fragments/dashboard-scripts.jspf" %>

<script>
  // Your custom code here runs after common scripts
</script>
```

---

### 4. dashboard-sidebar.jspf

**Status:** Prepared but not yet implemented

**Future Usage:**
```jsp
<c:set var="navItems" value="${[
  {section: 'overview', icon: 'home', label: 'Overview', active: true},
  {section: 'reports', icon: 'file-text', label: 'Reports', active: false}
]}" />
<%@ include file="../fragments/dashboard-sidebar.jspf" %>
```

**Current Practice:**
Keep sidebar inline in each dashboard file for now, as navigation items vary significantly by role.

---

## Styling Guidelines

### Using Existing Styles

The fragments include `core.css` and `dashboard.css`. Use these CSS classes:

**Layout:**
- `.layout` - Main container
- `.sidebar` - Sidebar navigation
- `.topbar` - Top navigation bar
- `.content` - Main content area

**Common Components:**
```css
.stat-card      /* Statistics card */
.action-card    /* Action button card */
.alert.info     /* Information alert */
.nav-item       /* Navigation item */
.nav-item.active /* Active navigation */
```

**CSS Variables:**
```css
var(--color-border)        /* Border color */
var(--color-accent)        /* Accent color */
var(--color-accent-hover)  /* Accent hover */
var(--color-surface)       /* Surface background */
var(--color-text)          /* Text color */
var(--radius-md)           /* Medium border radius */
var(--radius-lg)           /* Large border radius */
```

### Adding Custom Styles

Place role-specific styles in a `<style>` block AFTER the head fragment:

```jsp
<%@ include file="../fragments/dashboard-head.jspf" %>
    <style>
      .my-custom-card {
        background: var(--color-surface);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: 1.5rem;
      }
      
      @media (max-width: 768px) {
        .my-custom-card {
          padding: 1rem;
        }
      }
    </style>
  </head>
```

---

## Navigation Setup

### Adding Navigation Items

Each role has unique navigation items. Define them inline in the sidebar:

```jsp
<nav class="nav">
  <button class="nav-item active" data-section="overview">
    <span class="icon" data-lucide="home"></span>
    <span>Overview</span>
  </button>
  
  <button class="nav-item" data-section="reports">
    <span class="icon" data-lucide="file-text"></span>
    <span>Reports</span>
  </button>
  
  <button class="nav-item" data-section="settings">
    <span class="icon" data-lucide="settings"></span>
    <span>Settings</span>
  </button>
</nav>
```

**Guidelines:**
- First item should have `active` class
- Use `data-section` attribute for JavaScript handling
- Always include Lucide icon
- Keep labels concise (1-3 words)

### Available Lucide Icons

Common icons for dashboards:
- `home` - Overview/Home
- `line-chart` - Analytics/Forecast
- `file-text` - Reports/Documents
- `users` - Team/Users
- `map-pin` - Locations
- `gift` - Donations
- `alert-triangle` - Alerts/Warnings
- `settings` - Settings/Configuration
- `message-circle` - Forum/Messages
- `user` - Profile
- `boxes` - Inventory
- `check-square` - Confirmations
- `list` - Registry/Lists

Full list: https://lucide.dev/icons/

---

## JavaScript Patterns

### Adding Custom Scripts

Always add custom scripts AFTER the common scripts fragment:

```jsp
<%@ include file="../fragments/dashboard-scripts.jspf" %>

<script>
  // Wait for DOM to be ready
  document.addEventListener('DOMContentLoaded', () => {
    // Your code here
    
    // Example: Populate dynamic content
    const data = [...];
    const container = document.getElementById('myContainer');
    data.forEach(item => {
      // Render items
    });
  });
</script>
```

### Working with Templates

Use HTML `<template>` for dynamic content:

```jsp
<!-- HTML Template -->
<template id="card-template">
  <div class="card">
    <h3 class="card-title"></h3>
    <p class="card-text"></p>
  </div>
</template>

<!-- JavaScript -->
<script>
  const template = document.getElementById('card-template');
  const container = document.getElementById('cards');
  
  items.forEach(item => {
    const clone = template.content.firstElementChild.cloneNode(true);
    clone.querySelector('.card-title').textContent = item.title;
    clone.querySelector('.card-text').textContent = item.text;
    container.appendChild(clone);
  });
</script>
```

### Icon Initialization

Lucide icons are automatically initialized by `dashboard-scripts.jspf`. 

If you add icons dynamically, reinitialize them:

```javascript
// After adding new elements with data-lucide attributes
if (window.lucide) {
  lucide.createIcons();
}
```

---

## Session Data Access

Access authenticated user data from session:

```jsp
<%-- In JSP --%>
<h1>Welcome ${sessionScope.authUser.email}!</h1>
<p>Role: ${sessionScope.authUser.role}</p>
```

**Available session attributes:**
- `authUser.email` - User's email address
- `authUser.role` - User's role (GENERAL, VOLUNTEER, NGO, etc.)
- `authUser.id` - User's ID

**Security:** Always use `<c:out>` for user-generated content to prevent XSS:
```jsp
<p><c:out value="${sessionScope.authUser.email}" /></p>
```

---

## Best Practices

### 1. **Consistent Structure**
Always follow this order:
1. Set parameters
2. Include head fragment
3. Add custom styles
4. Close head, open body
5. Layout wrapper
6. Sidebar
7. Include topbar fragment
8. Main content
9. Close layout
10. Include scripts fragment
11. Add custom scripts
12. Close body and html

### 2. **Minimal Custom Code**
- Only add role-specific styles
- Avoid duplicating common styles
- Don't override fragment styles unless necessary

### 3. **Accessibility**
- Use semantic HTML
- Add aria-labels to buttons
- Ensure keyboard navigation works
- Test with screen readers

### 4. **Responsive Design**
- Test on mobile, tablet, desktop
- Use CSS Grid/Flexbox for layouts
- Add mobile-specific styles with media queries

### 5. **Performance**
- Keep custom JavaScript minimal
- Use event delegation for dynamic content
- Avoid synchronous XHR requests
- Lazy load heavy components

### 6. **Security**
- Never trust user input
- Use `<c:out>` for dynamic content
- Validate form inputs
- Check session authentication

---

## Common Patterns

### Statistics Grid

```jsp
<section class="stats-grid" aria-label="Dashboard Statistics">
  <div class="stat-card">
    <div class="stat-label">Total Users</div>
    <div class="stat-value">1,234</div>
  </div>
  <div class="stat-card">
    <div class="stat-label">Active Reports</div>
    <div class="stat-value">56</div>
  </div>
</section>
```

### Action Cards

```jsp
<div class="quick-actions">
  <button class="action-card" data-action="donate">
    <div class="action-icon"><i data-lucide="gift"></i></div>
    <span>Make a Donation</span>
  </button>
  <button class="action-card" data-action="report">
    <div class="action-icon"><i data-lucide="alert-octagon"></i></div>
    <span>Report Disaster</span>
  </button>
</div>
```

### Alert Messages

```jsp
<div class="alert info">
  <span class="alert-icon" data-lucide="alert-triangle"></span>
  <p>Heavy Rainfall Warning in Gampaha District</p>
</div>
```

### Data Tables

```jsp
<table class="table">
  <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>#001</td>
      <td>John Doe</td>
      <td><span class="status-active">Active</span></td>
    </tr>
  </tbody>
</table>
```

---

## Troubleshooting

### Fragment Not Found
**Error:** "File not found: dashboard-head.jspf"

**Solution:** Check the relative path. From a role folder, use:
```jsp
<%@ include file="../fragments/dashboard-head.jspf" %>
```

### Styles Not Applied
**Issue:** Custom styles not showing

**Solution:** Ensure styles are added AFTER the head fragment and BEFORE `</head>`:
```jsp
<%@ include file="../fragments/dashboard-head.jspf" %>
    <style>
      /* Styles here */
    </style>
  </head>
```

### Icons Not Showing
**Issue:** Lucide icons appear as blank spaces

**Solution:** 
1. Check browser console for CDN errors
2. Ensure `dashboard-scripts.jspf` is included
3. Verify data-lucide attribute is correct

### Navigation Not Working
**Issue:** Clicking nav items doesn't change active state

**Solution:**
1. Ensure `dashboard-scripts.jspf` is included
2. Check nav items have `.nav-item` class
3. Verify no JavaScript errors in console

---

## Testing Your Dashboard

### Checklist

Before committing your dashboard:

- [ ] Page loads without errors
- [ ] All icons render correctly
- [ ] Navigation items work
- [ ] Logout button functions
- [ ] Session data displays correctly
- [ ] Responsive design works
- [ ] No console errors
- [ ] Breadcrumb is correct
- [ ] Custom features work
- [ ] Tested in Chrome, Firefox, Safari

### Build and Test

```bash
# Build the project
mvn clean compile

# Package for deployment
mvn package

# Deploy to Tomcat and test in browser
```

---

## Examples

See existing dashboards for complete examples:
- `/WEB-INF/views/volunteer/dashboard.jsp` - Simple dashboard with report cards
- `/WEB-INF/views/ngo/dashboard.jsp` - Dashboard with multiple sections
- `/WEB-INF/views/dmc/dashboard.jsp` - Complex dashboard with tables and maps

---

## Getting Help

- Review [DASHBOARD_LAYOUT_REFACTOR.md](./DASHBOARD_LAYOUT_REFACTOR.md) for architecture details
- Check [DASHBOARD_TESTING_GUIDE.md](./DASHBOARD_TESTING_GUIDE.md) for testing procedures
- See [VIEWS_REORGANIZATION.md](./VIEWS_REORGANIZATION.md) for file structure

---

**Last Updated:** October 17, 2025

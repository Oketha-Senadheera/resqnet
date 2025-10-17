# Reusable Dashboard Layout Guide

## Overview

This guide explains how to use the reusable dashboard layouts created for the ResQnet application. These layouts eliminate code duplication and make it easy to add new pages to each role without duplicating sidebar, navigation, and other common components.

## Architecture

The dashboard layout system is organized in a three-tier structure:

1. **Base Layout** (`dashboard.tag`) - Contains the common HTML structure, CSS, and JavaScript
2. **Role-Specific Layouts** - Pre-configured layouts for each role with appropriate navigation items
3. **Page Content** - Individual JSP pages that use the role-specific layouts

## Available Layout Tags

The following reusable layout tags are available in `src/main/webapp/WEB-INF/tags/layouts/`:

- `<layout:volunteer-dashboard>` - For volunteer role pages
- `<layout:dmc-dashboard>` - For DMC (Disaster Management Center) role pages
- `<layout:ngo-dashboard>` - For NGO role pages
- `<layout:general-user-dashboard>` - For general user role pages
- `<layout:grama-niladhari-dashboard>` - For Grama Niladhari (GN) role pages

## Usage

### Basic Example

To use a reusable dashboard layout in your JSP page:

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:volunteer-dashboard pageTitle="ResQnet - Volunteer Overview" activePage="overview">
  <jsp:body>
    <!-- Your page content goes here -->
    <h1>Welcome ${sessionScope.authUser.email}!</h1>
    <p>This is the volunteer dashboard overview page.</p>
  </jsp:body>
</layout:volunteer-dashboard>
```

### Adding Custom Styles

To add page-specific styles:

```jsp
<layout:volunteer-dashboard pageTitle="My Page" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      .custom-class {
        color: red;
      }
    </style>
  </jsp:attribute>
  <jsp:body>
    <div class="custom-class">Custom styled content</div>
  </jsp:body>
</layout:volunteer-dashboard>
```

### Adding Custom JavaScript

To add page-specific JavaScript:

```jsp
<layout:volunteer-dashboard pageTitle="My Page" activePage="overview">
  <jsp:attribute name="scripts">
    <script>
      console.log('Page-specific JavaScript');
      // Your JavaScript code here
    </script>
  </jsp:attribute>
  <jsp:body>
    <!-- Your page content -->
  </jsp:body>
</layout:volunteer-dashboard>
```

### Complete Example with Styles and Scripts

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:volunteer-dashboard pageTitle="ResQnet - Volunteer Reports" activePage="report-disaster">
  <jsp:attribute name="styles">
    <style>
      .report-card {
        border: 1px solid #ddd;
        padding: 1rem;
        margin-bottom: 1rem;
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        console.log('Reports page loaded');
        // Initialize any page-specific functionality
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Disaster Reports</h1>
    <div class="report-card">
      <h3>Report #1</h3>
      <p>Details about the report...</p>
    </div>
  </jsp:body>
</layout:volunteer-dashboard>
```

## Layout Attributes

Each role-specific layout accepts the following attributes:

- `pageTitle` (optional) - The page title that appears in the browser tab. If not provided, a default title is used.
- `activePage` (optional) - The ID of the currently active navigation item. Defaults to "overview". This highlights the appropriate menu item in the sidebar.
- `styles` (optional, fragment) - Custom CSS styles for the page
- `scripts` (optional, fragment) - Custom JavaScript for the page

## Navigation Items per Role

### Volunteer Dashboard
- overview
- forecast
- safe-locations
- make-donation
- request-donation
- report-disaster
- forum
- profile-settings

### DMC Dashboard
- overview
- forecast
- disaster-reports
- volunteer-apps
- delivery-confirmations
- safe-locations
- gn-registry
- forum
- profile-settings

### NGO Dashboard
- overview
- forecast
- safe-locations
- donation-requests
- manage-inventory
- manage-collection
- forum
- profile-settings

### General User Dashboard
- overview
- forecast
- make-donation
- request-donation
- report-disaster
- be-volunteer
- forum
- profile-settings

### Grama Niladhari Dashboard
- overview
- forecast
- donation-requests
- disaster-reports
- safe-locations
- forum
- profile-settings

## Creating New Pages

When creating a new page for a specific role:

1. Create a new JSP file in the appropriate role's view directory:
   - `/src/main/webapp/WEB-INF/views/volunteer/`
   - `/src/main/webapp/WEB-INF/views/dmc/`
   - `/src/main/webapp/WEB-INF/views/ngo/`
   - `/src/main/webapp/WEB-INF/views/general-user/`
   - `/src/main/webapp/WEB-INF/views/grama-niladhari/`

2. Use the appropriate layout tag for that role

3. Set the `activePage` attribute to match one of the navigation items

4. Add your page-specific content, styles, and scripts

Example:

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:volunteer-dashboard 
    pageTitle="ResQnet - Volunteer Forum" 
    activePage="forum">
  <jsp:body>
    <h1>Community Forum</h1>
    <!-- Forum content here -->
  </jsp:body>
</layout:volunteer-dashboard>
```

## Benefits

1. **No Code Duplication** - The sidebar, header, navigation, and common scripts are defined once
2. **Consistent UI** - All pages for a role share the same layout and navigation
3. **Easy Maintenance** - Changes to the layout only need to be made in one place
4. **Easy to Add Pages** - New pages only need to focus on content, not layout
5. **Role-Specific Navigation** - Each role has its own set of navigation items pre-configured

## Migration from Old Style

Old style (before refactoring):
```jsp
<!DOCTYPE html>
<html>
  <head>
    <title>Page Title</title>
    <link rel="stylesheet" href="...">
    <!-- All the boilerplate -->
  </head>
  <body>
    <div class="layout">
      <aside class="sidebar">
        <!-- Full sidebar markup -->
      </aside>
      <header class="topbar">
        <!-- Full header markup -->
      </header>
      <main class="content">
        <!-- Actual page content -->
      </main>
    </div>
    <script>/* Common scripts */</script>
  </body>
</html>
```

New style (after refactoring):
```jsp
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:volunteer-dashboard pageTitle="Page Title" activePage="overview">
  <jsp:body>
    <!-- Actual page content only -->
  </jsp:body>
</layout:volunteer-dashboard>
```

## Technical Details

### Base Dashboard Tag (`dashboard.tag`)

The base `dashboard.tag` contains:
- HTML5 doctype and structure
- Common CSS imports (core.css, dashboard.css)
- Google Fonts import
- Lucide icons script
- Sidebar structure with dynamic navigation items
- Header/topbar with breadcrumb
- Logout form
- Basic navigation JavaScript

### Role-Specific Tags

Each role-specific tag:
- Defines the navigation items for that role
- Sets default page title and breadcrumb
- Wraps the base `dashboard.tag`
- Passes through custom styles and scripts

## Testing

To test your pages:

1. Build the project: `mvn clean package`
2. Deploy to Tomcat
3. Access the page through the appropriate URL
4. Verify that:
   - The correct navigation item is highlighted
   - The breadcrumb shows the correct role and page
   - Custom styles are applied
   - Custom scripts execute
   - The logout button works

## Best Practices

1. Always specify the `activePage` attribute to highlight the correct navigation item
2. Keep page-specific styles in the `styles` fragment, not in the page body
3. Keep page-specific JavaScript in the `scripts` fragment
4. Use semantic HTML in your page content
5. Test your pages in different browsers
6. Ensure accessibility by using proper ARIA labels in your content

## Future Enhancements

Potential future improvements to the layout system:

1. Add support for custom breadcrumb text
2. Add support for page-specific header actions
3. Add support for notifications/alerts in the header
4. Add support for user profile dropdown in the header
5. Add support for responsive mobile menu
6. Add theme switching capability

## Support

For questions or issues with the dashboard layouts, please:
1. Check this documentation first
2. Review the existing dashboard JSP files for examples
3. Examine the tag files in `/src/main/webapp/WEB-INF/tags/layouts/`
4. Contact the development team

<%@ tag description="NGO dashboard layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<%@ attribute name="pageTitle" required="false" %>
<%@ attribute name="activePage" required="false" %>
<%@ attribute name="styles" fragment="true" required="false" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<%
  java.util.List<java.util.Map<String, Object>> navItems = new java.util.ArrayList<>();
  String activePageVal = (String) jspContext.getAttribute("activePage");
  if (activePageVal == null) activePageVal = "overview";
  
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "overview");
    put("icon", "home");
    put("label", "Overview");
    put("active", "overview".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "forecast");
    put("icon", "line-chart");
    put("label", "Forecast Dashboard");
    put("active", "forecast".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "safe-locations");
    put("icon", "map-pin");
    put("label", "Safe Locations");
    put("active", "safe-locations".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "donation-requests");
    put("icon", "gift");
    put("label", "Donation Requests");
    put("active", "donation-requests".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "manage-inventory");
    put("icon", "boxes");
    put("label", "Manage Inventory");
    put("active", "manage-inventory".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "manage-collection");
    put("icon", "map");
    put("label", "Manage Collection Points");
    put("active", "manage-collection".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "forum");
    put("icon", "message-circle");
    put("label", "Forum");
    put("active", "forum".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "profile-settings");
    put("icon", "user");
    put("label", "Profile Settings");
    put("active", "profile-settings".equals(activePageVal));
  }});
  
  jspContext.setAttribute("navItems", navItems);
  
  String titleVal = (String) jspContext.getAttribute("pageTitle");
  if (titleVal == null) titleVal = "ResQnet NGO Dashboard";
  jspContext.setAttribute("finalTitle", titleVal);
  
  String breadcrumbVal = "NGO Dashboard / <span>" + 
    (activePageVal.substring(0, 1).toUpperCase() + activePageVal.substring(1).replace("-", " ")) + 
    "</span>";
  jspContext.setAttribute("finalBreadcrumb", breadcrumbVal);
%>
<layout:dashboard title="${finalTitle}" role="ngo" breadcrumb="${finalBreadcrumb}" navItems="${navItems}">
  <jsp:attribute name="styles">
    <c:if test="${not empty styles}">
      <jsp:invoke fragment="styles" />
    </c:if>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <c:if test="${not empty scripts}">
      <jsp:invoke fragment="scripts" />
    </c:if>
  </jsp:attribute>
  <jsp:body>
    <jsp:doBody />
  </jsp:body>
</layout:dashboard>

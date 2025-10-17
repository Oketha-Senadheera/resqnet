<%@ tag description="General User dashboard layout" pageEncoding="UTF-8" %>
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
    put("section", "make-donation");
    put("icon", "hand-coins");
    put("label", "Make a Donation");
    put("active", "make-donation".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "request-donation");
    put("icon", "package-plus");
    put("label", "Request a Donation");
    put("active", "request-donation".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "report-disaster");
    put("icon", "alert-octagon");
    put("label", "Report a Disaster");
    put("active", "report-disaster".equals(activePageVal));
  }});
  navItems.add(new java.util.HashMap<String, Object>() {{
    put("section", "be-volunteer");
    put("icon", "user-plus");
    put("label", "Be a Volunteer");
    put("active", "be-volunteer".equals(activePageVal));
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
  if (titleVal == null) titleVal = "ResQnet - General Public Overview";
  jspContext.setAttribute("finalTitle", titleVal);
  
  String breadcrumbVal = "General Public Dashboard / <span>" + 
    (activePageVal.substring(0, 1).toUpperCase() + activePageVal.substring(1).replace("-", " ")) + 
    "</span>";
  jspContext.setAttribute("finalBreadcrumb", breadcrumbVal);
%>
<layout:dashboard title="${finalTitle}" role="general-user" breadcrumb="${finalBreadcrumb}" navItems="${navItems}">
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

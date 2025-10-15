<%@ tag description="Authentication page layout" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="scripts" fragment="true" required="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>${title} • ResQnet</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
    rel="stylesheet"
  />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth.css" />
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/assets/img/logo.svg" />
  <script src="${pageContext.request.contextPath}/static/vendor/lucide.js"></script>
</head>
<body class="u-bg-surface">
  <main class="o-center">
    <section class="c-auth" aria-labelledby="auth-title">
      <div class="c-auth__brand">
        <img src="${pageContext.request.contextPath}/static/assets/img/logo.svg" alt="ResQnet Logo" height="36" />
        <span class="u-sr-only">ResQnet</span>
      </div>
      <jsp:doBody />
    </section>
  </main>
  <script src="${pageContext.request.contextPath}/static/auth.js"></script>
  <c:if test="${not empty scripts}">
    <jsp:invoke fragment="scripts" />
  </c:if>
</body>
</html>

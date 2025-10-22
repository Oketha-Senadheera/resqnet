<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Reset Password">
  <jsp:attribute name="styles">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth-pages.css" />
  </jsp:attribute>
  <jsp:body>
    <div class="auth-container">
      <h1 class="auth-heading">Set new password</h1>
      <p class="auth-subheading">
        Enter your new password below.
      </p>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form method="post" action="${pageContext.request.contextPath}/reset-password" novalidate>
        <input type="hidden" name="token" value="${token}" />
        
        <div class="form-field">
          <label for="password">New Password *</label>
          <input
            id="password"
            name="password"
            type="password"
            class="input"
            placeholder="Enter your new password"
            minlength="6"
            required
            autofocus
          />
        </div>
        
        <div class="form-field">
          <label for="confirm">Confirm Password *</label>
          <input
            id="confirm"
            name="confirm"
            type="password"
            class="input"
            placeholder="Confirm your new password"
            minlength="6"
            required
          />
        </div>
        
        <button type="submit" class="btn btn-primary btn-block">Update Password</button>
      </form>
      
      <div class="auth-switch">
        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
      </div>
      
      <footer class="auth-legal">
        <a href="#">Terms of Service</a>
        <span aria-hidden="true"> · </span>
        <a href="#">Privacy Policy</a>
      </footer>
    </div>
  </jsp:body>
</layout:auth>

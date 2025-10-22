<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Forgot Password">
  <jsp:attribute name="styles">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth-pages.css" />
  </jsp:attribute>
  <jsp:body>
    <div class="auth-container">
      <h1 class="auth-heading">Reset your password</h1>
      <p class="auth-subheading">
        Enter the email associated with your account and we'll send you a reset link.
      </p>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form method="post" novalidate>
        <div class="form-field">
          <label for="resetEmail">Email *</label>
          <input
            id="resetEmail"
            name="email"
            type="email"
            class="input"
            placeholder="Enter your email"
            autocomplete="email"
            value="${emailValue}"
            required
            autofocus
          />
        </div>
        
        <button type="submit" class="btn btn-primary btn-block">Send reset link</button>
      </form>
      
      <div class="auth-switch">
        Remembered your password?
        <a href="${pageContext.request.contextPath}/login">Login</a>
      </div>
      
      <footer class="auth-legal">
        <a href="#">Terms of Service</a>
        <span aria-hidden="true"> · </span>
        <a href="#">Privacy Policy</a>
      </footer>
    </div>
  </jsp:body>
</layout:auth>

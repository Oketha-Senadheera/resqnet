<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Login">
  <jsp:attribute name="styles">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth-pages.css" />
  </jsp:attribute>
  <jsp:body>
    <div class="auth-container">
      <h1 class="auth-heading">Welcome back</h1>
      <p class="auth-subheading">Sign in to your account</p>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form method="post" action="${pageContext.request.contextPath}/login" novalidate>
        <div class="form-field">
          <label for="email">Email or username *</label>
          <input
            id="email"
            name="email"
            type="email"
            class="input"
            placeholder="Enter your email or username"
            autocomplete="username"
            required
            autofocus
          />
        </div>
        
        <div class="form-field">
          <label for="password">Password *</label>
          <input
            id="password"
            name="password"
            type="password"
            class="input"
            placeholder="Enter your password"
            autocomplete="current-password"
            minlength="6"
            required
          />
        </div>
        
        <div class="auth-meta">
          <a href="${pageContext.request.contextPath}/forgot-password">Forgot Password?</a>
        </div>
        
        <button type="submit" class="btn btn-primary btn-block">Login</button>
      </form>
      
      <div class="auth-switch">
        <span>Don't have an account? </span>
        <a href="${pageContext.request.contextPath}/signup">Sign up</a>
      </div>
    </div>
  </jsp:body>
</layout:auth>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Login">
  <jsp:attribute name="styles">
    <style>
      .auth-container {
        max-width: 440px;
        margin: 3rem auto;
        padding: 0 1.5rem;
      }
      .auth-heading {
        font-size: clamp(1.75rem, 3vw, 2rem);
        font-weight: 600;
        margin: 0 0 0.5rem;
        text-align: center;
      }
      .auth-subheading {
        text-align: center;
        color: var(--color-text-subtle);
        font-size: var(--font-size-sm);
        margin: 0 0 2rem;
      }
      .error-message {
        color: var(--color-danger);
        background: rgba(215, 48, 47, 0.1);
        padding: 0.75rem 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1.5rem;
        font-size: var(--font-size-sm);
        text-align: center;
      }
      .auth-meta {
        text-align: right;
        margin-top: -0.5rem;
        margin-bottom: 1.5rem;
      }
      .auth-meta a {
        font-size: var(--font-size-sm);
        color: var(--color-text-subtle);
        text-decoration: none;
      }
      .auth-meta a:hover {
        color: var(--color-accent);
      }
      .auth-switch {
        text-align: center;
        margin-top: 1.5rem;
        font-size: var(--font-size-sm);
        color: var(--color-text-subtle);
      }
      .auth-switch a {
        color: var(--color-accent);
        text-decoration: none;
        font-weight: 600;
      }
      .auth-switch a:hover {
        text-decoration: underline;
      }
    </style>
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

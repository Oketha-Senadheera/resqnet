<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Forgot Password">
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
      .auth-legal {
        text-align: center;
        margin-top: 2rem;
        font-size: var(--font-size-xs);
        color: var(--color-text-subtle);
      }
      .auth-legal a {
        color: var(--color-text-subtle);
        text-decoration: none;
      }
      .auth-legal a:hover {
        color: var(--color-text);
      }
    </style>
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

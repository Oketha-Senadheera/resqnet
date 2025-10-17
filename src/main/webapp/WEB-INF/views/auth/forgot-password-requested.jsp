<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Reset Requested">
  <jsp:attribute name="styles">
    <style>
      .auth-container {
        max-width: 440px;
        margin: 3rem auto;
        padding: 0 1.5rem;
        text-align: center;
      }
      .success-icon {
        width: 64px;
        height: 64px;
        margin: 0 auto 1.5rem;
        background: rgba(255, 204, 0, 0.1);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .success-icon svg {
        width: 32px;
        height: 32px;
        stroke: var(--color-accent);
      }
      .auth-heading {
        font-size: clamp(1.75rem, 3vw, 2rem);
        font-weight: 600;
        margin: 0 0 0.75rem;
      }
      .auth-text {
        color: var(--color-text-subtle);
        font-size: var(--font-size-sm);
        margin: 0 0 1.5rem;
        line-height: 1.5;
      }
      .error-message {
        color: var(--color-danger);
        background: rgba(215, 48, 47, 0.1);
        padding: 0.75rem 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1.5rem;
        font-size: var(--font-size-sm);
      }
      .auth-switch {
        text-align: center;
        margin-top: 2rem;
        font-size: var(--font-size-sm);
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
      <div class="success-icon">
        <i data-lucide="check"></i>
      </div>
      
      <h1 class="auth-heading">Check your email</h1>
      <p class="auth-text">
        If the email exists, a reset link has been sent. Check your inbox and spam folder.
      </p>
      
      <c:if test="${emailSent == false}">
        <div class="error-message">Failed to send email: ${mailError}</div>
      </c:if>
      
      <div class="auth-switch">
        <a href="${pageContext.request.contextPath}/login">Back to Login</a>
      </div>
      
      <footer class="auth-legal">
        <a href="#">Terms of Service</a>
        <span aria-hidden="true"> · </span>
        <a href="#">Privacy Policy</a>
      </footer>
    </div>
    
    <script>
      document.addEventListener("DOMContentLoaded", () => {
        if (window.lucide) {
          window.lucide.createIcons();
        }
      });
    </script>
  </jsp:body>
</layout:auth>

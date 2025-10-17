<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="NGO Sign Up">
  <jsp:attribute name="styles">
    <style>
      body { background:#fff; }
      .site-header { position:sticky; top:0; z-index:40; }
      .main-wrapper { max-width:1080px; margin:0 auto; padding:3.5rem clamp(1rem,3vw,2.5rem) 4rem; }
      h1 { font-size:clamp(1.6rem,2.5vw,2rem); font-weight:600; margin:0 0 2rem; }
      .org-form .grid {
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(280px,1fr));
        gap:1.5rem;
        margin-bottom:1.5rem;
      }
      .org-form .form-field.wide { grid-column:1/-1; }
      .form-help { font-size:var(--font-size-xs); color:var(--color-text-subtle); margin-top:0.25rem; }
      .error {
        color:var(--color-danger);
        font-size:var(--font-size-xs);
        margin-top:0.25rem;
        display:none;
      }
      .error-message {
        color: var(--color-danger);
        background: rgba(215, 48, 47, 0.1);
        padding: 0.75rem 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1.5rem;
        font-size: var(--font-size-sm);
      }
      .form-actions {
        display: flex;
        gap: 1rem;
      }
    </style>
  </jsp:attribute>
  <jsp:body>
    <div class="main-wrapper">
      <h1>Sign up your organization</h1>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form id="orgPublicSignupForm" class="org-form" method="post" action="${pageContext.request.contextPath}/signup/ngo" novalidate>
        <div class="grid">
          <div class="form-field wide">
            <label for="orgName">Organization Name *</label>
            <input class="input" id="orgName" name="orgName" placeholder="Enter organization name" required />
          </div>
          <div class="form-field">
            <label for="regNo">Registration No. *</label>
            <input class="input" id="regNo" name="regNo" placeholder="Enter registration number" required />
          </div>
          <div class="form-field">
            <label for="years">Years of Operation</label>
            <input class="input" type="number" min="0" id="years" name="years" placeholder="Enter years of operation" />
          </div>
          <div class="form-field">
            <label for="contactPerson">Contact Person Name</label>
            <input class="input" id="contactPerson" name="contactPerson" placeholder="Enter contact person's name" />
          </div>
          <div class="form-field">
            <label for="contactEmail">Contact Person Email</label>
            <input class="input" type="email" id="contactEmail" name="contactEmail" placeholder="Enter contact person's email" />
          </div>
          <div class="form-field">
            <label for="telephone">Contact Person Telephone</label>
            <input class="input" id="telephone" name="telephone" placeholder="Enter contact person's telephone" />
          </div>
          <div class="form-field wide">
            <label for="address">Organization Address</label>
            <input class="input" id="address" name="address" placeholder="Enter organization address" />
          </div>
          <div class="form-field">
            <label for="username">Account Username *</label>
            <input class="input" id="username" name="username" placeholder="Choose a username" required />
          </div>
          <div class="form-field">
            <label for="email">Account Email *</label>
            <input class="input" type="email" id="email" name="email" placeholder="Enter account email" required />
          </div>
          <div class="form-field">
            <label for="password">Password *</label>
            <input class="input" type="password" id="password" name="password" placeholder="Enter password" minlength="6" required />
            <div class="form-help">Minimum 6 characters.</div>
          </div>
          <div class="form-field">
            <label for="confirmPassword">Confirm Password *</label>
            <input class="input" type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required />
            <div class="error" id="pwError">Passwords do not match.</div>
          </div>
        </div>
        <div class="form-actions">
          <a href="${pageContext.request.contextPath}/signup" class="btn">Back</a>
          <button type="submit" class="btn btn-primary">Sign Up</button>
        </div>
      </form>
    </div>
    <script>
      const form = document.getElementById('orgPublicSignupForm');
      const pw = document.getElementById('password');
      const confirmPw = document.getElementById('confirmPassword');
      const pwError = document.getElementById('pwError');
      
      function checkMatch(){
        const mismatch = pw.value && confirmPw.value && pw.value !== confirmPw.value;
        pwError.style.display = mismatch ? 'block' : 'none';
        confirmPw.classList.toggle('is-invalid', mismatch);
        return !mismatch;
      }
      
      pw.addEventListener('input', checkMatch);
      confirmPw.addEventListener('input', checkMatch);
      
      form.addEventListener('submit', e => {
        if(!form.reportValidity() || !checkMatch()) {
          e.preventDefault();
          return false;
        }
      });
    </script>
  </jsp:body>
</layout:auth>

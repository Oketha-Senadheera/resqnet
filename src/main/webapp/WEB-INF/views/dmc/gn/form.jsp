<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<c:set var="isEdit" value="${editMode == true}" />
<c:set var="pageTitle" value="${isEdit ? 'Edit Grama Niladhari' : 'Register Grama Niladhari'}" />
<layout:dmc-dashboard pageTitle="ResQnet - ${pageTitle}" activePage="gn-registry">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.4rem; }
      .alert { padding:0.75rem 1rem; margin-bottom:1rem; border-radius:var(--radius-md); font-size:0.85rem; }
      .alert-error { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb; }
      form#registerForm { max-width:1180px; display:flex; flex-direction:column; gap:1.6rem; }
      .grid-2 { display:grid; gap:1.1rem 2rem; grid-template-columns:repeat(auto-fit,minmax(320px,1fr)); }
      .form-field { display:flex; flex-direction:column; gap:0.4rem; }
      .form-field label { font-size:0.85rem; font-weight:600; color:#333; }
      .input { background:#fcf8ef; padding:0.75rem 1rem; border:1px solid var(--color-border); border-radius:var(--radius-md); font-size:0.85rem; font-family:inherit; }
      .input:focus { outline:none; border-color:var(--color-accent); }
      .input:disabled { background:#e9e9e9; cursor:not-allowed; }
      select.input { appearance:auto; }
      .actions { display:flex; justify-content:space-between; align-items:center; max-width:1180px; margin-top:0.25rem; }
      .actions-right { margin-left:auto; display:flex; gap:1.2rem; align-items:center; }
      .btn { all:unset; cursor:pointer; font-weight:600; padding:0.65rem 1.5rem; border-radius:999px; font-size:0.85rem; display:inline-block; text-align:center; }
      .btn-muted { background:#efefef; border:1px solid #dedede; color:#444; }
      .btn-muted:hover { background:#e7e7e7; }
      .btn-primary { background:var(--color-accent); color:#000; }
      .btn-primary:hover { background:var(--color-accent-hover); }
      .btn-secondary { background:#e9e9e9; color:#333; border:1px solid #ccc; }
      .btn-secondary:hover { background:#d9d9d9; }
      .input-group { display:flex; gap:0.75rem; align-items:center; }
      @media (max-width:640px){ .grid-2 { grid-template-columns:1fr; } .actions { flex-wrap:wrap; gap:0.8rem; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const generateBtn = document.getElementById('generateBtn');
        const passwordInput = document.getElementById('password');
        
        if (generateBtn && passwordInput) {
          generateBtn.addEventListener('click', () => {
            const generated = Math.random().toString(36).slice(2, 10) + Math.random().toString(36).slice(2, 10);
            passwordInput.value = generated;
            passwordInput.type = 'text';
          });
        }
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>${pageTitle}</h1>

    <c:if test="${not empty error}">
      <div class="alert alert-error">${error}</div>
    </c:if>

    <form id="registerForm" method="post" novalidate>
      <c:if test="${isEdit}">
        <input type="hidden" name="userId" value="${gnData.user.id}" />
      </c:if>

      <div class="grid-2">
        <div class="form-field">
          <label for="divisionName">Division Name *</label>
          <input class="input" id="divisionName" name="divisionName" type="text" 
                 placeholder="Enter Division Name" required 
                 value="${isEdit ? gnData.gramaNiladhari.gnDivision : ''}" />
        </div>
        <div class="form-field">
          <label for="divisionNumber">Division Number</label>
          <input class="input" id="divisionNumber" name="divisionNumber" type="text" 
                 placeholder="Enter Division Number" 
                 value="${isEdit ? gnData.gramaNiladhari.gnDivisionNumber : ''}" />
        </div>
        <div class="form-field">
          <label for="fullName">Full Name *</label>
          <input class="input" id="fullName" name="fullName" type="text" 
                 placeholder="Enter Full Name" required 
                 value="${isEdit ? gnData.gramaNiladhari.name : ''}" />
        </div>
        <div class="form-field">
          <label for="serviceNumber">Service Number</label>
          <input class="input" id="serviceNumber" name="serviceNumber" type="text" 
                 placeholder="Enter Service Number" 
                 value="${isEdit ? gnData.gramaNiladhari.serviceNumber : ''}" />
        </div>
        <div class="form-field">
          <label for="contactNumber">Contact Number *</label>
          <input class="input" id="contactNumber" name="contactNumber" type="tel" 
                 placeholder="Enter Contact Number" required 
                 value="${isEdit ? gnData.gramaNiladhari.contactNumber : ''}" />
        </div>
        <div class="form-field">
          <label for="address">Address</label>
          <input class="input" id="address" name="address" type="text" 
                 placeholder="Enter Address" 
                 value="${isEdit ? gnData.gramaNiladhari.address : ''}" />
        </div>
        <div class="form-field">
          <label for="email">Email *</label>
          <input class="input" id="email" name="email" type="email" 
                 placeholder="Enter Email" required 
                 value="${isEdit ? gnData.user.email : ''}"
                 ${isEdit ? 'disabled' : ''} />
          <c:if test="${isEdit}">
            <small style="color:#666; font-size:0.75rem;">Email cannot be changed</small>
          </c:if>
        </div>
        <div class="form-field">
          <label for="username">Username *</label>
          <input class="input" id="username" name="username" type="text" 
                 placeholder="Enter Username" 
                 value="${isEdit ? gnData.user.username : ''}"
                 ${isEdit ? 'disabled' : ''} />
          <c:if test="${isEdit}">
            <small style="color:#666; font-size:0.75rem;">Username cannot be changed</small>
          </c:if>
        </div>
      </div>

      <c:if test="${!isEdit}">
        <div class="form-field">
          <label for="password">Password *</label>
          <div class="input-group">
            <input class="input" id="password" name="password" type="password" 
                   placeholder="Enter or Generate Password" autocomplete="new-password" 
                   style="flex:1;" required />
            <button type="button" class="btn btn-secondary" id="generateBtn">Generate</button>
          </div>
        </div>
      </c:if>

      <div class="actions">
        <a href="${pageContext.request.contextPath}/dmc/gn-registry" class="btn btn-muted">Cancel</a>
        <div class="actions-right">
          <button type="submit" class="btn btn-primary">${isEdit ? 'Update GN' : 'Register GN'}</button>
        </div>
      </div>
    </form>
  </jsp:body>
</layout:dmc-dashboard>

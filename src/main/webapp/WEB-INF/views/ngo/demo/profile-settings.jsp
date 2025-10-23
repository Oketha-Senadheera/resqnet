<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet - General Public Overview" activePage="profile-settings">

<jsp:body>

<style>
      form.org-profile { max-width:1150px; display:flex; flex-direction:column; gap:2.25rem; }
      .grid-2 { display:grid; gap:1.25rem 2rem; grid-template-columns:repeat(auto-fit,minmax(250px,1fr)); }
      .section-block h2 { font-size:0.85rem; margin:0 0 0.9rem; font-weight:600; }
      textarea.input { min-height:140px; resize:vertical; }
      .action-row { display:flex; align-items:center; gap:0.85rem; justify-content:flex-end; }
      .danger { --btn-bg: var(--color-danger); --btn-border: var(--color-danger); --btn-color:#fff; }
      .btn-muted { background:#f0f0f0; border-color:#e2e2e2; }
      .btn-muted:hover { background:#e8e8e8; }
      .left-actions { margin-right:auto; display:flex; gap:0.75rem; }
      @media (max-width:640px){ .action-row { flex-wrap:wrap; } .left-actions { width:100%; order:2; justify-content:space-between; } }
    </style>

<main class="content" id="mainContent" tabindex="-1">
        <h1>My Organization Profile</h1>
        <form class="org-profile" id="orgProfileForm" novalidate>
          <div class="section-block">
            <h2>Organization Details</h2>
            <div class="form-field">
              <label for="orgName">Organization Name</label>
              <input class="input" type="text" id="orgName" name="orgName" required />
            </div>
            <div class="grid-2" style="margin-top:1rem;">
              <div class="form-field">
                <label for="regNumber">Registration Number</label>
                <input class="input" type="text" id="regNumber" name="registrationNumber" required />
              </div>
              <div class="form-field">
                <label for="years">Years of Operation</label>
                <input class="input" type="number" id="years" name="yearsOfOperation" min="0" step="1" required />
              </div>
            </div>
          </div>
          <div class="section-block">
            <h2>Contact Person Details</h2>
            <div class="form-field">
              <label for="contactName">Name</label>
              <input class="input" type="text" id="contactName" name="contactName" required />
            </div>
            <div class="grid-2" style="margin-top:1rem;">
              <div class="form-field">
                <label for="contactEmail">Email</label>
                <input class="input" type="email" id="contactEmail" name="contactEmail" required />
              </div>
              <div class="form-field">
                <label for="contactPhone">Telephone</label>
                <input class="input" type="tel" id="contactPhone" name="contactPhone" pattern="[0-9()+\-\s]{7,}" required />
              </div>
            </div>
          </div>
          <div class="section-block">
            <h2>Organization Address</h2>
            <div class="form-field">
              <label for="orgAddress">Address</label>
              <textarea class="input" id="orgAddress" name="orgAddress" placeholder="" required></textarea>
            </div>
          </div>
          <div class="section-block">
            <h2>Account Credentials</h2>
            <div class="form-field">
              <label for="username">Username</label>
              <input class="input" type="text" id="username" name="username" required />
            </div>
            <div class="left-actions" style="margin-top:1rem;">
              <button type="button" class="btn btn-muted" id="changePasswordBtn">Change Password</button>
              <button type="button" class="btn danger" id="deactivateBtn">Deactivate My Account</button>
            </div>
          </div>
          <div class="action-row">
            <button type="reset" class="btn btn-muted">Cancel</button>
            <button type="submit" class="btn btn-primary">Save Changes</button>
          </div>
        </form>
      </main>

 <script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        const form = document.getElementById('orgProfileForm');
        document.getElementById('changePasswordBtn').addEventListener('click', () => alert('Password change flow not implemented.'));
        document.getElementById('deactivateBtn').addEventListener('click', () => { if(confirm('Are you sure you want to deactivate this organization account?')) { console.log('Organization deactivation requested'); alert('Deactivation request logged (console).'); } });
        form.addEventListener('submit', e => {
          e.preventDefault();
          if(!form.reportValidity()) return;
          const fd = new FormData(form); const payload = Object.fromEntries(fd.entries());
          console.log('Organization profile saved', payload);
          alert('Organization profile saved! (See console for payload)');
        });
      });
    </script>

</jsp:body>

</layout:ngo-dashboard>




 <%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - General Public Overview" activePage="profile-settings">

<jsp:body>

<style>
      .password-wrapper { max-width: 760px; }
      .stack { display:flex; flex-direction:column; gap:1.85rem; }
      .btn-wide { width:100%; display:block; }
      .gap-lg { margin-top:2.2rem; }
      .btn-neutral { background:#eee; border-color:#e2e2e2; }
      .btn-neutral:hover { background:#e4e4e4; }
      .center-title { text-align:center; margin:0 0 2.2rem; }
    </style>

    <main class="content" id="mainContent" tabindex="-1">
        <div class="password-wrapper">
          <h1 class="center-title">Change Password</h1>
          <form id="changePasswordForm" class="stack" novalidate>
            <div class="form-field">
              <label for="currentPassword">Current Password</label>
              <input class="input" type="password" id="currentPassword" name="currentPassword" placeholder="Enter your current password" required autocomplete="current-password" />
            </div>
            <div class="form-field">
              <label for="newPassword">New Password</label>
              <input class="input" type="password" id="newPassword" name="newPassword" placeholder="Enter your new password" required minlength="8" autocomplete="new-password" />
              <div class="form-help">Must be at least 8 characters.</div>
            </div>
            <div class="form-field">
              <label for="confirmPassword">Confirm New Password</label>
              <input class="input" type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your new password" required autocomplete="new-password" />
              <div class="form-help" id="matchHelp" style="display:none;color:var(--color-danger);">Passwords do not match.</div>
            </div>
            <div class="gap-lg"></div>
            <button type="submit" class="btn btn-primary btn-wide">Submit</button>
            <button type="button" class="btn btn-neutral btn-wide" id="cancelButton">Cancel</button>
          </form>
        </div>
      </main>

      <script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        const form = document.getElementById('changePasswordForm');
        const current = document.getElementById('currentPassword');
        const pw = document.getElementById('newPassword');
        const confirmPw = document.getElementById('confirmPassword');
        const matchHelp = document.getElementById('matchHelp');
        const cancelBtn = document.getElementById('cancelButton');

        function checkMatch() {
          const mismatch = pw.value && confirmPw.value && pw.value !== confirmPw.value;
            matchHelp.style.display = mismatch ? 'block' : 'none';
            confirmPw.classList.toggle('is-invalid', mismatch);
            return !mismatch;
        }
        pw.addEventListener('input', checkMatch);
        confirmPw.addEventListener('input', checkMatch);

        form.addEventListener('submit', e => {
          e.preventDefault();
          if (!form.reportValidity()) return;
          if (!checkMatch()) return;
          const payload = { currentPassword: current.value, newPassword: pw.value };
          // In real app: send to backend via fetch POST.
          console.log('Password change submitted', payload);
          alert('Password change submitted! (Console log only)');
          form.reset();
        });
        cancelBtn.addEventListener('click', () => {
          history.back();
        });
      });
    </script>

</jsp:body>

</layout:dmc-dashboard>    
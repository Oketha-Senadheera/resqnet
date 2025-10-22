<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - General Public Overview" activePage="overview">

<jsp:body>
<style>
      /* Page-scoped helpers (reuse global tokens) */
      form.profile-form { max-width: 1100px; display: flex; flex-direction: column; gap: 2.5rem; }
      .grid-2 { display:grid; gap:1.5rem 2rem; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); }
      .section-block h2 { font-size:1rem; margin:0 0 1rem; font-weight:600; }
      .input[readonly] { background:#fcfbf7; }
      .stack-sm { display:flex; flex-direction:column; gap:0.75rem; }
      .inline-btn-row { display:flex; justify-content:flex-end; gap:0.85rem; align-items:center; }
      .danger { --btn-bg: var(--color-danger); --btn-border: var(--color-danger); --btn-color:#fff; }
      .danger:hover { filter:brightness(.92); }
      .btn-muted { background:#f4f4f4; border-color:#e5e5e5; }
      .btn-muted:hover { background:#ececec; }
      /* Toggle */
      .toggle { position:relative; display:inline-flex; align-items:center; width:44px; height:24px; }
      .toggle input { opacity:0; width:0; height:0; position:absolute; }
      .toggle-track { position:absolute; inset:0; background:#e7e4dd; border-radius:999px; transition:var(--transition); }
      .toggle-thumb { position:absolute; top:2px; left:2px; width:20px; height:20px; background:#fff; border-radius:50%; box-shadow:0 1px 2px rgba(0,0,0,.15); transition:var(--transition); }
      .toggle input:checked + .toggle-track { background: var(--color-accent); }
      .toggle input:checked + .toggle-track .toggle-thumb { transform:translateX(20px); }
      .consent-row { background:#fbfaf7; border:1px solid var(--color-border); padding:0.9rem 1rem; border-radius:var(--radius-sm); display:flex; justify-content:space-between; align-items:center; font-size:0.8rem; }
      .divider { border:none; border-top:1px solid var(--color-border); margin:0; }
      .actions-bar { display:flex; justify-content:flex-end; gap:1rem; align-items:center; }
      .grow { flex:1; }
    </style>
<main class="content" id="mainContent" tabindex="-1">
        <h1>My Profile</h1>
        <form class="profile-form" id="profileForm" novalidate>
          <!-- Personal Information -->
          <div class="section-block">
            <h2>Personal Information</h2>
            <div class="grid-2">
              <div class="form-field">
                <label for="fullName">Full Name</label>
                <input class="input" type="text" id="fullName" name="fullName" required />
              </div>
              <div class="form-field">
                <label for="contactNumber">Contact Number</label>
                <input class="input" type="tel" id="contactNumber" name="contactNumber" required />
              </div>
              <div class="form-field">
                <label for="email">Email Address</label>
                <input class="input" type="email" id="email" name="email" required />
              </div>
              <div class="form-field">
                <label for="username">Username</label>
                <div style="position:relative;">
                  <input class="input" type="text" id="username" name="username" required />
                  <button type="button" id="editUsername" aria-label="Edit Username" style="position:absolute;top:50%;right:8px;transform:translateY(-50%);background:none;border:0;cursor:pointer;padding:4px;display:flex;align-items:center;opacity:.6;"><span data-lucide="pencil"></span></button>
                </div>
              </div>
            </div>
          </div>

          <!-- Address -->
            <div class="section-block">
              <h2>Address</h2>
              <div class="grid-2">
                <div class="form-field">
                  <label for="houseNo">House No.</label>
                  <input class="input" type="text" id="houseNo" name="houseNo" />
                </div>
                <div class="form-field">
                  <label for="street">Street</label>
                  <input class="input" type="text" id="street" name="street" />
                </div>
                <div class="form-field">
                  <label for="city">City</label>
                  <input class="input" type="text" id="city" name="city" />
                </div>
                <div class="form-field">
                  <label for="district">District</label>
                  <select class="input" id="district" name="district">
                    <option value="">Select district</option>
                    <option>Colombo</option>
                    <option>Gampaha</option>
                    <option>Kalutara</option>
                    <option>Kandy</option>
                    <option>Galle</option>
                  </select>
                </div>
                <div class="form-field">
                  <label for="gnDivision">Grama Niladhari Division</label>
                  <input class="input" type="text" id="gnDivision" name="gnDivision" />
                </div>
              </div>
            </div>

            <!-- Account Security -->
            <div class="section-block">
              <h2>Account Security</h2>
              <div class="stack-sm">
                <button type="button" class="btn btn-muted" id="changePasswordBtn">Change Password</button>
              </div>
            </div>

            <!-- Consent -->
            <div class="section-block">
              <h2>Consent & Notifications</h2>
              <div class="consent-row">
                <span>Receive SMS updates</span>
                <label class="toggle">
                  <input type="checkbox" id="smsOptIn" name="smsOptIn" />
                  <span class="toggle-track"><span class="toggle-thumb"></span></span>
                </label>
              </div>
            </div>

            <hr class="divider" />
            <div class="actions-bar">
              <button type="button" class="btn danger" id="deactivateBtn">Deactivate My Account</button>
              <div class="grow"></div>
              <button type="reset" class="btn btn-muted">Cancel</button>
              <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
      </main>
<script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        const form = document.getElementById('profileForm');
        const editUsernameBtn = document.getElementById('editUsername');
        const usernameInput = document.getElementById('username');
        editUsernameBtn.addEventListener('click', () => {
          usernameInput.focus();
          usernameInput.select();
        });
        document.getElementById('changePasswordBtn').addEventListener('click', () => {
          alert('Password change flow not implemented.');
        });
        document.getElementById('deactivateBtn').addEventListener('click', () => {
          if (confirm('Are you sure you want to deactivate your account?')) {
            console.log('Account deactivation requested');
            alert('Deactivation request logged (console).');
          }
        });
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          if (!form.reportValidity()) return;
          const data = new FormData(form);
            const payload = Object.fromEntries(data.entries());
            payload.smsOptIn = data.get('smsOptIn') === 'on';
            console.log('Profile saved', payload);
            alert('Profile saved! (See console for payload)');
        });
      });
    </script>
</jsp:body>

</layout:general-user-dashboard>
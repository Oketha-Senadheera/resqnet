<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:volunteer-dashboard pageTitle="ResQnet - General Public Overview" activePage="profile-settings">

<jsp:body>

<style>
      /* Layout helpers scoped to this page */
      form.profile-form { max-width: 1180px; display:flex; flex-direction:column; gap:2rem; }
      .grid-2 { display:grid; gap:1.25rem 2rem; grid-template-columns:repeat(auto-fit,minmax(280px,1fr)); }
      .section h2 { margin:0 0 1rem; font-size:1rem; }
      .muted { color:#666; }
      .inline { display:flex; align-items:center; gap:.5rem; }
      .actions-bar { display:flex; align-items:center; gap:1rem; justify-content:flex-end; }
      .danger { --btn-bg: var(--color-danger); --btn-border: var(--color-danger); --btn-color:#fff; }
      .danger:hover { filter:brightness(.92); }
      .btn-muted { background:#f4f4f4; border-color:#e5e5e5; }
      .btn-muted:hover { background:#ececec; }
      .panelish { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.25rem; }
      .two-col { display:grid; gap:1.25rem 2rem; grid-template-columns:1fr 1fr; }
      @media (max-width: 920px){ .two-col{ grid-template-columns:1fr; } }
      .check-grid { display:grid; grid-template-columns:1fr; gap:.55rem; }
      .form-hint { font-size:.75rem; color:#888; margin-top:.25rem; }
    </style>

<main class="content" id="mainContent" tabindex="-1">
        <h1 style="margin:0 0 1rem;">My Volunteer Profile</h1>
        <form class="profile-form" id="vProfileForm" novalidate>
          <section class="section panelish">
            <h2>Personal Information</h2>
            <div class="grid-2">
              <div class="form-field">
                <label for="fullName">Full Name</label>
                <input class="input" id="fullName" name="fullName" required />
              </div>
              <div class="form-field">
                <label for="age">Age</label>
                <input class="input" id="age" name="age" type="number" min="16" />
              </div>
              <div class="form-field">
                <label for="gender">Gender</label>
                <select class="input" id="gender" name="gender">
                  <option value="">Select</option>
                  <option>Male</option>
                  <option>Female</option>
                  <option>Other</option>
                </select>
              </div>
              <div class="form-field">
                <label for="contactNumber">Contact Number</label>
                <input class="input" id="contactNumber" name="contactNumber" type="tel" />
              </div>
            </div>
          </section>

          <section class="section panelish">
            <h2>Address Information</h2>
            <div class="grid-2">
              <div class="form-field">
                <label for="houseNo">House No.</label>
                <input class="input" id="houseNo" name="houseNo" />
              </div>
              <div class="form-field">
                <label for="street">Street</label>
                <input class="input" id="street" name="street" />
              </div>
              <div class="form-field">
                <label for="city">City</label>
                <input class="input" id="city" name="city" />
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
                <input class="input" id="gnDivision" name="gnDivision" />
              </div>
            </div>
          </section>

          <section class="section panelish">
            <div class="two-col">
              <div>
                <h2>Preferred Volunteer Roles</h2>
                <div class="check-grid">
                  <label class="inline"><input type="checkbox" name="roles" value="Search & Rescue" checked /> Search & Rescue</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Medical Aid" checked /> Medical Aid</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Logistics Support" checked /> Logistics Support</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Technical Support" /> Technical Support</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Shelter Management" /> Shelter Management</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Food Preparation & Distribution" /> Food Preparation & Distribution</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Childcare Support" /> Childcare Support</label>
                  <label class="inline"><input type="checkbox" name="roles" value="Elderly Assistance" /> Elderly Assistance</label>
                </div>
              </div>
              <div>
                <h2>Specialized Skills</h2>
                <div class="check-grid">
                  <label class="inline"><input type="checkbox" name="skills" value="First Aid Certified" checked /> First Aid Certified</label>
                  <label class="inline"><input type="checkbox" name="skills" value="Medical Professional" checked /> Medical Professional</label>
                  <label class="inline"><input type="checkbox" name="skills" value="Firefighting" /> Firefighting</label>
                  <label class="inline"><input type="checkbox" name="skills" value="Swimming / Lifesaving" /> Swimming / Lifesaving</label>
                  <label class="inline"><input type="checkbox" name="skills" value="Rescue & Handling" /> Rescue & Handling</label>
                  <label class="inline"><input type="checkbox" name="skills" value="Disaster Management Training" /> Disaster Management Training</label>
                </div>
              </div>
            </div>
          </section>

          <section class="section panelish">
            <h2>Account Credentials</h2>
            <div class="grid-2">
              <div class="form-field">
                <label for="username">Username</label>
                <input class="input" id="username" name="username" />
                <div class="form-hint">Use 4–20 characters.</div>
              </div>
            </div>
            <div class="inline" style="justify-content:space-between;margin-top:.75rem;">
              <button type="button" class="btn btn-muted" id="changePasswordBtn">Change Password</button>
              <button type="button" class="btn danger" id="deactivateBtn">Deactivate My Account</button>
            </div>
          </section>

          <div class="actions-bar">
            <button type="reset" class="btn btn-muted">Cancel</button>
            <button type="submit" class="btn btn-primary">Save Changes</button>
          </div>
        </form>
      </main>


<script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();

        // Sidebar routing
        document.querySelectorAll('.nav-item').forEach((btn) => {
          btn.addEventListener('click', () => {
            const s = btn.getAttribute('data-section');
            switch (s) {
              case 'overview': location.href = 'volunteer-overview.html'; break;
              case 'forecast': location.href = 'forecast-dashboard.html'; break;
              case 'safe-locations': location.href = 'safe-locations-volunteer.html'; break;
              case 'make-donation': location.href = 'make-donation.html'; break;
              case 'request-donation': location.href = 'request-donation.html'; break;
              case 'report-disaster': location.href = 'report-disaster.html'; break;
              case 'forum': location.href = 'community-forum.html'; break;
              case 'profile-settings': location.href = 'volunteer-profile-settings.html'; break;
            }
          });
        });

        // Form handlers
        const form = document.getElementById('vProfileForm');
        document.getElementById('changePasswordBtn').addEventListener('click', ()=> alert('Password change flow coming soon.'));
        document.getElementById('deactivateBtn').addEventListener('click', ()=> {
          if(confirm('Are you sure you want to deactivate your account?')) alert('Deactivation requested.');
        });
        form.addEventListener('submit', (e) => {
          e.preventDefault();
          if(!form.reportValidity()) return;
          const fd = new FormData(form);
          const payload = Object.fromEntries(fd.entries());
          payload.roles = fd.getAll('roles');
          payload.skills = fd.getAll('skills');
          console.log('Volunteer profile saved', payload);
          alert('Profile saved! (See console)');
        });

        // Logout
        document.querySelector('.logout').addEventListener('click', () => {
          if (confirm('Are you sure you want to logout?')) location.href = 'login.html';
        });
      });
    </script>

</jsp:body>

</layout:volunteer-dashboard>




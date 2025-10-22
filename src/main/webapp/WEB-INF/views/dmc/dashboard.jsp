<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - DMC Overview" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      .safe-grid { 
        display: grid; 
        grid-template-columns: 1fr 1.2fr; 
        gap: 1.25rem; 
      }
      .add-btn { 
        all: unset; 
        display: block; 
        width: max-content; 
        background: var(--color-accent); 
        font-weight: 700; 
        padding: 0.65rem 1.2rem; 
        border-radius: 999px; 
        cursor: pointer; 
        font-size: 0.85rem; 
        margin-bottom: 0.8rem; 
        font-family: var(--font-family-base);
      }
      .add-btn:hover { 
        background: var(--color-accent-hover); 
      }
      .loc-list { 
        display: flex; 
        flex-direction: column; 
        gap: 0.6rem; 
      }
      .loc-item { 
        background: var(--color-surface); 
        border: 1px solid var(--color-border); 
        border-radius: var(--radius-md); 
        padding: 0.85rem 0.95rem; 
      }
      .loc-name { 
        font-size: 0.9rem; 
        font-weight: 600; 
        margin-bottom: 0.25rem; 
      }
      .loc-geo { 
        font-size: 0.72rem; 
        color: #666; 
      }
      .map-wrap { 
        background: var(--color-surface); 
        border: 1px solid var(--color-border); 
        border-radius: var(--radius-md); 
        min-height: 360px; 
        overflow: hidden; 
      }
      .map-wrap iframe { 
        width: 100%; 
        height: 100%; 
        border: 0; 
        display: block; 
      }
      @media (max-width: 980px) { 
        .safe-grid { 
          grid-template-columns: 1fr; 
        } 
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.querySelectorAll('.nav-item').forEach((btn) => {
        btn.addEventListener('click', () => {
          document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
          btn.classList.add('active');
        });
      });

      document.getElementById('reportsBody').addEventListener('click', (e) => {
        const btn = e.target.closest('button.pill');
        if (!btn) return;
        const row = btn.closest('tr');
        const statusCell = row.querySelector('.status');
        if (btn.dataset.action === 'verify') {
          statusCell.innerHTML = '<span class="status-verified">Verified</span>';
        } else if (btn.dataset.action === 'reject') {
          row.remove();
        }
        if (window.lucide) lucide.createIcons();
      });

      document.getElementById('deliveriesBody').addEventListener('click', (e) => {
        const btn = e.target.closest('button.pill-confirm');
        if (!btn) return;
        const row = btn.closest('tr');
        row.cells[3].innerHTML = '<span class="status-verified">Confirmed</span>';
        btn.remove();
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1 class="page-title">Welcome ${not empty displayName ? displayName : sessionScope.authUser.email}!</h1>

    <section class="stats-grid" aria-label="Key Metrics">
      <article class="stat-card" aria-label="Disaster Reports">
        <div class="label">Disaster Reports</div>
        <div class="value">12</div>
      </article>
      <article class="stat-card" aria-label="Volunteer Applications">
        <div class="label">Volunteer Applications</div>
        <div class="value">45</div>
      </article>
      <article class="stat-card" aria-label="Deliveries to Confirm">
        <div class="label">Deliveries to Confirm</div>
        <div class="value">8</div>
      </article>
      <article class="stat-card" aria-label="GNs Registered">
        <div class="label">GNs Registered</div>
        <div class="value">230</div>
      </article>
    </section>
        </section>

        <section class="safe-card" aria-label="Safe Locations">
          <h2>Safe Locations</h2>
          <div class="safe-grid">
            <div>
              <button class="add-btn" id="addLocationBtn">Add New Location</button>
              <div class="loc-list">
                <div class="loc-item"><div class="loc-name">Central Park</div><div class="loc-geo">40.7128° N, 74.0060° W</div></div>
                <div class="loc-item"><div class="loc-name">Griffith Observatory</div><div class="loc-geo">34.0522° N, 118.2437° W</div></div>
                <div class="loc-item"><div class="loc-name">Eiffel Tower</div><div class="loc-geo">48.8566° N, 2.3522° E</div></div>
                <div class="loc-item"><div class="loc-name">Golden Gate Park</div><div class="loc-geo">37.7749° N, 122.4194° W</div></div>
              </div>
            </div>
            <div class="map-wrap">
              <iframe src="https://www.openstreetmap.org/export/embed.html?bbox=-74.0170%2C40.7000%2C-73.9950%2C40.7250&layer=mapnik&marker=40.7128%2C-74.0060" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
          </div>
        </section>

        <section class="section-card" aria-label="Real-time Disaster Reports" style="margin-top:2rem;">
          <h2>Real-time Disaster Reports</h2>
          <div class="table-shell">
            <table class="table">
              <thead><tr><th>Report ID</th><th>Location</th><th>Type</th><th>Status</th><th style="text-align:right;">Actions</th></tr></thead>
              <tbody id="reportsBody">
                <tr>
                  <td>#DR2024-001</td>
                  <td><a href="#">Colombo</a></td>
                  <td>High</td>
                  <td class="status"><span class="status-pending">Pending</span></td>
                  <td style="text-align:right;">
                    <div class="action-pills">
                      <button class="pill pill-verify" data-action="verify"><span data-lucide="check"></span>Verify</button>
                      <button class="pill pill-danger" data-action="reject"><span data-lucide="x"></span>Reject</button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>#DR2024-002</td>
                  <td><a href="#">Colombo</a></td>
                  <td>High</td>
                  <td class="status"><span class="status-pending">Pending</span></td>
                  <td style="text-align:right;">
                    <div class="action-pills">
                      <button class="pill pill-verify" data-action="verify"><span data-lucide="check"></span>Verify</button>
                      <button class="pill pill-danger" data-action="reject"><span data-lucide="x"></span>Reject</button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>#DR2024-003</td>
                  <td><a href="#">Colombo</a></td>
                  <td>High</td>
                  <td class="status"><span class="status-pending">Pending</span></td>
                  <td style="text-align:right;">
                    <div class="action-pills">
                      <button class="pill pill-verify" data-action="verify"><span data-lucide="check"></span>Verify</button>
                      <button class="pill pill-danger" data-action="reject"><span data-lucide="x"></span>Reject</button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <section class="section-card" aria-label="Incoming NGO Deliveries" style="margin-top:2rem;">
          <h2>Incoming NGO Deliveries</h2>
          <div class="table-shell">
            <table class="table">
              <thead><tr><th>Delivery ID</th><th>NGO</th><th>Items</th><th>Status</th><th style="text-align:right;">Actions</th></tr></thead>
              <tbody id="deliveriesBody">
                <tr>
                  <td>#DLV2024-001</td>
                  <td><a href="#">Relief Aid International</a></td>
                  <td><a href="#">Food, Water</a></td>
                  <td><span class="status-pending">Pending</span></td>
                  <td style="text-align:right;"><button class="pill pill-confirm" data-action="confirm"><span data-lucide="check"></span>Confirm</button></td>
                </tr>
                <tr>
                  <td>#DLV2024-002</td>
                  <td><a href="#">Relief Aid International</a></td>
                  <td><a href="#">Food, Water</a></td>
                  <td><span class="status-pending">Pending</span></td>
                  <td style="text-align:right;"><button class="pill pill-confirm" data-action="confirm"><span data-lucide="check"></span>Confirm</button></td>
                </tr>
                <tr>
                  <td>#DLV2024-003</td>
                  <td><a href="#">Relief Aid International</a></td>
                  <td><a href="#">Food, Water</a></td>
                  <td><span class="status-pending">Pending</span></td>
                  <td style="text-align:right;"><button class="pill pill-confirm" data-action="confirm"><span data-lucide="check"></span>Confirm</button></td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
  </jsp:body>
</layout:dmc-dashboard>

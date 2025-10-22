<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - General Public Overview" activePage="overview">

<jsp:body>

<style>
      /* Page-specific helpers (base tokens in core.css/dashboard.css) */
      .subtitle { color:#777; margin:0 0 1.25rem; }
      .filters { display:flex; flex-direction:column; gap:0.75rem; max-width:520px; margin-bottom:2rem; }
      .forecast-grid { display:grid; grid-template-columns:1fr 1fr; gap:1.25rem; }
      .card { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.25rem; }
      .card h3 { margin:0 0 .5rem; font-size:.95rem; color:#333; }
      .metric { font-size:2rem; font-weight:800; margin:.25rem 0 .35rem; }
      .delta { font-size:.85rem; color:#3a7d2f; font-weight:600; }
      .delta.neg { color:#d12b2b; }
      .chart { margin-top:.5rem; }
      @media (max-width: 900px){ .forecast-grid{ grid-template-columns:1fr; } }
    </style>

<main class="content" id="mainContent" tabindex="-1">
        <h1 class="mt-0" style="margin:0 0 .5rem; font-size:1.75rem;">Forecast Dashboard</h1>
        <p class="subtitle">Stay informed with the latest rainfall and flood forecasts for your selected river and station.</p>

        <section class="filters" aria-label="Filters">
          <select class="input" id="riverSelect" aria-label="Select River">
            <option value="" selected disabled>Select River</option>
            <option value="kelani">Kelani River</option>
            <option value="mahaweli">Mahaweli River</option>
            <option value="kalu">Kalu River</option>
          </select>
          <select class="input" id="stationSelect" aria-label="Select Station" disabled>
            <option value="" selected disabled>Select Station</option>
          </select>
        </section>

        <h2 class="mt-0" style="margin:0 0 .75rem; font-size:1.25rem;">7–Day Forecast</h2>

        <section class="forecast-grid" aria-label="7-day forecast visuals">
          <!-- Rainfall Forecast Card -->
          <article class="card" aria-label="Rainfall Forecast">
            <h3>Rainfall Forecast</h3>
            <div class="metric">1.2 in</div>
            <div class="delta">Next 7 Days <span style="margin-left:6px;">+10%</span></div>
            <div class="chart" aria-hidden="true">
              <svg viewBox="0 0 560 180" width="100%" height="180" role="img">
                <defs>
                  <linearGradient id="rainfill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stop-color="#b6b08a" stop-opacity="0.5"/>
                    <stop offset="100%" stop-color="#b6b08a" stop-opacity="0"/>
                  </linearGradient>
                </defs>
                <polyline fill="none" stroke="#8b865f" stroke-width="3" points="20,120 80,60 140,95 200,70 260,110 320,130 380,50 440,110 500,85 540,130"/>
                <polygon fill="url(#rainfill)" points="20,120 80,60 140,95 200,70 260,110 320,130 380,50 440,110 500,85 540,130 540,170 20,170"/>
                <g fill="#777" font-size="12">
                  <text x="40" y="168">Mon</text>
                  <text x="120" y="168">Tue</text>
                  <text x="200" y="168">Wed</text>
                  <text x="280" y="168">Thu</text>
                  <text x="360" y="168">Fri</text>
                  <text x="440" y="168">Sat</text>
                  <text x="520" y="168">Sun</text>
                </g>
              </svg>
            </div>
          </article>

          <!-- Flood Forecast Card -->
          <article class="card" aria-label="Flood Forecast">
            <h3>Flood Forecast</h3>
            <div class="metric">Low</div>
            <div class="delta neg">Next 7 Days <span style="margin-left:6px;">-5%</span></div>
            <div class="chart" aria-hidden="true">
              <svg viewBox="0 0 560 180" width="100%" height="180" role="img">
                <g fill="#e9e9e9" stroke="#cfcfcf" stroke-width="1">
                  <rect x="60" y="80" width="30" height="70" rx="4"/>
                  <rect x="120" y="70" width="30" height="80" rx="4"/>
                  <rect x="180" y="75" width="30" height="75" rx="4"/>
                  <rect x="240" y="78" width="30" height="72" rx="4"/>
                  <rect x="300" y="76" width="30" height="74" rx="4"/>
                  <rect x="360" y="73" width="30" height="77" rx="4"/>
                  <rect x="420" y="70" width="30" height="80" rx="4"/>
                </g>
                <g fill="#777" font-size="12">
                  <text x="62" y="168">Mon</text>
                  <text x="122" y="168">Tue</text>
                  <text x="182" y="168">Wed</text>
                  <text x="242" y="168">Thu</text>
                  <text x="302" y="168">Fri</text>
                  <text x="362" y="168">Sat</text>
                  <text x="422" y="168">Sun</text>
                </g>
              </svg>
            </div>
          </article>
        </section>
      </main>

<script>
      // Icons
      if (window.lucide) lucide.createIcons();

      // Sidebar routing like other dashboard pages
      document.querySelectorAll('.nav-item').forEach((btn) => {
        btn.addEventListener('click', () => {
          const s = btn.getAttribute('data-section');
          switch (s) {
            case 'overview':
              location.href = 'dmc-overview.html';
              break;
            case 'forecast':
              location.href = 'forecast-dashboard.html';
              break;
            case 'disaster-reports':
              location.href = 'disaster-reports.html';
              break;
            case 'volunteer-apps':
              location.href = 'volunteer-overview.html';
              break;
            case 'delivery-confirmations':
              location.href = 'manage-collection-points-v2.html';
              break;
            case 'safe-locations':
              location.href = 'safe-locations-gn.html';
              break;
            case 'gn-registry':
              location.href = 'gn-registry.html';
              break;
            case 'forum':
              location.href = 'forum-moderation-v2.html';
              break;
            case 'profile-settings':
              location.href = 'profile-settings.html';
              break;
          }
        });
      });

      // Logout
      document.querySelector('.logout').addEventListener('click', () => {
        if (confirm('Are you sure you want to logout?')) location.href = 'login.html';
      });

      // Populate Station dropdown based on selected river (simple demo data)
      const riverToStations = {
        kelani: ['Glencourse', 'Hanwella', 'Nawagamuwa'],
        mahaweli: ['Peradeniya', 'Katugastota', 'Gatambe'],
        kalu: ['Ratnapura', 'Ellagawa', 'Putupaula']
      };

      const riverSelect = document.getElementById('riverSelect');
      const stationSelect = document.getElementById('stationSelect');

      function setOptions(select, options) {
        // Clear all options
        while (select.options.length) select.remove(0);
        // Placeholder
        const ph = document.createElement('option');
        ph.value = '';
        ph.textContent = select === stationSelect ? 'Select Station' : 'Select River';
        ph.disabled = true; ph.selected = true;
        select.appendChild(ph);
        // Add options
        options.forEach(name => {
          const opt = document.createElement('option');
          opt.value = name;
          opt.textContent = name;
          select.appendChild(opt);
        });
      }

      riverSelect?.addEventListener('change', () => {
        const key = riverSelect.value;
        const list = riverToStations[key] || [];
        setOptions(stationSelect, list);
        stationSelect.disabled = list.length === 0;
      });
    </script>

</jsp:body>

</layout:general-user-dashboard>




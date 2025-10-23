<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:volunteer-dashboard pageTitle="ResQnet - General Public Overview" activePage="safe-locations">

<jsp:body>

<style>
      .section { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.25rem; }
      .section h2 { margin:0 0 1rem; font-size:1.05rem; }
      .safe-grid { display:grid; grid-template-columns: 1fr 1.2fr; gap:1.25rem; }
      .list { display:flex; flex-direction:column; gap:0.6rem; }
      .loc { background:var(--color-surface); border:1px solid var(--color-border); padding:0.85rem 1rem; border-radius:var(--radius-md); cursor:pointer; }
      .loc:hover { background:var(--color-hover-surface); }
      .name { font-weight:700; font-size:.9rem; margin-bottom:0.25rem; }
      .coords { color:#666; font-size:.75rem; }
      .map { background:var(--color-surface); border:1px solid var(--color-border); border-radius:var(--radius-md); min-height:360px; overflow:hidden; }
      .map iframe { width:100%; height:100%; border:0; display:block; }
      @media (max-width: 900px){ .safe-grid{ grid-template-columns:1fr; } }
    </style>

<main class="content" id="mainContent" tabindex="-1">
        <section class="section" aria-label="Safe Locations">
          <h2>Safe Locations</h2>
          <div class="safe-grid">
            <div class="list" id="locList">
              <button class="loc" data-lat="40.7128" data-lng="-74.0060" data-title="Central Park">
                <div class="name">Central Park</div>
                <div class="coords">40.7128° N, 74.0060° W</div>
              </button>
              <button class="loc" data-lat="34.0522" data-lng="-118.2437" data-title="Griffith Observatory">
                <div class="name">Griffith Observatory</div>
                <div class="coords">34.0522° N, 118.2437° W</div>
              </button>
              <button class="loc" data-lat="48.8566" data-lng="2.3522" data-title="Eiffel Tower">
                <div class="name">Eiffel Tower</div>
                <div class="coords">48.8566° N, 2.3522° E</div>
              </button>
              <button class="loc" data-lat="37.7749" data-lng="-122.4194" data-title="Golden Gate Park">
                <div class="name">Golden Gate Park</div>
                <div class="coords">37.7749° N, 122.4194° W</div>
              </button>
            </div>
            <div class="map" id="mapContainer"></div>
          </div>
        </section>
      </main>

<script>
      if (window.lucide) lucide.createIcons();

      // Sidebar routing for volunteer paths
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
            case 'profile-settings': location.href = 'profile-settings.html'; break;
          }
        });
      });

      // Logout
      document.querySelector('.logout').addEventListener('click', () => {
        if (confirm('Are you sure you want to logout?')) location.href = 'login.html';
      });

      // Map iframe removed; container (#mapContainer) retained for future integration
    </script>

</jsp:body>

</layout:volunteer-dashboard>




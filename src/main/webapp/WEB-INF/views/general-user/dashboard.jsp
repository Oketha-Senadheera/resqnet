<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - General Public Overview" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1rem; }
      .welcome { margin-bottom:1.2rem; }
      .alert.info { background:#fff5d6; border:1px solid #f0e0a8; color:#3a3320; display:flex; align-items:center; gap:0.6rem; padding:0.7rem 1rem; border-radius:12px; }
      .alert .alert-icon { width:18px; height:18px; }
      .quick-actions { display:grid; grid-template-columns:repeat(4,1fr); gap:1rem; margin:1rem 0 1.5rem; }
      .action-card { display:flex; flex-direction:column; align-items:center; justify-content:center; gap:0.6rem; padding:1.2rem; border:1px solid var(--color-border); border-radius:12px; background:#f6f6f6; cursor:pointer; }
      .action-card .action-icon i { width:24px; height:24px; }
      .safe-section { display:grid; grid-template-columns:1fr 1.2fr; gap:1rem; align-items:start; }
      .safe-list { display:flex; flex-direction:column; gap:0.6rem; }
      .safe-item { background:#f6f6f6; border:1px solid var(--color-border); border-radius:12px; padding:0.8rem 1rem; }
      .safe-item .name { font-weight:600; margin-bottom:0.15rem; }
      .map-shell { position:relative; border:1px solid var(--color-border); border-radius:12px; overflow:hidden; min-height:340px; background:#eaeaea; }
      .map-toolbar { position:absolute; right:0.75rem; top:0.75rem; background:#fff; border:1px solid var(--color-border); border-radius:999px; padding:0.25rem; display:flex; gap:0.25rem; }
      .map-search { position:absolute; left:0.75rem; top:0.75rem; background:#fff; border:1px solid var(--color-border); border-radius:999px; padding:0.35rem 0.6rem; display:flex; align-items:center; gap:0.4rem; }
      .map-iframe-holder { width:100%; height:100%; }
      @media (max-width:980px){ .safe-section { grid-template-columns:1fr; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        const list=[
          { name:'Central Park', coords:'40.7128° N, 74.0060° W' },
          { name:'Griffith Observatory', coords:'34.0522° N, 118.2437° W' },
          { name:'Eiffel Tower', coords:'48.8566° N, 2.3522° E' },
          { name:'Golden Gate Park', coords:'37.7749° N, 122.4194° W' }
        ];
        const wrap=document.getElementById('safeList'); const tmpl=document.getElementById('safe-item-tmpl');
        list.forEach(item=>{ const node=tmpl.content.firstElementChild.cloneNode(true); node.querySelector('.name').textContent=item.name; node.querySelector('.coords').textContent=item.coords; wrap.appendChild(node); });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <section class="welcome">
      <h1>Welcome ${sessionScope.authUser.email}!</h1>
      <div class="alert info">
        <span class="alert-icon" data-lucide="alert-triangle"></span>
        <p>Heavy Rainfall Warning in Gampaha District – Next 48 Hours</p>
      </div>
    </section>
        <section class="quick">
          <div class="quick-actions">
            <button class="action-card" data-goto="make-donation.html"><div class="action-icon"><i data-lucide="gift"></i></div><span>Make a Donation</span></button>
            <button class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/general/donation-requests/form'"><div class="action-icon"><i data-lucide="package-plus"></i></div><span>Request a Donation</span></button>
            <button class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/general/disaster-reports/form'"><div class="action-icon"><i data-lucide="alert-octagon"></i></div><span>Report a Disaster</span></button>
            <button class="action-card" data-goto="be-volunteer.html"><div class="action-icon"><i data-lucide="user-plus"></i></div><span>Be a Volunteer</span></button>
          </div>
        </section>
        <section class="safe-section" aria-labelledby="safeHeading">
          <div>
            <h2 id="safeHeading" style="margin:0 0 0.8rem;">Safe Locations</h2>
            <div class="safe-list" id="safeList"></div>
          </div>
          <div>
            <div class="map-shell">
              <div class="map-search"><i data-lucide="search" style="width:16px;height:16px;"></i><span style="font-size:0.7rem;color:#666;">Search</span></div>
              <div class="map-toolbar"><button class="btn btn-icon" aria-label="Zoom In"><i data-lucide="plus"></i></button><button class="btn btn-icon" aria-label="Zoom Out"><i data-lucide="minus"></i></button></div>
              <div class="map-iframe-holder" id="mapHolder"></div>
            </div>
          </div>
        </section>

    <template id="safe-item-tmpl">
      <div class="safe-item"><div class="name"></div><div class="coords"></div></div>
    </template>
  </jsp:body>
</layout:general-user-dashboard>

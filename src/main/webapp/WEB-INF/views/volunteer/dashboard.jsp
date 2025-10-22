<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:volunteer-dashboard pageTitle="ResQnet - Volunteer Overview" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1rem; }
      .alert.info { background:#fff5d6; border:1px solid #f0e0a8; color:#3a3320; display:flex; align-items:center; gap:0.6rem; padding:0.7rem 1rem; border-radius:12px; }
      .alert .alert-icon { width:18px; height:18px; }
      .quick-actions { display:grid; grid-template-columns:repeat(4,1fr); gap:1rem; margin:1rem 0 1.5rem; }
      .action-card { display:flex; flex-direction:column; align-items:center; justify-content:center; gap:0.6rem; padding:1.2rem; border:1px solid var(--color-border); border-radius:12px; background:#f6f6f6; cursor:pointer; }
      .action-card .action-icon i { width:24px; height:24px; }
      .section-title { margin:1.25rem 0 0.75rem; font-size:0.95rem; }
      .report-list { display:flex; flex-direction:column; gap:0.9rem; }
      .report-card { display:grid; grid-template-columns:48px 1fr auto; gap:0.9rem; border:1px solid var(--color-border); border-radius:12px; background:#f6f6f6; padding:0.9rem; align-items:center; }
      .report-icon { width:36px; height:36px; border-radius:8px; border:1px solid var(--color-border); background:#eee; display:flex; align-items:center; justify-content:center; color:#666; }
      .report-meta { display:flex; flex-direction:column; gap:0.25rem; font-size:0.7rem; }
      .report-title { font-weight:700; }
      .assist-btn { all:unset; cursor:pointer; font-size:0.6rem; font-weight:600; padding:0.5rem 1rem; border-radius:999px; background:#e9e9e9; }
      @media (max-width:720px){ .quick-actions{ grid-template-columns:repeat(2,1fr); } .report-card{ grid-template-columns:36px 1fr; } .assist-btn{ justify-self:start; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        const reports=[
          { title:'Flooding in Residential Area', desc:'Urgent need for rescue in the flooded area near Main Street.', by:'Reported by: Sarah Miller' },
          { title:'Landslide Near Community Center', desc:'Landslide blocking access to the community center. Volunteers needed for debris removal.', by:'Reported by: David Chen' },
          { title:'Landslide Near Community Center', desc:'Landslide blocking access to the community center. Volunteers needed for debris removal.', by:'Reported by: David Chen' }
        ];
        const wrap=document.getElementById('reportList'); const tmpl=document.getElementById('report-card-tmpl');
        reports.forEach(r=>{ const node=tmpl.content.firstElementChild.cloneNode(true); node.querySelector('.report-title').textContent=r.title; node.querySelector('.report-desc').textContent=r.desc; node.querySelector('.report-by').textContent=r.by; const assist=node.querySelector('.assist-btn'); assist.addEventListener('click',()=>{ assist.textContent='Assisting'; assist.style.background='#ffe28a'; console.log('Volunteer assisting:', r.title); }); wrap.appendChild(node); });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <section class="welcome">
  <h1>Welcome ${not empty displayName ? displayName : sessionScope.authUser.email}!</h1>
      <div class="alert info">
        <span class="alert-icon" data-lucide="alert-triangle"></span>
        <p>Heavy Rainfall Warning in Gampaha District – Next 48 Hours</p>
      </div>
    </section>
    <section class="quick">
      <div class="quick-actions">
        <button class="action-card" data-goto="make-donation.html"><div class="action-icon"><i data-lucide="gift"></i></div><span>Make a Donation</span></button>
        <button class="action-card" data-goto="request-donation.html"><div class="action-icon"><i data-lucide="package-plus"></i></div><span>Request a Donation</span></button>
        <button class="action-card" data-goto="report-disaster.html"><div class="action-icon"><i data-lucide="alert-octagon"></i></div><span>Report a Disaster</span></button>
        <button class="action-card" data-goto="safe-locations-gn.html"><div class="action-icon"><i data-lucide="map-pin"></i></div><span>Safe Locations</span></button>
      </div>
    </section>
    <section aria-labelledby="verifiedHeading">
      <h2 id="verifiedHeading" class="section-title">Verified Disaster Reports</h2>
      <div class="report-list" id="reportList"></div>
    </section>

    <template id="report-card-tmpl">
      <div class="report-card">
        <div class="report-icon"><i data-lucide="flag"></i></div>
        <div class="report-meta">
          <div class="report-title"></div>
          <div class="report-desc" style="color:#555"></div>
          <div class="report-by" style="color:#777"></div>
        </div>
        <button class="assist-btn">I will assist</button>
      </div>
    </template>
  </jsp:body>
</layout:volunteer-dashboard>

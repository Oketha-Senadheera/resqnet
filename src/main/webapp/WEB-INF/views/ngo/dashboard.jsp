<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet NGO Dashboard" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      .dashboard-section h2 { margin:0 0 1rem; font-size:1rem; }
      .quick-actions-ngo { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:1rem; }
      .action-card.large { min-height:100px; }
      .requests-list { display:flex; flex-direction:column; gap:0.9rem; margin:0; padding:0; list-style:none; }
      .request-card { display:grid; grid-template-columns:1fr auto; gap:1rem; background:#f7f7f7; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1rem 1.15rem; position:relative; }
      .request-card.highlight { background:#fff9e3; }
      .req-meta { display:flex; flex-direction:column; gap:0.4rem; font-size:0.65rem; }
      .req-location { font-size:0.75rem; font-weight:600; display:flex; gap:0.35rem; align-items:center; }
      .item-tags { display:flex; flex-wrap:wrap; gap:0.4rem; margin-top:0.35rem; }
      .tag { background:#eee; border:1px solid #e3e3e3; padding:2px 8px; font-size:0.55rem; border-radius:999px; font-weight:500; letter-spacing:.25px; }
      .status-btn { all:unset; background:#e4e4e4; color:#222; font-size:0.6rem; font-weight:600; padding:0.45rem 1.1rem; border-radius:999px; cursor:pointer; align-self:start; }
      .status-btn.reserved { background:var(--color-accent); }
      .collection-points { display:flex; flex-direction:column; gap:1rem; margin-top:1.25rem; }
      .point-card { background:#f7f7f7; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1rem 1.15rem; font-size:0.65rem; display:flex; flex-direction:column; gap:0.4rem; }
      .point-card h3 { margin:0; font-size:0.8rem; }
      .small-meta { display:flex; flex-direction:column; gap:0.15rem; }
      .req-section { margin-top:2.5rem; }
      .col-section { margin-top:2.5rem; }
      @media (max-width:640px){ .request-card { grid-template-columns:1fr; } .status-btn { justify-self:start; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        const requests = [
          { id:1, location:'GN Division: 123 - Central', date:'2024-01-15', items:['Rice 10kg','Canned fish 15 units','Rice 10kg'], status:'fulfilled' },
          { id:2, location:'GN Division: 123 - Central', date:'2024-01-15', items:['Rice 10kg','Canned fish 10 units','Rice 10kg'], status:'fulfilled' },
          { id:3, location:'GN Division: 123 - Central', date:'2024-01-15', items:['Rice 10kg','Canned fish 10 units','Rice 10kg'], status:'reserved' }
        ];
        const listEl = document.getElementById('requestsList');
        const tmpl = document.getElementById('request-card-template');
        requests.forEach(r => {
          const node = tmpl.content.firstElementChild.cloneNode(true);
          node.querySelector('.loc-text').textContent = r.location;
            node.querySelector('.date-text').textContent = 'Requested on: '+r.date;
          const tagsWrap = node.querySelector('.item-tags');
          r.items.slice(0,3).forEach(item => {
            const span = document.createElement('span');
            span.className='tag';
            span.textContent=item;
            tagsWrap.appendChild(span);
          });
          const statusBtn = node.querySelector('.status-btn');
          if (r.status==='reserved'){ statusBtn.textContent='Reserved'; statusBtn.classList.add('reserved'); node.classList.add('highlight'); }
          listEl.appendChild(node);
        });

        const points = [
          { name:'Colombo Central Hub', city:'Colombo', address:'123 Main Street, Colombo 01' },
          { name:'Colombo Central Hub', city:'Colombo', address:'123 Main Street, Colombo 01' },
          { name:'Colombo Central Hub', city:'Colombo', address:'123 Main Street, Colombo 01' }
        ];
        const cpWrap = document.getElementById('collectionPoints');
        const cpTmpl = document.getElementById('collection-point-template');
        points.forEach(p => {
          const card = cpTmpl.content.firstElementChild.cloneNode(true);
          card.querySelector('.point-name').textContent = p.name;
          card.querySelector('.city').textContent = p.city;
          card.querySelector('.address').textContent = p.address;
          cpWrap.appendChild(card);
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <section class="welcome">
      <h1>Welcome ${sessionScope.authUser.email}!</h1>
      <div class="alert info" style="background:#fff9e6;border-color:#f5e3a3;">
        <span class="alert-icon" data-lucide="alert-triangle"></span>
        <p>Heavy Rainfall Warning in Gampaha District – Next 48 Hours</p>
      </div>
    </section>

        <section aria-label="Primary Actions">
          <div class="quick-actions-ngo">
            <button class="action-card large" data-section="donation-requests">
              <div class="action-icon"><i data-lucide="gift"></i></div>
              <span>Donation Requests</span>
            </button>
            <button class="action-card large" data-section="manage-inventory">
              <div class="action-icon"><i data-lucide="boxes"></i></div>
              <span>Manage Inventory</span>
            </button>
            <button class="action-card large" data-section="manage-collection">
              <div class="action-icon"><i data-lucide="map"></i></div>
              <span>Collection Points</span>
            </button>
            <button class="action-card large" data-section="safe-locations">
              <div class="action-icon"><i data-lucide="map-pin"></i></div>
              <span>Safe Locations</span>
            </button>
          </div>
        </section>

        <section class="req-section" aria-labelledby="donationRequestsHeading">
          <h2 id="donationRequestsHeading">Donation Requests</h2>
          <ul class="requests-list" id="requestsList"></ul>
        </section>

        <section class="col-section" aria-labelledby="collectionPointsHeading">
          <h2 id="collectionPointsHeading">Collection Points</h2>
          <div class="collection-points" id="collectionPoints"></div>
        </section>

    <template id="request-card-template">
      <li class="request-card">
        <div class="req-meta">
          <div class="req-location"><i data-lucide="map-pin" style="width:14px;height:14px;"></i><span class="loc-text"></span></div>
          <div><i data-lucide="calendar" style="width:12px;height:12px;vertical-align:middle;"></i> <span class="date-text"></span></div>
          <div class="item-tags"></div>
        </div>
        <button class="status-btn">Fulfill</button>
      </li>
    </template>

    <template id="collection-point-template">
      <div class="point-card">
        <h3 class="point-name"></h3>
        <div class="small-meta">
          <div class="city"></div>
          <div><i data-lucide="map-pin" style="width:12px;height:12px;vertical-align:middle;"></i> <span class="address"></span></div>
        </div>
      </div>
    </template>
  </jsp:body>
</layout:ngo-dashboard>

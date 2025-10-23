<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet - General Public Overview" activePage="donation-requests">

<jsp:body>

<style>
      /* Page specific (kept minimal; reuses core + dashboard) */
      h1 { margin:0 0 1.75rem; }
      .tabs { display:flex; gap:3rem; border-bottom:1px solid var(--color-border); margin-bottom:1.5rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.75rem; font-weight:600; padding:0.9rem 0; color:#222; }
      .tab-btn[aria-selected='true'] { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); width:160px; transition:transform .25s ease, width .25s ease; }
      .requests-list { display:flex; flex-direction:column; gap:1.1rem; list-style:none; margin:0; padding:0; }
      .request-card { display:grid; grid-template-columns:1fr auto; gap:1rem; background:#f4f4f4; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.15rem 1.3rem; }
      .request-card.approved { background:#fffdf6; border-color:var(--color-accent); }
      .req-meta { display:flex; flex-direction:column; gap:0.55rem; }
      .req-location { font-size:0.8rem; font-weight:600; display:flex; gap:0.4rem; align-items:center; }
      .req-date { font-size:0.65rem; }
      .item-tags { display:flex; flex-wrap:wrap; gap:0.4rem; }
      .tag { background:#eee; border:1px solid #e2e2e2; padding:2px 8px; font-size:0.55rem; border-radius:999px; font-weight:500; letter-spacing:.25px; }
      .request-card.approved .tag { background:#fff9e3; border-color:#ffe2a4; }
      .status-btn { all:unset; padding:0.55rem 1.25rem; font-size:0.6rem; font-weight:600; border-radius:999px; cursor:pointer; align-self:start; background:#ddd; }
      .request-card.approved .status-btn { background:var(--color-accent); color:#000; }
      .hidden { display:none !important; }
      @media (max-width:640px){ .request-card { grid-template-columns:1fr; } .status-btn { justify-self:start; } }
    </style>


<main class="content" id="mainContent" tabindex="-1">
        <h1>Donation Requests</h1>
        <div class="tabs" role="tablist">
          <button class="tab-btn" id="tab-approved" role="tab" aria-selected="true" aria-controls="panel-approved">Approved Donation Requests</button>
          <button class="tab-btn" id="tab-pending" role="tab" aria-selected="false" aria-controls="panel-pending" style="margin-left:1rem;">Pending Donation Requests</button>
          <span class="tab-indicator" aria-hidden="true"></span>
        </div>
        <section id="panel-approved" role="tabpanel" aria-labelledby="tab-approved">
          <ul class="requests-list" id="approvedList"></ul>
        </section>
        <section id="panel-pending" role="tabpanel" aria-labelledby="tab-pending" class="hidden">
          <ul class="requests-list" id="pendingList"></ul>
        </section>
      </main>

<script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        const indicator = document.querySelector('.tab-indicator');
        const tabs = Array.from(document.querySelectorAll('.tab-btn'));
        function positionIndicator(idx){
          const btn = tabs[idx];
          indicator.style.width = btn.offsetWidth+'px';
          indicator.style.transform = `translateX(${btn.offsetLeft}px)`;
        }
        positionIndicator(0);
        window.addEventListener('resize', () => {
          const activeIdx = tabs.findIndex(t => t.getAttribute('aria-selected')==='true');
          positionIndicator(activeIdx);
        });
        tabs.forEach((btn, idx) => btn.addEventListener('click', () => {
          if (btn.getAttribute('aria-selected')==='true') return;
          tabs.forEach(t => t.setAttribute('aria-selected','false'));
          btn.setAttribute('aria-selected','true');
          document.querySelectorAll('[role=tabpanel]').forEach(p => p.classList.add('hidden'));
          document.getElementById(btn.getAttribute('aria-controls')).classList.remove('hidden');
          positionIndicator(idx);
        }));
        // Data (sample)
        const approvedData = [1,2,3,4].map(i => ({ id:i, status:'approved', location:'GN Division: 123 - Central', date:'2024-01-15', items:['Rice: 50kg','Canned Food: 110 units','Rice: 50kg'] }));
        const pendingData = [5,6,7,8].map(i => ({ id:i, status:'pending', location:'GN Division: 123 - Central', date:'2024-01-15', items:['Rice: 50kg','Canned Food: 110 units','Rice: 50kg'] }));
        const tmpl = document.getElementById('request-template');
        function render(list, data){
          data.forEach(r => {
            const node = tmpl.content.firstElementChild.cloneNode(true);
            if(r.status==='approved') node.classList.add('approved');
            node.querySelector('.loc-text').textContent = r.location;
            node.querySelector('.date-text').textContent = 'Requested on: '+r.date;
            const tagsWrap = node.querySelector('.item-tags');
            r.items.forEach(item => { const span=document.createElement('span'); span.className='tag'; span.textContent=item; tagsWrap.appendChild(span); });
            const btn = node.querySelector('.status-btn');
            btn.textContent = r.status==='approved' ? 'Reserved' : 'Fulfill';
            list.appendChild(node);
          });
        }
        render(document.getElementById('approvedList'), approvedData);
        render(document.getElementById('pendingList'), pendingData);
      });
    </script>

</jsp:body>

</layout:ngo-dashboard>




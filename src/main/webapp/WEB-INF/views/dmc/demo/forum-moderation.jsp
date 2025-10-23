<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - General Public Overview" activePage="forum">

<jsp:body>

       <style>
      h1 { margin:0 0 1.5rem; }
      .tabs { display:flex; gap:2.75rem; border-bottom:1px solid var(--color-border); margin-bottom:1rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.9rem 0; color:#222; }
      .tab-btn[aria-selected='true'] { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); width:160px; transition:transform .25s ease, width .25s ease; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.mod-table { width:100%; border-collapse:collapse; font-size:0.65rem; }
      table.mod-table thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.mod-table tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table.mod-table tbody tr:last-child td { border-bottom:none; }
      .action-pills { display:flex; gap:0.5rem; }
      .pill { all:unset; cursor:pointer; font-size:0.55rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .pill-danger { background:#d91e18; color:#fff; }
      .hidden { display:none !important; }
      .title-multi { max-width:210px; line-height:1.3; }
      @media (max-width:820px){ .title-multi { max-width:160px; } }
      @media (max-width:640px){ table.mod-table thead { display:none; } table.mod-table tbody td { display:block; padding:0.6rem 0.85rem; } table.mod-table tbody tr { border-bottom:1px solid var(--color-border); } table.mod-table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } .action-pills { flex-wrap:wrap; } }
    </style>

          <main class="content" id="mainContent" tabindex="-1">
        <h1>Forum Moderation Panel</h1>
        <div class="tabs" role="tablist">
          <button class="tab-btn" id="tab-approved" role="tab" aria-controls="panel-approved" aria-selected="true">Approved Articles</button>
          <button class="tab-btn" id="tab-pending" role="tab" aria-controls="panel-pending" aria-selected="false">Pending Articles</button>
          <span class="tab-indicator" aria-hidden="true"></span>
        </div>
        <section id="panel-approved" role="tabpanel" aria-labelledby="tab-approved">
          <div class="table-shell"><table class="mod-table" aria-describedby="mainContent"><thead><tr><th>Title</th><th>Author</th><th>Posted Date</th><th>Actions</th></tr></thead><tbody id="approvedBody"></tbody></table></div>
        </section>
        <section id="panel-pending" role="tabpanel" aria-labelledby="tab-pending" class="hidden">
          <div class="table-shell"><table class="mod-table" aria-describedby="mainContent"><thead><tr><th>Title</th><th>Author</th><th>Posted Date</th><th>Actions</th></tr></thead><tbody id="pendingBody"></tbody></table></div>
        </section>
      </main>


          <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        const tabs=Array.from(document.querySelectorAll('.tab-btn')); const indicator=document.querySelector('.tab-indicator');
        function pos(idx){ const b=tabs[idx]; indicator.style.width=b.offsetWidth+'px'; indicator.style.transform=`translateX(${b.offsetLeft}px)`; }
        pos(0); window.addEventListener('resize',()=>pos(tabs.findIndex(t=>t.getAttribute('aria-selected')==='true')));
        tabs.forEach((btn,idx)=>btn.addEventListener('click',()=>{ if(btn.getAttribute('aria-selected')==='true') return; tabs.forEach(t=>t.setAttribute('aria-selected','false')); btn.setAttribute('aria-selected','true'); document.querySelectorAll('[role=tabpanel]').forEach(p=>p.classList.add('hidden')); document.getElementById(btn.getAttribute('aria-controls')).classList.remove('hidden'); pos(idx); }));
        let approvedData = [
          { id:1,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:2,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:3,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:4,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:5,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:6,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:7,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:8,title:'Mental Health Support After Disasters', author:'Dr. Ben Carter', date:'2024-02-20' },
          { id:9,title:'Sustainable Recovery Strategies', author:'Dr. Chloe Davis', date:'2024-03-10' }
        ];
        let pendingData = [
          { id:10,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:11,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:12,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:13,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:14,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:15,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:16,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:17,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' },
          { id:18,title:'Community Resilience in Urban Areas', author:'Dr. Anya Sharma', date:'2024-01-15' }
        ];
        const tmpl=document.getElementById('rowTemplate');
        function render(bodyId,data,isPending){ const body=document.getElementById(bodyId); body.innerHTML=''; data.forEach(r=>{ const node=tmpl.content.firstElementChild.cloneNode(true); const titleCell=node.querySelector('.c-title'); titleCell.className+=' title-multi'; titleCell.textContent=r.title; node.querySelector('.c-author').textContent=r.author; node.querySelector('.c-date').textContent=r.date; const act=node.querySelector('.c-actions'); if(isPending){ const approve=document.createElement('button'); approve.className='pill'; approve.type='button'; approve.textContent='Approve'; approve.addEventListener('click',()=>approveArticle(r.id)); const reject=document.createElement('button'); reject.className='pill pill-danger'; reject.type='button'; reject.textContent='Reject'; reject.addEventListener('click',()=>rejectArticle(r.id)); act.appendChild(approve); act.appendChild(reject); } else { const view=document.createElement('button'); view.className='pill'; view.type='button'; view.textContent='View'; view.addEventListener('click',()=>{ console.log('View article', r); alert('View article: '+r.title); }); act.appendChild(view); } body.appendChild(node); }); }
        function approveArticle(id){ const idx=pendingData.findIndex(a=>a.id===id); if(idx>-1){ const [art]=pendingData.splice(idx,1); approvedData.push(art); rerender(); }}
        function rejectArticle(id){ pendingData = pendingData.filter(a=>a.id!==id); rerender(); }
        function rerender(){ render('approvedBody', approvedData,false); render('pendingBody', pendingData,true); }
        rerender();
      });
    </script>

</jsp:body>


</layout:dmc-dashboard>




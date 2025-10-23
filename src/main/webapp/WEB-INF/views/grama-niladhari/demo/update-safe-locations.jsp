<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - General Public Overview" activePage="safe-locations">

<jsp:body>

<style>
      h1 { margin:0 0 0.6rem; }
      .subtitle { color:#9a8b5a; font-size:0.75rem; margin-bottom:1.2rem; }
      .search-wrap { position:relative; max-width:680px; margin-bottom:1rem; }
      .search-wrap input { width:100%; padding:0.65rem 0.9rem 0.65rem 2.2rem; border:1px solid var(--color-border); border-radius:999px; font-size:0.75rem; background:#f6f6f6; }
      .search-wrap .icon { position:absolute; left:0.8rem; top:50%; transform:translateY(-50%); color:#777; width:18px; height:18px; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.safe-table { width:100%; border-collapse:collapse; font-size:0.65rem; }
      table.safe-table thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.safe-table tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table.safe-table tbody tr:last-child td { border-bottom:none; }
      .pill { all:unset; cursor:pointer; font-size:0.55rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .pill svg { width:14px; height:14px; }
      @media (max-width:780px){ table.safe-table thead { display:none; } table.safe-table tbody td { display:block; padding:0.6rem 0.85rem; } table.safe-table tbody tr { border-bottom:1px solid var(--color-border); } table.safe-table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } }
    </style>

    <main class="content" id="mainContent" tabindex="-1">
        <h1>Safe Locations – Green Valley Division</h1>
        <div class="search-wrap">
          <i class="icon" data-lucide="search"></i>
          <input id="search" type="search" placeholder="Search safe locations" aria-label="Search safe locations" />
        </div>
        <div class="table-shell">
          <table class="safe-table" aria-describedby="mainContent">
            <thead>
              <tr>
                <th>Safe Location Name</th>
                <th>Address/Landmark</th>
                <th>Capacity</th>
                <th>Contact Person</th>
                <th>Update</th>
              </tr>
            </thead>
            <tbody id="safeBody"></tbody>
          </table>
        </div>
      </main>

       <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        const data=[
          { name:'Community Center', address:'123 Oak Street, Near the Park', total:200, current:150, contact:'Sarah Miller' },
          { name:'School Gymnasium', address:'456 Elm Avenue, Next to the Library', total:300, current:250, contact:'David Lee' },
          { name:'Temple Hall', address:'789 Pine Road, Opposite the Post Office', total:150, current:100, contact:'Emily Chen' },
          { name:'Temple Hall', address:'789 Pine Road, Opposite the Post Office', total:150, current:100, contact:'Emily Chen' },
          { name:'Temple Hall', address:'789 Pine Road, Opposite the Post Office', total:150, current:100, contact:'Emily Chen' },
          { name:'Temple Hall', address:'789 Pine Road, Opposite the Post Office', total:150, current:100, contact:'Emily Chen' },
          { name:'Youth Center', address:'101 Maple Drive, Behind the Supermarket', total:100, current:75, contact:'Michael Brown' },
          { name:'Retirement Home', address:'222 Cedar Lane, Beside the Hospital', total:50, current:40, contact:'Jessica White' }
        ];
        const body=document.getElementById('safeBody'); const tmpl=document.getElementById('row-tmpl');
        function render(list){
          body.innerHTML='';
          list.forEach(r=>{
            const node=tmpl.content.firstElementChild.cloneNode(true);
            node.querySelector('.c-name').textContent=r.name;
            node.querySelector('.c-address').textContent=r.address;
            node.querySelector('.c-capacity').textContent=`Total: ${r.total}, Current: ${r.current}`;
            node.querySelector('.c-contact').textContent=r.contact;
            const act=node.querySelector('.c-actions'); const btn=document.createElement('button'); btn.className='pill'; btn.innerHTML='<span data-lucide="edit-2"></span><span>Edit</span>'; btn.type='button'; btn.addEventListener('click',()=>{ window.location.href='update-safe-location-gn.html'; }); act.appendChild(btn);
            // responsive labels
            node.children[0].setAttribute('data-label','Safe Location Name');
            node.children[1].setAttribute('data-label','Address/Landmark');
            node.children[2].setAttribute('data-label','Capacity');
            node.children[3].setAttribute('data-label','Contact Person');
            node.children[4].setAttribute('data-label','Update');
            body.appendChild(node);
          });
          if(window.lucide) lucide.createIcons();
        }
        render(data);
        const search=document.getElementById('search');
        search.addEventListener('input',()=>{
          const q=search.value.toLowerCase();
          const filtered=data.filter(d=>[d.name,d.address,d.contact].join(' ').toLowerCase().includes(q));
          render(filtered);
        });
      });
    </script>

</jsp:body>

</layout:grama-niladhari-dashboard>
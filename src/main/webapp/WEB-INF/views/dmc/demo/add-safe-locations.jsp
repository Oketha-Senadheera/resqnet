<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - General Public Overview" activePage="safe-locations">

<jsp:body>

<style>
      h1 { margin:0 0 2rem; }
      form#locationForm { max-width:1180px; display:flex; flex-direction:column; gap:2rem; }
      .grid-2 { display:grid; gap:1.25rem 2rem; grid-template-columns:repeat(auto-fit,minmax(320px,1fr)); }
      textarea.input { min-height:170px; resize:vertical; }
      .actions { display:flex; justify-content:space-between; align-items:center; max-width:1180px; }
      .actions-right { margin-left:auto; display:flex; gap:1rem; }
      .btn-muted { background:#efefef; border-color:#e2e2e2; }
      .btn-muted:hover { background:#e7e7e7; }
      @media (max-width:640px){ .grid-2 { grid-template-columns:1fr; } .actions { flex-wrap:wrap; gap:0.75rem; } }
    </style>

 <main class="content" id="mainContent" tabindex="-1">
        <h1>Add New Location</h1>
        <form id="locationForm" novalidate>
          <div class="grid-2">
            <div class="form-field">
              <label for="locName">Location Name</label>
              <input class="input" type="text" id="locName" name="locationName" placeholder="e.g., Central Park" required />
            </div>
            <div class="form-field">
              <label for="gnDivision">GN Divisions</label>
              <select class="input" id="gnDivision" name="gnDivision" required>
                <option value="" disabled selected>Select a GN Division</option>
              </select>
              <p class="form-help" id="gnDivisionHelp">Loading GN divisions

  <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();

        // Populate GN Division dropdown from backend
        const gnSelect = document.getElementById('gnDivision');
        const help = document.getElementById('gnDivisionHelp');

        async function loadGnDivisions() {
          // Note: update the URL below to match your backend route
          const urlCandidates = [
            '/api/gn-divisions',
            'http://localhost:3000/api/gn-divisions'
          ];

          // Fallback values (can be removed once API is wired)
          const fallback = [
            { id: 'GN-001', name: 'Colombo - Fort' },
            { id: 'GN-002', name: 'Colombo - Pettah' },
            { id: 'GN-003', name: 'Gampaha - Yakkala' },
            { id: 'GN-004', name: 'Kandy - Katugastota' }
          ];

          function fillOptions(list) {
            // Clear existing dynamic options
            [...gnSelect.options].forEach((opt, i) => { if (i !== 0) gnSelect.remove(i); });
            list.forEach(rec => {
              const opt = document.createElement('option');
              opt.value = rec.id || rec.code || rec.name;
              opt.textContent = `${rec.name || rec.title || rec.code}`;
              gnSelect.appendChild(opt);
            });
            help.textContent = `${list.length} GN divisions loaded`;
          }

          for (const url of urlCandidates) {
            try {
              const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
              if (!res.ok) throw new Error('HTTP ' + res.status);
              const data = await res.json();
              // Accept arrays like [{id,name}] or {items:[...]} or {data:[...]}
              const rows = Array.isArray(data) ? data : (data.items || data.data || []);
              if (rows.length) { fillOptions(rows); return; }
            } catch (err) {
              // Try next candidate; if all fail, show fallback
            }
          }
          fillOptions(fallback);
          help.textContent = 'Using fallback GN divisions (connect backend to replace)';
        }

        loadGnDivisions();

        // Form handling
        const form = document.getElementById('locationForm');
        form.addEventListener('submit', e => {
          e.preventDefault();
          if(!form.reportValidity()) return;
          const fd = new FormData(form);
          const payload = Object.fromEntries(fd.entries());
          console.log('New safe location', payload);
          alert('Location added! (Check console)');
          form.reset();
        });
      });
    </script>

</jsp:body>

</layout:dmc-dashboard>




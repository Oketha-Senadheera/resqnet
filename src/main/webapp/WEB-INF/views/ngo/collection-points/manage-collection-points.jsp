<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet - Manage Collection Points" activePage="manage-collection">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 2rem; }
      .grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:1rem 1.25rem; }
      .grid span.full { grid-column:1/-1; }
      .form-actions-inline { display:flex; justify-content:space-between; align-items:center; margin-top:0.9rem; }
      .btn-reset { background:#e6e6e6; color:#111; }
      .btn-primary { background:var(--color-accent); color:#000; }
      .alert { padding:0.75rem 1rem; margin-bottom:1rem; border-radius:var(--radius-md); font-size:0.85rem; }
      .alert-success { background:#d4edda; color:#155724; border:1px solid #c3e6cb; }
      .alert-error { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb; }
      table { width:100%; border-collapse:collapse; font-size:0.7rem; }
      thead th { text-align:left; font-weight:600; padding:0.75rem 0.85rem; border-bottom:1px solid var(--color-border); background:#fafafa; }
      tbody td { padding:0.85rem; border-bottom:1px solid var(--color-border); }
      tbody tr:last-child td { border-bottom:none; }
      .table-wrap { margin-top:1.75rem; border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      .actions { display:flex; gap:0.5rem; }
      .chip { all:unset; cursor:pointer; font-size:0.55rem; font-weight:600; padding:0.45rem 0.9rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .chip-danger { background:#d91e18; color:#fff; }
      .empty-row { text-align:center; padding:2rem !important; color:#666; font-style:italic; }
      @media (max-width:720px){ .grid { grid-template-columns:1fr; } .form-actions-inline { flex-wrap:wrap; gap:0.75rem; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        
        const form = document.getElementById('cpForm');
        const body = document.getElementById('cpBody');
        let editingId = null;
        
        // Render collection points from server
        const collectionPoints = [
          <c:forEach var="cp" items="${collectionPoints}" varStatus="status">
          {
            id: ${cp.collectionPointId},
            name: '<c:out value="${cp.name}" />',
            landmark: '<c:out value="${cp.locationLandmark}" />',
            address: '<c:out value="${cp.fullAddress}" />',
            contact: '<c:out value="${cp.contactPerson}" />',
            phone: '<c:out value="${cp.contactNumber}" />'
          }<c:if test="${!status.last}">,</c:if>
          </c:forEach>
        ];
        
        function render(){
          body.innerHTML='';
          if(!collectionPoints.length){ 
            const tr=document.createElement('tr'); 
            const td=document.createElement('td'); 
            td.colSpan=4; 
            td.className='empty-row'; 
            td.textContent='No collection points added yet.'; 
            tr.appendChild(td); 
            body.appendChild(tr); 
            return; 
          }
          collectionPoints.forEach(r => {
            const tr = document.createElement('tr');
            tr.innerHTML = '<td>' + escapeHtml(r.name) + '</td>' +
                          '<td>' + escapeHtml(r.landmark || '') + '</td>' +
                          '<td>' + escapeHtml(r.address) + '</td>' +
                          '<td><div class="actions">' +
                          '<button class="chip chip-edit" type="button" data-id="' + r.id + '"><span data-lucide="edit"></span> Edit</button>' +
                          '<button class="chip chip-danger chip-del" type="button" data-id="' + r.id + '"><span data-lucide="trash-2"></span> Delete</button>' +
                          '</div></td>';
            body.appendChild(tr);
          });
          if (window.lucide) lucide.createIcons();
          
          // Attach event listeners
          document.querySelectorAll('.chip-edit').forEach(btn => {
            btn.addEventListener('click', () => startEdit(parseInt(btn.dataset.id)));
          });
          document.querySelectorAll('.chip-del').forEach(btn => {
            btn.addEventListener('click', () => del(parseInt(btn.dataset.id)));
          });
        }
        
        function escapeHtml(text) {
          const map = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' };
          return text.replace(/[&<>"']/g, m => map[m]);
        }
        
        function startEdit(id){
          const item=collectionPoints.find(x=>x.id===id); 
          if(!item) return;
          editingId=id;
          form.name.value=item.name; 
          form.landmark.value=item.landmark||''; 
          form.address.value=item.address; 
          form.contact.value=item.contact||''; 
          form.phone.value=item.phone||'';
          form.querySelector('[type=submit]').textContent='Update Collection Point';
          form.action='${pageContext.request.contextPath}/ngo/collection-points/edit';
          
          // Add hidden ID field
          let idField = form.querySelector('input[name="id"]');
          if (!idField) {
            idField = document.createElement('input');
            idField.type = 'hidden';
            idField.name = 'id';
            form.appendChild(idField);
          }
          idField.value = id;
        }
        
        function del(id){ 
          if (confirm('Are you sure you want to delete this collection point?')) {
            const delForm = document.createElement('form');
            delForm.method = 'POST';
            delForm.action = '${pageContext.request.contextPath}/ngo/collection-points/delete';
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'id';
            input.value = id;
            delForm.appendChild(input);
            document.body.appendChild(delForm);
            delForm.submit();
          }
        }
        
        form.addEventListener('reset',()=>{ 
          editingId=null; 
          form.querySelector('[type=submit]').textContent='Add Collection Point'; 
          form.action='${pageContext.request.contextPath}/ngo/collection-points/add';
          const idField = form.querySelector('input[name="id"]');
          if (idField) idField.remove();
        });
        
        render();
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Manage Collection Points</h1>
    
    <c:if test="${param.success == 'added'}">
      <div class="alert alert-success">Collection point successfully added!</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="alert alert-success">Collection point successfully updated!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
      <div class="alert alert-success">Collection point successfully deleted!</div>
    </c:if>
    <c:if test="${param.error == 'required'}">
      <div class="alert alert-error">Required fields are missing!</div>
    </c:if>
    <c:if test="${param.error == 'notfound'}">
      <div class="alert alert-error">Collection point not found!</div>
    </c:if>
    <c:if test="${param.error == 'add'}">
      <div class="alert alert-error">Error adding collection point!</div>
    </c:if>
    <c:if test="${param.error == 'update'}">
      <div class="alert alert-error">Error updating collection point!</div>
    </c:if>
    <c:if test="${param.error == 'delete'}">
      <div class="alert alert-error">Error deleting collection point!</div>
    </c:if>
    
    <section aria-labelledby="add-heading">
      <h2 id="add-heading" style="font-size:0.85rem; margin:0 0 0.9rem;">Add New Collection Point</h2>
      <form id="cpForm" method="POST" action="${pageContext.request.contextPath}/ngo/collection-points/add" novalidate>
        <div class="grid">
          <div class="form-group">
            <label for="cpName">Collection Point Name</label>
            <input id="cpName" name="name" type="text" placeholder="e.g., Community Center" required />
          </div>
          <div class="form-group">
            <label for="cpLandmark">Location Name/Landmark</label>
            <input id="cpLandmark" name="landmark" type="text" placeholder="e.g., Near the old library" />
          </div>
          <span class="full form-group">
            <label for="cpAddress">Full Address</label>
            <input id="cpAddress" name="address" type="text" placeholder="e.g., 123 Main Street, Anytown" required />
          </span>
          <div class="form-group">
            <label for="cpContact">Contact Person (Optional)</label>
            <input id="cpContact" name="contact" type="text" placeholder="e.g., Sarah Johnson" />
          </div>
          <div class="form-group">
            <label for="cpPhone">Phone Number (Optional)</label>
            <input id="cpPhone" name="phone" type="tel" pattern="[0-9()+\-\s]{7,}" placeholder="e.g., (555)123-4567" />
          </div>
        </div>
        <div class="form-actions-inline">
          <button type="reset" class="btn btn-reset">Reset</button>
          <button type="submit" class="btn btn-primary">Add Collection Point</button>
        </div>
      </form>
    </section>
    <section aria-labelledby="current-heading" class="table-section">
      <h2 id="current-heading" style="font-size:0.85rem;margin:2rem 0 0.9rem;">Current Collection Points</h2>
      <div class="table-wrap">
        <table aria-describedby="current-heading">
          <thead>
            <tr>
              <th>Name</th>
              <th>Location/Landmark</th>
              <th>Full Address</th>
              <th style="width:140px;">Actions</th>
            </tr>
          </thead>
          <tbody id="cpBody"></tbody>
        </table>
      </div>
    </section>
  </jsp:body>
</layout:ngo-dashboard>

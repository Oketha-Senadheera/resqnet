<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet - Manage Collection Points" activePage="manage-collection">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .form-section { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.75rem; margin-bottom:1.5rem; }
      .form-section h2 { margin:0 0 1.25rem; font-size:1.15rem; font-weight:600; }
      .form-group { margin-bottom:1.25rem; }
      .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:0.5rem; color:#333; }
      .form-group input[type="text"],
      .form-group input[type="tel"],
      .form-group textarea,
      .form-group select { width:100%; padding:0.75rem; border:1px solid var(--color-border); border-radius:var(--radius-md); font-size:0.85rem; font-family:inherit; }
      .form-group textarea { min-height:100px; resize:vertical; }
      .form-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:1rem 1.25rem; }
      .form-grid .full { grid-column:1/-1; }
      .form-actions { display:flex; justify-content:space-between; gap:1rem; margin-top:1.5rem; flex-wrap:wrap; }
      .btn { all:unset; cursor:pointer; font-weight:600; font-size:0.9rem; padding:0.9rem 2rem; border-radius:999px; text-align:center; display:inline-block; }
      .btn-secondary { background:#e3e3e3; color:#333; }
      .btn-secondary:hover { background:#d3d3d3; }
      .btn-primary { background:var(--color-accent); color:#000; }
      .btn-primary:hover { background:var(--color-accent-hover); }
      .alert { padding:0.75rem 1rem; border-radius:var(--radius-md); margin-bottom:1rem; font-size:0.85rem; }
      .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
      .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
      .table-section { margin-top:2rem; }
      table { width:100%; border-collapse:collapse; font-size:0.75rem; }
      thead th { text-align:left; font-weight:600; padding:0.85rem 1rem; border-bottom:1px solid var(--color-border); background:#fafafa; }
      tbody td { padding:1rem; border-bottom:1px solid var(--color-border); }
      tbody tr:last-child td { border-bottom:none; }
      .table-wrap { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      .actions { display:flex; gap:0.5rem; }
      .chip { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.5rem 1rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .chip:hover { background:#d3d3d3; }
      .chip-danger { background:#d91e18; color:#fff; }
      .chip-danger:hover { background:#b91814; }
      .empty-row { text-align:center; padding:2rem !important; color:#666; font-style:italic; }
      @media (max-width:720px){ .form-grid { grid-template-columns:1fr; } .form-actions { flex-direction:column; } }
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
      <div class="alert success">Collection point successfully added!</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="alert success">Collection point successfully updated!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
      <div class="alert success">Collection point successfully deleted!</div>
    </c:if>
    <c:if test="${param.error == 'required'}">
      <div class="alert error">Required fields are missing!</div>
    </c:if>
    <c:if test="${param.error == 'notfound'}">
      <div class="alert error">Collection point not found!</div>
    </c:if>
    <c:if test="${param.error == 'add'}">
      <div class="alert error">Error adding collection point!</div>
    </c:if>
    <c:if test="${param.error == 'update'}">
      <div class="alert error">Error updating collection point!</div>
    </c:if>
    <c:if test="${param.error == 'delete'}">
      <div class="alert error">Error deleting collection point!</div>
    </c:if>
    
    <div class="form-section">
      <h2>Add New Collection Point</h2>
      <form id="cpForm" method="POST" action="${pageContext.request.contextPath}/ngo/collection-points/add" novalidate>
        <div class="form-grid">
          <div class="form-group">
            <label for="cpName">Collection Point Name *</label>
            <input id="cpName" name="name" type="text" placeholder="e.g., Community Center" required />
          </div>
          <div class="form-group">
            <label for="cpLandmark">Location Name/Landmark</label>
            <input id="cpLandmark" name="landmark" type="text" placeholder="e.g., Near the old library" />
          </div>
          <div class="form-group full">
            <label for="cpAddress">Full Address *</label>
            <input id="cpAddress" name="address" type="text" placeholder="e.g., 123 Main Street, Anytown" required />
          </div>
          <div class="form-group">
            <label for="cpContact">Contact Person (Optional)</label>
            <input id="cpContact" name="contact" type="text" placeholder="e.g., Sarah Johnson" />
          </div>
          <div class="form-group">
            <label for="cpPhone">Phone Number (Optional)</label>
            <input id="cpPhone" name="phone" type="tel" pattern="[0-9()+\-\s]{7,}" placeholder="e.g., (555)123-4567" />
          </div>
        </div>
        <div class="form-actions">
          <button type="reset" class="btn btn-secondary">Reset</button>
          <button type="submit" class="btn btn-primary">Add Collection Point</button>
        </div>
      </form>
    </div>
    <div class="table-section">
      <h2 style="font-size:1.15rem;margin:0 0 1rem;font-weight:600;">Current Collection Points</h2>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Location/Landmark</th>
              <th>Full Address</th>
              <th style="width:180px;">Actions</th>
            </tr>
          </thead>
          <tbody id="cpBody"></tbody>
        </table>
      </div>
    </div>
  </jsp:body>
</layout:ngo-dashboard>

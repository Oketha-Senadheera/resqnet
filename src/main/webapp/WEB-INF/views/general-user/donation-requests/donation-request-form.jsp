<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - Request Donation" activePage="donation-requests">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .form-container { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:2rem; max-width:800px; }
      .form-group { margin-bottom:1.5rem; }
      .form-label { display:block; font-weight:600; font-size:0.85rem; margin-bottom:0.5rem; color:#333; }
      .form-input, .form-textarea, .form-select { width:100%; padding:0.75rem; border:1px solid var(--color-border); border-radius:var(--radius-md); font-size:0.85rem; font-family:inherit; }
      .form-textarea { min-height:100px; resize:vertical; }
      .form-input:focus, .form-textarea:focus, .form-select:focus { outline:none; border-color:var(--color-accent); }
      .items-section { margin-top:2rem; }
      .items-section h3 { font-size:1rem; margin-bottom:1rem; }
      .item-row { display:grid; grid-template-columns:2fr 1fr auto; gap:1rem; margin-bottom:1rem; align-items:end; }
      .btn-add-item { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; font-size:0.75rem; padding:0.5rem 1rem; border-radius:var(--radius-md); text-align:center; }
      .btn-remove { all:unset; cursor:pointer; color:#e74c3c; font-size:0.85rem; padding:0.5rem; }
      .btn-submit { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; font-size:0.9rem; padding:0.85rem 2rem; border-radius:999px; text-align:center; margin-top:1.5rem; display:inline-block; }
      .btn-submit:hover { background:var(--color-accent-hover); }
      .alert { padding:1rem; border-radius:var(--radius-md); margin-bottom:1.5rem; }
      .alert-error { background:#fee; border:1px solid #fcc; color:#c33; }
      .alert-success { background:#efe; border:1px solid #cfc; color:#3c3; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      let itemCount = 1;
      
      function addItemRow() {
        itemCount++;
        const container = document.getElementById('itemsContainer');
        const row = document.createElement('div');
        row.className = 'item-row';
        row.id = 'item-row-' + itemCount;
        
        const catalogSelect = document.querySelector('select[name="itemName[]"]').cloneNode(true);
        catalogSelect.value = '';
        
        row.innerHTML = `
          <div class="form-group">
          </div>
          <div class="form-group">
            <input type="number" name="quantity[]" class="form-input" value="1" min="1" required>
          </div>
          <button type="button" class="btn-remove" onclick="removeItemRow(${itemCount})">Remove</button>
        `;
        
        row.querySelector('.form-group').appendChild(catalogSelect);
        container.appendChild(row);
      }
      
      function removeItemRow(id) {
        const row = document.getElementById('item-row-' + id);
        if (row) row.remove();
      }
      
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Request Donation</h1>
    
    <c:if test="${param.error == 'required'}">
      <div class="alert alert-error">Relief center name is required.</div>
    </c:if>
    <c:if test="${param.error == 'no_items'}">
      <div class="alert alert-error">Please add at least one item to your request.</div>
    </c:if>
    <c:if test="${param.error == 'submit'}">
      <div class="alert alert-error">Failed to submit donation request. Please try again.</div>
    </c:if>
    
    <div class="form-container">
      <form method="post" action="${pageContext.request.contextPath}/general/donation-requests/submit">
        <div class="form-group">
          <label class="form-label" for="reliefCenterName">Relief Center Name *</label>
          <input type="text" id="reliefCenterName" name="reliefCenterName" class="form-input" 
                 placeholder="Enter the name of the relief center" required>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="specialNotes">Special Notes</label>
          <textarea id="specialNotes" name="specialNotes" class="form-textarea" 
                    placeholder="Any additional information or special requirements"></textarea>
        </div>
        
        <div class="items-section">
          <h3>Requested Items</h3>
          <div id="itemsContainer">
            <div class="item-row" id="item-row-1">
              <div class="form-group">
                <label class="form-label">Item Name *</label>
                <select name="itemName[]" class="form-select" required>
                  <option value="">-- Select an item --</option>
                  <c:forEach var="item" items="${catalogItems}">
                    <option value="${item.itemName}">${item.itemName} (${item.category})</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">Quantity *</label>
                <input type="number" name="quantity[]" class="form-input" value="1" min="1" required>
              </div>
              <div></div>
            </div>
          </div>
          <button type="button" class="btn-add-item" onclick="addItemRow()">+ Add Another Item</button>
        </div>
        
        <button type="submit" class="btn-submit">Submit Request</button>
      </form>
    </div>
  </jsp:body>
</layout:general-user-dashboard>

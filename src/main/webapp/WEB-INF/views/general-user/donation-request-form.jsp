<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - Request Donation" activePage="request-donation">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .form-card { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:2rem; max-width:800px; }
      .form-group { margin-bottom:1.5rem; }
      .form-label { display:block; font-size:0.875rem; font-weight:600; margin-bottom:0.5rem; color:#333; }
      .form-input, .form-textarea, .form-select { width:100%; padding:0.75rem; border:1px solid var(--color-border); border-radius:var(--radius-md); font-size:0.875rem; font-family:inherit; }
      .form-textarea { min-height:100px; resize:vertical; }
      .form-input:focus, .form-textarea:focus, .form-select:focus { outline:none; border-color:var(--color-accent); }
      .items-section { margin-bottom:1.5rem; }
      .items-section h3 { font-size:1rem; margin-bottom:1rem; }
      .item-row { display:grid; grid-template-columns:2fr 1fr auto; gap:1rem; margin-bottom:0.75rem; align-items:end; }
      .btn-add-item { all:unset; cursor:pointer; background:#e3e3e3; padding:0.5rem 1rem; border-radius:var(--radius-md); font-size:0.75rem; font-weight:600; transition:background .2s; }
      .btn-add-item:hover { background:#d4d4d4; }
      .btn-remove { all:unset; cursor:pointer; color:#dc2626; font-size:0.75rem; padding:0.5rem; }
      .btn-primary { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; padding:0.875rem 2rem; border-radius:999px; text-align:center; transition:background .2s; }
      .btn-primary:hover { background:var(--color-accent-hover); }
      .btn-secondary { all:unset; cursor:pointer; background:#e3e3e3; color:#333; font-weight:600; padding:0.875rem 2rem; border-radius:999px; text-align:center; margin-left:1rem; transition:background .2s; }
      .btn-secondary:hover { background:#d4d4d4; }
      .alert { padding:1rem; border-radius:var(--radius-md); margin-bottom:1.5rem; }
      .alert.error { background:#fee; border:1px solid #fcc; color:#c33; }
      .alert.success { background:#efe; border:1px solid #cfc; color:#3a3; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        const itemsContainer = document.getElementById('itemsContainer');
        const addItemBtn = document.getElementById('addItemBtn');
        
        addItemBtn.addEventListener('click', () => {
          const itemRow = document.createElement('div');
          itemRow.className = 'item-row';
          itemRow.innerHTML = `
            <div class="form-group">
              <select name="itemId" class="form-select" required>
                <option value="">Select Item</option>
                <c:forEach var="item" items="${catalogItems}">
                  <option value="${item.itemId}">${item.itemName} (${item.category})</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <input type="number" name="quantity" class="form-input" placeholder="Quantity" min="1" value="1" required />
            </div>
            <button type="button" class="btn-remove" onclick="this.parentElement.remove()">Remove</button>
          `;
          itemsContainer.appendChild(itemRow);
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Request Donation</h1>
    
    <c:if test="${param.error == 'required'}">
      <div class="alert error">Please fill in all required fields.</div>
    </c:if>
    <c:if test="${param.error == 'no-items'}">
      <div class="alert error">Please add at least one item to your request.</div>
    </c:if>
    <c:if test="${param.error == 'submit'}">
      <div class="alert error">An error occurred while submitting your request. Please try again.</div>
    </c:if>
    
    <div class="form-card">
      <form action="${pageContext.request.contextPath}/general/donation-requests/submit" method="post">
        <div class="form-group">
          <label class="form-label" for="reliefCenterName">Relief Center Name *</label>
          <input type="text" id="reliefCenterName" name="reliefCenterName" class="form-input" required />
        </div>
        
        <div class="items-section">
          <h3>Requested Items *</h3>
          <div id="itemsContainer">
            <div class="item-row">
              <div class="form-group">
                <select name="itemId" class="form-select" required>
                  <option value="">Select Item</option>
                  <c:forEach var="item" items="${catalogItems}">
                    <option value="${item.itemId}">${item.itemName} (${item.category})</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <input type="number" name="quantity" class="form-input" placeholder="Quantity" min="1" value="1" required />
              </div>
              <div></div>
            </div>
          </div>
          <button type="button" id="addItemBtn" class="btn-add-item">+ Add Another Item</button>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="specialNotes">Special Notes</label>
          <textarea id="specialNotes" name="specialNotes" class="form-textarea" placeholder="Any additional information or special requirements..."></textarea>
        </div>
        
        <div style="margin-top:2rem;">
          <button type="submit" class="btn-primary">Submit Request</button>
          <a href="${pageContext.request.contextPath}/general/donation-requests" class="btn-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </jsp:body>
</layout:general-user-dashboard>

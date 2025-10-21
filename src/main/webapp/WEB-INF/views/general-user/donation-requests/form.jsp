<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - Request Donation" activePage="request-donation">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1rem; }
      .form-section { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.75rem; margin-bottom:1.5rem; }
      .form-section h2 { margin:0 0 1.25rem; font-size:1.15rem; font-weight:600; }
      .form-group { margin-bottom:1.25rem; }
      .form-group label { display:block; font-size:0.85rem; font-weight:600; margin-bottom:0.5rem; color:#333; }
      .form-group input[type="text"],
      .form-group textarea,
      .form-group select { width:100%; padding:0.75rem; border:1px solid var(--color-border); border-radius:var(--radius-md); font-size:0.85rem; font-family:inherit; }
      .form-group textarea { min-height:100px; resize:vertical; }
      .items-section { background:#f9f9f9; padding:1rem; border-radius:var(--radius-md); margin-bottom:1rem; }
      .item-row { display:grid; grid-template-columns:2fr 1fr auto; gap:0.75rem; margin-bottom:0.75rem; align-items:end; }
      .btn-add-item { all:unset; cursor:pointer; background:#e3e3e3; padding:0.75rem 1.25rem; border-radius:var(--radius-md); font-size:0.85rem; font-weight:600; display:inline-flex; align-items:center; gap:0.5rem; margin-bottom:1rem; }
      .btn-add-item:hover { background:#d3d3d3; }
      .btn-remove { all:unset; cursor:pointer; color:#dc2626; font-size:0.85rem; font-weight:600; padding:0.75rem; }
      .btn-submit { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; font-size:0.9rem; padding:0.9rem 2rem; border-radius:999px; text-align:center; display:inline-block; }
      .btn-submit:hover { background:var(--color-accent-hover); }
      .alert { padding:0.75rem 1rem; border-radius:var(--radius-md); margin-bottom:1rem; font-size:0.85rem; }
      .alert.error { background:#fef2f2; border:1px solid #fecaca; color:#991b1b; }
      .alert.success { background:#f0fdf4; border:1px solid #bbf7d0; color:#166534; }
      @media (max-width:768px){ .item-row { grid-template-columns:1fr; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const itemsContainer = document.getElementById('itemsContainer');
        const addItemBtn = document.getElementById('addItemBtn');
        let itemCount = 1;
        
        addItemBtn.addEventListener('click', () => {
          const newRow = document.createElement('div');
          newRow.className = 'item-row';
          newRow.innerHTML = `
            <div class="form-group" style="margin-bottom:0;">
              <select name="itemId" required>
                <option value="">Select an item</option>
                <c:forEach var="item" items="${donationItems}">
                  <option value="${item.itemId}">${item.itemName} (${item.category})</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group" style="margin-bottom:0;">
              <input type="number" name="quantity" placeholder="Quantity" min="1" value="1" required />
            </div>
            <button type="button" class="btn-remove" onclick="this.parentElement.remove()">Remove</button>
          `;
          itemsContainer.appendChild(newRow);
          itemCount++;
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Request Donation</h1>
    
    <c:if test="${param.error == 'required'}">
      <div class="alert error">Please fill in all required fields.</div>
    </c:if>
    <c:if test="${param.error == 'items'}">
      <div class="alert error">Please add at least one item to your request.</div>
    </c:if>
    <c:if test="${param.error == 'submit'}">
      <div class="alert error">Failed to submit donation request. Please try again.</div>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/general/donation-requests/submit" method="post">
      <div class="form-section">
        <h2>Request Details</h2>
        
        <div class="form-group">
          <label for="reliefCenterName">Relief Center Name *</label>
          <input type="text" id="reliefCenterName" name="reliefCenterName" required />
        </div>
        
        <div class="form-group">
          <label for="specialNotes">Special Notes</label>
          <textarea id="specialNotes" name="specialNotes" placeholder="Any additional information..."></textarea>
        </div>
      </div>
      
      <div class="form-section">
        <h2>Requested Items</h2>
        
        <button type="button" id="addItemBtn" class="btn-add-item">
          <i data-lucide="plus" style="width:16px;height:16px;"></i>
          Add Item
        </button>
        
        <div class="items-section" id="itemsContainer">
          <div class="item-row">
            <div class="form-group" style="margin-bottom:0;">
              <label>Item</label>
              <select name="itemId" required>
                <option value="">Select an item</option>
                <c:forEach var="item" items="${donationItems}">
                  <option value="${item.itemId}">${item.itemName} (${item.category})</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group" style="margin-bottom:0;">
              <label>Quantity</label>
              <input type="number" name="quantity" placeholder="Quantity" min="1" value="1" required />
            </div>
            <div></div>
          </div>
        </div>
      </div>
      
      <button type="submit" class="btn-submit">Submit Request</button>
    </form>
  </jsp:body>
</layout:general-user-dashboard>

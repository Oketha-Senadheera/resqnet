<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - Request Donation" activePage="request-donation">
  <jsp:attribute name="styles">
    <style>
      h1 { margin: 0 0 1.5rem; }
      .form-container { max-width: 800px; }
      .form-group { margin-bottom: 1.5rem; }
      .form-label { display: block; font-weight: 600; margin-bottom: 0.5rem; font-size: 0.9rem; }
      .form-input, .form-textarea, .form-select {
        width: 100%; padding: 0.75rem; border: 1px solid var(--color-border);
        border-radius: 8px; font-size: 0.9rem; font-family: inherit;
      }
      .form-textarea { min-height: 100px; resize: vertical; }
      .items-section { background: #f9f9f9; padding: 1.5rem; border-radius: 12px; margin-bottom: 1.5rem; }
      .items-section h3 { margin: 0 0 1rem; font-size: 1rem; }
      .item-row { display: grid; grid-template-columns: 2fr 1fr auto; gap: 1rem; margin-bottom: 1rem; align-items: end; }
      .btn-add-item { all: unset; cursor: pointer; background: #e0e0e0; padding: 0.5rem 1rem;
        border-radius: 8px; font-size: 0.85rem; font-weight: 600; }
      .btn-remove-item { all: unset; cursor: pointer; padding: 0.75rem 1rem; background: #ff5252;
        color: white; border-radius: 8px; font-size: 0.85rem; font-weight: 600; }
      .form-actions { display: flex; gap: 1rem; margin-top: 2rem; }
      .btn-primary { all: unset; cursor: pointer; background: var(--color-accent); color: #000;
        font-weight: 600; padding: 0.9rem 2rem; border-radius: 999px; font-size: 0.9rem; }
      .btn-secondary { all: unset; cursor: pointer; background: #e0e0e0; color: #000;
        font-weight: 600; padding: 0.9rem 2rem; border-radius: 999px; font-size: 0.9rem; }
      .alert { padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; }
      .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
      .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      let itemCount = 1;
      
      function addItem() {
        itemCount++;
        const itemsContainer = document.getElementById('itemsContainer');
        const itemRow = document.createElement('div');
        itemRow.className = 'item-row';
        itemRow.id = 'item-row-' + itemCount;
        itemRow.innerHTML = `
          <div class="form-group" style="margin-bottom: 0;">
            <select class="form-select" name="item_id" required>
              <option value="">Select Item</option>
              <c:forEach var="item" items="${donationItems}">
                <option value="${item.itemId}">${item.itemName} (${item.category})</option>
              </c:forEach>
            </select>
          </div>
          <div class="form-group" style="margin-bottom: 0;">
            <input type="number" class="form-input" name="quantity" min="1" value="1" required>
          </div>
          <button type="button" class="btn-remove-item" onclick="removeItem(${itemCount})">Remove</button>
        `;
        itemsContainer.appendChild(itemRow);
      }
      
      function removeItem(id) {
        const itemRow = document.getElementById('item-row-' + id);
        if (itemRow) {
          itemRow.remove();
        }
      }
    </script>
  </jsp:attribute>
  <jsp:body>
    <div class="form-container">
      <h1>Request Donation</h1>
      
      <c:if test="${param.success == 'submitted'}">
        <div class="alert alert-success">
          Your donation request has been submitted successfully!
        </div>
      </c:if>
      
      <c:if test="${param.error == 'required'}">
        <div class="alert alert-error">
          Please fill in all required fields.
        </div>
      </c:if>
      
      <c:if test="${param.error == 'noitems'}">
        <div class="alert alert-error">
          Please add at least one item to your request.
        </div>
      </c:if>
      
      <c:if test="${param.error == 'submit'}">
        <div class="alert alert-error">
          An error occurred while submitting your request. Please try again.
        </div>
      </c:if>
      
      <form action="${pageContext.request.contextPath}/general/donation-requests/submit" method="post">
        <div class="form-group">
          <label class="form-label" for="relief_center_name">Relief Center Name *</label>
          <input type="text" id="relief_center_name" name="relief_center_name" class="form-input" required>
        </div>
        
        <div class="items-section">
          <h3>Requested Items *</h3>
          <div id="itemsContainer">
            <div class="item-row" id="item-row-1">
              <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Item</label>
                <select class="form-select" name="item_id" required>
                  <option value="">Select Item</option>
                  <c:forEach var="item" items="${donationItems}">
                    <option value="${item.itemId}">${item.itemName} (${item.category})</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group" style="margin-bottom: 0;">
                <label class="form-label">Quantity</label>
                <input type="number" class="form-input" name="quantity" min="1" value="1" required>
              </div>
              <div style="visibility: hidden;">
                <button type="button" class="btn-remove-item">Remove</button>
              </div>
            </div>
          </div>
          <button type="button" class="btn-add-item" onclick="addItem()">+ Add Another Item</button>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="special_notes">Special Notes (Optional)</label>
          <textarea id="special_notes" name="special_notes" class="form-textarea" 
                    placeholder="Any special requirements or notes..."></textarea>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="btn-primary">Submit Request</button>
          <a href="${pageContext.request.contextPath}/general/dashboard" class="btn-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </jsp:body>
</layout:general-user-dashboard>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Edit Donation Request" activePage="donation-requests">
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
      .btn-group { display:flex; gap:1rem; }
      .btn-submit { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; font-size:0.9rem; padding:0.9rem 2rem; border-radius:999px; text-align:center; display:inline-block; }
      .btn-submit:hover { background:var(--color-accent-hover); }
      .btn-cancel { all:unset; cursor:pointer; background:#e3e3e3; color:#333; font-weight:600; font-size:0.9rem; padding:0.9rem 2rem; border-radius:999px; text-align:center; display:inline-block; }
      .btn-cancel:hover { background:#d3d3d3; }
      @media (max-width:768px){ .item-row { grid-template-columns:1fr; } .btn-group { flex-direction:column; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const itemsContainer = document.getElementById('itemsContainer');
        const addItemBtn = document.getElementById('addItemBtn');
        
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
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Edit Donation Request</h1>
    
    <form action="${pageContext.request.contextPath}/gn/donation-requests/edit" method="post">
      <input type="hidden" name="requestId" value="${request.requestId}" />
      
      <div class="form-section">
        <h2>Request Details</h2>
        
        <div class="form-group">
          <label for="reliefCenterName">Relief Center Name *</label>
          <input type="text" id="reliefCenterName" name="reliefCenterName" value="${request.reliefCenterName}" required />
        </div>
        
        <div class="form-group">
          <label for="specialNotes">Special Notes</label>
          <textarea id="specialNotes" name="specialNotes" placeholder="Any additional information...">${request.specialNotes}</textarea>
        </div>
      </div>
      
      <div class="form-section">
        <h2>Requested Items</h2>
        
        <button type="button" id="addItemBtn" class="btn-add-item">
          <i data-lucide="plus" style="width:16px;height:16px;"></i>
          Add Item
        </button>
        
        <div class="items-section" id="itemsContainer">
          <c:choose>
            <c:when test="${not empty requestItems}">
              <c:forEach var="item" items="${requestItems}">
                <div class="item-row">
                  <div class="form-group" style="margin-bottom:0;">
                    <select name="itemId" required>
                      <option value="">Select an item</option>
                      <c:forEach var="catalogItem" items="${donationItems}">
                        <option value="${catalogItem.itemId}" ${catalogItem.itemId == item.itemId ? 'selected' : ''}>
                          ${catalogItem.itemName} (${catalogItem.category})
                        </option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="form-group" style="margin-bottom:0;">
                    <input type="number" name="quantity" placeholder="Quantity" min="1" value="${item.quantity}" required />
                  </div>
                  <button type="button" class="btn-remove" onclick="this.parentElement.remove()">Remove</button>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="item-row">
                <div class="form-group" style="margin-bottom:0;">
                  <select name="itemId" required>
                    <option value="">Select an item</option>
                    <c:forEach var="catalogItem" items="${donationItems}">
                      <option value="${catalogItem.itemId}">${catalogItem.itemName} (${catalogItem.category})</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="form-group" style="margin-bottom:0;">
                  <input type="number" name="quantity" placeholder="Quantity" min="1" value="1" required />
                </div>
                <div></div>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
      
      <div class="btn-group">
        <button type="submit" class="btn-submit">Update Request</button>
        <a href="${pageContext.request.contextPath}/gn/donation-requests" class="btn-cancel">Cancel</a>
      </div>
    </form>
  </jsp:body>
</layout:grama-niladhari-dashboard>

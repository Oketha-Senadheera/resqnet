<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Edit Donation Request" activePage="donation-requests">
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
      .item-row { display:grid; grid-template-columns:2fr 1fr; gap:1rem; margin-bottom:0.75rem; }
      .btn-primary { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; padding:0.875rem 2rem; border-radius:999px; text-align:center; transition:background .2s; }
      .btn-primary:hover { background:var(--color-accent-hover); }
      .btn-secondary { all:unset; cursor:pointer; background:#e3e3e3; color:#333; font-weight:600; padding:0.875rem 2rem; border-radius:999px; text-align:center; margin-left:1rem; transition:background .2s; }
      .btn-secondary:hover { background:#d4d4d4; }
      .info-section { background:#f9fafb; border:1px solid var(--color-border); border-radius:var(--radius-md); padding:1rem; margin-bottom:1.5rem; }
      .info-label { font-size:0.75rem; color:#666; margin-bottom:0.25rem; }
      .info-value { font-size:0.875rem; font-weight:600; }
    </style>
  </jsp:attribute>
  <jsp:body>
    <h1>Edit Donation Request</h1>
    
    <div class="form-card">
      <div class="info-section">
        <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:1rem;">
          <div>
            <div class="info-label">Request ID</div>
            <div class="info-value">#${donationRequest.requestId}</div>
          </div>
          <div>
            <div class="info-label">Submitted By</div>
            <div class="info-value">${donationRequest.submitterName}</div>
          </div>
          <div>
            <div class="info-label">Contact</div>
            <div class="info-value">${donationRequest.submitterContact}</div>
          </div>
          <div>
            <div class="info-label">Status</div>
            <div class="info-value">${donationRequest.status}</div>
          </div>
        </div>
      </div>
      
      <form action="${pageContext.request.contextPath}/gn/donation-requests/update" method="post">
        <input type="hidden" name="requestId" value="${donationRequest.requestId}" />
        
        <div class="form-group">
          <label class="form-label" for="reliefCenterName">Relief Center Name *</label>
          <input type="text" id="reliefCenterName" name="reliefCenterName" class="form-input" value="${donationRequest.reliefCenterName}" required />
        </div>
        
        <div class="items-section">
          <h3>Requested Items</h3>
          <c:forEach var="item" items="${donationRequest.items}">
            <div class="item-row">
              <input type="hidden" name="requestItemId" value="${item.requestItemId}" />
              <div class="form-group">
                <select name="itemId" class="form-select" required>
                  <c:forEach var="catalogItem" items="${catalogItems}">
                    <option value="${catalogItem.itemId}" ${catalogItem.itemId == item.itemId ? 'selected' : ''}>
                      ${catalogItem.itemName} (${catalogItem.category})
                    </option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group">
                <input type="number" name="quantity" class="form-input" value="${item.quantity}" min="1" required />
              </div>
            </div>
          </c:forEach>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="specialNotes">Special Notes</label>
          <textarea id="specialNotes" name="specialNotes" class="form-textarea">${donationRequest.specialNotes}</textarea>
        </div>
        
        <div style="margin-top:2rem;">
          <button type="submit" class="btn-primary">Save Changes</button>
          <a href="${pageContext.request.contextPath}/gn/donation-requests" class="btn-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </jsp:body>
</layout:grama-niladhari-dashboard>

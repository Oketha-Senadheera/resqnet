<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Edit Donation Request" activePage="donation-requests">
  <jsp:attribute name="styles">
    <style>
      h1 { margin: 0 0 1.5rem; }
      .form-container { max-width: 800px; }
      .form-group { margin-bottom: 1.5rem; }
      .form-label { display: block; font-weight: 600; margin-bottom: 0.5rem; font-size: 0.9rem; }
      .form-input, .form-textarea {
        width: 100%; padding: 0.75rem; border: 1px solid var(--color-border);
        border-radius: 8px; font-size: 0.9rem; font-family: inherit;
      }
      .form-textarea { min-height: 100px; resize: vertical; }
      .info-section { background: #f9f9f9; padding: 1.5rem; border-radius: 12px; margin-bottom: 1.5rem; }
      .info-section h3 { margin: 0 0 1rem; font-size: 1rem; }
      .item-list { margin: 0; padding: 0; list-style: none; }
      .item-list li { padding: 0.5rem 0; border-bottom: 1px solid #e0e0e0; }
      .item-list li:last-child { border-bottom: none; }
      .form-actions { display: flex; gap: 1rem; margin-top: 2rem; }
      .btn-primary { all: unset; cursor: pointer; background: var(--color-accent); color: #000;
        font-weight: 600; padding: 0.9rem 2rem; border-radius: 999px; font-size: 0.9rem; }
      .btn-secondary { all: unset; cursor: pointer; background: #e0e0e0; color: #000;
        font-weight: 600; padding: 0.9rem 2rem; border-radius: 999px; font-size: 0.9rem; }
      .alert { padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; }
      .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
  </jsp:attribute>
  <jsp:body>
    <div class="form-container">
      <h1>Edit Donation Request</h1>
      
      <c:if test="${param.error != null}">
        <div class="alert alert-error">
          An error occurred. Please try again.
        </div>
      </c:if>
      
      <form action="${pageContext.request.contextPath}/gn/donation-requests/edit" method="post">
        <input type="hidden" name="request_id" value="${donationRequest.requestId}">
        
        <div class="form-group">
          <label class="form-label" for="relief_center_name">Relief Center Name *</label>
          <input type="text" id="relief_center_name" name="relief_center_name" 
                 class="form-input" value="${donationRequest.reliefCenterName}" required>
        </div>
        
        <div class="info-section">
          <h3>Requested Items</h3>
          <ul class="item-list">
            <c:forEach var="item" items="${donationRequest.items}">
              <li>
                <strong>${item.itemName}</strong> (${item.category}) - Quantity: ${item.quantity}
              </li>
            </c:forEach>
          </ul>
          <p style="margin-top: 1rem; font-size: 0.85rem; color: #666;">
            Note: Item changes are not supported in edit mode. To change items, reject this request and ask the user to submit a new one.
          </p>
        </div>
        
        <div class="form-group">
          <label class="form-label" for="special_notes">Special Notes (Optional)</label>
          <textarea id="special_notes" name="special_notes" class="form-textarea">${donationRequest.specialNotes}</textarea>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="btn-primary">Update Request</button>
          <a href="${pageContext.request.contextPath}/gn/donation-requests" class="btn-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </jsp:body>
</layout:grama-niladhari-dashboard>

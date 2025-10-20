<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - My Donation Requests" activePage="request-donation">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1rem; }
      .header-row { display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem; }
      .btn-primary { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; padding:0.75rem 1.5rem; border-radius:999px; font-size:0.875rem; transition:background .2s; }
      .btn-primary:hover { background:var(--color-accent-hover); }
      .alert { padding:1rem; border-radius:var(--radius-md); margin-bottom:1.5rem; }
      .alert.success { background:#efe; border:1px solid #cfc; color:#3a3; }
      .requests-list { display:flex; flex-direction:column; gap:1rem; }
      .request-card { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:1.5rem; }
      .request-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:1rem; }
      .request-id { font-weight:600; font-size:0.95rem; }
      .status-badge { padding:0.375rem 0.75rem; border-radius:999px; font-size:0.75rem; font-weight:600; }
      .status-pending { background:#fef3c7; color:#92400e; }
      .status-verified { background:#dbeafe; color:#1e40af; }
      .status-approved { background:#d1fae5; color:#065f46; }
      .status-rejected { background:#fee2e2; color:#991b1b; }
      .request-details { display:grid; grid-template-columns:repeat(2, 1fr); gap:1rem; margin-bottom:1rem; }
      .detail-item { font-size:0.875rem; }
      .detail-label { color:#666; margin-bottom:0.25rem; }
      .detail-value { font-weight:600; }
      .items-list { margin-top:1rem; }
      .items-label { font-size:0.875rem; font-weight:600; margin-bottom:0.5rem; color:#666; }
      .item-tags { display:flex; flex-wrap:wrap; gap:0.5rem; }
      .item-tag { background:#f3f4f6; border:1px solid #e5e7eb; padding:0.375rem 0.75rem; border-radius:999px; font-size:0.75rem; }
      .empty-state { text-align:center; padding:3rem 1rem; color:#666; }
      .empty-icon { width:48px; height:48px; margin:0 auto 1rem; opacity:0.5; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <div class="header-row">
      <h1>My Donation Requests</h1>
      <a href="${pageContext.request.contextPath}/general/donation-requests/new" class="btn-primary">+ New Request</a>
    </div>
    
    <c:if test="${param.success == 'submitted'}">
      <div class="alert success">Your donation request has been submitted successfully!</div>
    </c:if>
    
    <c:choose>
      <c:when test="${not empty requests}">
        <div class="requests-list">
          <c:forEach var="request" items="${requests}">
            <div class="request-card">
              <div class="request-header">
                <div class="request-id">Request #${request.requestId}</div>
                <c:choose>
                  <c:when test="${request.status == 'Pending'}">
                    <span class="status-badge status-pending">Pending</span>
                  </c:when>
                  <c:when test="${request.status == 'Verified'}">
                    <span class="status-badge status-verified">Verified</span>
                  </c:when>
                  <c:when test="${request.status == 'Approved'}">
                    <span class="status-badge status-approved">Approved</span>
                  </c:when>
                  <c:when test="${request.status == 'Rejected'}">
                    <span class="status-badge status-rejected">Rejected</span>
                  </c:when>
                </c:choose>
              </div>
              
              <div class="request-details">
                <div class="detail-item">
                  <div class="detail-label">Relief Center</div>
                  <div class="detail-value">${request.reliefCenterName}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">Submitted Date</div>
                  <div class="detail-value">
                    <fmt:formatDate value="${request.submittedAt}" pattern="MMM dd, yyyy" />
                  </div>
                </div>
              </div>
              
              <c:if test="${not empty request.specialNotes}">
                <div class="detail-item" style="margin-bottom:1rem;">
                  <div class="detail-label">Special Notes</div>
                  <div style="font-size:0.875rem;">${request.specialNotes}</div>
                </div>
              </c:if>
              
              <div class="items-list">
                <div class="items-label">Requested Items</div>
                <div class="item-tags">
                  <c:forEach var="item" items="${request.items}">
                    <span class="item-tag">${item.itemName}: ${item.quantity}</span>
                  </c:forEach>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <div class="empty-icon">
            <i data-lucide="package-x" style="width:48px;height:48px;"></i>
          </div>
          <p>You haven't made any donation requests yet.</p>
          <a href="${pageContext.request.contextPath}/general/donation-requests/new" class="btn-primary" style="display:inline-block;margin-top:1rem;">Make Your First Request</a>
        </div>
      </c:otherwise>
    </c:choose>
  </jsp:body>
</layout:general-user-dashboard>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - My Donations" activePage="donations">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .header-actions { display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem; }
      .header-actions h1 { margin:0; }
      .donations-list { display:flex; flex-direction:column; gap:1rem; }
      .donation-card { background:#f9f9f9; border:1px solid var(--color-border); border-radius:12px; padding:1.25rem; }
      .donation-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:0.75rem; }
      .donation-id { font-weight:600; font-size:0.85rem; }
      .status-badge { padding:0.3rem 0.75rem; border-radius:999px; font-size:0.7rem; font-weight:600; }
      .status-badge.pending { background:#fff3cd; color:#856404; }
      .status-badge.received, .status-badge.delivered { background:#d4edda; color:#155724; }
      .status-badge.cancelled { background:#f8d7da; color:#721c24; }
      .donation-details { display:grid; gap:0.5rem; font-size:0.75rem; margin-bottom:0.75rem; }
      .detail-row { display:flex; gap:0.5rem; }
      .detail-label { font-weight:600; min-width:120px; }
      .donation-actions { display:flex; gap:0.5rem; margin-top:0.75rem; }
      .empty-state { text-align:center; padding:3rem; color:#666; }
      .alert { padding:0.75rem 1rem; border-radius:8px; margin-bottom:1rem; font-size:0.75rem; }
      .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
      .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        // Confirm cancel
        document.querySelectorAll('.cancel-donation-btn').forEach(btn => {
          btn.addEventListener('click', (e) => {
            if (!confirm('Are you sure you want to cancel this donation?')) {
              e.preventDefault();
            }
          });
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <div class="header-actions">
      <h1>My Donations</h1>
      <a href="${pageContext.request.contextPath}/general/make-donation" class="btn btn-primary">
        Make a Donation
      </a>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert success">${sessionScope.successMessage}</div>
      <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert error">${sessionScope.errorMessage}</div>
      <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <c:choose>
      <c:when test="${empty donations}">
        <div class="empty-state">
          <p>You haven't made any donations yet.</p>
          <a href="${pageContext.request.contextPath}/general/make-donation" class="btn btn-primary" style="margin-top:1rem;">Make a Donation</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="donations-list">
          <c:forEach items="${donations}" var="donation">
            <div class="donation-card">
              <div class="donation-header">
                <div class="donation-id">Donation #${donation.donationId}</div>
                <span class="status-badge ${donation.status.toLowerCase()}">
                  <c:choose>
                    <c:when test="${donation.status == 'Received'}">Delivered</c:when>
                    <c:otherwise>${donation.status}</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="donation-details">
                <div class="detail-row">
                  <span class="detail-label">Collection Date:</span>
                  <span><fmt:formatDate value="${donation.collectionDate}" pattern="yyyy-MM-dd" /></span>
                </div>
                <div class="detail-row">
                  <span class="detail-label">Time Slot:</span>
                  <span>${donation.timeSlot}</span>
                </div>
                <div class="detail-row">
                  <span class="detail-label">Submitted:</span>
                  <span><fmt:formatDate value="${donation.submittedAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                </div>
                <c:if test="${not empty donation.specialNotes}">
                  <div class="detail-row">
                    <span class="detail-label">Special Notes:</span>
                    <span>${donation.specialNotes}</span>
                  </div>
                </c:if>
              </div>
              <div class="donation-actions">
                <c:if test="${donation.status == 'Pending'}">
                  <form action="${pageContext.request.contextPath}/general/donations/cancel" method="post" style="display:inline;">
                    <input type="hidden" name="donationId" value="${donation.donationId}" />
                    <button type="submit" class="btn cancel-donation-btn">Cancel Donation</button>
                  </form>
                </c:if>
              </div>
            </div>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </jsp:body>
</layout:general-user-dashboard>

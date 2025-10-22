<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet - Donations Management" activePage="donations">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .tabs { display:flex; gap:0.5rem; margin-bottom:1.5rem; border-bottom:2px solid var(--color-border); }
      .tab { padding:0.75rem 1.25rem; border:none; background:none; cursor:pointer; font-weight:600; font-size:0.8rem; border-bottom:3px solid transparent; transition:all 0.2s; }
      .tab:hover { background:#f5f5f5; }
      .tab.active { border-bottom-color:var(--color-accent); color:var(--color-accent); }
      .donations-list { display:flex; flex-direction:column; gap:1rem; }
      .donation-card { background:#f9f9f9; border:1px solid var(--color-border); border-radius:12px; padding:1.25rem; }
      .donation-header { display:flex; justify-content:space-between; align-items:start; margin-bottom:0.75rem; }
      .donation-id { font-weight:600; font-size:0.85rem; }
      .status-badge { padding:0.3rem 0.75rem; border-radius:999px; font-size:0.7rem; font-weight:600; }
      .status-badge.pending { background:#fff3cd; color:#856404; }
      .status-badge.received { background:#d4edda; color:#155724; }
      .status-badge.cancelled { background:#f8d7da; color:#721c24; }
      .donation-details { display:grid; gap:0.5rem; font-size:0.75rem; margin-bottom:0.75rem; }
      .detail-row { display:flex; gap:0.5rem; }
      .detail-label { font-weight:600; min-width:140px; }
      .donation-items { margin-top:0.75rem; padding:0.75rem; background:#fff; border-radius:8px; }
      .donation-items h4 { margin:0 0 0.5rem; font-size:0.75rem; }
      .items-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(150px,1fr)); gap:0.5rem; font-size:0.7rem; }
      .item-tag { background:#e9ecef; padding:0.3rem 0.6rem; border-radius:999px; }
      .donation-actions { display:flex; gap:0.5rem; margin-top:0.75rem; }
      .empty-state { text-align:center; padding:3rem; color:#666; }
      .alert { padding:0.75rem 1rem; border-radius:8px; margin-bottom:1rem; font-size:0.75rem; }
      .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
      .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
      .tab-content { display:none; }
      .tab-content.active { display:block; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        // Tab switching
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        tabs.forEach(tab => {
          tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            tabContents.forEach(tc => tc.classList.remove('active'));
            tab.classList.add('active');
            document.getElementById(tab.dataset.tab).classList.add('active');
          });
        });
        
        // Confirm mark as received
        document.querySelectorAll('.mark-received-btn').forEach(btn => {
          btn.addEventListener('click', (e) => {
            if (!confirm('Are you sure you want to mark this donation as received? This will update your inventory.')) {
              e.preventDefault();
            }
          });
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Donations Management</h1>

    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert success">${sessionScope.successMessage}</div>
      <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert error">${sessionScope.errorMessage}</div>
      <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Tabs -->
    <div class="tabs">
      <button class="tab active" data-tab="pending-tab">Pending</button>
      <button class="tab" data-tab="received-tab">Received</button>
      <button class="tab" data-tab="cancelled-tab">Cancelled</button>
    </div>

    <!-- Pending Donations -->
    <div id="pending-tab" class="tab-content active">
      <c:set var="pendingDonations" value="${donations.stream().filter(d -> d.donation.status == 'Pending').toList()}" />
      <c:choose>
        <c:when test="${empty pendingDonations}">
          <div class="empty-state">No pending donations.</div>
        </c:when>
        <c:otherwise>
          <div class="donations-list">
            <c:forEach items="${donations}" var="donation">
              <c:if test="${donation.donation.status == 'Pending'}">
                <div class="donation-card">
                  <div class="donation-header">
                    <div class="donation-id">Donation #${donation.donation.donationId}</div>
                    <span class="status-badge pending">Pending</span>
                  </div>
                  <div class="donation-details">
                    <div class="detail-row">
                      <span class="detail-label">Donor:</span>
                      <span>${donation.donation.name}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Contact:</span>
                      <span>${donation.donation.contactNumber}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Collection Point:</span>
                      <span>${donation.collectionPointName}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Collection Date:</span>
                      <span><fmt:formatDate value="${donation.donation.collectionDate}" pattern="yyyy-MM-dd" /> (${donation.donation.timeSlot})</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Submitted:</span>
                      <span><fmt:formatDate value="${donation.donation.submittedAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                    </div>
                    <c:if test="${not empty donation.donation.specialNotes}">
                      <div class="detail-row">
                        <span class="detail-label">Special Notes:</span>
                        <span>${donation.donation.specialNotes}</span>
                      </div>
                    </c:if>
                  </div>
                  <div class="donation-items">
                    <h4>Items:</h4>
                    <div class="items-grid">
                      <c:forEach items="${donation.items}" var="item">
                        <span class="item-tag">${item.itemName} (${item.quantity})</span>
                      </c:forEach>
                    </div>
                  </div>
                  <div class="donation-actions">
                    <form action="${pageContext.request.contextPath}/ngo/donations/mark-received" method="post" style="display:inline;">
                      <input type="hidden" name="donationId" value="${donation.donation.donationId}" />
                      <button type="submit" class="btn btn-primary mark-received-btn">Mark as Received</button>
                    </form>
                  </div>
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Received Donations -->
    <div id="received-tab" class="tab-content">
      <c:set var="receivedDonations" value="${donations.stream().filter(d -> d.donation.status == 'Received').toList()}" />
      <c:choose>
        <c:when test="${empty receivedDonations}">
          <div class="empty-state">No received donations.</div>
        </c:when>
        <c:otherwise>
          <div class="donations-list">
            <c:forEach items="${donations}" var="donation">
              <c:if test="${donation.donation.status == 'Received'}">
                <div class="donation-card">
                  <div class="donation-header">
                    <div class="donation-id">Donation #${donation.donation.donationId}</div>
                    <span class="status-badge received">Received</span>
                  </div>
                  <div class="donation-details">
                    <div class="detail-row">
                      <span class="detail-label">Donor:</span>
                      <span>${donation.donation.name}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Collection Point:</span>
                      <span>${donation.collectionPointName}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Received At:</span>
                      <span><fmt:formatDate value="${donation.donation.receivedAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                    </div>
                  </div>
                  <div class="donation-items">
                    <h4>Items:</h4>
                    <div class="items-grid">
                      <c:forEach items="${donation.items}" var="item">
                        <span class="item-tag">${item.itemName} (${item.quantity})</span>
                      </c:forEach>
                    </div>
                  </div>
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- Cancelled Donations -->
    <div id="cancelled-tab" class="tab-content">
      <c:set var="cancelledDonations" value="${donations.stream().filter(d -> d.donation.status == 'Cancelled').toList()}" />
      <c:choose>
        <c:when test="${empty cancelledDonations}">
          <div class="empty-state">No cancelled donations.</div>
        </c:when>
        <c:otherwise>
          <div class="donations-list">
            <c:forEach items="${donations}" var="donation">
              <c:if test="${donation.donation.status == 'Cancelled'}">
                <div class="donation-card">
                  <div class="donation-header">
                    <div class="donation-id">Donation #${donation.donation.donationId}</div>
                    <span class="status-badge cancelled">Cancelled</span>
                  </div>
                  <div class="donation-details">
                    <div class="detail-row">
                      <span class="detail-label">Donor:</span>
                      <span>${donation.donation.name}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Collection Point:</span>
                      <span>${donation.collectionPointName}</span>
                    </div>
                    <div class="detail-row">
                      <span class="detail-label">Cancelled At:</span>
                      <span><fmt:formatDate value="${donation.donation.cancelledAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                    </div>
                  </div>
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </jsp:body>
</layout:ngo-dashboard>

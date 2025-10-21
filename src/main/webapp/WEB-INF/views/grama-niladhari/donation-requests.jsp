<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Donation Requests (GN)" activePage="donation-requests">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 0.5rem; }
      .subtitle { color:#9a8b5a; font-size:0.75rem; margin-bottom:1.2rem; }
      .tabs { display:flex; gap:2.75rem; border-bottom:1px solid var(--color-border); margin-bottom:1rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.85rem; font-weight:600; padding:0.9rem 0; color:#222; transition:color 0.2s; }
      .tab-btn.active { color:#000; }
      .tab-btn:hover { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); transition:transform .25s ease, width .25s ease; }
      .tab-panel { display:none; }
      .tab-panel.active { display:block; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table { width:100%; border-collapse:collapse; font-size:0.8rem; }
      table thead th { text-align:left; padding:0.85rem 1rem; background:#fafafa; font-weight:600; font-size:0.75rem; color:#555; border-bottom:1px solid var(--color-border); }
      table tbody td { padding:1rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table tbody tr:last-child td { border-bottom:none; }
      table tbody tr:hover { background:#f9f9f9; }
      .action-pills { display:flex; gap:0.55rem; align-items:center; flex-wrap:wrap; }
      .pill { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.5rem 1rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; transition:background 0.2s; }
      .pill:hover { background:#d3d3d3; }
      .pill svg { width:14px; height:14px; }
      .pill.verify { background:#d1fae5; color:#065f46; }
      .pill.verify:hover { background:#a7f3d0; }
      .status-badge { display:inline-block; padding:0.3rem 0.75rem; border-radius:999px; font-size:0.7rem; font-weight:600; }
      .status-pending { background:#fef3c7; color:#92400e; }
      .status-approved { background:#d1fae5; color:#065f46; }
      .items-list { font-size:0.75rem; line-height:1.6; }
      .alert { padding:0.75rem 1rem; border-radius:var(--radius-md); margin-bottom:1rem; font-size:0.85rem; }
      .alert.success { background:#f0fdf4; border:1px solid #bbf7d0; color:#166534; }
      .alert.error { background:#fef2f2; border:1px solid #fecaca; color:#991b1b; }
      .empty-state { text-align:center; padding:3rem 1rem; color:#666; }
      @media (max-width:780px){ table thead { display:none; } table tbody td { display:block; padding:0.6rem 1rem; } table tbody tr { border-bottom:1px solid var(--color-border); } table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const tabs = document.querySelectorAll('.tab-btn');
        const panels = document.querySelectorAll('.tab-panel');
        const indicator = document.querySelector('.tab-indicator');
        
        function positionIndicator(btn) {
          indicator.style.width = btn.offsetWidth + 'px';
          indicator.style.transform = 'translateX(' + btn.offsetLeft + 'px)';
        }
        
        tabs.forEach((tab, idx) => {
          tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            panels.forEach(p => p.classList.remove('active'));
            
            tab.classList.add('active');
            panels[idx].classList.add('active');
            positionIndicator(tab);
          });
        });
        
        // Initialize
        const activeTab = document.querySelector('.tab-btn.active');
        if (activeTab) positionIndicator(activeTab);
        
        window.addEventListener('resize', () => {
          const activeTab = document.querySelector('.tab-btn.active');
          if (activeTab) positionIndicator(activeTab);
        });
      });
      
      function verifyRequest(requestId) {
        if (confirm('Are you sure you want to verify and approve this donation request?')) {
          const form = document.createElement('form');
          form.method = 'POST';
          form.action = '${pageContext.request.contextPath}/gn/donation-requests/verify';
          
          const input = document.createElement('input');
          input.type = 'hidden';
          input.name = 'requestId';
          input.value = requestId;
          
          form.appendChild(input);
          document.body.appendChild(form);
          form.submit();
        }
      }
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Donation Requests</h1>
    <div class="subtitle">Manage donation requests in your division</div>
    
    <c:if test="${param.success == 'verified'}">
      <div class="alert success">Donation request verified and approved successfully!</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="alert success">Donation request updated successfully!</div>
    </c:if>
    <c:if test="${param.error != null}">
      <div class="alert error">An error occurred. Please try again.</div>
    </c:if>
    
    <div class="tabs" role="tablist">
      <button class="tab-btn active" role="tab">Pending Donation Requests</button>
      <button class="tab-btn" role="tab">Approved Donation Requests</button>
      <span class="tab-indicator" aria-hidden="true"></span>
    </div>
    
    <div class="tab-panel active">
      <c:choose>
        <c:when test="${not empty pendingRequests}">
          <div class="table-shell">
            <table>
              <thead>
                <tr>
                  <th>Request ID</th>
                  <th>Submitted By</th>
                  <th>Relief Center</th>
                  <th>Requested Items</th>
                  <th>Notes</th>
                  <th>Submitted Date</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="request" items="${pendingRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Submitted By">
                      ${request.userName}<br/>
                      <small>${request.userContact != null ? request.userContact : ''}</small>
                    </td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Requested Items">
                      <div class="items-list">
                        <c:forEach var="item" items="${request.items}" varStatus="status">
                          ${item.itemName} (${item.quantity})<c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Notes">${request.specialNotes != null ? request.specialNotes : '-'}</td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                    <td data-label="Actions">
                      <div class="action-pills">
                        <button class="pill verify" onclick="verifyRequest(${request.requestId})">
                          <i data-lucide="check"></i>
                          <span>Verify</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/gn/donation-requests/edit?id=${request.requestId}" class="pill">
                          <i data-lucide="edit-2"></i>
                          <span>Edit</span>
                        </a>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-state">
            <i data-lucide="inbox" style="width:48px;height:48px;margin-bottom:1rem;"></i>
            <p>No pending donation requests.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
    
    <div class="tab-panel">
      <c:choose>
        <c:when test="${not empty approvedRequests}">
          <div class="table-shell">
            <table>
              <thead>
                <tr>
                  <th>Request ID</th>
                  <th>Submitted By</th>
                  <th>Relief Center</th>
                  <th>Requested Items</th>
                  <th>Notes</th>
                  <th>Submitted Date</th>
                  <th>Approved Date</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="request" items="${approvedRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Submitted By">
                      ${request.userName}<br/>
                      <small>${request.userContact != null ? request.userContact : ''}</small>
                    </td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Requested Items">
                      <div class="items-list">
                        <c:forEach var="item" items="${request.items}" varStatus="status">
                          ${item.itemName} (${item.quantity})<c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Notes">${request.specialNotes != null ? request.specialNotes : '-'}</td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                    <td data-label="Approved Date">
                      <fmt:formatDate value="${request.approvedAt}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </c:when>
        <c:otherwise>
          <div class="empty-state">
            <i data-lucide="inbox" style="width:48px;height:48px;margin-bottom:1rem;"></i>
            <p>No approved donation requests yet.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </jsp:body>
</layout:grama-niladhari-dashboard>

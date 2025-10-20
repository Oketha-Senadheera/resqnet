<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Donation Requests (GN)" activePage="donation-requests">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 0.5rem; }
      .subtitle { color:#9a8b5a; font-size:0.75rem; margin-bottom:1.2rem; }
      .tabs { display:flex; gap:2.75rem; border-bottom:1px solid var(--color-border); margin-bottom:1rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.9rem 0; color:#222; transition:color .2s; }
      .tab-btn[aria-selected='true'] { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); width:220px; transition:transform .25s ease, width .25s ease; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.req-table { width:100%; border-collapse:collapse; font-size:0.65rem; }
      table.req-table thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.req-table tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table.req-table tbody tr:last-child td { border-bottom:none; }
      table.req-table tbody tr:hover { background:#fafafa; }
      .action-pills { display:flex; gap:0.55rem; align-items:center; flex-wrap:wrap; }
      .pill { all:unset; cursor:pointer; font-size:0.55rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; transition:background .2s; }
      .pill:hover { background:#d4d4d4; }
      .pill-verify { background:#d1fae5; color:#065f46; }
      .pill-verify:hover { background:#bbf7d0; }
      .pill svg { width:14px; height:14px; }
      .hidden { display:none !important; }
      .alert { padding:1rem; border-radius:var(--radius-md); margin-bottom:1rem; }
      .alert.success { background:#efe; border:1px solid #cfc; color:#3a3; }
      .alert.error { background:#fee; border:1px solid #fcc; color:#c33; }
      .submitter-info { line-height:1.5; }
      .item-list { line-height:1.6; }
      @media (max-width:780px){ 
        table.req-table thead { display:none; } 
        table.req-table tbody td { display:block; padding:0.6rem 0.85rem; } 
        table.req-table tbody tr { border-bottom:1px solid var(--color-border); } 
        table.req-table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } 
        .action-pills{ flex-wrap:wrap; } 
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const tabs = Array.from(document.querySelectorAll('.tab-btn'));
        const indicator = document.querySelector('.tab-indicator');
        
        function positionIndicator(idx) {
          const btn = tabs[idx];
          indicator.style.width = btn.offsetWidth + 'px';
          indicator.style.transform = 'translateX(' + btn.offsetLeft + 'px)';
        }
        
        positionIndicator(0);
        
        window.addEventListener('resize', () => {
          const activeIdx = tabs.findIndex(t => t.getAttribute('aria-selected') === 'true');
          positionIndicator(activeIdx);
        });
        
        tabs.forEach((btn, idx) => btn.addEventListener('click', () => {
          if (btn.getAttribute('aria-selected') === 'true') return;
          tabs.forEach(t => t.setAttribute('aria-selected', 'false'));
          btn.setAttribute('aria-selected', 'true');
          document.querySelectorAll('[role=tabpanel]').forEach(p => p.classList.add('hidden'));
          document.getElementById(btn.getAttribute('aria-controls')).classList.remove('hidden');
          positionIndicator(idx);
        }));
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
    <div class="subtitle">GN Division Management</div>
    
    <c:if test="${param.success == 'verified'}">
      <div class="alert success">Donation request has been successfully verified and approved!</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="alert success">Donation request has been successfully updated!</div>
    </c:if>
    <c:if test="${param.error == 'not-found'}">
      <div class="alert error">Donation request not found.</div>
    </c:if>
    <c:if test="${param.error == 'verify' || param.error == 'update'}">
      <div class="alert error">An error occurred. Please try again.</div>
    </c:if>
    
    <div class="tabs" role="tablist">
      <button class="tab-btn" id="tab-pending" role="tab" aria-controls="panel-pending" aria-selected="true">Pending Donation Requests</button>
      <button class="tab-btn" id="tab-approved" role="tab" aria-controls="panel-approved" aria-selected="false">Approved Donation Requests</button>
      <span class="tab-indicator" aria-hidden="true"></span>
    </div>
    
    <section id="panel-pending" role="tabpanel" aria-labelledby="tab-pending">
      <div class="table-shell">
        <table class="req-table" aria-describedby="mainContent">
          <thead>
            <tr>
              <th>Request ID</th>
              <th>Submitted By</th>
              <th>Relief Center</th>
              <th>Item List</th>
              <th>Notes</th>
              <th>Submitted Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty pendingRequests}">
                <c:forEach var="request" items="${pendingRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Submitted By">
                      <div class="submitter-info">
                        ${request.submitterName}<br/>
                        <c:if test="${not empty request.submitterContact}">
                          (${request.submitterContact})
                        </c:if>
                      </div>
                    </td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Item List">
                      <div class="item-list">
                        <c:forEach var="item" items="${request.items}">
                          ${item.itemName}: ${item.quantity}<br/>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Notes">${request.specialNotes}</td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="MMM dd, yyyy" />
                    </td>
                    <td data-label="Actions">
                      <div class="action-pills">
                        <button class="pill pill-verify" type="button" onclick="verifyRequest(${request.requestId})">
                          <span data-lucide="check"></span><span>Verify</span>
                        </button>
                        <a href="${pageContext.request.contextPath}/gn/donation-requests/edit?id=${request.requestId}" class="pill">
                          <span data-lucide="edit-2"></span><span>Edit</span>
                        </a>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="7" style="text-align:center;padding:2rem;color:#666;">No pending donation requests</td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
    
    <section id="panel-approved" role="tabpanel" aria-labelledby="tab-approved" class="hidden">
      <div class="table-shell">
        <table class="req-table" aria-describedby="mainContent">
          <thead>
            <tr>
              <th>Request ID</th>
              <th>Submitted By</th>
              <th>Relief Center</th>
              <th>Item List</th>
              <th>Notes</th>
              <th>Submitted Date</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${not empty approvedRequests}">
                <c:forEach var="request" items="${approvedRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Submitted By">
                      <div class="submitter-info">
                        ${request.submitterName}<br/>
                        <c:if test="${not empty request.submitterContact}">
                          (${request.submitterContact})
                        </c:if>
                      </div>
                    </td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Item List">
                      <div class="item-list">
                        <c:forEach var="item" items="${request.items}">
                          ${item.itemName}: ${item.quantity}<br/>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Notes">${request.specialNotes}</td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="MMM dd, yyyy" />
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" style="text-align:center;padding:2rem;color:#666;">No approved donation requests</td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </jsp:body>
</layout:grama-niladhari-dashboard>

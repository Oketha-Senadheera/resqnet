<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Donation Requests" activePage="donation-requests">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 0.5rem; }
      .subtitle { color:#9a8b5a; font-size:0.75rem; margin-bottom:1.2rem; }
      .tabs { display:flex; gap:2.75rem; border-bottom:1px solid var(--color-border); margin-bottom:1rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.9rem 0; color:#222; }
      .tab-btn[aria-selected='true'] { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); width:220px; transition:transform .25s ease, width .25s ease; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.req-table { width:100%; border-collapse:collapse; font-size:0.65rem; }
      table.req-table thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.req-table tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table.req-table tbody tr:last-child td { border-bottom:none; }
      .action-pills { display:flex; gap:0.55rem; align-items:center; }
      .pill { all:unset; cursor:pointer; font-size:0.55rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .pill.verify { background:var(--color-accent); color:#000; }
      .pill.edit { background:#e3e3e3; color:#333; }
      .pill svg { width:14px; height:14px; }
      .hidden { display:none !important; }
      .item-list { font-size:0.6rem; }
      .alert { padding:0.75rem 1rem; border-radius:var(--radius-md); margin-bottom:1rem; font-size:0.75rem; }
      .alert-success { background:#efe; border:1px solid #cfc; color:#3c3; }
      .alert-error { background:#fee; border:1px solid #fcc; color:#c33; }
      @media (max-width:780px){ table.req-table thead { display:none; } table.req-table tbody td { display:block; padding:0.6rem 0.85rem; } table.req-table tbody tr { border-bottom:1px solid var(--color-border); } table.req-table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } .action-pills{ flex-wrap:wrap; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        const tabs=Array.from(document.querySelectorAll('.tab-btn')); 
        const indicator=document.querySelector('.tab-indicator');
        
        function pos(idx){ 
          const b=tabs[idx]; 
          indicator.style.width=b.offsetWidth+'px'; 
          indicator.style.transform=`translateX(\${b.offsetLeft}px)`; 
        }
        
        pos(0); 
        window.addEventListener('resize',()=>pos(tabs.findIndex(t=>t.getAttribute('aria-selected')==='true')));
        
        tabs.forEach((btn,idx)=>btn.addEventListener('click',()=>{ 
          if(btn.getAttribute('aria-selected')==='true') return; 
          tabs.forEach(t=>t.setAttribute('aria-selected','false')); 
          btn.setAttribute('aria-selected','true'); 
          document.querySelectorAll('[role=tabpanel]').forEach(p=>p.classList.add('hidden')); 
          document.getElementById(btn.getAttribute('aria-controls')).classList.remove('hidden'); 
          pos(idx); 
        }));
      });
      
      function verifyRequest(requestId) {
        if (confirm('Are you sure you want to verify this donation request?')) {
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
    <div class="subtitle">Manage donation requests from your division</div>
    
    <c:if test="${param.success == 'verified'}">
      <div class="alert alert-success">Donation request verified successfully!</div>
    </c:if>
    <c:if test="${param.error != null}">
      <div class="alert alert-error">An error occurred. Please try again.</div>
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
              <c:when test="${empty pendingRequests}">
                <tr>
                  <td colspan="7" style="text-align:center; padding:2rem; color:#999;">No pending donation requests</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="request" items="${pendingRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Submitted By">
                      ${request.userName}<br/>
                      <c:if test="${not empty request.userContact}">(${request.userContact})</c:if>
                    </td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Item List">
                      <div class="item-list">
                        <c:forEach var="item" items="${request.items}" varStatus="status">
                          ${item.itemName}: ${item.quantity}<c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Notes">${empty request.specialNotes ? '-' : request.specialNotes}</td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td data-label="Actions">
                      <div class="action-pills">
                        <button type="button" class="pill verify" onclick="verifyRequest(${request.requestId})">
                          <span data-lucide="check"></span><span>Verify</span>
                        </button>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
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
              <th>Approved Date</th>
            </tr>
          </thead>
          <tbody>
            <c:choose>
              <c:when test="${empty approvedRequests}">
                <tr>
                  <td colspan="7" style="text-align:center; padding:2rem; color:#999;">No approved donation requests</td>
                </tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="request" items="${approvedRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Submitted By">
                      ${request.userName}<br/>
                      <c:if test="${not empty request.userContact}">(${request.userContact})</c:if>
                    </td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Item List">
                      <div class="item-list">
                        <c:forEach var="item" items="${request.items}" varStatus="status">
                          ${item.itemName}: ${item.quantity}<c:if test="${!status.last}">, </c:if>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Notes">${empty request.specialNotes ? '-' : request.specialNotes}</td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                    <td data-label="Approved Date">
                      <fmt:formatDate value="${request.approvedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>
    </section>
  </jsp:body>
</layout:grama-niladhari-dashboard>

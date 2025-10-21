<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - Disaster Reports" activePage="disaster-reports">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.4rem; }
      .tabs { display:flex; gap:2.75rem; border-bottom:1px solid var(--color-border); margin-bottom:1rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.9rem 0; color:#222; }
      .tab-btn[aria-selected='true'] { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); width:220px; transition:transform .25s ease, width .25s ease; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.report-table { width:100%; border-collapse:collapse; font-size:0.65rem; }
      table.report-table thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.report-table tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table.report-table tbody tr:last-child td { border-bottom:none; }
      .hidden { display:none !important; }
      .reported-by { color:#666; }
      .date-time { display:flex; flex-direction:column; gap:0.2rem; color:#666; }
      .type-strong { font-weight:700; }
      .action-pills { display:flex; gap:0.55rem; align-items:center; }
      .pill { all:unset; cursor:pointer; font-size:0.55rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .pill-danger { background:#d91e18; color:#fff; }
      .pill svg { width:14px; height:14px; }
      .alert { padding: 0.75rem 1rem; border-radius: var(--radius-sm); margin-bottom: 1rem; }
      .alert.error { background: #fee; border: 1px solid #fcc; color: #c00; }
      .alert.success { background: #efe; border: 1px solid #cfc; color: #060; }
      @media (max-width:780px){ 
        table.report-table thead { display:none; } 
        table.report-table tbody td { display:block; padding:0.6rem 0.85rem; } 
        table.report-table tbody tr { border-bottom:1px solid var(--color-border); } 
        table.report-table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } 
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
        
        function moveIndicator(idx){ 
          const b=tabs[idx]; 
          indicator.style.width=b.offsetWidth+'px'; 
          indicator.style.transform='translateX(' + b.offsetLeft + 'px)'; 
        }
        moveIndicator(1); // Start with pending tab
        
        window.addEventListener('resize', ()=>moveIndicator(tabs.findIndex(t=>t.getAttribute('aria-selected')==='true')));
        
        tabs.forEach((btn,idx)=>btn.addEventListener('click',()=>{ 
          if(btn.getAttribute('aria-selected')==='true') return; 
          tabs.forEach(t=>t.setAttribute('aria-selected','false')); 
          btn.setAttribute('aria-selected','true'); 
          document.querySelectorAll('[role=tabpanel]').forEach(p=>p.classList.add('hidden')); 
          document.getElementById(btn.getAttribute('aria-controls')).classList.remove('hidden'); 
          moveIndicator(idx); 
        }));
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Disaster Reports</h1>
    
    <c:if test="${param.success == 'approve'}">
      <div class="alert success">Disaster report approved successfully.</div>
    </c:if>
    <c:if test="${param.success == 'reject'}">
      <div class="alert success">Disaster report rejected successfully.</div>
    </c:if>
    <c:if test="${param.error != null}">
      <div class="alert error">An error occurred. Please try again.</div>
    </c:if>
    
    <div class="tabs" role="tablist">
      <button class="tab-btn" id="tab-approved" role="tab" aria-controls="panel-approved" aria-selected="false">Approved Disaster Reports</button>
      <button class="tab-btn" id="tab-pending" role="tab" aria-controls="panel-pending" aria-selected="true">Pending Disaster Reports</button>
      <span class="tab-indicator" aria-hidden="true"></span>
    </div>
    
    <section id="panel-approved" role="tabpanel" aria-labelledby="tab-approved" class="hidden">
      <div class="table-shell">
        <table class="report-table" aria-describedby="mainContent">
          <thead>
            <tr>
              <th>Report ID</th>
              <th>Reported By</th>
              <th>Date/Time</th>
              <th>Location</th>
              <th>Disaster Type</th>
              <th>Description/Notes</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="report" items="${approvedReports}">
              <tr>
                <td data-label="Report ID">#${report.reportId}</td>
                <td data-label="Reported By" class="reported-by">${report.reporterName}<br/>${report.contactNumber}</td>
                <td data-label="Date/Time" class="date-time">
                  <fmt:formatDate value="${report.disasterDatetime}" pattern="yyyy-MM-dd" /><br/>
                  <fmt:formatDate value="${report.disasterDatetime}" pattern="HH:mm" />
                </td>
                <td data-label="Location">${report.location}</td>
                <td data-label="Disaster Type" class="type-strong">
                  <c:choose>
                    <c:when test="${report.disasterType == 'Other'}">
                      ${report.otherDisasterType}
                    </c:when>
                    <c:otherwise>
                      ${report.disasterType}
                    </c:otherwise>
                  </c:choose>
                </td>
                <td data-label="Description/Notes">${report.description != null ? report.description : 'N/A'}</td>
              </tr>
            </c:forEach>
            <c:if test="${empty approvedReports}">
              <tr>
                <td colspan="6" style="text-align:center; padding:2rem; color:#666;">No approved disaster reports found.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </section>
    
    <section id="panel-pending" role="tabpanel" aria-labelledby="tab-pending">
      <div class="table-shell">
        <table class="report-table" aria-describedby="mainContent">
          <thead>
            <tr>
              <th>Report ID</th>
              <th>Reported By</th>
              <th>Date/Time</th>
              <th>Location</th>
              <th>Disaster Type</th>
              <th>Description/Notes</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="report" items="${pendingReports}">
              <tr>
                <td data-label="Report ID">#${report.reportId}</td>
                <td data-label="Reported By" class="reported-by">${report.reporterName}<br/>${report.contactNumber}</td>
                <td data-label="Date/Time" class="date-time">
                  <fmt:formatDate value="${report.disasterDatetime}" pattern="yyyy-MM-dd" /><br/>
                  <fmt:formatDate value="${report.disasterDatetime}" pattern="HH:mm" />
                </td>
                <td data-label="Location">${report.location}</td>
                <td data-label="Disaster Type" class="type-strong">
                  <c:choose>
                    <c:when test="${report.disasterType == 'Other'}">
                      ${report.otherDisasterType}
                    </c:when>
                    <c:otherwise>
                      ${report.disasterType}
                    </c:otherwise>
                  </c:choose>
                </td>
                <td data-label="Description/Notes">${report.description != null ? report.description : 'N/A'}</td>
                <td data-label="Actions">
                  <div class="action-pills">
                    <form method="post" action="${pageContext.request.contextPath}/dmc/disaster-reports" style="display:inline;">
                      <input type="hidden" name="reportId" value="${report.reportId}" />
                      <input type="hidden" name="action" value="approve" />
                      <button type="submit" class="pill">
                        <span data-lucide="check"></span><span>Verify</span>
                      </button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/dmc/disaster-reports" style="display:inline;">
                      <input type="hidden" name="reportId" value="${report.reportId}" />
                      <input type="hidden" name="action" value="reject" />
                      <button type="submit" class="pill pill-danger">
                        <span data-lucide="trash-2"></span><span>Reject</span>
                      </button>
                    </form>
                  </div>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty pendingReports}">
              <tr>
                <td colspan="7" style="text-align:center; padding:2rem; color:#666;">No pending disaster reports found.</td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </section>
  </jsp:body>
</layout:dmc-dashboard>

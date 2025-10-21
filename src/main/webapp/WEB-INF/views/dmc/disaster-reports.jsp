<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - Disaster Reports" activePage="disaster-reports">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.4rem; }
      .tabs { display:flex; gap:2.75rem; border-bottom:1px solid var(--color-border); margin-bottom:1rem; position:relative; }
      .tab-btn { all:unset; cursor:pointer; font-size:0.85rem; font-weight:600; padding:0.9rem 0; color:#222; }
      .tab-btn.active { color:#000; }
      .tab-indicator { position:absolute; bottom:-1px; height:2px; background:var(--color-accent); transition:transform .25s ease, width .25s ease; }
      .hidden { display:none !important; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.report-table { width:100%; border-collapse:collapse; font-size:0.8rem; }
      table.report-table thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.report-table tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table.report-table tbody tr:last-child td { border-bottom:none; }
      .reported-by { color:#666; font-size:0.75rem; }
      .date-time { display:flex; flex-direction:column; gap:0.2rem; color:#666; font-size:0.75rem; }
      .type-strong { font-weight:700; }
      .action-pills { display:flex; gap:0.55rem; align-items:center; }
      .pill { all:unset; cursor:pointer; font-size:0.7rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .pill:hover { background:#d0d0d0; }
      .pill-danger { background:#d91e18; color:#fff; }
      .pill-danger:hover { background:#b01510; }
      .pill svg { width:14px; height:14px; }
      .alert { padding:1rem; border-radius:var(--radius-sm); margin-bottom:1rem; }
      .alert-success { background:#efe; border:1px solid #cfc; color:#3c3; }
      .alert-error { background:#fee; border:1px solid #fcc; color:#c33; }
      .empty-state { padding:3rem; text-align:center; color:#888; font-size:0.9rem; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const tabs = document.querySelectorAll('.tab-btn');
        const indicator = document.querySelector('.tab-indicator');
        const panels = document.querySelectorAll('[role="tabpanel"]');
        
        function updateIndicator(btn) {
          indicator.style.width = btn.offsetWidth + 'px';
          indicator.style.transform = 'translateX(' + btn.offsetLeft + 'px)';
        }
        
        tabs.forEach((btn, idx) => {
          btn.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            panels.forEach(p => p.classList.add('hidden'));
            
            btn.classList.add('active');
            const targetPanel = document.getElementById(btn.getAttribute('aria-controls'));
            targetPanel.classList.remove('hidden');
            
            updateIndicator(btn);
          });
        });
        
        // Initialize indicator position
        const activeTab = document.querySelector('.tab-btn.active');
        if (activeTab) {
          updateIndicator(activeTab);
        }
        
        window.addEventListener('resize', () => {
          const activeTab = document.querySelector('.tab-btn.active');
          if (activeTab) updateIndicator(activeTab);
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Disaster Reports</h1>
    
    <c:if test="${param.success == 'verified'}">
      <div class="alert alert-success">Disaster report has been verified successfully!</div>
    </c:if>
    <c:if test="${param.success == 'rejected'}">
      <div class="alert alert-success">Disaster report has been rejected.</div>
    </c:if>
    <c:if test="${param.error != null}">
      <div class="alert alert-error">An error occurred while processing the report.</div>
    </c:if>
    
    <div class="tabs" role="tablist">
      <button class="tab-btn active" id="tab-pending" role="tab" aria-controls="panel-pending">Pending Disaster Reports</button>
      <button class="tab-btn" id="tab-approved" role="tab" aria-controls="panel-approved">Approved Disaster Reports</button>
      <span class="tab-indicator" aria-hidden="true"></span>
    </div>
    
    <section id="panel-pending" role="tabpanel" aria-labelledby="tab-pending">
      <div class="table-shell">
        <c:choose>
          <c:when test="${empty pendingReports}">
            <div class="empty-state">No pending disaster reports.</div>
          </c:when>
          <c:otherwise>
            <table class="report-table">
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
                    <td>#${report.reportId}</td>
                    <td class="reported-by">
                      ${report.reporterName}<br/>
                      ${report.contactNumber}
                    </td>
                    <td class="date-time">
                      <fmt:formatDate value="${report.disasterDatetime}" pattern="yyyy-MM-dd" /><br/>
                      <fmt:formatDate value="${report.disasterDatetime}" pattern="HH:mm" />
                    </td>
                    <td>${report.location}</td>
                    <td class="type-strong">
                      <c:choose>
                        <c:when test="${report.disasterType == 'Other'}">
                          ${report.otherDisasterType}
                        </c:when>
                        <c:otherwise>
                          ${report.disasterType}
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${report.description != null ? report.description : '-'}</td>
                    <td>
                      <div class="action-pills">
                        <form method="post" action="${pageContext.request.contextPath}/dmc/disaster-reports/verify" style="display:inline;">
                          <input type="hidden" name="reportId" value="${report.reportId}" />
                          <input type="hidden" name="action" value="verify" />
                          <button type="submit" class="pill">
                            <span data-lucide="check"></span>
                            <span>Verify</span>
                          </button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/dmc/disaster-reports/verify" style="display:inline;">
                          <input type="hidden" name="reportId" value="${report.reportId}" />
                          <input type="hidden" name="action" value="reject" />
                          <button type="submit" class="pill pill-danger">
                            <span data-lucide="trash-2"></span>
                            <span>Reject</span>
                          </button>
                        </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </section>
    
    <section id="panel-approved" role="tabpanel" aria-labelledby="tab-approved" class="hidden">
      <div class="table-shell">
        <c:choose>
          <c:when test="${empty approvedReports}">
            <div class="empty-state">No approved disaster reports.</div>
          </c:when>
          <c:otherwise>
            <table class="report-table">
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
                    <td>#${report.reportId}</td>
                    <td class="reported-by">
                      ${report.reporterName}<br/>
                      ${report.contactNumber}
                    </td>
                    <td class="date-time">
                      <fmt:formatDate value="${report.disasterDatetime}" pattern="yyyy-MM-dd" /><br/>
                      <fmt:formatDate value="${report.disasterDatetime}" pattern="HH:mm" />
                    </td>
                    <td>${report.location}</td>
                    <td class="type-strong">
                      <c:choose>
                        <c:when test="${report.disasterType == 'Other'}">
                          ${report.otherDisasterType}
                        </c:when>
                        <c:otherwise>
                          ${report.disasterType}
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${report.description != null ? report.description : '-'}</td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </section>
  </jsp:body>
</layout:dmc-dashboard>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - My Donation Requests" activePage="request-donation">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1rem; }
      .actions-bar { display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem; }
      .btn-new { all:unset; cursor:pointer; background:var(--color-accent); color:#000; font-weight:600; font-size:0.85rem; padding:0.75rem 1.5rem; border-radius:999px; display:inline-flex; align-items:center; gap:0.5rem; }
      .btn-new:hover { background:var(--color-accent-hover); }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table { width:100%; border-collapse:collapse; font-size:0.8rem; }
      table thead th { text-align:left; padding:0.9rem 1rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table tbody td { padding:1rem; border-bottom:1px solid var(--color-border); vertical-align:top; }
      table tbody tr:last-child td { border-bottom:none; }
      table tbody tr:hover { background:#f9f9f9; }
      .status-badge { display:inline-block; padding:0.3rem 0.75rem; border-radius:999px; font-size:0.75rem; font-weight:600; }
      .status-pending { background:#fef3c7; color:#92400e; }
      .status-approved { background:#d1fae5; color:#065f46; }
      .status-rejected { background:#fee2e2; color:#991b1b; }
      .alert { padding:0.75rem 1rem; border-radius:var(--radius-md); margin-bottom:1rem; font-size:0.85rem; }
      .alert.success { background:#f0fdf4; border:1px solid #bbf7d0; color:#166534; }
      .empty-state { text-align:center; padding:3rem 1rem; color:#666; }
      @media (max-width:768px){ table thead { display:none; } table tbody td { display:block; padding:0.6rem 1rem; } table tbody tr { border-bottom:1px solid var(--color-border); } table tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } }
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
    <h1>My Donation Requests</h1>
    
    <c:if test="${param.success == 'submitted'}">
      <div class="alert success">Donation request submitted successfully!</div>
    </c:if>
    
    <div class="actions-bar">
      <div></div>
      <a href="${pageContext.request.contextPath}/general/donation-requests/form" class="btn-new">
        <i data-lucide="plus" style="width:16px;height:16px;"></i>
        New Request
      </a>
    </div>
    
    <c:choose>
      <c:when test="${not empty requests}">
        <div class="table-shell">
          <table>
            <thead>
              <tr>
                <th>Request ID</th>
                <th>Relief Center</th>
                <th>Status</th>
                <th>Submitted Date</th>
                <th>Notes</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="request" items="${requests}">
                <tr>
                  <td data-label="Request ID">#${request.requestId}</td>
                  <td data-label="Relief Center">${request.reliefCenterName}</td>
                  <td data-label="Status">
                    <span class="status-badge status-${request.status.toLowerCase()}">
                      ${request.status}
                    </span>
                  </td>
                  <td data-label="Submitted Date">
                    <fmt:formatDate value="${request.submittedAt}" pattern="yyyy-MM-dd HH:mm" />
                  </td>
                  <td data-label="Notes">${request.specialNotes != null ? request.specialNotes : '-'}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </c:when>
      <c:otherwise>
        <div class="empty-state">
          <i data-lucide="inbox" style="width:48px;height:48px;margin-bottom:1rem;"></i>
          <p>No donation requests yet. Click "New Request" to create one.</p>
        </div>
      </c:otherwise>
    </c:choose>
  </jsp:body>
</layout:general-user-dashboard>

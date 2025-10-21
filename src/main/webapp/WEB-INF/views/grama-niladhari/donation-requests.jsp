<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Donation Requests" activePage="donation-requests">
  <jsp:attribute name="styles">
    <style>
      h1 { margin: 0 0 0.5rem; }
      .subtitle { color: #666; font-size: 0.85rem; margin-bottom: 1.5rem; }
      .tabs { display: flex; gap: 2.5rem; border-bottom: 1px solid var(--color-border); margin-bottom: 1.5rem; position: relative; }
      .tab-btn { all: unset; cursor: pointer; font-size: 0.85rem; font-weight: 600; padding: 0.9rem 0; color: #666; }
      .tab-btn.active { color: #000; }
      .tab-indicator { position: absolute; bottom: -1px; height: 2px; background: var(--color-accent); width: 180px; transition: transform 0.25s ease, width 0.25s ease; }
      .table-container { border: 1px solid var(--color-border); border-radius: 12px; overflow: hidden; background: #fff; }
      .requests-table { width: 100%; border-collapse: collapse; font-size: 0.8rem; }
      .requests-table thead th { text-align: left; padding: 1rem; background: #f9f9f9; font-weight: 600; border-bottom: 1px solid var(--color-border); }
      .requests-table tbody td { padding: 1rem; border-bottom: 1px solid var(--color-border); vertical-align: top; }
      .requests-table tbody tr:last-child td { border-bottom: none; }
      .requests-table tbody tr:hover { background: #f9f9f9; }
      .action-buttons { display: flex; gap: 0.5rem; flex-wrap: wrap; }
      .btn { all: unset; cursor: pointer; font-size: 0.75rem; font-weight: 600; padding: 0.5rem 1rem; border-radius: 999px; display: inline-flex; align-items: center; gap: 0.4rem; }
      .btn-approve { background: var(--color-accent); color: #000; }
      .btn-reject { background: #ff5252; color: white; }
      .btn-edit { background: #e0e0e0; color: #000; }
      .item-list { font-size: 0.75rem; color: #666; }
      .item-list-item { margin-bottom: 0.25rem; }
      .hidden { display: none !important; }
      .alert { padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; }
      .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
      .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
      .empty-state { text-align: center; padding: 3rem; color: #999; }
      @media (max-width: 768px) {
        .requests-table thead { display: none; }
        .requests-table tbody td { display: block; padding: 0.75rem; }
        .requests-table tbody tr { border-bottom: 2px solid var(--color-border); }
        .requests-table tbody td::before { content: attr(data-label); display: block; font-weight: 600; margin-bottom: 0.5rem; }
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      function switchTab(tabName) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.add('hidden'));
        
        document.getElementById('tab-' + tabName).classList.add('active');
        document.getElementById('panel-' + tabName).classList.remove('hidden');
        
        const indicator = document.querySelector('.tab-indicator');
        const activeTab = document.getElementById('tab-' + tabName);
        indicator.style.width = activeTab.offsetWidth + 'px';
        indicator.style.transform = 'translateX(' + activeTab.offsetLeft + 'px)';
      }
      
      function confirmApprove(requestId) {
        if (confirm('Are you sure you want to approve this donation request?')) {
          document.getElementById('approve-form-' + requestId).submit();
        }
      }
      
      function confirmReject(requestId) {
        if (confirm('Are you sure you want to reject and delete this donation request?')) {
          document.getElementById('reject-form-' + requestId).submit();
        }
      }
      
      window.addEventListener('load', function() {
        const indicator = document.querySelector('.tab-indicator');
        const activeTab = document.querySelector('.tab-btn.active');
        if (activeTab) {
          indicator.style.width = activeTab.offsetWidth + 'px';
          indicator.style.transform = 'translateX(' + activeTab.offsetLeft + 'px)';
        }
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Donation Requests</h1>
    <div class="subtitle">Review and manage donation requests from your division</div>
    
    <c:if test="${param.success == 'approved'}">
      <div class="alert alert-success">
        Donation request has been approved successfully!
      </div>
    </c:if>
    
    <c:if test="${param.success == 'updated'}">
      <div class="alert alert-success">
        Donation request has been updated successfully!
      </div>
    </c:if>
    
    <c:if test="${param.success == 'rejected'}">
      <div class="alert alert-success">
        Donation request has been rejected and removed.
      </div>
    </c:if>
    
    <c:if test="${param.error != null}">
      <div class="alert alert-error">
        An error occurred. Please try again.
      </div>
    </c:if>
    
    <div class="tabs">
      <button class="tab-btn active" id="tab-pending" onclick="switchTab('pending')">Pending Requests</button>
      <button class="tab-btn" id="tab-approved" onclick="switchTab('approved')">Approved Requests</button>
      <span class="tab-indicator"></span>
    </div>
    
    <div class="tab-panel" id="panel-pending">
      <div class="table-container">
        <c:choose>
          <c:when test="${empty pendingRequests}">
            <div class="empty-state">
              <p>No pending donation requests at the moment.</p>
            </div>
          </c:when>
          <c:otherwise>
            <table class="requests-table">
              <thead>
                <tr>
                  <th>Request ID</th>
                  <th>Relief Center</th>
                  <th>Requested Items</th>
                  <th>Special Notes</th>
                  <th>Submitted Date</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="request" items="${pendingRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Requested Items">
                      <div class="item-list">
                        <c:forEach var="item" items="${request.items}">
                          <div class="item-list-item">
                            ${item.itemName}: ${item.quantity} unit<c:if test="${item.quantity > 1}">s</c:if>
                          </div>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Special Notes">
                      <c:choose>
                        <c:when test="${not empty request.specialNotes}">
                          ${request.specialNotes}
                        </c:when>
                        <c:otherwise>
                          <em style="color: #999;">No notes</em>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td data-label="Submitted Date">
                      <fmt:formatDate value="${request.submittedAt}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                    <td data-label="Actions">
                      <div class="action-buttons">
                        <button type="button" class="btn btn-approve" onclick="confirmApprove(${request.requestId})">
                          Approve
                        </button>
                        <a href="${pageContext.request.contextPath}/gn/donation-requests/edit?request_id=${request.requestId}" class="btn btn-edit">
                          Edit
                        </a>
                        <button type="button" class="btn btn-reject" onclick="confirmReject(${request.requestId})">
                          Reject
                        </button>
                      </div>
                      <form id="approve-form-${request.requestId}" method="post" 
                            action="${pageContext.request.contextPath}/gn/donation-requests/approve" style="display: none;">
                        <input type="hidden" name="request_id" value="${request.requestId}">
                      </form>
                      <form id="reject-form-${request.requestId}" method="post" 
                            action="${pageContext.request.contextPath}/gn/donation-requests/reject" style="display: none;">
                        <input type="hidden" name="request_id" value="${request.requestId}">
                      </form>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    
    <div class="tab-panel hidden" id="panel-approved">
      <div class="table-container">
        <c:choose>
          <c:when test="${empty approvedRequests}">
            <div class="empty-state">
              <p>No approved donation requests yet.</p>
            </div>
          </c:when>
          <c:otherwise>
            <table class="requests-table">
              <thead>
                <tr>
                  <th>Request ID</th>
                  <th>Relief Center</th>
                  <th>Requested Items</th>
                  <th>Special Notes</th>
                  <th>Submitted Date</th>
                  <th>Approved Date</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="request" items="${approvedRequests}">
                  <tr>
                    <td data-label="Request ID">#${request.requestId}</td>
                    <td data-label="Relief Center">${request.reliefCenterName}</td>
                    <td data-label="Requested Items">
                      <div class="item-list">
                        <c:forEach var="item" items="${request.items}">
                          <div class="item-list-item">
                            ${item.itemName}: ${item.quantity} unit<c:if test="${item.quantity > 1}">s</c:if>
                          </div>
                        </c:forEach>
                      </div>
                    </td>
                    <td data-label="Special Notes">
                      <c:choose>
                        <c:when test="${not empty request.specialNotes}">
                          ${request.specialNotes}
                        </c:when>
                        <c:otherwise>
                          <em style="color: #999;">No notes</em>
                        </c:otherwise>
                      </c:choose>
                    </td>
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
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </jsp:body>
</layout:grama-niladhari-dashboard>

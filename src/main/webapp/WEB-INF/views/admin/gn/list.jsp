<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:dmc-dashboard pageTitle="ResQnet - GN Registry" activePage="gn-registry">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.9rem; }
      .top-actions { display:flex; justify-content:space-between; align-items:center; margin:0 0 0.75rem; }
      .add-btn { background:var(--color-accent); color:#000; font-size:0.85rem; font-weight:600; border-radius:999px; padding:0.6rem 1.1rem; border:none; cursor:pointer; text-decoration:none; display:inline-block; }
      .add-btn:hover { background:var(--color-accent-hover); }
      .alert { padding:0.75rem 1rem; margin-bottom:1rem; border-radius:var(--radius-md); font-size:0.85rem; }
      .alert-success { background:#d4edda; color:#155724; border:1px solid #c3e6cb; }
      .alert-error { background:#f8d7da; color:#721c24; border:1px solid #f5c6cb; }
      .table-shell { border:1px solid var(--color-border); border-radius:var(--radius-lg); overflow:hidden; background:#fff; }
      table.registry { width:100%; border-collapse:collapse; font-size:0.85rem; }
      table.registry thead th { text-align:left; padding:0.75rem 0.85rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.registry tbody td { padding:0.9rem 0.85rem; border-bottom:1px solid var(--color-border); vertical-align:middle; }
      table.registry tbody tr:last-child td { border-bottom:none; }
      .actions-cell { display:flex; gap:0.55rem; }
      .pill { all:unset; cursor:pointer; font-size:0.75rem; font-weight:600; padding:0.5rem 1.05rem; border-radius:999px; background:#e3e3e3; display:inline-flex; align-items:center; gap:0.35rem; }
      .pill:hover { background:#d0d0d0; }
      .pill-danger { background:#d91e18; color:#fff; }
      .pill-danger:hover { background:#b81812; }
      .pill svg { width:14px; height:14px; }
      .empty-row { text-align:center; padding:2rem !important; font-style:italic; color:#666; }
      @media (max-width:780px){ 
        table.registry thead { display:none; } 
        table.registry tbody td { display:block; padding:0.6rem 0.85rem; } 
        table.registry tbody tr { border-bottom:1px solid var(--color-border); } 
        table.registry tbody td::before { content:attr(data-label); display:block; font-weight:600; margin-bottom:0.25rem; } 
        .actions-cell { flex-wrap:wrap; } 
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      function confirmDelete(name, userId) {
        if (confirm('Are you sure you want to delete Grama Niladhari "' + name + '"? This action cannot be undone.')) {
          const form = document.createElement('form');
          form.method = 'POST';
          form.action = '${pageContext.request.contextPath}/admin/gn-registry/delete';
          const input = document.createElement('input');
          input.type = 'hidden';
          input.name = 'id';
          input.value = userId;
          form.appendChild(input);
          document.body.appendChild(form);
          form.submit();
        }
      }
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Registered Grama Niladharis</h1>

    <c:if test="${param.success == 'added'}">
      <div class="alert alert-success">Grama Niladhari successfully added!</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="alert alert-success">Grama Niladhari successfully updated!</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
      <div class="alert alert-success">Grama Niladhari successfully deleted!</div>
    </c:if>
    <c:if test="${param.error == 'notfound'}">
      <div class="alert alert-error">Grama Niladhari not found!</div>
    </c:if>
    <c:if test="${param.error == 'delete'}">
      <div class="alert alert-error">Error deleting Grama Niladhari!</div>
    </c:if>

    <div class="top-actions">
      <div></div>
      <a href="${pageContext.request.contextPath}/admin/gn-registry/add" class="add-btn">Add new GN</a>
    </div>

    <div class="table-shell">
      <table class="registry" aria-describedby="mainContent">
        <thead>
          <tr>
            <th>Name</th>
            <th>Division</th>
            <th>Contact Info</th>
            <th>Username</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty gnList}">
              <tr>
                <td colspan="5" class="empty-row">No GN records found.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="gnWithUser" items="${gnList}">
                <tr>
                  <td data-label="Name">${gnWithUser.gramaNiladhari.name}</td>
                  <td data-label="Division">${gnWithUser.gramaNiladhari.gnDivision}</td>
                  <td data-label="Contact Info">${gnWithUser.gramaNiladhari.contactNumber}</td>
                  <td data-label="Username">${gnWithUser.user.username}</td>
                  <td data-label="Actions">
                    <div class="actions-cell">
                      <a href="${pageContext.request.contextPath}/admin/gn-registry/edit?id=${gnWithUser.user.id}" class="pill">
                        <span data-lucide="edit"></span>Edit
                      </a>
                      <button type="button" class="pill pill-danger" onclick="confirmDelete('${gnWithUser.gramaNiladhari.name}', ${gnWithUser.user.id})">
                        <span data-lucide="trash-2"></span>Delete
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
  </jsp:body>
</layout:dmc-dashboard>

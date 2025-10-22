<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:ngo-dashboard pageTitle="ResQnet - Inventory Management" activePage="manage-inventory">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .filters { display:flex; gap:0.75rem; flex-wrap:wrap; margin:0 0 1.5rem; }
      .filters .search-wrap { flex:1 1 240px; position:relative; }
      .filters input[type=search] { width:100%; padding:0.6rem 0.6rem 0.6rem 2.25rem; border:1px solid var(--color-border); border-radius:999px; font-size:0.75rem; }
      .filters .search-wrap .icon { position:absolute; top:50%; left:0.75rem; transform:translateY(-50%); width:16px; height:16px; opacity:.6; }
      .pill-select { position:relative; }
      .pill-select select { appearance:none; -webkit-appearance:none; background:#fff; font-size:0.75rem; padding:0.6rem 2rem 0.6rem 1rem; border:1px solid var(--color-border); border-radius:999px; cursor:pointer; }
      .pill-select:after { content:"\25BC"; position:absolute; right:0.9rem; top:50%; transform:translateY(-48%); font-size:0.5rem; pointer-events:none; }
      .inventory-table-wrapper { border:1px solid var(--color-border); border-radius:12px; overflow:hidden; background:#fff; }
      table.inventory { width:100%; border-collapse:collapse; font-size:0.75rem; }
      table.inventory thead th { text-align:left; padding:0.85rem 1rem; background:#fafafa; font-weight:600; border-bottom:1px solid var(--color-border); }
      table.inventory tbody td { padding:1rem; border-bottom:1px solid var(--color-border); vertical-align:middle; }
      table.inventory tbody tr:last-child td { border-bottom:none; }
      .qty-cell { display:flex; align-items:center; gap:0.75rem; }
      .qty-cell input { width:80px; text-align:right; font-size:0.75rem; padding:0.45rem; border:1px solid var(--color-border); border-radius:6px; }
      .update-btn { background:#e3e3e3; padding:0.5rem 1rem; border-radius:999px; cursor:pointer; font-size:0.7rem; font-weight:600; border:none; transition:background 0.2s; }
      .update-btn:hover { background:#d0d0d0; }
      .status { font-weight:600; font-size:0.7rem; }
      .status.in-stock { color:#0d6b35; }
      .status.low { color:#b25600; }
      .status.out { color:#b00020; }
      .empty-row { text-align:center; padding:2rem !important; color:#666; font-style:italic; }
      .alert { padding:0.75rem 1rem; border-radius:8px; margin-bottom:1rem; font-size:0.75rem; }
      .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
      .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
      @media (max-width:780px){ .qty-cell { flex-direction:column; align-items:flex-start; } .qty-cell input { width:100%; } }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const searchInput = document.getElementById('search');
        const categoryFilter = document.getElementById('filterCategory');
        const collectionPointFilter = document.getElementById('filterCollectionPoint');
        const statusFilter = document.getElementById('filterStatus');
        
        const allRows = Array.from(document.querySelectorAll('.inventory tbody tr'));
        
        function filterTable() {
          const searchTerm = searchInput.value.toLowerCase();
          const categoryValue = categoryFilter.value;
          const collectionPointValue = collectionPointFilter.value;
          const statusValue = statusFilter.value;
          
          allRows.forEach(row => {
            const itemName = row.dataset.itemName.toLowerCase();
            const category = row.dataset.category;
            const collectionPoint = row.dataset.collectionPoint;
            const status = row.dataset.status;
            
            const matchesSearch = !searchTerm || itemName.includes(searchTerm);
            const matchesCategory = !categoryValue || category === categoryValue;
            const matchesCollectionPoint = !collectionPointValue || collectionPoint === collectionPointValue;
            const matchesStatus = !statusValue || status === statusValue;
            
            if (matchesSearch && matchesCategory && matchesCollectionPoint && matchesStatus) {
              row.style.display = '';
            } else {
              row.style.display = 'none';
            }
          });
        }
        
        searchInput.addEventListener('input', filterTable);
        categoryFilter.addEventListener('change', filterTable);
        collectionPointFilter.addEventListener('change', filterTable);
        statusFilter.addEventListener('change', filterTable);
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Inventory Management</h1>

    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert success">${sessionScope.successMessage}</div>
      <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert error">${sessionScope.errorMessage}</div>
      <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <div class="filters">
      <div class="search-wrap">
        <span class="icon" data-lucide="search"></span>
        <input type="search" id="search" placeholder="Search items..." />
      </div>
      <div class="pill-select">
        <select id="filterCategory">
          <option value="">All Categories</option>
          <option value="Medicine">Medicine</option>
          <option value="Food">Food</option>
          <option value="Shelter">Shelter</option>
        </select>
      </div>
      <div class="pill-select">
        <select id="filterCollectionPoint">
          <option value="">All Collection Points</option>
          <c:forEach items="${collectionPoints}" var="cp">
            <option value="${cp.collectionPointId}">${cp.name}</option>
          </c:forEach>
        </select>
      </div>
      <div class="pill-select">
        <select id="filterStatus">
          <option value="">All Status</option>
          <option value="In Stock">In Stock</option>
          <option value="Low on Stock">Low on Stock</option>
          <option value="Out of Stock">Out of Stock</option>
        </select>
      </div>
    </div>

    <div class="inventory-table-wrapper">
      <table class="inventory">
        <thead>
          <tr>
            <th>Item Name</th>
            <th>Category</th>
            <th>Collection Point</th>
            <th>Status</th>
            <th>Quantity</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty inventory}">
              <tr><td colspan="5" class="empty-row">No inventory items found. Items will appear here once donations are received.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach items="${inventory}" var="item">
                <tr data-item-name="${item.itemName}" 
                    data-category="${item.category}" 
                    data-collection-point="${item.collectionPointId}"
                    data-status="${item.status}">
                  <td>${item.itemName}</td>
                  <td>${item.category}</td>
                  <td>${item.collectionPointName}</td>
                  <td>
                    <span class="status ${item.status == 'In Stock' ? 'in-stock' : item.status == 'Low on Stock' ? 'low' : 'out'}">
                      ${item.status}
                    </span>
                  </td>
                  <td>
                    <form action="${pageContext.request.contextPath}/ngo/inventory/update" method="post" style="display:inline;">
                      <div class="qty-cell">
                        <input type="hidden" name="inventoryId" value="${item.inventoryId}" />
                        <input type="number" name="quantity" value="${item.quantity}" min="0" required />
                        <button type="submit" class="update-btn">Update</button>
                      </div>
                    </form>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </jsp:body>
</layout:ngo-dashboard>

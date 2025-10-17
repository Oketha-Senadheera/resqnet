# Example: How to Add a New Page

This example demonstrates how easy it is to add a new page for any role using the reusable dashboard layouts.

## Example: Adding a "Reports" Page for Volunteers

### Step 1: Create the JSP File

Create a new file: `src/main/webapp/WEB-INF/views/volunteer/reports.jsp`

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:volunteer-dashboard 
    pageTitle="ResQnet - My Reports" 
    activePage="report-disaster">
  
  <jsp:attribute name="styles">
    <style>
      .reports-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 1.5rem;
        margin-top: 1.5rem;
      }
      .report-card {
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 12px;
        padding: 1.5rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      }
      .report-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1rem;
      }
      .report-status {
        padding: 0.25rem 0.75rem;
        border-radius: 999px;
        font-size: 0.75rem;
        font-weight: 600;
      }
      .status-pending { background: #fff3cd; color: #856404; }
      .status-verified { background: #d4edda; color: #155724; }
    </style>
  </jsp:attribute>
  
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        
        // Add event listeners for report actions
        document.querySelectorAll('.report-action').forEach(btn => {
          btn.addEventListener('click', (e) => {
            const reportId = e.target.closest('.report-card').dataset.reportId;
            console.log('Action clicked for report:', reportId);
            // Handle report action
          });
        });
      });
    </script>
  </jsp:attribute>
  
  <jsp:body>
    <section>
      <h1>My Disaster Reports</h1>
      <p>View and manage your submitted disaster reports</p>
      
      <div class="reports-grid">
        <div class="report-card" data-report-id="1">
          <div class="report-header">
            <h3>Flooding on Main Street</h3>
            <span class="report-status status-verified">Verified</span>
          </div>
          <p><strong>Location:</strong> Main Street, Colombo</p>
          <p><strong>Date:</strong> 2024-10-15</p>
          <p><strong>Severity:</strong> High</p>
          <button class="report-action btn btn-primary">View Details</button>
        </div>
        
        <div class="report-card" data-report-id="2">
          <div class="report-header">
            <h3>Landslide Near School</h3>
            <span class="report-status status-pending">Pending</span>
          </div>
          <p><strong>Location:</strong> Hill Road, Kandy</p>
          <p><strong>Date:</strong> 2024-10-17</p>
          <p><strong>Severity:</strong> Medium</p>
          <button class="report-action btn btn-primary">View Details</button>
        </div>
        
        <div class="report-card" data-report-id="3">
          <div class="report-header">
            <h3>Road Damage</h3>
            <span class="report-status status-verified">Verified</span>
          </div>
          <p><strong>Location:</strong> Highway A1, Galle</p>
          <p><strong>Date:</strong> 2024-10-10</p>
          <p><strong>Severity:</strong> Low</p>
          <button class="report-action btn btn-primary">View Details</button>
        </div>
      </div>
    </section>
  </jsp:body>
  
</layout:volunteer-dashboard>
```

### Step 2: Create the Servlet/Controller (if needed)

Create a servlet to handle the route:

```java
@WebServlet("/volunteer/reports")
public class VolunteerReportsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Add any data fetching logic here
        request.getRequestDispatcher("/WEB-INF/views/volunteer/reports.jsp").forward(request, response);
    }
}
```

### Step 3: That's It!

You now have a new page with:
- ✅ Consistent layout with sidebar and header
- ✅ Correct navigation highlighting (report-disaster is active)
- ✅ Page-specific styles
- ✅ Page-specific JavaScript
- ✅ All common functionality (logout, icons, etc.)

## Comparison: Before vs After

### Before (Without Reusable Layout)

You would need to:
1. Copy 50+ lines of boilerplate HTML
2. Copy sidebar navigation
3. Copy header/topbar
4. Copy logout functionality
5. Copy all CSS imports
6. Copy all script imports
7. Add your content
8. Manually ensure navigation highlighting works
9. Risk inconsistencies if you forgot to copy something

**Total: ~100+ lines to write**

### After (With Reusable Layout)

You only need to:
1. Use `<layout:volunteer-dashboard>` tag
2. Set `activePage` attribute
3. Add your content
4. Add custom styles (optional)
5. Add custom scripts (optional)

**Total: ~50 lines to write (or less)**

## Another Example: Adding a Profile Page for DMC

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:dmc-dashboard 
    pageTitle="ResQnet - DMC Profile Settings" 
    activePage="profile-settings">
  
  <jsp:body>
    <h1>Profile Settings</h1>
    
    <form action="${pageContext.request.contextPath}/dmc/profile" method="post">
      <div class="form-group">
        <label for="name">Organization Name</label>
        <input type="text" id="name" name="name" value="${user.name}" required />
      </div>
      
      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" value="${user.email}" required />
      </div>
      
      <div class="form-group">
        <label for="phone">Phone</label>
        <input type="tel" id="phone" name="phone" value="${user.phone}" />
      </div>
      
      <button type="submit" class="btn btn-primary">Update Profile</button>
    </form>
  </jsp:body>
  
</layout:dmc-dashboard>
```

That's it! Just 30 lines of code for a complete page with consistent layout.

## Example: Adding a Page with Complex Interaction

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>

<layout:ngo-dashboard 
    pageTitle="ResQnet - Inventory Management" 
    activePage="manage-inventory">
  
  <jsp:attribute name="styles">
    <style>
      .inventory-table { width: 100%; border-collapse: collapse; }
      .inventory-table th, .inventory-table td { 
        padding: 1rem; 
        border-bottom: 1px solid #e0e0e0; 
      }
      .inventory-table th { background: #f5f5f5; font-weight: 600; }
      .quantity-badge {
        display: inline-block;
        padding: 0.25rem 0.75rem;
        border-radius: 999px;
        font-size: 0.85rem;
      }
      .low-stock { background: #fee; color: #c00; }
      .in-stock { background: #efe; color: #080; }
    </style>
  </jsp:attribute>
  
  <jsp:attribute name="scripts">
    <script>
      class InventoryManager {
        constructor() {
          this.init();
        }
        
        init() {
          document.querySelectorAll('.add-stock-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
              const itemId = e.target.dataset.itemId;
              this.showAddStockDialog(itemId);
            });
          });
        }
        
        showAddStockDialog(itemId) {
          // Show dialog to add stock
          const quantity = prompt('Enter quantity to add:');
          if (quantity) {
            this.addStock(itemId, quantity);
          }
        }
        
        addStock(itemId, quantity) {
          // Send AJAX request to add stock
          fetch('/api/inventory/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ itemId, quantity })
          })
          .then(response => response.json())
          .then(data => {
            console.log('Stock added:', data);
            location.reload(); // Refresh to show updated stock
          });
        }
      }
      
      document.addEventListener('DOMContentLoaded', () => {
        new InventoryManager();
      });
    </script>
  </jsp:attribute>
  
  <jsp:body>
    <h1>Inventory Management</h1>
    
    <table class="inventory-table">
      <thead>
        <tr>
          <th>Item</th>
          <th>Category</th>
          <th>Quantity</th>
          <th>Status</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${inventory}" var="item">
          <tr>
            <td>${item.name}</td>
            <td>${item.category}</td>
            <td>${item.quantity}</td>
            <td>
              <span class="quantity-badge ${item.quantity < 10 ? 'low-stock' : 'in-stock'}">
                ${item.quantity < 10 ? 'Low Stock' : 'In Stock'}
              </span>
            </td>
            <td>
              <button class="btn btn-sm add-stock-btn" data-item-id="${item.id}">
                Add Stock
              </button>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </jsp:body>
  
</layout:ngo-dashboard>
```

## Key Takeaways

1. **Simple pages** need just the `<jsp:body>` section
2. **Styled pages** add the `<jsp:attribute name="styles">` section
3. **Interactive pages** add the `<jsp:attribute name="scripts">` section
4. **Always** set the correct `activePage` to highlight navigation
5. **No need** to worry about sidebar, header, logout, or common scripts

## Best Practices

1. ✅ Always use the correct role-specific layout tag
2. ✅ Set `activePage` to match the navigation item
3. ✅ Keep styles page-specific, not global
4. ✅ Keep scripts page-specific and modular
5. ✅ Test your page after creating it
6. ✅ Follow existing code style and patterns
7. ✅ Use semantic HTML in your content
8. ✅ Ensure accessibility with ARIA labels

Now adding new pages takes minutes instead of hours, and there's no risk of inconsistent layouts!

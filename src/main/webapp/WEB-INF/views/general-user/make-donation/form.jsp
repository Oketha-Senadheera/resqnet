<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - Make a Donation" activePage="make-donation">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.5rem; }
      .form-grid { display:grid; gap:1rem; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); margin-bottom:1.5rem; }
      .form-field { display:flex; flex-direction:column; gap:0.4rem; }
      .form-field label { font-weight:600; font-size:0.75rem; }
      .form-field input, .form-field select, .form-field textarea { padding:0.6rem; border:1px solid var(--color-border); border-radius:8px; font-size:0.75rem; }
      .form-field textarea { resize:vertical; min-height:100px; }
      .section-heading { font-size:0.85rem; font-weight:600; margin:1.5rem 0 1rem; }
      .time-slots { display:flex; gap:0.75rem; flex-wrap:wrap; margin-top:0.5rem; }
      .time-slot-btn { background:#fff; border:1px solid var(--color-border); padding:0.5rem 1rem; border-radius:999px; font-size:0.7rem; cursor:pointer; transition:all 0.2s; }
      .time-slot-btn:hover { background:#f5f5f5; }
      .time-slot-btn.selected { background:var(--color-accent); border-color:var(--color-accent); color:#151515; font-weight:600; }
      .donation-items { display:grid; gap:1.5rem; grid-template-columns:repeat(auto-fit,minmax(210px,1fr)); margin:1rem 0 1.5rem; }
      .item-col h3 { margin:0 0 0.75rem; font-size:0.8rem; font-weight:600; }
      .don-item { display:flex; align-items:center; gap:0.5rem; font-size:0.75rem; padding:0.3rem 0; }
      .don-item input[type="checkbox"] { width:16px; height:16px; }
      .don-item input[type="number"] { width:60px; padding:0.35rem; font-size:0.7rem; border:1px solid var(--color-border); border-radius:4px; }
      .don-item label { flex:1; }
      .confirm-line { display:flex; align-items:flex-start; gap:0.5rem; font-size:0.75rem; margin:1rem 0; }
      .form-actions { display:flex; justify-content:space-between; gap:1rem; margin-top:1.5rem; flex-wrap:wrap; }
      .form-actions .btn { min-width:140px; padding:0.7rem 1.5rem; }
      .alert { padding:0.75rem 1rem; border-radius:8px; margin-bottom:1rem; font-size:0.75rem; }
      .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
      .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        // Time slot selection
        const timeSlotBtns = document.querySelectorAll('.time-slot-btn');
        const timeSlotInput = document.getElementById('timeSlot');
        timeSlotBtns.forEach(btn => {
          btn.addEventListener('click', () => {
            timeSlotBtns.forEach(b => b.classList.remove('selected'));
            btn.classList.add('selected');
            timeSlotInput.value = btn.dataset.slot;
          });
        });

        // Auto-enable/disable quantity inputs
        document.querySelectorAll('.don-item input[type="checkbox"]').forEach(checkbox => {
          const qtyInput = checkbox.parentElement.querySelector('input[type="number"]');
          if (qtyInput) {
            qtyInput.disabled = !checkbox.checked;
            checkbox.addEventListener('change', () => {
              qtyInput.disabled = !checkbox.checked;
              if (!checkbox.checked) qtyInput.value = 1;
            });
          }
        });

        // Form submission
        const form = document.getElementById('donationForm');
        form.addEventListener('submit', (e) => {
          // Remove unchecked items from submission
          document.querySelectorAll('.don-item input[type="checkbox"]').forEach(checkbox => {
            if (!checkbox.checked) {
              const itemIdInput = checkbox.parentElement.querySelector('input[name="itemId"]');
              const qtyInput = checkbox.parentElement.querySelector('input[name="quantity"]');
              if (itemIdInput) itemIdInput.remove();
              if (qtyInput) qtyInput.remove();
            }
          });
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Make a Donation</h1>

    <c:if test="${not empty sessionScope.successMessage}">
      <div class="alert success">${sessionScope.successMessage}</div>
      <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
      <div class="alert error">${sessionScope.errorMessage}</div>
      <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <form id="donationForm" action="${pageContext.request.contextPath}/general/make-donation/submit" method="post">
      <!-- Donor Information -->
      <div class="form-grid">
        <div class="form-field">
          <label for="donorName">Name *</label>
          <input id="donorName" name="donorName" type="text" 
                 value="${not empty generalUser ? generalUser.name : ''}" required />
        </div>
        <div class="form-field">
          <label for="donorContact">Contact Number *</label>
          <input id="donorContact" name="donorContact" type="tel" 
                 value="${not empty generalUser ? generalUser.contactNumber : ''}" required />
        </div>
        <div class="form-field" style="grid-column:1/-1;">
          <label for="donorEmail">Email *</label>
          <input id="donorEmail" name="donorEmail" type="email" 
                 value="${sessionScope.authUser.email}" required />
        </div>
        <div class="form-field" style="grid-column:1/-1;">
          <label for="donorAddress">Address *</label>
          <textarea id="donorAddress" name="donorAddress" required>${not empty generalUser ? generalUser.houseNo.concat(', ').concat(generalUser.street).concat(', ').concat(generalUser.city).concat(', ').concat(generalUser.district) : ''}</textarea>
        </div>
      </div>

      <!-- Collection Details -->
      <h2 class="section-heading">Collection Details</h2>
      <div class="form-grid">
        <div class="form-field">
          <label for="collectionPoint">Collection Point *</label>
          <select id="collectionPoint" name="collectionPoint" required>
            <option value="">Select a collection point</option>
            <c:forEach items="${collectionPoints}" var="cp">
              <option value="${cp.collectionPointId}">${cp.name} - ${cp.fullAddress}</option>
            </c:forEach>
          </select>
        </div>
        <div class="form-field">
          <label for="collectionDate">Collection Date *</label>
          <input id="collectionDate" name="collectionDate" type="date" required />
        </div>
        <div class="form-field" style="grid-column:1/-1;">
          <label>Time Slot *</label>
          <div class="time-slots">
            <button type="button" class="time-slot-btn" data-slot="9am–12pm">9am–12pm</button>
            <button type="button" class="time-slot-btn" data-slot="12pm–4pm">12pm–4pm</button>
            <button type="button" class="time-slot-btn" data-slot="6pm–9pm">6pm–9pm</button>
          </div>
          <input type="hidden" id="timeSlot" name="timeSlot" required />
        </div>
      </div>

      <!-- Donation Items -->
      <h2 class="section-heading">Donation Items</h2>
      <div class="donation-items">
        <c:forEach items="${{'Medicine', 'Food', 'Shelter'}}" var="category">
          <div class="item-col">
            <h3>${category}</h3>
            <c:forEach items="${itemsCatalog}" var="item">
              <c:if test="${item.category == category}">
                <div class="don-item">
                  <input type="checkbox" id="itm_${item.itemId}" />
                  <label for="itm_${item.itemId}">${item.itemName}</label>
                  <input type="hidden" name="itemId" value="${item.itemId}" />
                  <input type="number" name="quantity" min="1" value="1" disabled />
                </div>
              </c:if>
            </c:forEach>
          </div>
        </c:forEach>
      </div>

      <!-- Special Notes -->
      <div class="form-field">
        <label for="specialNotes">Special Notes</label>
        <textarea id="specialNotes" name="specialNotes" placeholder="Any additional information (optional)"></textarea>
      </div>

      <!-- Confirmation -->
      <div class="confirm-line">
        <input type="checkbox" id="confirmation" name="confirmation" required />
        <label for="confirmation">I confirm that all items are in acceptable condition and non-expired. *</label>
      </div>

      <div class="form-actions">
        <button type="button" class="btn" onclick="history.back()">Cancel</button>
        <button type="submit" class="btn btn-primary">Submit Donation</button>
      </div>
    </form>
  </jsp:body>
</layout:general-user-dashboard>

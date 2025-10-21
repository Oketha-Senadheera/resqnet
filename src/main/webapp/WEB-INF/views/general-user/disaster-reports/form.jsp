<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - Report a Disaster" activePage="report-disaster">
  <jsp:attribute name="styles">
    <style>
      h1 { margin:0 0 1.4rem; }
      .form-shell { background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-lg); padding:2rem 2rem 2.5rem; box-shadow:var(--shadow-sm); max-width:1100px; }
      .two-col-grid { display:grid; gap:2rem 2.25rem; grid-template-columns:repeat(auto-fit,minmax(300px,1fr)); }
      .form-field { display:flex; flex-direction:column; gap:0.5rem; }
      .form-field label { font-size:0.85rem; font-weight:600; color:#222; }
      .form-field input, .form-field select, .form-field textarea { padding:0.75rem 1rem; border:1px solid var(--color-border); border-radius:var(--radius-sm); font-size:0.85rem; font-family:inherit; }
      .form-field input:focus, .form-field select:focus, .form-field textarea:focus { outline:none; border-color:var(--color-accent); }
      .disaster-types { display:flex; flex-direction:column; gap:0.75rem; }
      .disaster-option { border:1px solid var(--color-border); border-radius:var(--radius-sm); padding:0.9rem 1rem; display:flex; align-items:center; gap:0.75rem; font-size:0.85rem; cursor:pointer; background:#fff; }
      .disaster-option:hover { background:var(--color-hover-surface); }
      .disaster-option input { accent-color:var(--color-accent); }
      .ack { display:flex; align-items:center; gap:0.6rem; font-size:0.85rem; margin-top:1.25rem; }
      .ack input { width:16px; height:16px; accent-color:var(--color-accent); }
      .inline-actions { display:flex; justify-content:space-between; align-items:center; margin-top:1.5rem; }
      .btn { all:unset; cursor:pointer; font-size:0.85rem; font-weight:600; padding:0.75rem 1.5rem; border-radius:var(--radius-md); display:inline-block; text-align:center; }
      .btn-primary { background:var(--color-accent); color:#fff; }
      .btn-primary:hover { background:var(--color-accent-hover); }
      .btn-secondary { background:#f1f1f1; color:#222; }
      .btn-secondary:hover { background:#e0e0e0; }
      .alert { padding:1rem; border-radius:var(--radius-sm); margin-bottom:1rem; }
      .alert-error { background:#fee; border:1px solid #fcc; color:#c33; }
      .alert-success { background:#efe; border:1px solid #cfc; color:#3c3; }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        
        const form = document.getElementById('reportDisasterForm');
        const otherInput = document.getElementById('otherDisaster');
        const disasterTypeRadios = document.querySelectorAll('input[name="disasterType"]');
        
        disasterTypeRadios.forEach(radio => {
          radio.addEventListener('change', (e) => {
            otherInput.disabled = e.target.value !== 'Other';
            if (otherInput.disabled) {
              otherInput.value = '';
              otherInput.removeAttribute('required');
            } else {
              otherInput.setAttribute('required', 'required');
            }
          });
        });
        
        form.addEventListener('submit', (e) => {
          const confirmation = document.getElementById('confirmation');
          if (!confirmation.checked) {
            e.preventDefault();
            alert('You must confirm that the information provided is accurate before submitting.');
            return false;
          }
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <h1>Report a Disaster</h1>
    
    <c:if test="${param.error == 'required'}">
      <div class="alert alert-error">All required fields must be filled.</div>
    </c:if>
    <c:if test="${param.error == 'submit'}">
      <div class="alert alert-error">An error occurred while submitting your report. Please try again.</div>
    </c:if>
    <c:if test="${param.success == 'submitted'}">
      <div class="alert alert-success">Your disaster report has been submitted successfully!</div>
    </c:if>
    
    <form id="reportDisasterForm" class="form-shell" method="post" action="${pageContext.request.contextPath}/general/disaster-reports/form" enctype="multipart/form-data">
      <div class="two-col-grid">
        <div class="form-field">
          <label for="reporterName">Reporter's Name <span style="color:red;">*</span></label>
          <input type="text" id="reporterName" name="reporterName" placeholder="Enter your name" required />
        </div>
        
        <div class="form-field">
          <label for="contactNumber">Contact Number <span style="color:red;">*</span></label>
          <input type="tel" id="contactNumber" name="contactNumber" placeholder="Enter your contact number" required />
        </div>

        <div class="form-field" style="grid-row:span 6;">
          <label>Type of Disaster <span style="color:red;">*</span></label>
          <div class="disaster-types" role="radiogroup">
            <label class="disaster-option">
              <input type="radio" name="disasterType" value="Flood" checked />
              Flood
            </label>
            <label class="disaster-option">
              <input type="radio" name="disasterType" value="Landslide" />
              Landslide
            </label>
            <label class="disaster-option">
              <input type="radio" name="disasterType" value="Fire" />
              Fire
            </label>
            <label class="disaster-option">
              <input type="radio" name="disasterType" value="Earthquake" />
              Earthquake
            </label>
            <label class="disaster-option">
              <input type="radio" name="disasterType" value="Tsunami" />
              Tsunami
            </label>
            <label class="disaster-option">
              <input type="radio" name="disasterType" value="Other" />
              Other
            </label>
          </div>
        </div>

        <div class="form-field">
          <label for="otherDisaster">If 'Other', specify</label>
          <input type="text" id="otherDisaster" name="otherDisaster" placeholder="Specify the type of disaster" disabled />
        </div>
        
        <div class="form-field">
          <label for="datetime">Date and Time of Disaster <span style="color:red;">*</span></label>
          <input type="datetime-local" id="datetime" name="datetime" required />
        </div>

        <div class="form-field">
          <label for="location">Location <span style="color:red;">*</span></label>
          <input type="text" id="location" name="location" placeholder="Enter the location of the disaster" required />
        </div>

        <div class="form-field">
          <label for="proofImage">Upload Image of Proof (Optional)</label>
          <input type="file" id="proofImage" name="proofImage" accept="image/*" />
        </div>
        
        <div class="form-field" style="grid-column:1/-1;">
          <label for="description">Additional Description (Optional)</label>
          <textarea id="description" name="description" rows="4" placeholder="Provide any additional information about the disaster"></textarea>
        </div>
      </div>

      <div class="ack">
        <input type="checkbox" id="confirmation" name="confirmation" required />
        <label for="confirmation" style="margin:0;font-weight:400;">I confirm that the information provided is accurate to the best of my knowledge. <span style="color:red;">*</span></label>
      </div>

      <div class="inline-actions">
        <button type="button" class="btn btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/general/dashboard'">Cancel</button>
        <button type="submit" class="btn btn-primary">Submit Report</button>
      </div>
    </form>
  </jsp:body>
</layout:general-user-dashboard>

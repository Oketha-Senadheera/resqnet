<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Volunteer Sign Up">
  <jsp:attribute name="styles">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/auth-pages.css" />
  </jsp:attribute>
  <jsp:body>
    <div class="signup-container">
      <h1 class="signup-heading"><c:choose><c:when test="${isUpgrade}">Upgrade to Volunteer</c:when><c:otherwise>Volunteer Registration</c:otherwise></c:choose></h1>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form id="volunteerForm" method="post" action="${pageContext.request.contextPath}${isUpgrade ? '/general/volunteer-upgrade' : '/signup/volunteer'}" novalidate>
        <div class="form-layout">
          <div class="col-left">
            <h2 class="section-title">Personal Information</h2>
            <div class="form-field">
              <label for="name">Full Name *</label>
              <input class="input" type="text" id="name" name="name" placeholder="Enter your full name" value="${not empty generalUser ? generalUser.name : ''}" required />
            </div>
            <div class="two-col-inline">
              <div class="form-field">
                <label for="age">Age</label>
                <input class="input" type="number" min="16" id="age" name="age" placeholder="Age" />
              </div>
              <div class="form-field">
                <label for="gender">Gender</label>
                <select class="input" id="gender" name="gender">
                  <option value="">Select</option>
                  <option value="male">Male</option>
                  <option value="female">Female</option>
                  <option value="other">Other</option>
                </select>
              </div>
            </div>
            <div class="form-field">
              <label for="contactNumber">Contact Number</label>
              <input class="input" type="tel" id="contactNumber" name="contactNumber" placeholder="Enter your contact number" value="${not empty generalUser ? generalUser.contactNumber : ''}" />
            </div>
            
            <h2 class="section-title">Address</h2>
            <div class="form-field">
              <label for="houseNo">House No</label>
              <input class="input" type="text" id="houseNo" name="houseNo" placeholder="House number" value="${not empty generalUser ? generalUser.houseNo : ''}" />
            </div>
            <div class="form-field">
              <label for="street">Street</label>
              <input class="input" type="text" id="street" name="street" placeholder="Street name" value="${not empty generalUser ? generalUser.street : ''}" />
            </div>
            <div class="form-field">
              <label for="city">City</label>
              <input class="input" type="text" id="city" name="city" placeholder="City" value="${not empty generalUser ? generalUser.city : ''}" />
            </div>
            <div class="form-field">
              <label for="district">District</label>
              <select class="input" id="district" name="district">
                <option value="">Select district</option>
                <option value="Colombo" ${not empty generalUser && generalUser.district == 'Colombo' ? 'selected' : ''}>Colombo</option>
                <option value="Gampaha" ${not empty generalUser && generalUser.district == 'Gampaha' ? 'selected' : ''}>Gampaha</option>
                <option value="Kalutara" ${not empty generalUser && generalUser.district == 'Kalutara' ? 'selected' : ''}>Kalutara</option>
                <option value="Kandy" ${not empty generalUser && generalUser.district == 'Kandy' ? 'selected' : ''}>Kandy</option>
                <option value="Galle" ${not empty generalUser && generalUser.district == 'Galle' ? 'selected' : ''}>Galle</option>
                <option value="Matara" ${not empty generalUser && generalUser.district == 'Matara' ? 'selected' : ''}>Matara</option>
              </select>
            </div>
            <div class="form-field">
              <label for="gnDivision">Grama Niladhari Division</label>
              <input class="input" type="text" id="gnDivision" name="gnDivision" placeholder="GN Division" value="${not empty generalUser ? generalUser.gnDivision : ''}" />
            </div>
          </div>

          <div class="col-right">
            <h2 class="section-title">Volunteer Preferences</h2>
            <div class="checkbox-group">
              <label><input type="checkbox" name="preferences" value="Search & Rescue" /> Search & Rescue</label>
              <label><input type="checkbox" name="preferences" value="Medical Aid" /> Medical Aid</label>
              <label><input type="checkbox" name="preferences" value="Logistics Support" /> Logistics Support</label>
              <label><input type="checkbox" name="preferences" value="Technical Support" /> Technical Support</label>
              <label><input type="checkbox" name="preferences" value="Shelter Management" /> Shelter Management</label>
              <label><input type="checkbox" name="preferences" value="Food Distribution" /> Food Distribution</label>
              <label><input type="checkbox" name="preferences" value="Childcare Support" /> Childcare Support</label>
              <label><input type="checkbox" name="preferences" value="Elderly Assistance" /> Elderly Assistance</label>
            </div>
            
            <h2 class="section-title">Specialized Skills</h2>
            <div class="checkbox-group">
              <label><input type="checkbox" name="skills" value="First Aid Certified" /> First Aid Certified</label>
              <label><input type="checkbox" name="skills" value="Medical Professional" /> Medical Professional</label>
              <label><input type="checkbox" name="skills" value="Firefighting" /> Firefighting</label>
              <label><input type="checkbox" name="skills" value="Swimming / Lifesaving" /> Swimming / Lifesaving</label>
              <label><input type="checkbox" name="skills" value="Rescue & Handling" /> Rescue & Handling</label>
              <label><input type="checkbox" name="skills" value="Disaster Management Training" /> Disaster Management Training</label>
            </div>
            
            <c:if test="${!isUpgrade}">
              <h2 class="section-title">Account Details</h2>
              <div class="form-field">
                <label for="username">Username *</label>
                <input class="input" type="text" id="username" name="username" placeholder="Choose a username" required />
              </div>
              <div class="form-field">
                <label for="email">Email *</label>
                <input class="input" type="email" id="email" name="email" placeholder="Enter your email" required />
              </div>
              <div class="form-field">
                <label for="password">Password *</label>
                <input class="input" type="password" id="password" name="password" placeholder="Create a password" minlength="6" required />
              </div>
              <div class="form-field">
                <label for="confirmPassword">Confirm Password *</label>
                <input class="input" type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required />
              </div>
            </c:if>
          </div>
        </div>

        <div class="form-actions">
          <a href="${pageContext.request.contextPath}${isUpgrade ? '/general/dashboard' : '/signup'}" class="btn">Back</a>
          <button type="submit" class="btn btn-primary">${isUpgrade ? 'Upgrade to Volunteer' : 'Register'}</button>
        </div>
      </form>
    </div>
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if (window.lucide) lucide.createIcons();
        
        const form = document.getElementById('volunteerForm');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');

        form.addEventListener('submit', (e) => {
          // Only validate passwords if they exist (i.e., not an upgrade)
          if (password && confirmPassword && password.value !== confirmPassword.value) {
            e.preventDefault();
            alert('Passwords do not match!');
            confirmPassword.focus();
            return false;
          }
        });
      });
    </script>
  </jsp:body>
</layout:auth>

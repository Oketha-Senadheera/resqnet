<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:auth title="Volunteer Sign Up">
  <jsp:attribute name="styles">
    <style>
      .signup-container {
        max-width: 1080px;
        margin: 0 auto;
        padding: 2rem clamp(1rem,3vw,2.5rem) 4rem;
      }
      .signup-heading {
        margin: 0 0 1rem;
        font-size: clamp(1.55rem, 2.3vw, 1.9rem);
        font-weight: 600;
      }
      .form-layout {
        display: grid;
        gap: 2.5rem;
        grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
        margin-bottom: 2rem;
      }
      .section-title {
        font-size: var(--font-size-sm);
        font-weight: 600;
        margin: 1.5rem 0 1rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      .section-title:first-child {
        margin-top: 0;
      }
      .two-col-inline {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
      }
      .checkbox-group {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
      }
      .checkbox-group label {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: var(--font-size-sm);
      }
      .form-actions {
        margin-top: 1rem;
        display: flex;
        gap: 1rem;
      }
      .error-message {
        color: var(--color-danger);
        background: rgba(215, 48, 47, 0.1);
        padding: 0.75rem 1rem;
        border-radius: var(--radius-sm);
        margin-bottom: 1.5rem;
        font-size: var(--font-size-sm);
      }
    </style>
  </jsp:attribute>
  <jsp:body>
    <div class="signup-container">
      <h1 class="signup-heading">Volunteer Registration</h1>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form id="volunteerForm" method="post" action="${pageContext.request.contextPath}/signup/volunteer" novalidate>
        <div class="form-layout">
          <div class="col-left">
            <h2 class="section-title">Personal Information</h2>
            <div class="form-field">
              <label for="name">Full Name *</label>
              <input class="input" type="text" id="name" name="name" placeholder="Enter your full name" required />
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
              <input class="input" type="tel" id="contactNumber" name="contactNumber" placeholder="Enter your contact number" />
            </div>
            
            <h2 class="section-title">Address</h2>
            <div class="form-field">
              <label for="houseNo">House No</label>
              <input class="input" type="text" id="houseNo" name="houseNo" placeholder="House number" />
            </div>
            <div class="form-field">
              <label for="street">Street</label>
              <input class="input" type="text" id="street" name="street" placeholder="Street name" />
            </div>
            <div class="form-field">
              <label for="city">City</label>
              <input class="input" type="text" id="city" name="city" placeholder="City" />
            </div>
            <div class="form-field">
              <label for="district">District</label>
              <select class="input" id="district" name="district">
                <option value="">Select district</option>
                <option value="Colombo">Colombo</option>
                <option value="Gampaha">Gampaha</option>
                <option value="Kalutara">Kalutara</option>
                <option value="Kandy">Kandy</option>
                <option value="Galle">Galle</option>
                <option value="Matara">Matara</option>
              </select>
            </div>
            <div class="form-field">
              <label for="gnDivision">Grama Niladhari Division</label>
              <input class="input" type="text" id="gnDivision" name="gnDivision" placeholder="GN Division" />
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
          </div>
        </div>

        <div class="form-actions">
          <a href="${pageContext.request.contextPath}/signup" class="btn">Back</a>
          <button type="submit" class="btn btn-primary">Register</button>
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
          if (password.value !== confirmPassword.value) {
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

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>General User Sign Up – ResQnet</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/core.css" />
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/assets/img/logo.svg" />
    <script src="https://unpkg.com/lucide@latest" defer></script>
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
      .signup-subheading {
        margin: 0 0 2.5rem;
        font-size: var(--font-size-sm);
        color: var(--color-text-subtle);
      }
      .form-sections {
        display: grid;
        gap: 2.5rem;
        grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
        margin-bottom: 2rem;
      }
      .form-section h2 {
        font-size: var(--font-size-sm);
        font-weight: 600;
        margin: 0 0 1.5rem;
        text-transform: uppercase;
        letter-spacing: 0.5px;
      }
      .form-actions {
        margin-top: 1rem;
        display: flex;
        gap: 1rem;
        align-items: center;
      }
      .form-actions .btn {
        flex: 1;
        min-width: 180px;
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
  </head>
  <body>
    <header class="site-header" role="banner">
      <div class="site-header__inner">
        <a href="${pageContext.request.contextPath}/" class="brand-inline">
          <img src="${pageContext.request.contextPath}/static/assets/img/logo.svg" alt="ResQnet logo" />
          <span>ResQnet</span>
        </a>
        <nav class="primary-nav" aria-label="Primary navigation"></nav>
        <div class="header-actions">
          <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Login</a>
        </div>
      </div>
    </header>

    <main class="signup-container" id="mainContent" tabindex="-1">
      <h1 class="signup-heading">General User Sign Up</h1>
      <p class="signup-subheading">
        Create your account to access disaster response resources
      </p>
      
      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>
      
      <form id="signupForm" method="post" action="${pageContext.request.contextPath}/signup/general" novalidate>
        <div class="form-sections">
          <section class="form-section" aria-labelledby="personalInfoHeading">
            <h2 id="personalInfoHeading">Personal Information</h2>
            <div class="form-field">
              <label for="name">Full Name *</label>
              <input
                id="name"
                name="name"
                type="text"
                class="input"
                placeholder="Enter your full name"
                required
              />
            </div>
            <div class="form-field">
              <label for="contactNumber">Contact Number</label>
              <input
                id="contactNumber"
                name="contactNumber"
                type="tel"
                class="input"
                placeholder="Enter your contact number"
              />
            </div>
            <div class="form-field">
              <label for="username">Username *</label>
              <input
                id="username"
                name="username"
                type="text"
                class="input"
                placeholder="Choose a username"
                minlength="3"
                required
              />
            </div>
            <div class="form-field">
              <label for="email">Email *</label>
              <input
                id="email"
                name="email"
                type="email"
                class="input"
                placeholder="Enter your email address"
                required
              />
            </div>
            <div class="form-field">
              <label for="password">Password *</label>
              <input
                id="password"
                name="password"
                type="password"
                class="input"
                placeholder="Create a password (min 6 characters)"
                minlength="6"
                required
              />
            </div>
            <div class="form-field">
              <label for="confirmPassword">Confirm Password *</label>
              <input
                id="confirmPassword"
                name="confirmPassword"
                type="password"
                class="input"
                placeholder="Confirm your password"
                minlength="6"
                required
              />
            </div>
          </section>

          <section class="form-section" aria-labelledby="addressInfoHeading">
            <h2 id="addressInfoHeading">Address</h2>
            <div class="form-field">
              <label for="houseNo">House No</label>
              <input
                id="houseNo"
                name="houseNo"
                type="text"
                class="input"
                placeholder="Enter your house number"
              />
            </div>
            <div class="form-field">
              <label for="street">Street</label>
              <input
                id="street"
                name="street"
                type="text"
                class="input"
                placeholder="Enter your street name"
              />
            </div>
            <div class="form-field">
              <label for="city">City</label>
              <input
                id="city"
                name="city"
                type="text"
                class="input"
                placeholder="Enter your city"
              />
            </div>
            <div class="form-field">
              <label for="district">District</label>
              <select id="district" name="district" class="input">
                <option value="">Select your district</option>
                <option value="Colombo">Colombo</option>
                <option value="Gampaha">Gampaha</option>
                <option value="Kalutara">Kalutara</option>
                <option value="Kandy">Kandy</option>
                <option value="Galle">Galle</option>
                <option value="Matara">Matara</option>
                <option value="Hambantota">Hambantota</option>
                <option value="Jaffna">Jaffna</option>
                <option value="Kilinochchi">Kilinochchi</option>
                <option value="Mannar">Mannar</option>
                <option value="Mullaitivu">Mullaitivu</option>
                <option value="Vavuniya">Vavuniya</option>
                <option value="Puttalam">Puttalam</option>
                <option value="Kurunegala">Kurunegala</option>
                <option value="Anuradhapura">Anuradhapura</option>
                <option value="Polonnaruwa">Polonnaruwa</option>
                <option value="Badulla">Badulla</option>
                <option value="Monaragala">Monaragala</option>
                <option value="Ratnapura">Ratnapura</option>
                <option value="Kegalle">Kegalle</option>
                <option value="Ampara">Ampara</option>
                <option value="Trincomalee">Trincomalee</option>
                <option value="Batticaloa">Batticaloa</option>
                <option value="Nuwara Eliya">Nuwara Eliya</option>
                <option value="Matale">Matale</option>
              </select>
            </div>
            <div class="form-field">
              <label for="gnDivision">Grama Niladhari Division</label>
              <input
                id="gnDivision"
                name="gnDivision"
                type="text"
                class="input"
                placeholder="Enter your GN Division"
              />
            </div>
            <div class="form-field">
              <label class="checkbox-label">
                <input type="checkbox" name="smsAlert" id="smsAlert" />
                Enable SMS Alerts for Disasters
              </label>
            </div>
          </section>
        </div>

        <div class="form-actions">
          <a
            href="${pageContext.request.contextPath}/signup"
            class="btn"
            >Back</a>
          <button type="submit" class="btn btn-primary">
            Sign Up
          </button>
        </div>
      </form>
    </main>

    <script>
      document.addEventListener("DOMContentLoaded", () => {
        if (window.lucide) window.lucide.createIcons();
        
        const form = document.getElementById("signupForm");
        const password = document.getElementById("password");
        const confirmPassword = document.getElementById("confirmPassword");

        form.addEventListener("submit", (e) => {
          if (password.value !== confirmPassword.value) {
            e.preventDefault();
            alert("Passwords do not match!");
            confirmPassword.focus();
            return false;
          }
        });
      });
    </script>
  </body>
</html>

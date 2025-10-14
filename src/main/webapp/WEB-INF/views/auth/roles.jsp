<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>Choose Your Role – ResQnet</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/core.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/roles.css" />
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/static/assets/img/logo.svg" />
    <script src="https://unpkg.com/lucide@latest" defer></script>
  </head>
  <body>
    <main class="role-layout" id="mainContent" tabindex="-1">
      <header class="role-heading-wrap">
        <h1>Choose your role</h1>
        <p>Select the role that best describes you to get started.</p>
      </header>

      <section class="choice-grid" aria-label="Available roles">
        <article class="choice-card" data-role="user">
          <div class="choice-icon"><i data-lucide="user"></i></div>
          <div class="choice-body">
            <h2>General User</h2>
            <p>
              Individuals seeking assistance or resources during a disaster.
            </p>
          </div>
          <div class="choice-actions">
            <a href="${pageContext.request.contextPath}/signup/general" class="btn btn-primary">Sign Up</a>
          </div>
        </article>
        <article class="choice-card" data-role="ngo">
          <div class="choice-icon"><i data-lucide="building"></i></div>
          <div class="choice-body">
            <h2>NGO</h2>
            <p>
              Organizations providing aid and support to affected communities.
            </p>
          </div>
          <div class="choice-actions">
            <a href="${pageContext.request.contextPath}/signup/ngo" class="btn btn-primary">Sign Up</a>
          </div>
        </article>
        <article class="choice-card" data-role="volunteer">
          <div class="choice-icon"><i data-lucide="users"></i></div>
          <div class="choice-body">
            <h2>Volunteer</h2>
            <p>
              Individuals offering their time and skills to support relief
              efforts.
            </p>
          </div>
          <div class="choice-actions">
            <a href="${pageContext.request.contextPath}/signup/volunteer" class="btn btn-primary">Sign Up</a>
          </div>
        </article>
      </section>
      
      <div style="text-align: center; margin-top: 2rem;">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/login" style="color: var(--color-accent);">Login</a></p>
      </div>
    </main>

    <script>
      document.addEventListener("DOMContentLoaded", () => {
        if (window.lucide) {
          window.lucide.createIcons();
        }
      });
    </script>
  </body>
</html>

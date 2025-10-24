<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - General Public Overview" activePage="forum">

<jsp:body>

    <style>
      .page-head { display:flex; align-items:center; justify-content:space-between; gap:1rem; }
      .subtitle { color:#777; margin:.35rem 0 1.2rem; }
      .create-post { padding:10px 16px; font-weight:700; }
      .forum-grid { display:grid; grid-template-columns: repeat(auto-fit, minmax(260px,1fr)); gap:1.25rem; }
      .post-card { background:#fff; border:1px solid var(--color-border); border-radius: var(--radius-lg); overflow:hidden; display:flex; flex-direction:column; }
      .post-card img { width:100%; height:170px; object-fit:cover; display:block; }
      .post-body { padding:0.9rem 1rem 1.1rem; }
      .post-title { margin:0 0 .4rem; font-size:.95rem; font-weight:700; }
      .post-desc { margin:0; font-size:.8rem; color:#666; line-height:1.4; }
    </style>
<main class="content" id="mainContent" tabindex="-1">
        <div class="page-head">
          <div>
            <h1 class="mt-0" style="margin:0; font-size:1.75rem;">Community Forum</h1>
            <p class="subtitle">Stay connected with your community during this time.</p>
          </div>
          <button id="createPostBtn" class="btn btn-primary create-post">Create a Post</button>
        </div>

        <section class="forum-grid" aria-label="Forum Posts">
          <a class="post-card" href="#">
            <img src="https://picsum.photos/seed/safety/640/360" alt="Post image" />
            <div class="post-body">
              <h3 class="post-title">Safety Tips During a Flood</h3>
              <p class="post-desc">Learn essential safety measures to protect yourself and your family during a flood.</p>
            </div>
          </a>
          <a class="post-card" href="#">
            <img src="https://picsum.photos/seed/shelter/640/360" alt="Post image" />
            <div class="post-body">
              <h3 class="post-title">Emergency Shelter Locations</h3>
              <p class="post-desc">Find the nearest emergency shelter providing temporary housing and support.</p>
            </div>
          </a>
          <a class="post-card" href="#">
            <img src="https://picsum.photos/seed/firstaid/640/360" alt="Post image" />
            <div class="post-body">
              <h3 class="post-title">First Aid Basics</h3>
              <p class="post-desc">Learn basic first aid techniques to help those in need until professional help arrives.</p>
            </div>
          </a>

          <a class="post-card" href="#">
            <img src="https://picsum.photos/seed/safety2/640/360" alt="Post image" />
            <div class="post-body">
              <h3 class="post-title">Safety Tips During a Flood</h3>
              <p class="post-desc">Learn essential safety measures to protect yourself and your family during a flood.</p>
            </div>
          </a>
          <a class="post-card" href="#">
            <img src="https://picsum.photos/seed/shelter2/640/360" alt="Post image" />
            <div class="post-body">
              <h3 class="post-title">Emergency Shelter Locations</h3>
              <p class="post-desc">Find the nearest emergency shelter providing temporary housing and support.</p>
            </div>
          </a>
          <a class="post-card" href="#">
            <img src="https://picsum.photos/seed/firstaid2/640/360" alt="Post image" />
            <div class="post-body">
              <h3 class="post-title">First Aid Basics</h3>
              <p class="post-desc">Learn basic first aid techniques to help those in need until professional help arrives.</p>
            </div>
          </a>
        </section>
      </main>

<script>
      if (window.lucide) lucide.createIcons();

      // Sidebar routing
      document.querySelectorAll('.nav-item').forEach((btn) => {
        btn.addEventListener('click', () => {
          const s = btn.getAttribute('data-section');
          switch (s) {
            case 'overview': location.href = 'public-overview.html'; break;
            case 'forecast': location.href = 'forecast-dashboard.html'; break;
            case 'make-donation': location.href = 'make-donation.html'; break;
            case 'request-donation': location.href = 'request-donation.html'; break;
            case 'report-disaster': location.href = 'report-disaster.html'; break;
            case 'be-volunteer': location.href = 'be-volunteer.html'; break;
            case 'forum': location.href = 'community-forum.html'; break;
            case 'profile-settings': location.href = 'profile-settings.html'; break;
          }
        });
      });

      // Create Post action (placeholder)
      document.getElementById('createPostBtn').addEventListener('click', () => {
        alert('Post creation coming soon!');
      });

      // Logout
      document.querySelector('.logout').addEventListener('click', () => {
        if (confirm('Are you sure you want to logout?')) location.href = 'login.html';
      });
    </script>

</jsp:body>


</layout:grama-niladhari-dashboard>




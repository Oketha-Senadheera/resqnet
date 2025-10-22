<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:general-user-dashboard pageTitle="ResQnet - General Public Overview" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      .safe-section { 
        display: grid; 
        grid-template-columns: 1fr 1.2fr; 
        gap: 1.5rem; 
        align-items: start; 
      }
      .safe-list { 
        display: flex; 
        flex-direction: column; 
        gap: 0.75rem; 
      }
      .safe-item { 
        background: #f6f6f6; 
        border: 1px solid var(--color-border); 
        border-radius: var(--radius-md); 
        padding: 0.9rem 1rem; 
      }
      .safe-item .name { 
        font-weight: 600; 
        font-size: 0.9rem;
        margin-bottom: 0.25rem; 
      }
      .safe-item .coords {
        font-size: 0.75rem;
        color: #666;
      }
      .map-shell { 
        position: relative; 
        border: 1px solid var(--color-border); 
        border-radius: var(--radius-md); 
        overflow: hidden; 
        min-height: 340px; 
        background: #eaeaea; 
      }
      .map-toolbar { 
        position: absolute; 
        right: 0.75rem; 
        top: 0.75rem; 
        background: #fff; 
        border: 1px solid var(--color-border); 
        border-radius: 999px; 
        padding: 0.25rem; 
        display: flex; 
        gap: 0.25rem; 
      }
      .map-search { 
        position: absolute; 
        left: 0.75rem; 
        top: 0.75rem; 
        background: #fff; 
        border: 1px solid var(--color-border); 
        border-radius: 999px; 
        padding: 0.35rem 0.6rem; 
        display: flex; 
        align-items: center; 
        gap: 0.4rem; 
      }
      .map-iframe-holder { 
        width: 100%; 
        height: 100%; 
      }
      @media (max-width: 980px) { 
        .safe-section { 
          grid-template-columns: 1fr; 
        } 
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        if(window.lucide) lucide.createIcons();
        const list=[
          { name:'Central Park', coords:'40.7128° N, 74.0060° W' },
          { name:'Griffith Observatory', coords:'34.0522° N, 118.2437° W' },
          { name:'Eiffel Tower', coords:'48.8566° N, 2.3522° E' },
          { name:'Golden Gate Park', coords:'37.7749° N, 122.4194° W' }
        ];
        const wrap=document.getElementById('safeList'); const tmpl=document.getElementById('safe-item-tmpl');
        list.forEach(item=>{ const node=tmpl.content.firstElementChild.cloneNode(true); node.querySelector('.name').textContent=item.name; node.querySelector('.coords').textContent=item.coords; wrap.appendChild(node); });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <section class="welcome">
      <h1>Welcome ${not empty displayName ? displayName : sessionScope.authUser.email}!</h1>
      <div class="alert info">
        <span class="alert-icon" data-lucide="alert-triangle"></span>
        <p>Heavy Rainfall Warning in Gampaha District – Next 48 Hours</p>
      </div>
    </section>
    
    <section class="quick">
      <div class="quick-actions">
        <button class="action-card" data-goto="make-donation.html">
          <div class="action-icon"><i data-lucide="gift"></i></div>
          <span>Make a Donation</span>
        </button>
        <button class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/general/donation-requests/form'">
          <div class="action-icon"><i data-lucide="package-plus"></i></div>
          <span>Request a Donation</span>
        </button>
        <button class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/general/disaster-reports/form'">
          <div class="action-icon"><i data-lucide="alert-octagon"></i></div>
          <span>Report a Disaster</span>
        </button>
        <button class="action-card" onclick="window.location.href='${pageContext.request.contextPath}/general/be-volunteer'">
          <div class="action-icon"><i data-lucide="user-plus"></i></div>
          <span>Be a Volunteer</span>
        </button>
      </div>
    </section>
    
    <section class="safe-section" aria-labelledby="safeHeading">
      <div>
        <h2 id="safeHeading" style="margin: 0 0 0.8rem; font-size: 1.1rem; font-weight: 600;">Safe Locations</h2>
        <div class="safe-list" id="safeList"></div>
      </div>
      <div>
        <div class="map-shell">
          <div class="map-search">
            <i data-lucide="search" style="width: 16px; height: 16px;"></i>
            <span style="font-size: 0.7rem; color: #666;">Search</span>
          </div>
          <div class="map-toolbar">
            <button class="btn btn-icon" aria-label="Zoom In"><i data-lucide="plus"></i></button>
            <button class="btn btn-icon" aria-label="Zoom Out"><i data-lucide="minus"></i></button>
          </div>
          <div class="map-iframe-holder" id="mapHolder"></div>
        </div>
      </div>
    </section>

    <template id="safe-item-tmpl">
      <div class="safe-item"><div class="name"></div><div class="coords"></div></div>
    </template>
  </jsp:body>
</layout:general-user-dashboard>

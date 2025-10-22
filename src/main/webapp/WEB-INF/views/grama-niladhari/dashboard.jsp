<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags/layouts" %>
<layout:grama-niladhari-dashboard pageTitle="ResQnet - Grama Niladari Dashboard" activePage="overview">
  <jsp:attribute name="styles">
    <style>
      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 1.25rem;
        margin-bottom: 2.5rem;
      }
      .stat-card {
        background: #fff;
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: 1.5rem 1.25rem;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
      }
      .stat-label {
        font-size: 0.8rem;
        color: #555;
        font-weight: 500;
      }
      .stat-value {
        font-size: 2rem;
        font-weight: 700;
        color: var(--color-text);
      }
      .safe-locations-section {
        background: #fff;
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: 1.5rem;
        margin-bottom: 2.5rem;
      }
      .safe-locations-section h2 {
        margin: 0 0 1.25rem;
        font-size: 1.15rem;
        font-weight: 600;
      }
      .locations-container {
        display: grid;
        grid-template-columns: 1fr 1.2fr;
        gap: 1.5rem;
      }
      .locations-list {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
      }
      .update-btn {
        all: unset;
        cursor: pointer;
        background: var(--color-accent);
        color: #000;
        font-weight: 600;
        font-size: 0.85rem;
        padding: 0.7rem 1.5rem;
        border-radius: 999px;
        text-align: center;
        margin-bottom: 1rem;
        transition: background-color var(--transition);
        display: block;
      }
      .update-btn:hover {
        background: var(--color-accent-hover);
      }
      .location-item {
        background: var(--color-surface);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        padding: 0.9rem 1rem;
      }
      .location-name {
        font-size: 0.9rem;
        font-weight: 600;
        margin-bottom: 0.3rem;
      }
      .location-coords {
        font-size: 0.75rem;
        color: #666;
      }
      .map-container {
        background: var(--color-surface);
        border: 1px solid var(--color-border);
        border-radius: var(--radius-md);
        min-height: 350px;
        overflow: hidden;
        position: relative;
      }
      .map-container iframe {
        width: 100%;
        height: 100%;
        border: 0;
        display: block;
      }
      .reports-section {
        background: #fff;
        border: 1px solid var(--color-border);
        border-radius: var(--radius-lg);
        padding: 1.5rem;
      }
      .reports-section h2 {
        margin: 0 0 1.25rem;
        font-size: 1.15rem;
        font-weight: 600;
      }
      .reports-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 0.85rem;
      }
      .reports-table thead {
        background: var(--color-surface);
      }
      .reports-table th {
        text-align: left;
        padding: 0.85rem 1rem;
        font-weight: 600;
        font-size: 0.8rem;
        color: #555;
        border-bottom: 1px solid var(--color-border);
      }
      .reports-table td {
        padding: 1rem;
        border-bottom: 1px solid var(--color-border);
      }
      .reports-table tbody tr:last-child td {
        border-bottom: none;
      }
      .reports-table tbody tr:hover {
        background: var(--color-surface);
      }
      .location-link {
        color: #4a90e2;
        text-decoration: none;
      }
      .location-link:hover {
        text-decoration: underline;
      }
      .severity-high {
        color: var(--color-accent-2);
        font-weight: 600;
      }
      .status-pending {
        color: #f59e0b;
        font-weight: 500;
      }
      @media (max-width: 768px) {
        .locations-container {
          grid-template-columns: 1fr;
        }
        .stats-grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </jsp:attribute>
  <jsp:attribute name="scripts">
    <script>
      document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', function() {
          document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
          this.classList.add('active');
        });
      });
    </script>
  </jsp:attribute>
  <jsp:body>
    <section class="welcome">
  <h1>Welcome ${not empty displayName ? displayName : sessionScope.authUser.email}!</h1>
    </section>

        <section class="stats-grid" aria-label="Dashboard Statistics">
          <div class="stat-card">
            <div class="stat-label">Pending Donation Requests</div>
            <div class="stat-value">12</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Safe Locations in Division</div>
            <div class="stat-value">45</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Disaster Reports</div>
            <div class="stat-value">8</div>
          </div>
        </section>

        <section class="safe-locations-section" aria-label="Safe Locations">
          <h2>Safe Locations</h2>
          <div class="locations-container">
            <div class="locations-list">
              <button class="update-btn">Update Details</button>
              
              <div class="location-item">
                <div class="location-name">Central Park</div>
                <div class="location-coords">40.7128° N, 74.0060° W</div>
              </div>
              
              <div class="location-item">
                <div class="location-name">Griffith Observatory</div>
                <div class="location-coords">34.1522° N, 118.2437° W</div>
              </div>
              
              <div class="location-item">
                <div class="location-name">Eifel Tower</div>
                <div class="location-coords">48.8566° N, 2.3522° E</div>
              </div>
              
              <div class="location-item">
                <div class="location-name">Golden Gate Park</div>
                <div class="location-coords">37.7749° N, 122.4194° W</div>
              </div>
            </div>
            
            <div class="map-container">
              <iframe 
                src="https://www.openstreetmap.org/export/embed.html?bbox=-74.0170%2C40.7000%2C-73.9950%2C40.7250&layer=mapnik&marker=40.7128%2C-74.0060" 
                style="border: 0;" 
                allowfullscreen="" 
                loading="lazy" 
                referrerpolicy="no-referrer-when-downgrade">
              </iframe>
            </div>
          </div>
        </section>

        <section class="reports-section" aria-label="Real-time Disaster Reports">
          <h2>Real-time Disaster Reports</h2>
          <table class="reports-table">
            <thead>
              <tr>
                <th>Report ID</th>
                <th>Location</th>
                <th>Type</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>#DR2024-001</td>
                <td><a href="#" class="location-link">Colombo</a></td>
                <td><span class="severity-high">High</span></td>
                <td><span class="status-pending">Pending</span></td>
              </tr>
              <tr>
                <td>#DR2024-001</td>
                <td><a href="#" class="location-link">Colombo</a></td>
                <td><span class="severity-high">High</span></td>
                <td><span class="status-pending">Pending</span></td>
              </tr>
              <tr>
                <td>#DR2024-001</td>
                <td><a href="#" class="location-link">Colombo</a></td>
                <td><span class="severity-high">High</span></td>
                <td><span class="status-pending">Pending</span></td>
              </tr>
            </tbody>
          </table>
        </section>
  </jsp:body>
</layout:grama-niladhari-dashboard>

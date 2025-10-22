<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Community</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <script
      src="https://unpkg.com/lucide@latest"
      defer
      onload="window.lucide && window.lucide.createIcons()"
    ></script>
    <style>
      :root {
        --bg: #f6f7fb;
        --surface: #fff;
        --text: #121212;
        --muted: #65728a;
        --border: #e6e8ef;
        --accent: #a4e2ff;
        --accent2: #eaeefc;
      }
      * {
        box-sizing: border-box;
      }
      body {
        margin: 0;
        font-family: "Plus Jakarta Sans", system-ui, -apple-system, Segoe UI,
          Roboto, Arial, sans-serif;
        background: var(--bg);
        color: var(--text);
      }
      .layout {
        display: grid;
        grid-template-columns: 240px 1fr;
        min-height: 100vh;
      }
      .sidebar {
        background: #ffffff;
        border-right: 1px solid var(--border);
        padding: 14px;
      }
      .user {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 8px;
        border-radius: 12px;
      }
      .user .avatar {
        width: 36px;
        height: 36px;
        background: #ddd;
        border-radius: 50%;
      }
      .menu a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 12px;
        border-radius: 10px;
        color: #1e293b;
        text-decoration: none;
        font-weight: 600;
      }
      .menu a.active,
      .menu a:hover {
        background: var(--accent2);
      }
      .content {
        padding: 28px;
      }
      .card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 16px;
      }
      .container {
        max-width: 1060px;
        margin: 0 auto;
      }
      .crumbs {
        font-size: 12px;
        color: #667085;
        margin-bottom: 14px;
      }
      .page {
        padding: 18px 20px;
      }
      .tabs {
        display: flex;
        gap: 24px;
        border-bottom: 1px solid var(--border);
        padding: 0 4px;
      }
      .tab {
        padding: 12px 0;
        font-size: 13px;
        font-weight: 700;
        color: #667085;
        cursor: pointer;
        position: relative;
      }
      .tab.active {
        color: #000;
      }
      .tab.active::after {
        content: "";
        position: absolute;
        left: 0;
        bottom: -1px;
        width: 100%;
        height: 2px;
        background: #4f46e5;
      }
      .list {
        padding: 16px 20px;
        display: grid;
        gap: 18px;
      }
      .post {
        padding: 14px 12px;
        border: 1px solid var(--border);
        border-radius: 14px;
        background: #fff;
      }
      .post .meta {
        display: flex;
        align-items: center;
        gap: 10px;
        color: #667085;
        font-size: 12px;
      }
      .post .body {
        margin-top: 8px;
        font-size: 13px;
      }
      .actions {
        display: flex;
        gap: 14px;
        margin-top: 10px;
        color: #667085;
        font-size: 12px;
      }
      .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 16px 20px;
      }
      .btn {
        all: unset;
        background: #6ee7b7;
        color: #043d29;
        font-weight: 800;
        padding: 10px 14px;
        border-radius: 999px;
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <div class="layout">
      <aside class="sidebar">
        <div class="user">
          <div class="avatar"></div>
          <div>
            <div style="font-weight: 800">Sophia</div>
            <div style="font-size: 12px; color: #667085">Student</div>
          </div>
        </div>
        <nav class="menu">
          <a href="#" class="active"
            ><span data-lucide="layout-dashboard"></span> Dashboard</a
          >
          <a href="#"><span data-lucide="book-open"></span> My Subjects</a>
          <a href="#"><span data-lucide="users"></span> Kuppi Sessions</a>
          <a href="#"><span data-lucide="folder"></span> My Resources</a>
          <a href="#"><span data-lucide="activity"></span> Progress Analysis</a>
          <a href="#"><span data-lucide="messages-square"></span> Community</a>
          <a href="#"><span data-lucide="user"></span> Profile Settings</a>
          <a href="#"><span data-lucide="log-out"></span> Logout</a>
        </nav>
      </aside>
      <main class="content">
        <div class="container">
          <div class="crumbs">Home / Community</div>
          <div class="card">
            <div class="header">
              <h1 style="margin: 0; font-size: 22px">Community</h1>
              <button class="btn">New Post</button>
            </div>
            <div class="page">
              <div style="color: #667085; font-size: 12px; margin-bottom: 12px">
                Stay updated with the latest discussions and resources from your
                peers.
              </div>
              <div class="tabs">
                <div class="tab active">Most Upvoted</div>
                <div class="tab">Most Recent</div>
                <div class="tab">Unanswered</div>
              </div>
              <div class="list">
                <article class="post">
                  <div class="meta">
                    <span data-lucide="user"></span> Sophia Clark • 2d ago
                  </div>
                  <div class="body">
                    I'm having trouble understanding recursion in the
                    programming module. Can anyone explain it in simpler terms?
                  </div>
                  <div class="actions">
                    <span><span data-lucide="thumbs-up"></span> 12</span>
                    <span><span data-lucide="message-circle"></span> 3</span>
                  </div>
                </article>
                <article class="post">
                  <div class="meta">
                    <span data-lucide="user"></span> Noah Thompson • 3d ago
                  </div>
                  <div class="body">
                    Has anyone found a good resource for learning about data
                    structures? I'm struggling with linked lists.
                  </div>
                </article>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  </body>
</html>

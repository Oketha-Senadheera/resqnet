package com.resqnet.controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import java.io.IOException;

/**
 * Demo servlet to serve plain jsp files via simple GET routing.
 *
 * Usage:
 *   - Place your .jsp files under /WEB-INF/demo
 *   - Access them at /demo/<name>, e.g., /demo/community -> /WEB-INF/demo/community.jsp
 *   - /demo or /demo/ maps to /WEB-INF/demo/index.jsp
 */
@WebServlet(urlPatterns = { "demo/*" })
public class DemoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo(); // part after /demo
        if (path == null || "/".equals(path)) {
            path = "/index.jsp";
        }
        // Ensure .jsp suffix
        if (!path.endsWith(".jsp")) {
            path = path + ".jsp";
        }
        // Normalize: prevent path traversal
        path = path.replace("..", "");

        String resourcePath = "/WEB-INF/demo" + path;
        ServletContext ctx = getServletContext();

        // Check existence using getResource (null when not found)
        try {
            if (ctx.getResource(resourcePath) == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.setContentType("text/plain;charset=UTF-8");
                resp.getWriter().println("404 Not Found: " + resourcePath);
                return;
            }
        } catch (Exception ignore) {
            // Fallback to forward; container will handle 404 if missing
        }

        RequestDispatcher rd = ctx.getRequestDispatcher(resourcePath);
        if (rd != null) {
            rd.forward(req, resp);
        } else {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.setContentType("text/plain;charset=UTF-8");
            resp.getWriter().println("404 Not Found: " + resourcePath);
        }
    }
}

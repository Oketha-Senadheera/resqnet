package com.resqnet.controller;

import com.resqnet.model.Role;
import com.resqnet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {
    "/dashboard",
    "/dashboard/general",
    "/dashboard/volunteer",
    "/dashboard/ngo",
    "/dashboard/gn",
    "/dashboard/dmc"
})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        Role role = user.getRole();
        
        String path = req.getServletPath();
        
        // Handle /dashboard - redirect to role-specific dashboard
        if ("/dashboard".equals(path)) {
            redirectToRoleDashboard(req, resp, role);
            return;
        }
        
        // Handle specific dashboard routes
        switch (path) {
            case "/dashboard/general":
                if (role == Role.GENERAL) {
                    req.getRequestDispatcher("/WEB-INF/views/dashboard/general-dashboard.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
                
            case "/dashboard/volunteer":
                if (role == Role.VOLUNTEER) {
                    req.getRequestDispatcher("/WEB-INF/views/dashboard/volunteer-dashboard.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
                
            case "/dashboard/ngo":
                if (role == Role.NGO) {
                    req.getRequestDispatcher("/WEB-INF/views/dashboard/ngo-dashboard.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
                
            case "/dashboard/gn":
                if (role == Role.GRAMA_NILADHARI) {
                    req.getRequestDispatcher("/WEB-INF/views/dashboard/gn-dashboard.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
                
            case "/dashboard/dmc":
                if (role == Role.DMC) {
                    req.getRequestDispatcher("/WEB-INF/views/dashboard/dmc-dashboard.jsp").forward(req, resp);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                }
                break;
                
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    
    private void redirectToRoleDashboard(HttpServletRequest req, HttpServletResponse resp, Role role) throws IOException {
        String contextPath = req.getContextPath();
        
        switch (role) {
            case GENERAL:
                resp.sendRedirect(contextPath + "/dashboard/general");
                break;
            case VOLUNTEER:
                resp.sendRedirect(contextPath + "/dashboard/volunteer");
                break;
            case NGO:
                resp.sendRedirect(contextPath + "/dashboard/ngo");
                break;
            case GRAMA_NILADHARI:
                resp.sendRedirect(contextPath + "/dashboard/gn");
                break;
            case DMC:
                resp.sendRedirect(contextPath + "/dashboard/dmc");
                break;
            default:
                resp.sendRedirect(contextPath + "/login");
                break;
        }
    }
}

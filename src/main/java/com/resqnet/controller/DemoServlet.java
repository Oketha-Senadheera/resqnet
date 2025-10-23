package com.resqnet.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Centralized servlet for handling simple GET requests to static JSP pages.
 * No business logic - just routing to views.
 */
@WebServlet(urlPatterns = {
    // General User
    "/demo/community",
    "/general/profile-settings",
    "/general/forecastdashboard",


    "/volunteer/forecastdashboard",
    "/volunteer/donations"
    
})
public class DemoServlet extends HttpServlet {
    
    private static final Map<String, String> ROUTE_MAP = new HashMap<>();
    
    static {
        // Community routes
        ROUTE_MAP.put("/demo/community", "/WEB-INF/views/demo/community.jsp");
        ROUTE_MAP.put("/general/profile-settings", "/WEB-INF/views/general-user/demo/profile-settings.jsp");
        ROUTE_MAP.put("/general/forecastdashboard", "/WEB-INF/views/general-user/demo/forecast-dashboard.jsp");
        ROUTE_MAP.put("/volunteer/forecastdashboard", "/WEB-INF/views/volunteer/demo/forecast-dashboard.jsp");
        ROUTE_MAP.put("/volunteer/donations", "/WEB-INF/views/volunteer/donations/index.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String jspPath = ROUTE_MAP.get(path);
        
        if (jspPath != null) {
            req.getRequestDispatcher(jspPath).forward(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
        }
    }
}

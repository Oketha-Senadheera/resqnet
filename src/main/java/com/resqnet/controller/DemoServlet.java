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
    "/demo/general/dashboard",
    "/demo/general/make-donation",
    "/demo/general/request-donation",
    "/demo/general/report-disaster",
    "/demo/general/disaster-reports",
    "/demo/general/safe-locations",
    "/demo/general/forecast",
    "/demo/general/forum",
    "/demo/general/profile-settings",
    
    // Volunteer
    "/demo/volunteer/dashboard",
    "/demo/volunteer/make-donation",
    "/demo/volunteer/request-donation",
    "/demo/volunteer/report-disaster",
    "/demo/volunteer/safe-locations",
    "/demo/volunteer/forecast",
    "/demo/volunteer/forum",
    "/demo/volunteer/profile-settings",
    
    // NGO
    "/demo/ngo/dashboard",
    "/demo/ngo/manage-inventory",
    "/demo/ngo/manage-collection",
    "/demo/ngo/donation-requests",
    "/demo/ngo/safe-locations",
    "/demo/ngo/forecast",
    "/demo/ngo/forum",
    "/demo/ngo/profile-settings",
    
    // Grama Niladhari
    "/demo/gn/dashboard",
    "/demo/gn/donation-requests",
    "/demo/gn/disaster-reports",
    "/demo/gn/safe-locations",
    "/demo/gn/forecast",
    "/demo/gn/forum",
    "/demo/gn/profile-settings",
    
    // DMC
    "/demo/dmc/dashboard",
    "/demo/dmc/disaster-reports",
    "/demo/dmc/volunteer-apps",
    "/demo/dmc/delivery-confirmations",
    "/demo/dmc/safe-locations",
    "/demo/dmc/gn-registry",
    "/demo/dmc/forecast",
    "/demo/dmc/forum",
    "/demo/dmc/profile-settings"
})
public class DemoServlet extends HttpServlet {
    
    private static final Map<String, String> ROUTE_MAP = new HashMap<>();
    
    static {
        // General User routes
        ROUTE_MAP.put("/demo/general/dashboard", "/WEB-INF/views/general-user/dashboard.jsp");
        ROUTE_MAP.put("/demo/general/make-donation", "/WEB-INF/views/general-user/make-donation/form.jsp");
        ROUTE_MAP.put("/demo/general/request-donation", "/WEB-INF/views/general-user/donation-requests/form.jsp");
        ROUTE_MAP.put("/demo/general/report-disaster", "/WEB-INF/views/general-user/disaster-reports/form.jsp");
        ROUTE_MAP.put("/demo/general/disaster-reports", "/WEB-INF/views/general-user/disaster-reports/list.jsp");
        ROUTE_MAP.put("/demo/general/safe-locations", "/WEB-INF/views/general-user/safe-locations.jsp");
        ROUTE_MAP.put("/demo/general/forecast", "/WEB-INF/views/general-user/forecast.jsp");
        ROUTE_MAP.put("/demo/general/forum", "/WEB-INF/views/general-user/forum.jsp");
        ROUTE_MAP.put("/demo/general/profile-settings", "/WEB-INF/views/general-user/profile-settings.jsp");
        
        // Volunteer routes
        ROUTE_MAP.put("/demo/volunteer/dashboard", "/WEB-INF/views/volunteer/dashboard.jsp");
        ROUTE_MAP.put("/demo/volunteer/make-donation", "/WEB-INF/views/volunteer/make-donation.jsp");
        ROUTE_MAP.put("/demo/volunteer/request-donation", "/WEB-INF/views/volunteer/request-donation.jsp");
        ROUTE_MAP.put("/demo/volunteer/report-disaster", "/WEB-INF/views/volunteer/report-disaster.jsp");
        ROUTE_MAP.put("/demo/volunteer/safe-locations", "/WEB-INF/views/volunteer/safe-locations.jsp");
        ROUTE_MAP.put("/demo/volunteer/forecast", "/WEB-INF/views/volunteer/forecast.jsp");
        ROUTE_MAP.put("/demo/volunteer/forum", "/WEB-INF/views/volunteer/forum.jsp");
        ROUTE_MAP.put("/demo/volunteer/profile-settings", "/WEB-INF/views/volunteer/profile-settings.jsp");
        
        // NGO routes
        ROUTE_MAP.put("/demo/ngo/dashboard", "/WEB-INF/views/ngo/dashboard.jsp");
        ROUTE_MAP.put("/demo/ngo/manage-inventory", "/WEB-INF/views/ngo/inventory/manage-inventory.jsp");
        ROUTE_MAP.put("/demo/ngo/manage-collection", "/WEB-INF/views/ngo/collection-points/manage-collection-points.jsp");
        ROUTE_MAP.put("/demo/ngo/donation-requests", "/WEB-INF/views/ngo/donation-requests.jsp");
        ROUTE_MAP.put("/demo/ngo/safe-locations", "/WEB-INF/views/ngo/safe-locations.jsp");
        ROUTE_MAP.put("/demo/ngo/forecast", "/WEB-INF/views/ngo/forecast.jsp");
        ROUTE_MAP.put("/demo/ngo/forum", "/WEB-INF/views/ngo/forum.jsp");
        ROUTE_MAP.put("/demo/ngo/profile-settings", "/WEB-INF/views/ngo/profile-settings.jsp");
        
        // Grama Niladhari routes
        ROUTE_MAP.put("/demo/gn/dashboard", "/WEB-INF/views/grama-niladhari/dashboard.jsp");
        ROUTE_MAP.put("/demo/gn/donation-requests", "/WEB-INF/views/grama-niladhari/donation-requests.jsp");
        ROUTE_MAP.put("/demo/gn/disaster-reports", "/WEB-INF/views/grama-niladhari/disaster-reports.jsp");
        ROUTE_MAP.put("/demo/gn/safe-locations", "/WEB-INF/views/grama-niladhari/safe-locations.jsp");
        ROUTE_MAP.put("/demo/gn/forecast", "/WEB-INF/views/grama-niladhari/forecast.jsp");
        ROUTE_MAP.put("/demo/gn/forum", "/WEB-INF/views/grama-niladhari/forum.jsp");
        ROUTE_MAP.put("/demo/gn/profile-settings", "/WEB-INF/views/grama-niladhari/profile-settings.jsp");
        
        // DMC routes
        ROUTE_MAP.put("/demo/dmc/dashboard", "/WEB-INF/views/dmc/dashboard.jsp");
        ROUTE_MAP.put("/demo/dmc/disaster-reports", "/WEB-INF/views/dmc/disaster-reports.jsp");
        ROUTE_MAP.put("/demo/dmc/volunteer-apps", "/WEB-INF/views/dmc/volunteer-apps.jsp");
        ROUTE_MAP.put("/demo/dmc/delivery-confirmations", "/WEB-INF/views/dmc/delivery-confirmations.jsp");
        ROUTE_MAP.put("/demo/dmc/safe-locations", "/WEB-INF/views/dmc/safe-locations.jsp");
        ROUTE_MAP.put("/demo/dmc/gn-registry", "/WEB-INF/views/dmc/gn/list.jsp");
        ROUTE_MAP.put("/demo/dmc/forecast", "/WEB-INF/views/dmc/forecast.jsp");
        ROUTE_MAP.put("/demo/dmc/forum", "/WEB-INF/views/dmc/forum.jsp");
        ROUTE_MAP.put("/demo/dmc/profile-settings", "/WEB-INF/views/dmc/profile-settings.jsp");
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

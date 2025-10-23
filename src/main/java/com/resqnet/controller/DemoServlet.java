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
    "/volunteer/donations",
    "/volunteer/report-disaster",
    "/volunteer/request-donation",
    "/volunteer/request-donation/form",
    "/volunteer/forum",
    "/volunteer/safe-locations",
    "/volunteer/profile-settings",

    "/ngo/forecast",
    "/ngo/forum",
    "/ngo/profile-settings",
    "/ngo/safe-locations",
    "/ngo/donation-requests",

    "/dmc/forecast",
    "/dmc/forum",
    "/dmc/safe-locations",
    "/dmc/add-safe-locations",
    "/dmc/profile-settings",

    "/gn/forecast",
    "/gn/forum",
    "/gn/safe-locations",
    "/gn/profile-settings",
    "/gn/disaster-reports"

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
        ROUTE_MAP.put("/volunteer/report-disaster", "/WEB-INF/views/volunteer/disaster-reports/form.jsp");
        ROUTE_MAP.put("/volunteer/request-donation", "/WEB-INF/views/volunteer/donation-requests/list.jsp");
        ROUTE_MAP.put("/volunteer/request-donation/form", "/WEB-INF/views/volunteer/donation-requests/form.jsp");
        ROUTE_MAP.put("/volunteer/forum", "/WEB-INF/views/volunteer/demo/forum.jsp");
        ROUTE_MAP.put("/volunteer/safe-locations", "/WEB-INF/views/volunteer/demo/safe-locations.jsp");
        ROUTE_MAP.put("/volunteer/profile-settings", "/WEB-INF/views/volunteer/demo/profile-settings.jsp");
        ROUTE_MAP.put("/ngo/forecast", "/WEB-INF/views/ngo/demo/forecast-dashboard.jsp");
        ROUTE_MAP.put("/ngo/forum", "/WEB-INF/views/ngo/demo/forum.jsp");
        ROUTE_MAP.put("/ngo/profile-settings", "/WEB-INF/views/ngo/demo/profile-settings.jsp");
        ROUTE_MAP.put("/ngo/safe-locations", "/WEB-INF/views/ngo/demo/safe-locations.jsp");
        ROUTE_MAP.put("/ngo/donation-requests", "/WEB-INF/views/ngo/demo/donation-requests.jsp");
        ROUTE_MAP.put("/dmc/forecast", "/WEB-INF/views/dmc/demo/forecast-dashboard.jsp");
        ROUTE_MAP.put("/dmc/forum", "/WEB-INF/views/dmc/demo/forum.jsp");
        ROUTE_MAP.put("/dmc/safe-locations", "/WEB-INF/views/dmc/demo/safe-locations.jsp");
        ROUTE_MAP.put("/dmc/add-safe-locations", "/WEB-INF/views/dmc/demo/add-safe-locations.jsp");
        ROUTE_MAP.put("/dmc/profile-settings", "/WEB-INF/views/dmc/demo/change-pwd.jsp");
        ROUTE_MAP.put("/gn/forecast", "/WEB-INF/views/grama-niladhari/demo/forecast-dashboard.jsp");
        ROUTE_MAP.put("/gn/forum", "/WEB-INF/views/grama-niladhari/demo/forum.jsp");
        ROUTE_MAP.put("/gn/safe-locations", "/WEB-INF/views/grama-niladhari/demo/update-safe-locations.jsp");
        ROUTE_MAP.put("/gn/profile-settings", "/WEB-INF/views/grama-niladhari/demo/change-pwd.jsp");
        ROUTE_MAP.put("/gn/disaster-reports", "/WEB-INF/views/grama-niladhari/demo/disaster-reports.jsp");
        


       
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

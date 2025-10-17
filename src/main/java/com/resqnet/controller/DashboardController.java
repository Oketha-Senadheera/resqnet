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
        
        // Redirect all old dashboard URLs to new role-based URLs
        redirectToRoleDashboard(req, resp, role);
    }
    
    private void redirectToRoleDashboard(HttpServletRequest req, HttpServletResponse resp, Role role) throws IOException {
        String contextPath = req.getContextPath();
        
        switch (role) {
            case GENERAL:
                resp.sendRedirect(contextPath + "/general/dashboard");
                break;
            case VOLUNTEER:
                resp.sendRedirect(contextPath + "/volunteer/dashboard");
                break;
            case NGO:
                resp.sendRedirect(contextPath + "/ngo/dashboard");
                break;
            case GRAMA_NILADHARI:
                resp.sendRedirect(contextPath + "/gn/dashboard");
                break;
            case DMC:
                resp.sendRedirect(contextPath + "/dmc/dashboard");
                break;
            default:
                resp.sendRedirect(contextPath + "/login");
                break;
        }
    }
}

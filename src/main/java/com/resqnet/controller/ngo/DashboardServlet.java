package com.resqnet.controller.ngo;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.NGODAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ngo/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

    User user = (User) session.getAttribute("authUser");
        
        // Check if user has NGO role
        if (user.getRole() != Role.NGO) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        // Load display name (organization name)
        try {
            new NGODAO().findByUserId(user.getId())
                .ifPresent(ngo -> req.setAttribute("displayName", ngo.getOrganizationName()));
        } catch (Exception ignored) { }

        req.getRequestDispatcher("/WEB-INF/views/ngo/dashboard.jsp").forward(req, resp);
    }
}

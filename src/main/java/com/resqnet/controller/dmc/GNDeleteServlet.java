package com.resqnet.controller.dmc;

import com.resqnet.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/dmc/gn-registry/delete")
public class GNDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is DMC admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isDMC()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String userIdParam = req.getParameter("id");
        if (userIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?error=invalid");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            
            // Delete user (will cascade delete grama_niladhari due to FK constraint)
            // We use a simple approach by executing SQL directly through DAO
            // In production, you might want to add a delete method to UserDAO
            java.sql.Connection con = com.resqnet.util.DBConnection.getConnection();
            java.sql.PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE user_id = ?");
            ps.setInt(1, userId);
            ps.executeUpdate();
            ps.close();
            con.close();

            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?success=deleted");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?error=delete");
        }
    }
}

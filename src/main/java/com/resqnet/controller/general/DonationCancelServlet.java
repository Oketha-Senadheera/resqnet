package com.resqnet.controller.general;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/general/donations/cancel")
public class DonationCancelServlet extends HttpServlet {

    private final DonationDAO donationDAO = new DonationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        // Check if user has GENERAL role
        if (user.getRole() != Role.GENERAL) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            int donationId = Integer.parseInt(req.getParameter("donationId"));
            donationDAO.updateStatus(donationId, "Cancelled");
            
            session.setAttribute("successMessage", "Donation cancelled successfully!");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error cancelling donation: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/general/donations/list");
    }
}

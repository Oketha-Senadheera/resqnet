package com.resqnet.controller.general;

import com.resqnet.model.Donation;
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
import java.util.List;

@WebServlet("/general/donations/list")
public class DonationsListServlet extends HttpServlet {

    private final DonationDAO donationDAO = new DonationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        // Get all donations for this user
        List<Donation> donations = donationDAO.findByUserId(user.getId());
        req.setAttribute("donations", donations);

        req.getRequestDispatcher("/WEB-INF/views/general-user/donations/list.jsp").forward(req, resp);
    }
}

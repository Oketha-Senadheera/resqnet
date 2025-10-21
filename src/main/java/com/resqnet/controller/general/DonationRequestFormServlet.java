package com.resqnet.controller.general;

import com.resqnet.model.DonationItem;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationItemDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/general/donation-requests")
public class DonationRequestFormServlet extends HttpServlet {
    private final DonationItemDAO donationItemDAO = new DonationItemDAO();

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

        // Get all donation items for the form
        List<DonationItem> donationItems = donationItemDAO.findAll();
        req.setAttribute("donationItems", donationItems);

        req.getRequestDispatcher("/WEB-INF/views/general-user/donation-requests/form.jsp").forward(req, resp);
    }
}

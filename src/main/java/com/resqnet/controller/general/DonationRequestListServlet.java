package com.resqnet.controller.general;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationRequestDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/general/donation-requests/list")
public class DonationRequestListServlet extends HttpServlet {
    private final DonationRequestDAO requestDAO = new DonationRequestDAO();

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

        // Fetch donation requests for this user
        List<DonationRequest> requests = requestDAO.findByUserId(user.getId());
        req.setAttribute("requests", requests);

        req.getRequestDispatcher("/WEB-INF/views/general-user/donation-requests/list.jsp").forward(req, resp);
    }
}

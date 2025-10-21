package com.resqnet.controller.gn;

import com.resqnet.model.DonationRequestWithItems;
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

@WebServlet("/gn/donation-requests")
public class DonationRequestsServlet extends HttpServlet {
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
        
        // Check if user has GRAMA_NILADHARI role
        if (user.getRole() != Role.GRAMA_NILADHARI) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        // Fetch pending and approved donation requests with items
        List<DonationRequestWithItems> pendingRequests = requestDAO.findByStatusWithItems("Pending");
        List<DonationRequestWithItems> approvedRequests = requestDAO.findByStatusWithItems("Approved");
        
        req.setAttribute("pendingRequests", pendingRequests);
        req.setAttribute("approvedRequests", approvedRequests);

        req.getRequestDispatcher("/WEB-INF/views/grama-niladhari/donation-requests.jsp").forward(req, resp);
    }
}

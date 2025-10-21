package com.resqnet.controller.gn;

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
import com.resqnet.model.DonationRequest;
import java.util.Optional;

@WebServlet("/gn/donation-requests/verify")
public class DonationRequestVerifyServlet extends HttpServlet {
    private final DonationRequestDAO requestDAO = new DonationRequestDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        try {
            String requestIdStr = req.getParameter("requestId");
            if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid");
                return;
            }

            int requestId = Integer.parseInt(requestIdStr);
            Optional<DonationRequest> optRequest = requestDAO.findById(requestId);
            if (!optRequest.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=notfound");
                return;
            }

            // Approve the request (any GN can do this)
            requestDAO.approve(requestId);

            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?success=verified");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=verify");
        }
    }
}

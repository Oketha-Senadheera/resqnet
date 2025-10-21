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

@WebServlet("/gn/donation-requests/reject")
public class DonationRequestRejectServlet extends HttpServlet {
    private final DonationRequestDAO donationRequestDAO = new DonationRequestDAO();

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
            String requestIdParam = req.getParameter("request_id");
            
            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid");
                return;
            }

            int requestId = Integer.parseInt(requestIdParam);
            donationRequestDAO.delete(requestId);

            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?success=rejected");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=reject");
        }
    }
}

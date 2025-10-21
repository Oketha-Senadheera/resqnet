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

@WebServlet("/gn/donation-requests/verify")
public class DonationRequestVerifyServlet extends HttpServlet {
    private final DonationRequestDAO requestDAO = new DonationRequestDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Require login
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");

        // Only GN can verify, but any GN can verify any request (no per-request ownership check)
        if (user.getRole() != Role.GRAMA_NILADHARI) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String requestIdParam = req.getParameter("requestId");
        if (requestIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=missing-id");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            requestDAO.approve(requestId); // sets status='Approved' and approved_at=NOW()
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?success=verified");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid-id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=approve");
        }
    }
}

package com.resqnet.controller.gn;

import com.resqnet.model.DonationItemsCatalog;
import com.resqnet.model.DonationRequest;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationItemsCatalogDAO;
import com.resqnet.model.dao.DonationRequestDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/gn/donation-requests/edit")
public class DonationRequestEditServlet extends HttpServlet {
    private final DonationRequestDAO requestDAO = new DonationRequestDAO();
    private final DonationItemsCatalogDAO catalogDAO = new DonationItemsCatalogDAO();

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

        String requestIdParam = req.getParameter("id");
        if (requestIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=missing-id");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdParam);
            Optional<DonationRequest> requestOpt = requestDAO.findById(requestId);
            
            if (!requestOpt.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=not-found");
                return;
            }

            DonationRequest donationRequest = requestOpt.get();
            List<DonationItemsCatalog> catalogItems = catalogDAO.findAll();
            
            req.setAttribute("donationRequest", donationRequest);
            req.setAttribute("catalogItems", catalogItems);

            req.getRequestDispatcher("/WEB-INF/views/grama-niladhari/donation-request-edit.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid-id");
        }
    }
}

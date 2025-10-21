package com.resqnet.controller.gn;

import com.resqnet.model.DonationItem;
import com.resqnet.model.DonationRequest;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationItemDAO;
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
    private final DonationRequestDAO donationRequestDAO = new DonationRequestDAO();
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
            Optional<DonationRequest> requestOpt = donationRequestDAO.findById(requestId);
            
            if (!requestOpt.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=notfound");
                return;
            }

            List<DonationItem> donationItems = donationItemDAO.findAll();
            req.setAttribute("donationRequest", requestOpt.get());
            req.setAttribute("donationItems", donationItems);

            req.getRequestDispatcher("/WEB-INF/views/grama-niladhari/donation-request-edit.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=load");
        }
    }

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
            String reliefCenterName = req.getParameter("relief_center_name");
            String specialNotes = req.getParameter("special_notes");

            if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid");
                return;
            }

            int requestId = Integer.parseInt(requestIdParam);
            Optional<DonationRequest> requestOpt = donationRequestDAO.findById(requestId);
            
            if (!requestOpt.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=notfound");
                return;
            }

            DonationRequest request = requestOpt.get();
            
            if (reliefCenterName != null && !reliefCenterName.trim().isEmpty()) {
                request.setReliefCenterName(reliefCenterName.trim());
            }
            
            request.setSpecialNotes(specialNotes != null ? specialNotes.trim() : null);
            
            donationRequestDAO.update(request);

            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?success=updated");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=update");
        }
    }
}

package com.resqnet.controller.general;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestItem;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationRequestDAO;
import com.resqnet.model.dao.DonationRequestItemDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/general/donation-requests/submit")
public class DonationRequestSubmitServlet extends HttpServlet {
    private final DonationRequestDAO requestDAO = new DonationRequestDAO();
    private final DonationRequestItemDAO itemDAO = new DonationRequestItemDAO();

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
            // Get form parameters
            String reliefCenterName = req.getParameter("reliefCenterName");
            String specialNotes = req.getParameter("specialNotes");
            String[] itemIds = req.getParameterValues("itemId");
            String[] quantities = req.getParameterValues("quantity");

            // Validate required fields
            if (reliefCenterName == null || reliefCenterName.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests/new?error=required");
                return;
            }

            if (itemIds == null || itemIds.length == 0) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests/new?error=no-items");
                return;
            }

            // Create donation request
            DonationRequest request = new DonationRequest();
            request.setUserId(user.getId());
            request.setReliefCenterName(reliefCenterName.trim());
            request.setSpecialNotes(specialNotes != null ? specialNotes.trim() : null);
            request.setStatus("Pending");

            int requestId = requestDAO.create(request);

            // Add items to the request
            for (int i = 0; i < itemIds.length; i++) {
                try {
                    int itemId = Integer.parseInt(itemIds[i]);
                    int quantity = (quantities != null && i < quantities.length) 
                                   ? Integer.parseInt(quantities[i]) 
                                   : 1;
                    
                    if (quantity > 0) {
                        DonationRequestItem item = new DonationRequestItem();
                        item.setRequestId(requestId);
                        item.setItemId(itemId);
                        item.setQuantity(quantity);
                        itemDAO.create(item);
                    }
                } catch (NumberFormatException e) {
                    // Skip invalid items
                }
            }

            // Redirect back with success message
            resp.sendRedirect(req.getContextPath() + "/general/donation-requests?success=submitted");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/general/donation-requests/new?error=submit");
        }
    }
}

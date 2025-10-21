package com.resqnet.controller.general;

import com.resqnet.model.DonationItemsCatalog;
import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestItem;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationItemsCatalogDAO;
import com.resqnet.model.dao.DonationRequestDAO;
import com.resqnet.model.dao.DonationRequestItemDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/general/donation-requests/submit")
public class DonationRequestSubmitServlet extends HttpServlet {
    private final DonationRequestDAO donationRequestDAO = new DonationRequestDAO();
    private final DonationRequestItemDAO requestItemDAO = new DonationRequestItemDAO();
    private final DonationItemsCatalogDAO itemsCatalogDAO = new DonationItemsCatalogDAO();

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
            String[] itemNames = req.getParameterValues("itemName[]");
            String[] quantities = req.getParameterValues("quantity[]");

            // Validate required fields
            if (reliefCenterName == null || reliefCenterName.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests/form?error=required");
                return;
            }

            if (itemNames == null || itemNames.length == 0) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests/form?error=no_items");
                return;
            }

            // Create donation request
            DonationRequest request = new DonationRequest();
            request.setUserId(user.getId());
            request.setReliefCenterName(reliefCenterName.trim());
            request.setSpecialNotes(specialNotes != null ? specialNotes.trim() : null);
            request.setStatus("Pending");

            int requestId = donationRequestDAO.create(request);

            // Add items to the request
            for (int i = 0; i < itemNames.length; i++) {
                String itemName = itemNames[i];
                if (itemName != null && !itemName.trim().isEmpty()) {
                    // Get or create the item in catalog
                    Optional<DonationItemsCatalog> catalogItem = itemsCatalogDAO.findByName(itemName.trim());
                    int itemId;
                    
                    if (catalogItem.isPresent()) {
                        itemId = catalogItem.get().getItemId();
                    } else {
                        // For simplicity, skip items not in catalog
                        // In production, you might want to handle this differently
                        continue;
                    }

                    int quantity = 1;
                    if (quantities != null && i < quantities.length) {
                        try {
                            quantity = Integer.parseInt(quantities[i]);
                            if (quantity < 1) quantity = 1;
                        } catch (NumberFormatException e) {
                            quantity = 1;
                        }
                    }

                    DonationRequestItem requestItem = new DonationRequestItem();
                    requestItem.setRequestId(requestId);
                    requestItem.setItemId(itemId);
                    requestItem.setQuantity(quantity);
                    requestItemDAO.create(requestItem);
                }
            }

            // Redirect back with success message
            resp.sendRedirect(req.getContextPath() + "/general/dashboard?success=donation_request_submitted");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/general/donation-requests/form?error=submit");
        }
    }
}

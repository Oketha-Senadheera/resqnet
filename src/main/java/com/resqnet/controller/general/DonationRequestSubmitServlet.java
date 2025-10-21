package com.resqnet.controller.general;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestItem;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/general/donation-requests/submit")
public class DonationRequestSubmitServlet extends HttpServlet {
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
        
        // Check if user has GENERAL role
        if (user.getRole() != Role.GENERAL) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            // Get form parameters
            String reliefCenterName = req.getParameter("relief_center_name");
            String specialNotes = req.getParameter("special_notes");
            String[] itemIds = req.getParameterValues("item_id");
            String[] quantities = req.getParameterValues("quantity");

            // Validate required fields
            if (reliefCenterName == null || reliefCenterName.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests?error=required");
                return;
            }

            if (itemIds == null || itemIds.length == 0) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests?error=noitems");
                return;
            }

            // Create donation request
            DonationRequest request = new DonationRequest();
            request.setUserId(user.getId());
            request.setReliefCenterName(reliefCenterName.trim());
            request.setSpecialNotes(specialNotes != null ? specialNotes.trim() : null);
            request.setStatus("Pending");

            // Add items
            List<DonationRequestItem> items = new ArrayList<>();
            for (int i = 0; i < itemIds.length; i++) {
                if (itemIds[i] != null && !itemIds[i].isEmpty()) {
                    DonationRequestItem item = new DonationRequestItem();
                    item.setItemId(Integer.parseInt(itemIds[i]));
                    
                    int quantity = 1;
                    if (quantities != null && i < quantities.length && quantities[i] != null && !quantities[i].isEmpty()) {
                        try {
                            quantity = Integer.parseInt(quantities[i]);
                            if (quantity < 1) quantity = 1;
                        } catch (NumberFormatException e) {
                            quantity = 1;
                        }
                    }
                    item.setQuantity(quantity);
                    items.add(item);
                }
            }

            if (items.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/general/donation-requests?error=noitems");
                return;
            }

            request.setItems(items);
            donationRequestDAO.create(request);

            // Redirect back with success message
            resp.sendRedirect(req.getContextPath() + "/general/donation-requests?success=submitted");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/general/donation-requests?error=submit");
        }
    }
}

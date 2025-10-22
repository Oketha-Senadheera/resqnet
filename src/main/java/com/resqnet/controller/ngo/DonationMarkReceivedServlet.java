package com.resqnet.controller.ngo;

import com.resqnet.model.DonationItemWithDetails;
import com.resqnet.model.DonationWithItems;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationDAO;
import com.resqnet.model.dao.InventoryDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ngo/donations/mark-received")
public class DonationMarkReceivedServlet extends HttpServlet {

    private final DonationDAO donationDAO = new DonationDAO();
    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        // Check if user has NGO role
        if (user.getRole() != Role.NGO) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            int donationId = Integer.parseInt(req.getParameter("donationId"));
            
            // Get donation with items
            DonationWithItems donation = donationDAO.findWithItemsById(donationId);
            
            if (donation != null) {
                // Update donation status to Received (which also sets it as Delivered for general user)
                donationDAO.updateStatus(donationId, "Received");
                
                // Update inventory for each item
                int collectionPointId = donation.getDonation().getCollectionPointId();
                for (DonationItemWithDetails item : donation.getItems()) {
                    inventoryDAO.upsertInventoryItem(
                        user.getId(), 
                        collectionPointId, 
                        item.getItemId(), 
                        item.getQuantity()
                    );
                }
                
                session.setAttribute("successMessage", "Donation marked as received and inventory updated!");
            } else {
                session.setAttribute("errorMessage", "Donation not found!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error marking donation as received: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/ngo/donations");
    }
}

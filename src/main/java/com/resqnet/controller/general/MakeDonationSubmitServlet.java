package com.resqnet.controller.general;

import com.resqnet.model.Donation;
import com.resqnet.model.DonationItem;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationDAO;
import com.resqnet.model.dao.DonationItemDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/general/make-donation/submit")
public class MakeDonationSubmitServlet extends HttpServlet {

    private final DonationDAO donationDAO = new DonationDAO();
    private final DonationItemDAO donationItemDAO = new DonationItemDAO();

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
            // Create donation
            Donation donation = new Donation();
            donation.setUserId(user.getId());
            donation.setCollectionPointId(Integer.parseInt(req.getParameter("collectionPoint")));
            donation.setName(req.getParameter("donorName"));
            donation.setContactNumber(req.getParameter("donorContact"));
            donation.setEmail(req.getParameter("donorEmail"));
            donation.setAddress(req.getParameter("donorAddress"));
            donation.setCollectionDate(Date.valueOf(req.getParameter("collectionDate")));
            donation.setTimeSlot(req.getParameter("timeSlot"));
            donation.setSpecialNotes(req.getParameter("specialNotes"));
            donation.setConfirmation(req.getParameter("confirmation") != null);
            donation.setStatus("Pending");

            int donationId = donationDAO.create(donation);

            // Add donation items
            String[] itemIds = req.getParameterValues("itemId");
            String[] quantities = req.getParameterValues("quantity");
            
            if (itemIds != null && quantities != null) {
                for (int i = 0; i < itemIds.length; i++) {
                    if (itemIds[i] != null && !itemIds[i].isEmpty() && 
                        quantities[i] != null && !quantities[i].isEmpty()) {
                        int qty = Integer.parseInt(quantities[i]);
                        if (qty > 0) {
                            DonationItem item = new DonationItem();
                            item.setDonationId(donationId);
                            item.setItemId(Integer.parseInt(itemIds[i]));
                            item.setQuantity(qty);
                            donationItemDAO.create(item);
                        }
                    }
                }
            }

            // Redirect to donations list with success message
            session.setAttribute("successMessage", "Donation submitted successfully!");
            resp.sendRedirect(req.getContextPath() + "/general/donations/list");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error submitting donation: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/general/make-donation");
        }
    }
}

package com.resqnet.controller.gn;

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
import java.util.Optional;

@WebServlet("/gn/donation-requests/update")
public class DonationRequestUpdateServlet extends HttpServlet {
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
        
        // Check if user has GRAMA_NILADHARI role
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
            Optional<DonationRequest> requestOpt = requestDAO.findById(requestId);
            
            if (!requestOpt.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=not-found");
                return;
            }

            DonationRequest donationRequest = requestOpt.get();
            
            // Update request details
            String reliefCenterName = req.getParameter("reliefCenterName");
            String specialNotes = req.getParameter("specialNotes");
            
            if (reliefCenterName != null && !reliefCenterName.trim().isEmpty()) {
                donationRequest.setReliefCenterName(reliefCenterName.trim());
            }
            donationRequest.setSpecialNotes(specialNotes != null ? specialNotes.trim() : null);

            requestDAO.update(donationRequest);

            // Update items if provided
            String[] itemIds = req.getParameterValues("itemId");
            String[] quantities = req.getParameterValues("quantity");
            String[] requestItemIds = req.getParameterValues("requestItemId");

            if (itemIds != null && requestItemIds != null) {
                for (int i = 0; i < itemIds.length && i < requestItemIds.length; i++) {
                    try {
                        int itemId = Integer.parseInt(itemIds[i]);
                        int quantity = (quantities != null && i < quantities.length) 
                                       ? Integer.parseInt(quantities[i]) 
                                       : 1;
                        int requestItemId = Integer.parseInt(requestItemIds[i]);
                        
                        if (quantity > 0) {
                            DonationRequestItem item = new DonationRequestItem();
                            item.setRequestItemId(requestItemId);
                            item.setItemId(itemId);
                            item.setQuantity(quantity);
                            itemDAO.update(item);
                        }
                    } catch (NumberFormatException e) {
                        // Skip invalid items
                    }
                }
            }

            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?success=updated");

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid-id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=update");
        }
    }
}

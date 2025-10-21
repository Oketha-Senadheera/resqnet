package com.resqnet.controller.gn;

import com.resqnet.model.DonationRequest;
import com.resqnet.model.DonationRequestItem;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.DonationRequestDAO;
import com.resqnet.model.dao.DonationRequestItemDAO;
import com.resqnet.model.dao.DonationItemsCatalogDAO;

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
    private final DonationRequestItemDAO itemDAO = new DonationRequestItemDAO();
    private final DonationItemsCatalogDAO catalogDAO = new DonationItemsCatalogDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        if (user.getRole() != Role.GRAMA_NILADHARI) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String requestIdStr = req.getParameter("id");
        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=invalid");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdStr);
            Optional<DonationRequest> optRequest = requestDAO.findById(requestId);
            
            if (!optRequest.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=notfound");
                return;
            }

            req.setAttribute("request", optRequest.get());
            req.setAttribute("requestItems", itemDAO.findByRequestId(requestId));
            req.setAttribute("donationItems", catalogDAO.findAll());
            
            req.getRequestDispatcher("/WEB-INF/views/grama-niladhari/donation-request-edit.jsp").forward(req, resp);
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=load");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        
        if (user.getRole() != Role.GRAMA_NILADHARI) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            String requestIdStr = req.getParameter("requestId");
            String reliefCenterName = req.getParameter("reliefCenterName");
            String specialNotes = req.getParameter("specialNotes");
            String[] itemIds = req.getParameterValues("itemId");
            String[] quantities = req.getParameterValues("quantity");

            if (requestIdStr == null || reliefCenterName == null || reliefCenterName.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=required");
                return;
            }

            int requestId = Integer.parseInt(requestIdStr);
            Optional<DonationRequest> optRequest = requestDAO.findById(requestId);
            
            if (!optRequest.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=notfound");
                return;
            }

            DonationRequest request = optRequest.get();
            request.setReliefCenterName(reliefCenterName.trim());
            request.setSpecialNotes(specialNotes != null ? specialNotes.trim() : null);
            
            requestDAO.update(request);

            // Update items
            itemDAO.deleteByRequestId(requestId);
            if (itemIds != null) {
                for (int i = 0; i < itemIds.length; i++) {
                    if (itemIds[i] != null && !itemIds[i].trim().isEmpty()) {
                        DonationRequestItem item = new DonationRequestItem();
                        item.setRequestId(requestId);
                        item.setItemId(Integer.parseInt(itemIds[i]));
                        item.setQuantity(quantities != null && i < quantities.length && 
                                       quantities[i] != null && !quantities[i].trim().isEmpty() 
                                       ? Integer.parseInt(quantities[i]) : 1);
                        itemDAO.create(item);
                    }
                }
            }

            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?success=updated");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/gn/donation-requests?error=update");
        }
    }
}

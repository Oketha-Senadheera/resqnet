package com.resqnet.controller.ngo;

import com.resqnet.model.CollectionPoint;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.CollectionPointDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/ngo/collection-points/add")
public class CollectionPointAddServlet extends HttpServlet {
    private final CollectionPointDAO collectionPointDAO = new CollectionPointDAO();

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
            // Get form parameters
            String name = req.getParameter("name");
            String locationLandmark = req.getParameter("landmark");
            String fullAddress = req.getParameter("address");
            String contactPerson = req.getParameter("contact");
            String contactNumber = req.getParameter("phone");

            // Validate required fields
            if (name == null || name.trim().isEmpty() ||
                fullAddress == null || fullAddress.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?error=required");
                return;
            }

            // Create collection point
            CollectionPoint collectionPoint = new CollectionPoint();
            collectionPoint.setNgoId(user.getId());
            collectionPoint.setName(name.trim());
            collectionPoint.setLocationLandmark(locationLandmark != null ? locationLandmark.trim() : null);
            collectionPoint.setFullAddress(fullAddress.trim());
            collectionPoint.setContactPerson(contactPerson != null ? contactPerson.trim() : null);
            collectionPoint.setContactNumber(contactNumber != null ? contactNumber.trim() : null);

            collectionPointDAO.create(collectionPoint);

            // Redirect back with success message
            resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?success=added");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?error=add");
        }
    }
}

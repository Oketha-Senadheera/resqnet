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
import java.util.Optional;

@WebServlet("/ngo/collection-points/delete")
public class CollectionPointDeleteServlet extends HttpServlet {
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
            // Get collection point ID
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?error=notfound");
                return;
            }

            int collectionPointId = Integer.parseInt(idParam);

            // Verify the collection point exists and belongs to this NGO
            Optional<CollectionPoint> existingOpt = collectionPointDAO.findById(collectionPointId);
            if (!existingOpt.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?error=notfound");
                return;
            }

            CollectionPoint existing = existingOpt.get();
            if (!existing.getNgoId().equals(user.getId())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }

            // Delete the collection point
            collectionPointDAO.delete(collectionPointId);

            // Redirect back with success message
            resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?success=deleted");

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?error=invalid");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/ngo/manage-collection?error=delete");
        }
    }
}

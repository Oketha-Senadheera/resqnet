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
import java.util.List;

@WebServlet("/ngo/manage-collection")
public class ManageCollectionPointsServlet extends HttpServlet {
    private final CollectionPointDAO collectionPointDAO = new CollectionPointDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        // Fetch collection points for this NGO
        List<CollectionPoint> collectionPoints = collectionPointDAO.findByNgoId(user.getId());
        req.setAttribute("collectionPoints", collectionPoints);

        req.getRequestDispatcher("/WEB-INF/views/ngo/collection-points/manage-collection-points.jsp").forward(req, resp);
    }
}

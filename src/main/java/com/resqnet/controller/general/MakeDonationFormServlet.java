package com.resqnet.controller.general;

import com.resqnet.model.CollectionPoint;
import com.resqnet.model.DonationItemsCatalog;
import com.resqnet.model.GeneralUser;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.CollectionPointDAO;
import com.resqnet.model.dao.DonationItemsCatalogDAO;
import com.resqnet.model.dao.GeneralUserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/general/make-donation")
public class MakeDonationFormServlet extends HttpServlet {

    private final CollectionPointDAO collectionPointDAO = new CollectionPointDAO();
    private final DonationItemsCatalogDAO itemsCatalogDAO = new DonationItemsCatalogDAO();
    private final GeneralUserDAO generalUserDAO = new GeneralUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

        // Get all collection points
        List<CollectionPoint> collectionPoints = collectionPointDAO.findAll();
        req.setAttribute("collectionPoints", collectionPoints);

        // Get all donation items catalog
        List<DonationItemsCatalog> itemsCatalog = itemsCatalogDAO.findAll();
        req.setAttribute("itemsCatalog", itemsCatalog);

        // Get general user details for autofill
        Optional<GeneralUser> generalUserOpt = generalUserDAO.findByUserId(user.getId());
        if (generalUserOpt.isPresent()) {
            req.setAttribute("generalUser", generalUserOpt.get());
        }

        req.getRequestDispatcher("/WEB-INF/views/general-user/make-donation/form.jsp").forward(req, resp);
    }
}

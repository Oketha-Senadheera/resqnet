package com.resqnet.controller.general;

import com.resqnet.model.GeneralUser;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.GeneralUserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/general/be-volunteer")
public class BeVolunteerServlet extends HttpServlet {

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

        // Load general user data to pre-fill the form
        try {
            GeneralUserDAO generalUserDAO = new GeneralUserDAO();
            Optional<GeneralUser> generalUserOpt = generalUserDAO.findByUserId(user.getId());
            
            if (generalUserOpt.isPresent()) {
                GeneralUser generalUser = generalUserOpt.get();
                req.setAttribute("generalUser", generalUser);
            }
            
            // Set flag to indicate this is an upgrade, not a new signup
            req.setAttribute("isUpgrade", true);
            
            req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Error loading user data: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
        }
    }
}

package com.resqnet.controller.dmc;

import com.resqnet.model.GramaNiladhari;
import com.resqnet.model.GramaNiladhariWithUser;
import com.resqnet.model.User;
import com.resqnet.model.dao.GramaNiladhariDAO;
import com.resqnet.model.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/dmc/gn-registry/edit")
public class GNEditServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final GramaNiladhariDAO gnDAO = new GramaNiladhariDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is DMC admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isDMC()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String userIdParam = req.getParameter("id");
        if (userIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            Optional<GramaNiladhari> gnOpt = gnDAO.findByUserId(userId);
            Optional<User> userOpt = userDAO.findById(userId);

            if (!gnOpt.isPresent() || !userOpt.isPresent()) {
                resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?error=notfound");
                return;
            }

            GramaNiladhariWithUser gnWithUser = new GramaNiladhariWithUser(userOpt.get(), gnOpt.get());
            req.setAttribute("gnData", gnWithUser);
            req.setAttribute("editMode", true);
            req.getRequestDispatcher("/WEB-INF/views/dmc/gn/form.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?error=invalid");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is DMC admin
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("authUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("authUser");
        if (!user.isDMC()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String userIdParam = req.getParameter("userId");
        if (userIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);

            // Get form parameters
            String divisionName = req.getParameter("divisionName");
            String divisionNumber = req.getParameter("divisionNumber");
            String fullName = req.getParameter("fullName");
            String serviceNumber = req.getParameter("serviceNumber");
            String contactNumber = req.getParameter("contactNumber");
            String address = req.getParameter("address");
            String email = req.getParameter("email");

            // Validate required fields
            if (divisionName == null || divisionName.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                contactNumber == null || contactNumber.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "Required fields are missing");
                
                // Re-fetch data for display
                Optional<GramaNiladhari> gnOpt = gnDAO.findByUserId(userId);
                Optional<User> userOpt = userDAO.findById(userId);
                if (gnOpt.isPresent() && userOpt.isPresent()) {
                    req.setAttribute("gnData", new GramaNiladhariWithUser(userOpt.get(), gnOpt.get()));
                    req.setAttribute("editMode", true);
                }
                req.getRequestDispatcher("/WEB-INF/views/dmc/gn/form.jsp").forward(req, resp);
                return;
            }

            // Update Grama Niladhari profile
            GramaNiladhari gn = new GramaNiladhari();
            gn.setUserId(userId);
            gn.setName(fullName);
            gn.setContactNumber(contactNumber);
            gn.setAddress(address);
            gn.setGnDivision(divisionName);
            gn.setServiceNumber(serviceNumber);
            gn.setGnDivisionNumber(divisionNumber);

            gnDAO.update(gn);

            // Note: We're not updating email/username as those are in users table
            // and would require additional validation

            // Redirect to list page with success message
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?success=updated");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?error=update");
        }
    }
}

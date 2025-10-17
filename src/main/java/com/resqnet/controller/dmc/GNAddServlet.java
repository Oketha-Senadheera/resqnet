package com.resqnet.controller.dmc;

import com.resqnet.model.GramaNiladhari;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.GramaNiladhariDAO;
import com.resqnet.model.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.Optional;

@WebServlet("/dmc/gn-registry/add")
public class GNAddServlet extends HttpServlet {
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

        req.getRequestDispatcher("/WEB-INF/views/admin/gn/form.jsp").forward(req, resp);
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

        try {
            // Get form parameters
            String divisionName = req.getParameter("divisionName");
            String divisionNumber = req.getParameter("divisionNumber");
            String fullName = req.getParameter("fullName");
            String serviceNumber = req.getParameter("serviceNumber");
            String contactNumber = req.getParameter("contactNumber");
            String address = req.getParameter("address");
            String email = req.getParameter("email");
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            // Validate required fields
            if (divisionName == null || divisionName.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                contactNumber == null || contactNumber.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                req.setAttribute("error", "Required fields are missing");
                req.getRequestDispatcher("/WEB-INF/views/dmc/gn/form.jsp").forward(req, resp);
                return;
            }

            // Check if username or email already exists
            Optional<User> existingByUsername = userDAO.findByUsername(username);
            if (existingByUsername.isPresent()) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/WEB-INF/views/dmc/gn/form.jsp").forward(req, resp);
                return;
            }

            Optional<User> existingByEmail = userDAO.findByEmail(email);
            if (existingByEmail.isPresent()) {
                req.setAttribute("error", "Email already exists");
                req.getRequestDispatcher("/WEB-INF/views/dmc/gn/form.jsp").forward(req, resp);
                return;
            }

            // Create user account
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setEmail(email);
            newUser.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            newUser.setRole(Role.GRAMA_NILADHARI);
            
            int userId = userDAO.create(newUser);

            // Create Grama Niladhari profile
            GramaNiladhari gn = new GramaNiladhari();
            gn.setUserId(userId);
            gn.setName(fullName);
            gn.setContactNumber(contactNumber);
            gn.setAddress(address);
            gn.setGnDivision(divisionName);
            gn.setServiceNumber(serviceNumber);
            gn.setGnDivisionNumber(divisionNumber);

            gnDAO.create(gn);

            // Redirect to list page with success message
            resp.sendRedirect(req.getContextPath() + "/dmc/gn-registry?success=added");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error creating Grama Niladhari: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/dmc/gn/form.jsp").forward(req, resp);
        }
    }
}

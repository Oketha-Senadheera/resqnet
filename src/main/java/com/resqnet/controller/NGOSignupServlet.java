package com.resqnet.controller;

import com.resqnet.model.NGO;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.NGODAO;
import com.resqnet.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "signupNGO", urlPatterns = "/signup-ngo")
public class NGOSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final NGODAO ngodao = new NGODAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/signup-ngo.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get form parameters
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String orgName = req.getParameter("orgName");
            String regNo = req.getParameter("regNo");
            String yearsStr = req.getParameter("years");
            String address = req.getParameter("address");
            String contactPerson = req.getParameter("contactPerson");
            String email = req.getParameter("email");
            String telephone = req.getParameter("telephone");

            // Validate required fields
            if (username == null || password == null || orgName == null || regNo == null || 
                contactPerson == null || email == null || telephone == null) {
                req.setAttribute("error", "All required fields must be filled");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-ngo.jsp").forward(req, resp);
                return;
            }

            // Check if username or email already exists
            if (userDAO.findByUsername(username).isPresent()) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-ngo.jsp").forward(req, resp);
                return;
            }
            if (userDAO.findByEmail(email).isPresent()) {
                req.setAttribute("error", "Email already exists");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-ngo.jsp").forward(req, resp);
                return;
            }

            // Parse years of operation
            Integer years = null;
            if (yearsStr != null && !yearsStr.isEmpty()) {
                try {
                    years = Integer.parseInt(yearsStr);
                } catch (NumberFormatException e) {
                    // Ignore invalid years
                }
            }

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.NGO);
            userDAO.create(user);

            // Create NGO profile
            NGO ngo = new NGO();
            ngo.setUserId(user.getUserId());
            ngo.setOrganizationName(orgName);
            ngo.setRegistrationNumber(regNo);
            ngo.setYearsOfOperation(years);
            ngo.setAddress(address);
            ngo.setContactPersonName(contactPerson);
            ngo.setContactPersonTelephone(telephone);
            ngo.setContactPersonEmail(email);
            ngodao.create(ngo);

            // Set session and redirect to dashboard
            req.getSession(true).setAttribute("authUser", user);
            resp.sendRedirect(req.getContextPath() + "/ngo/dashboard");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup-ngo.jsp").forward(req, resp);
        }
    }
}

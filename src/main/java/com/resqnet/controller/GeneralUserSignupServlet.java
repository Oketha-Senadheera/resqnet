package com.resqnet.controller;

import com.resqnet.model.GeneralUser;
import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.dao.GeneralUserDAO;
import com.resqnet.model.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "signupGeneral", urlPatterns = "/signup-general")
public class GeneralUserSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final GeneralUserDAO generalUserDAO = new GeneralUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/signup-general.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get form parameters
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String fullName = req.getParameter("fullName");
            String contactNo = req.getParameter("contactNo");
            String houseNo = req.getParameter("houseNo");
            String street = req.getParameter("street");
            String city = req.getParameter("city");
            String district = req.getParameter("district");
            String gnDivision = req.getParameter("gnDivision");
            boolean smsAlert = "on".equals(req.getParameter("smsAlert"));

            // Validate required fields
            if (username == null || email == null || password == null || fullName == null || contactNo == null) {
                req.setAttribute("error", "All required fields must be filled");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-general.jsp").forward(req, resp);
                return;
            }

            // Check if username or email already exists
            if (userDAO.findByUsername(username).isPresent()) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-general.jsp").forward(req, resp);
                return;
            }
            if (userDAO.findByEmail(email).isPresent()) {
                req.setAttribute("error", "Email already exists");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-general.jsp").forward(req, resp);
                return;
            }

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.GENERAL);
            userDAO.create(user);

            // Create general user profile
            GeneralUser generalUser = new GeneralUser();
            generalUser.setUserId(user.getUserId());
            generalUser.setName(fullName);
            generalUser.setContactNumber(contactNo);
            generalUser.setHouseNo(houseNo);
            generalUser.setStreet(street);
            generalUser.setCity(city);
            generalUser.setDistrict(district);
            generalUser.setGnDivision(gnDivision);
            generalUser.setSmsAlert(smsAlert);
            generalUserDAO.create(generalUser);

            // Set session and redirect to dashboard
            req.getSession(true).setAttribute("authUser", user);
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup-general.jsp").forward(req, resp);
        }
    }
}

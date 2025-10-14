package com.resqnet.controller;

import com.resqnet.model.Role;
import com.resqnet.model.User;
import com.resqnet.model.Volunteer;
import com.resqnet.model.dao.UserDAO;
import com.resqnet.model.dao.VolunteerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "signupVolunteer", urlPatterns = "/signup-volunteer")
public class VolunteerSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/signup-volunteer.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get form parameters
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String fullName = req.getParameter("fullName");
            String ageStr = req.getParameter("age");
            String gender = req.getParameter("gender");
            String contactNo = req.getParameter("contactNo");
            String houseNo = req.getParameter("houseNo");
            String street = req.getParameter("street");
            String city = req.getParameter("city");
            String district = req.getParameter("district");
            String gnDivision = req.getParameter("gnDivision");
            String[] skillsArray = req.getParameterValues("skills");
            String[] preferencesArray = req.getParameterValues("preferences");

            // Validate required fields
            if (username == null || email == null || password == null || fullName == null || contactNo == null) {
                req.setAttribute("error", "All required fields must be filled");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-volunteer.jsp").forward(req, resp);
                return;
            }

            // Check if username or email already exists
            if (userDAO.findByUsername(username).isPresent()) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-volunteer.jsp").forward(req, resp);
                return;
            }
            if (userDAO.findByEmail(email).isPresent()) {
                req.setAttribute("error", "Email already exists");
                req.getRequestDispatcher("/WEB-INF/views/auth/signup-volunteer.jsp").forward(req, resp);
                return;
            }

            // Parse age
            Integer age = null;
            if (ageStr != null && !ageStr.isEmpty()) {
                try {
                    age = Integer.parseInt(ageStr);
                } catch (NumberFormatException e) {
                    // Ignore invalid age
                }
            }

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.VOLUNTEER);
            userDAO.create(user);

            // Create volunteer profile
            Volunteer volunteer = new Volunteer();
            volunteer.setUserId(user.getUserId());
            volunteer.setName(fullName);
            volunteer.setAge(age);
            volunteer.setGender(gender);
            volunteer.setContactNumber(contactNo);
            volunteer.setHouseNo(houseNo);
            volunteer.setStreet(street);
            volunteer.setCity(city);
            volunteer.setDistrict(district);
            volunteer.setGnDivision(gnDivision);
            volunteerDAO.create(volunteer);

            // Add skills and preferences
            if (skillsArray != null && skillsArray.length > 0) {
                List<String> skills = Arrays.asList(skillsArray);
                volunteerDAO.addSkills(user.getUserId(), skills);
            }
            if (preferencesArray != null && preferencesArray.length > 0) {
                List<String> preferences = Arrays.asList(preferencesArray);
                volunteerDAO.addPreferences(user.getUserId(), preferences);
            }

            // Set session and redirect to dashboard
            req.getSession(true).setAttribute("authUser", user);
            resp.sendRedirect(req.getContextPath() + "/volunteer/dashboard");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/signup-volunteer.jsp").forward(req, resp);
        }
    }
}

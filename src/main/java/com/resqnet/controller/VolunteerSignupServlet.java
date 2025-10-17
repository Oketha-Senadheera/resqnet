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

@WebServlet(name = "volunteerSignup", urlPatterns = "/signup/volunteer")
public class VolunteerSignupServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Get user account details
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            
            // Get volunteer details
            String name = req.getParameter("name");
            String ageStr = req.getParameter("age");
            String gender = req.getParameter("gender");
            String contactNumber = req.getParameter("contactNumber");
            String houseNo = req.getParameter("houseNo");
            String street = req.getParameter("street");
            String city = req.getParameter("city");
            String district = req.getParameter("district");
            String gnDivision = req.getParameter("gnDivision");

            // Get skills and preferences (multi-select)
            String[] skills = req.getParameterValues("skills");
            String[] preferences = req.getParameterValues("preferences");

            // Validate required fields
            if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                name == null || name.trim().isEmpty()) {
                req.setAttribute("error", "Required fields are missing");
                req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
                return;
            }

            // Create user account
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(BCrypt.hashpw(password, BCrypt.gensalt()));
            user.setRole(Role.VOLUNTEER);
            
            int userId = userDAO.create(user);

            // Create volunteer profile
            Volunteer volunteer = new Volunteer();
            volunteer.setUserId(userId);
            volunteer.setName(name);
            if (ageStr != null && !ageStr.trim().isEmpty()) {
                try {
                    volunteer.setAge(Integer.parseInt(ageStr));
                } catch (NumberFormatException e) {
                    // Ignore invalid age
                }
            }
            volunteer.setGender(gender);
            volunteer.setContactNumber(contactNumber);
            volunteer.setHouseNo(houseNo);
            volunteer.setStreet(street);
            volunteer.setCity(city);
            volunteer.setDistrict(district);
            volunteer.setGnDivision(gnDivision);
            
            volunteerDAO.create(volunteer);

            // Add skills
            if (skills != null) {
                for (String skill : skills) {
                    if (skill != null && !skill.trim().isEmpty()) {
                        volunteerDAO.addSkill(userId, skill);
                    }
                }
            }

            // Add preferences
            if (preferences != null) {
                for (String preference : preferences) {
                    if (preference != null && !preference.trim().isEmpty()) {
                        volunteerDAO.addPreference(userId, preference);
                    }
                }
            }

            // Redirect to login
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/volunteer/signup.jsp").forward(req, resp);
        }
    }
}
